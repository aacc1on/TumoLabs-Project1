#!/bin/bash

# PurpleWire Server Setup - Complete and Secure
# Creates users, sets permissions, configures SFTP-only access, fail2ban protection
# FIXED: No forced password change, No chroot issues

set -e  # Stop on error

BASEDIR="/src/purplewire"
CEO="ani"
STANDARD_USERS=("ani" "ruzan" "tatevik" "yelena" "narine" "hovhannes")

ensure_password_policy() {
    local username=$1
    # Disable forced password change and make password non-expiring for operational stability
    chage -d 99999 -M 99999 "$username"
}

echo "================================================"
echo "PurpleWire - Server Setup (FIXED VERSION)"
echo "================================================"

# ========================================
# STEP 1: CREATE GROUPS
# ========================================
echo ""
echo "Step 1: Creating groups..."

# Division groups
if ! getent group finance > /dev/null 2>&1; then
    groupadd finance
    echo "  ✓ finance"
fi

if ! getent group hr > /dev/null 2>&1; then
    groupadd hr
    echo "  ✓ hr"
fi

if ! getent group sales > /dev/null 2>&1; then
    groupadd sales
    echo "  ✓ sales"
fi

if ! getent group management > /dev/null 2>&1; then
    groupadd management
    echo "  ✓ management"
fi

if ! getent group ceo > /dev/null 2>&1; then
    groupadd ceo
    echo "  ✓ ceo"
fi

if ! getent group employees > /dev/null 2>&1; then
    groupadd employees
    echo "  ✓ employees"
fi

# SFTP-only group (no terminal access)
if ! getent group sftponly > /dev/null 2>&1; then
    groupadd sftponly
    echo "  ✓ sftponly"
fi

# ========================================
# STEP 2: CREATE USERS
# ========================================
echo ""
echo "Step 2: Creating users..."

# Function to create user with password (NO FORCED CHANGE)
create_user() {
    local username=$1
    local password=$2
    
    if ! id "$username" > /dev/null 2>&1; then
        useradd -m -s /bin/bash "$username"
        echo "$username:$password" | chpasswd
        ensure_password_policy "$username"
        usermod -aG employees,sftponly "$username"
        echo "  ✓ $username (password: $password)"
    else
        echo "  → $username (already exists)"
        # Reset password for existing users
        echo "$username:$password" | chpasswd
        ensure_password_policy "$username"
        echo "  → Password reset for $username"
    fi
}

# Create all users
create_user "ani" "PurpleWire2026!"
usermod -aG ceo ani

create_user "ruzan" "PurpleWire2026!"
usermod -aG finance,management ruzan

create_user "tatevik" "PurpleWire2026!"
usermod -aG hr,management tatevik

create_user "yelena" "PurpleWire2026!"
usermod -aG hr yelena

create_user "narine" "PurpleWire2026!"
usermod -aG sales narine

create_user "hovhannes" "PurpleWire2026!"
usermod -aG finance,sales,management hovhannes

create_user "vard" "TimeIsTheMostPreciousCommodity"
usermod -aG sudo vard  # Root access for CTO
ensure_password_policy "vard"
echo "  ⚠ vard has sudo privileges"

# ========================================
# STEP 3: CREATE DIRECTORIES
# ========================================
echo ""
echo "Step 3: Creating directories..."

mkdir -p $BASEDIR
echo "  ✓ Base directory: $BASEDIR"

# Finance folder - finance group only
mkdir -p $BASEDIR/Finance
chown root:finance $BASEDIR/Finance
chmod 770 $BASEDIR/Finance
echo "  ✓ Finance (finance group only)"

# HR folder - hr group only
mkdir -p $BASEDIR/HR
chown root:hr $BASEDIR/HR
chmod 770 $BASEDIR/HR
echo "  ✓ HR (hr group only)"

# Sales folder - sales group only
mkdir -p $BASEDIR/Sales
chown root:sales $BASEDIR/Sales
chmod 770 $BASEDIR/Sales
echo "  ✓ Sales (sales group only)"

# EmployeeContracts - HR full access, Finance read-only
mkdir -p $BASEDIR/EmployeeContracts
chown root:hr $BASEDIR/EmployeeContracts
chmod 770 $BASEDIR/EmployeeContracts
setfacl -m g:finance:rx $BASEDIR/EmployeeContracts  # Finance read-only
setfacl -d -m g:finance:rx $BASEDIR/EmployeeContracts
echo "  ✓ EmployeeContracts (HR: rwx, Finance: r-x)"

# Management folder - management group only
mkdir -p $BASEDIR/Management
chown root:management $BASEDIR/Management
chmod 770 $BASEDIR/Management
echo "  ✓ Management (management group only)"

# Marketing folder - all employees
mkdir -p $BASEDIR/Marketing
chown root:employees $BASEDIR/Marketing
chmod 775 $BASEDIR/Marketing
echo "  ✓ Marketing (all employees)"

# Marketing subfolders
mkdir -p $BASEDIR/Marketing/{Printable,Vector,Image,Docs}
chown -R root:employees $BASEDIR/Marketing/
chmod -R 775 $BASEDIR/Marketing/
echo "  ✓ Marketing subfolders: Printable, Vector, Image, Docs"

# ========================================
# STEP 4: CEO FULL ACCESS
# ========================================
echo ""
echo "Step 4: Granting CEO full access..."

for dir in $BASEDIR/Finance $BASEDIR/HR $BASEDIR/Sales $BASEDIR/EmployeeContracts $BASEDIR/Management $BASEDIR/Marketing; do
    setfacl -m u:$CEO:rwx $dir
    setfacl -d -m u:$CEO:rwx $dir
done
echo "  ✓ CEO (ani) has full access to all folders"

# ========================================
# STEP 5: MARKETING AUTO-SORT
# ========================================
echo ""
echo "Step 5: Setting up Marketing auto-sort..."

# Create auto-sort script
cat > /usr/local/bin/sort-marketing << 'EOF'
#!/bin/bash
# Auto-sort Marketing files into subfolders

MARKETING="/src/purplewire/Marketing"

# PDF -> Printable
find "$MARKETING" -maxdepth 1 -type f -iname "*.pdf" -exec mv {} "$MARKETING/Printable/" \; 2>/dev/null

# Vector files (SVG, AI, CDR) -> Vector
find "$MARKETING" -maxdepth 1 -type f \( -iname "*.svg" -o -iname "*.ai" -o -iname "*.cdr" \) -exec mv {} "$MARKETING/Vector/" \; 2>/dev/null

# Image files (JPG, GIF, HEIC) -> Image
find "$MARKETING" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.heic" \) -exec mv {} "$MARKETING/Image/" \; 2>/dev/null

# Document files (DOC, DOCX, ODT) -> Docs
find "$MARKETING" -maxdepth 1 -type f \( -iname "*.doc" -o -iname "*.docx" -o -iname "*.odt" \) -exec mv {} "$MARKETING/Docs/" \; 2>/dev/null
EOF

chmod +x /usr/local/bin/sort-marketing
echo "  ✓ Created: /usr/local/bin/sort-marketing"

# Create alias for easy use
echo "alias sort-marketing='/usr/local/bin/sort-marketing'" >> /etc/bash.bashrc
echo "  ✓ Created alias: sort-marketing"

# Create cron job (runs every 5 minutes)
cat > /etc/cron.d/marketing-sort << 'EOF'
# Auto-sort Marketing files every 5 minutes
*/1 * * * * root /usr/local/bin/sort-marketing >/dev/null 2>&1
EOF

echo "  ✓ Cron job created (every 5 minutes)"

# ========================================
# STEP 6: SSH/SFTP SECURITY (NO CHROOT)
# ========================================
echo ""
echo "Step 6: Configuring SSH/SFTP security..."

# Backup SSH config
if [ -f /etc/ssh/sshd_config ]; then
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.$(date +%Y%m%d)
    echo "  ✓ Backup created"
fi

# Create secure SSH configuration WITHOUT chroot
cat > /etc/ssh/sshd_config.d/purplewire.conf << 'EOF'
# PurpleWire Secure SSH Configuration (NO CHROOT - FIXED)

# SFTP subsystem
Subsystem sftp internal-sftp

# Disable root login
PermitRootLogin no

# Authentication
PubkeyAuthentication yes
PasswordAuthentication yes
PermitEmptyPasswords no

# Protocol and limits
Protocol 2
MaxAuthTries 3
MaxSessions 5

# Timeouts
ClientAliveInterval 300
ClientAliveCountMax 2

# SFTP-only users (no chroot - allows passwd command to work)
Match Group sftponly
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
    PermitTunnel no

# CTO exception (full terminal access)
Match User vard
    ForceCommand none
    AllowTcpForwarding yes
EOF

echo "  ✓ SSH configuration saved (NO CHROOT)"

# Remove any legacy chroot settings from the main sshd config
if [ -f /etc/ssh/sshd_config ]; then
    sed -i '/^\s*ChrootDirectory\s\+/d' /etc/ssh/sshd_config
fi

# ========================================
# STEP 7: FAIL2BAN INSTALLATION
# ========================================
echo ""
echo "Step 7: Installing fail2ban..."

# Install fail2ban if not present
if ! command -v fail2ban-client &> /dev/null; then
    apt-get update -qq
    apt-get install -y fail2ban >/dev/null 2>&1
    echo "  ✓ fail2ban installed"
else
    echo "  → fail2ban already installed"
fi

# Configure fail2ban for SSH
cat > /etc/fail2ban/jail.d/sshd.local << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
EOF

echo "  ✓ fail2ban configured (3 attempts, 1 hour ban)"

# Enable and start fail2ban
systemctl enable fail2ban >/dev/null 2>&1
systemctl restart fail2ban >/dev/null 2>&1
echo "  ✓ fail2ban service started"

# ========================================
# STEP 8: RESTART SSH
# ========================================
echo ""
echo "Step 8: Restarting SSH service..."

# Test SSH config before restart
if sshd -t 2>/dev/null; then
    systemctl restart sshd
    echo "  ✓ SSH service restarted"
else
    echo "  ✗ ERROR in SSH configuration!"
    exit 1
fi

# ========================================
# COMPLETE
# ========================================
echo ""
echo "================================================"
echo "✓ SETUP COMPLETE! (FIXED VERSION)"
echo "================================================"
echo ""
echo "USER CREDENTIALS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "All employees password (NO CHANGE REQUIRED):"
echo "  PurpleWire2026!"
echo ""
echo "Vard (CTO) password:"
echo "  TimeIsTheMostPreciousCommodity"
echo ""
echo "✅ Users can login immediately - NO password change required"
echo "✅ NO chroot jail - passwd command works"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "USERS AND PERMISSIONS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "ani (CEO): Full access to ALL folders"
echo "ruzan (Finance+Management): Finance, Management, EmployeeContracts (read-only), Marketing"
echo "tatevik (HR+Management): HR, Management, EmployeeContracts, Marketing"
echo "yelena (HR): HR, EmployeeContracts, Marketing"
echo "narine (Sales): Sales, Marketing"
echo "hovhannes (Finance+Sales+Management): Finance, Sales, Management, EmployeeContracts (read-only), Marketing"
echo "vard (CTO): Sudo access (root privileges)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "MARKETING AUTO-SORT:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Manual sort: sort-marketing"
echo "Automatic: Every 5 minutes (cron job)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "SECURITY:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✓ SFTP-only access (no terminal)"
echo "✓ fail2ban active (ban after 3 attempts)"
echo "✓ NO forced password change (FIXED)"
echo "✓ NO chroot jail (FIXED)"
echo "✓ SSH Protocol 2"
echo "✓ Root login disabled"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "POST-SETUP VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for user in "${STANDARD_USERS[@]}"; do
    ensure_password_policy "$user"
done

if sshd -t 2>/dev/null; then
    echo "✓ SSH configuration validation passed"
else
    echo "✗ SSH configuration validation failed"
    exit 1
fi

echo "✓ Single-script setup complete (no separate fix script required)"
echo ""
