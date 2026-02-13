#!/bin/bash

# PurpleWire - Complete Cleanup Script
# Removes ALL users, groups, directories, and configurations
# Use this to start fresh

echo "================================================"
echo "PurpleWire - COMPLETE CLEANUP"
echo "================================================"
echo ""
echo "⚠️  WARNING: This will DELETE everything!"
echo "   - All users (except vard for safety)"
echo "   - All groups"
echo "   - All directories (/src/purplewire/)"
echo "   - All SSH configurations"
echo "   - Marketing auto-sort"
echo ""
read -p "Are you sure? Type 'YES' to continue: " confirm

if [ "$confirm" != "YES" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Starting cleanup in 3 seconds..."
sleep 3
echo ""

# ========================================
# STEP 1: STOP SERVICES
# ========================================
echo "Step 1: Stopping services..."
systemctl stop fail2ban 2>/dev/null
echo "  ✓ fail2ban stopped"

# ========================================
# STEP 2: DELETE USERS
# ========================================
echo ""
echo "Step 2: Deleting users..."

delete_user() {
    local username=$1
    if id "$username" >/dev/null 2>&1; then
        userdel -r "$username" 2>/dev/null
        echo "  ✓ Deleted: $username"
    else
        echo "  → $username (not found)"
    fi
}

delete_user "ani"
delete_user "ruzan"
delete_user "tatevik"
delete_user "yelena"
delete_user "narine"
delete_user "hovhannes"

# Keep vard for safety
echo "  → vard (kept for safety - admin account)"

# ========================================
# STEP 3: DELETE GROUPS
# ========================================
echo ""
echo "Step 3: Deleting groups..."

delete_group() {
    local groupname=$1
    if getent group "$groupname" >/dev/null 2>&1; then
        groupdel "$groupname" 2>/dev/null
        echo "  ✓ Deleted: $groupname"
    else
        echo "  → $groupname (not found)"
    fi
}

delete_group "finance"
delete_group "hr"
delete_group "sales"
delete_group "management"
delete_group "ceo"
delete_group "employees"
delete_group "sftponly"

# ========================================
# STEP 4: DELETE DIRECTORIES
# ========================================
echo ""
echo "Step 4: Deleting directories..."

if [ -d "/src/purplewire" ]; then
    rm -rf /src/purplewire
    echo "  ✓ Deleted: /src/purplewire/"
else
    echo "  → /src/purplewire/ (not found)"
fi

if [ -d "/src" ]; then
    rmdir /src 2>/dev/null
    echo "  ✓ Deleted: /src/ (if empty)"
fi

# ========================================
# STEP 5: DELETE SSH CONFIGURATION
# ========================================
echo ""
echo "Step 5: Removing SSH configuration..."

if [ -f "/etc/ssh/sshd_config.d/purplewire.conf" ]; then
    rm -f /etc/ssh/sshd_config.d/purplewire.conf
    echo "  ✓ Deleted: SSH config"
else
    echo "  → SSH config (not found)"
fi

# Restore from backup if exists
if [ -f "/etc/ssh/sshd_config.backup."* ]; then
    latest_backup=$(ls -t /etc/ssh/sshd_config.backup.* | head -1)
    cp "$latest_backup" /etc/ssh/sshd_config
    echo "  ✓ Restored: SSH config from backup"
fi

# ========================================
# STEP 6: DELETE MARKETING AUTO-SORT
# ========================================
echo ""
echo "Step 6: Removing marketing auto-sort..."

if [ -f "/usr/local/bin/sort-marketing" ]; then
    rm -f /usr/local/bin/sort-marketing
    echo "  ✓ Deleted: /usr/local/bin/sort-marketing"
fi

if [ -f "/etc/cron.d/marketing-sort" ]; then
    rm -f /etc/cron.d/marketing-sort
    echo "  ✓ Deleted: /etc/cron.d/marketing-sort"
fi

# Remove alias from bashrc
if grep -q "sort-marketing" /etc/bash.bashrc; then
    sed -i '/sort-marketing/d' /etc/bash.bashrc
    echo "  ✓ Removed: alias from /etc/bash.bashrc"
fi

# ========================================
# STEP 7: RESTART SSH
# ========================================
echo ""
echo "Step 7: Restarting SSH service..."
systemctl restart sshd
echo "  ✓ SSH service restarted"

# ========================================
# STEP 8: RESTART FAIL2BAN
# ========================================
echo ""
echo "Step 8: Restarting fail2ban..."
systemctl start fail2ban 2>/dev/null
echo "  ✓ fail2ban restarted"

# ========================================
# COMPLETE
# ========================================
echo ""
echo "================================================"
echo "✓ CLEANUP COMPLETE!"
echo "================================================"
echo ""
echo "System is now clean. You can run setup again:"
echo "  sudo ./setup_purplewire_complete.sh"
echo ""
echo "Remaining users:"
for user in $(cut -d: -f1 /etc/passwd | grep -E '^(vard|root)$'); do
    echo "  - $user"
done
echo ""
echo "Remaining groups:"
groups vard 2>/dev/null || echo "  (vard's groups)"
echo ""