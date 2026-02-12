#!/bin/bash

# Quick CTO Account Creation - URGENT
# Creates Vard's account with sudo access

echo "================================"
echo "Vard CTO - Account Creation"
echo "================================"
echo ""

# Create user if doesn't exist
if ! id "vard" > /dev/null 2>&1; then
    useradd -m -s /bin/bash vard
    echo "✓ User created: vard"
else
    echo "→ User already exists: vard"
fi

# Set password
echo "vard:TimeIsTheMostPreciousCommodity" | chpasswd
echo "✓ Password set"

# Grant sudo privileges (root access)
usermod -aG sudo vard
echo "✓ Sudo privileges granted"

# Add to groups
usermod -aG employees,management vard
echo "✓ Added to groups: employees, management"

echo ""
echo "================================"
echo "✓ Vard's account is ready!"
echo "================================"
echo ""
echo "Login credentials:"
echo "  Username: vard"
echo "  Password: TimeIsTheMostPreciousCommodity"
echo "  Access: sudo (root privileges)"
echo ""
echo "SSH login:"
echo "  ssh vard@your-server-ip"
echo ""
