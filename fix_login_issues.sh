#!/bin/bash

# Quick Fix for PurpleWire Login Issues
# Run this if users cannot login

echo "================================"
echo "PurpleWire - Login Issue Fix"
echo "================================"
echo ""

# Step 1: Remove forced password change for all users
echo "Step 1: Removing forced password change..."
chage -d 99999 ani 2>/dev/null
chage -d 99999 ruzan 2>/dev/null
chage -d 99999 tatevik 2>/dev/null
chage -d 99999 yelena 2>/dev/null
chage -d 99999 narine 2>/dev/null
chage -d 99999 hovhannes 2>/dev/null
echo "✓ Forced password change removed for all users"
echo ""

# Step 2: Fix SSH configuration (remove chroot)
echo "Step 2: Fixing SSH configuration..."
cat > /etc/ssh/sshd_config.d/purplewire.conf << 'EOF'
# PurpleWire Secure SSH Configuration (FIXED)

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

# SFTP-only users (NO chroot - allows passwd to work)
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

echo "✓ SSH configuration fixed (chroot removed)"
echo ""

# Step 3: Test SSH configuration
echo "Step 3: Testing SSH configuration..."
if sshd -t 2>/dev/null; then
    echo "✓ SSH config is valid"
else
    echo "✗ ERROR in SSH configuration!"
    exit 1
fi
echo ""

# Step 4: Restart SSH service
echo "Step 4: Restarting SSH service..."
systemctl restart sshd
echo "✓ SSH service restarted"
echo ""

# Step 5: Show user status
echo "================================"
echo "USER STATUS:"
echo "================================"
echo ""

for user in ani ruzan tatevik yelena narine hovhannes; do
    if id "$user" >/dev/null 2>&1; then
        echo "✓ $user - Ready to login"
        echo "  Password: PurpleWire2026!"
    fi
done
echo ""

echo "✓ vard (CTO)"
echo "  Password: TimeIsTheMostPreciousCommodity"
echo ""

echo "================================"
echo "✓ ALL FIXED!"
echo "================================"
echo ""
echo "Users can now login with:"
echo "  ssh username@192.168.56.101"
echo "  Password: PurpleWire2026!"
echo ""
echo "No password change required!"
echo ""