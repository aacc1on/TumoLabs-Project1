#!/bin/bash

# PurpleWire System Check
# Verifies that everything is configured correctly

echo "================================================"
echo "PurpleWire - System Check"
echo "================================================"
echo ""

# ========================================
# CHECK GROUPS
# ========================================
echo "1. GROUPS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

GROUPS=("finance" "hr" "sales" "management" "ceo" "employees" "sftponly")
for group in "${GROUPS[@]}"; do
    if getent group "$group" > /dev/null 2>&1; then
        echo "  ✓ $group"
    else
        echo "  ✗ $group - MISSING!"
    fi
done

# ========================================
# CHECK USERS
# ========================================
echo ""
echo "2. USERS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_user() {
    local username=$1
    
    if id "$username" > /dev/null 2>&1; then
        echo "  ✓ $username"
        echo "    Groups: $(id -nG $username)"
    else
        echo "  ✗ $username - MISSING!"
    fi
}

check_user "ani"
check_user "ruzan"
check_user "tatevik"
check_user "yelena"
check_user "narine"
check_user "hovhannes"
check_user "vard"

# ========================================
# CHECK DIRECTORIES
# ========================================
echo ""
echo "3. DIRECTORIES:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

BASEDIR="/src/purplewire"

check_directory() {
    local dir=$1
    
    if [ -d "$dir" ]; then
        perms=$(stat -c '%a' "$dir")
        owner=$(stat -c '%U:%G' "$dir")
        echo "  ✓ $(basename $dir)"
        echo "    Path: $dir"
        echo "    Owner: $owner"
        echo "    Permissions: $perms"
    else
        echo "  ✗ $(basename $dir) - MISSING!"
    fi
}

check_directory "$BASEDIR/Finance"
echo ""
check_directory "$BASEDIR/HR"
echo ""
check_directory "$BASEDIR/Sales"
echo ""
check_directory "$BASEDIR/EmployeeContracts"
echo ""
check_directory "$BASEDIR/Management"
echo ""
check_directory "$BASEDIR/Marketing"

# ========================================
# CHECK MARKETING SUBFOLDERS
# ========================================
echo ""
echo "4. MARKETING SUBFOLDERS:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for subdir in Printable Vector Image Docs; do
    if [ -d "$BASEDIR/Marketing/$subdir" ]; then
        echo "  ✓ $subdir"
    else
        echo "  ✗ $subdir - MISSING!"
    fi
done

# ========================================
# CHECK AUTO-SORT
# ========================================
echo ""
echo "5. AUTO-SORT:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "/usr/local/bin/sort-marketing" ]; then
    echo "  ✓ Script exists: /usr/local/bin/sort-marketing"
else
    echo "  ✗ Script missing!"
fi

if [ -f "/etc/cron.d/marketing-sort" ]; then
    echo "  ✓ Cron job configured"
else
    echo "  ✗ Cron job missing!"
fi

# ========================================
# CHECK SSH
# ========================================
echo ""
echo "6. SSH/SFTP SECURITY:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "/etc/ssh/sshd_config.d/purplewire.conf" ]; then
    echo "  ✓ SSH configuration exists"
else
    echo "  ✗ SSH configuration missing!"
fi

if systemctl is-active --quiet sshd; then
    echo "  ✓ SSH service running"
else
    echo "  ✗ SSH service not active!"
fi

# ========================================
# CHECK FAIL2BAN
# ========================================
echo ""
echo "7. FAIL2BAN:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v fail2ban-client &> /dev/null; then
    echo "  ✓ fail2ban installed"
    
    if systemctl is-active --quiet fail2ban; then
        echo "  ✓ fail2ban service running"
        
        # Show banned IPs
        banned=$(fail2ban-client status sshd 2>/dev/null | grep "Banned IP" | awk '{print $NF}')
        echo "  → Banned IPs: $banned"
    else
        echo "  ✗ fail2ban service not active!"
    fi
else
    echo "  ✗ fail2ban not installed!"
fi

# ========================================
# SUMMARY
# ========================================
echo ""
echo "================================================"
echo "CHECK COMPLETE"
echo "================================================"
echo ""
echo "If you see ✗ marks, run:"
echo "  sudo ./setup_purplewire_complete.sh"
echo ""
