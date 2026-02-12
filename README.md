# PurpleWire Server Setup - Guide

## Quick Start

```bash
# 1. Main setup
chmod +x setup_purplewire_complete.sh
sudo ./setup_purplewire_complete.sh

# 2. Vard CTO (urgent)
chmod +x create_vard_cto.sh
sudo ./create_vard_cto.sh

# 3. Check system
chmod +x check_system.sh
sudo ./check_system.sh
```

## Users and Passwords

### Temporary password (for everyone)
```
PurpleWire2026!
```

### Vard (CTO)
```
Username: vard
Password: TimeIsTheMostPreciousCommodity
Access: sudo (root)
```

**Important:** All users must change password on first login

## User Permissions

| User | Access |
|------|--------|
| **ani** (CEO) | Full access to all folders |
| **ruzan** | Finance, Management, EmployeeContracts (read-only), Marketing |
| **tatevik** | HR, Management, EmployeeContracts, Marketing |
| **yelena** | HR, EmployeeContracts, Marketing |
| **narine** | Sales, Marketing |
| **hovhannes** | Finance, Sales, Management, EmployeeContracts (read-only), Marketing |
| **vard** | Root access (sudo) |

## Directory Structure

```
/src/purplewire/
├── Finance/              # Finance group only
├── HR/                   # HR group only
├── Sales/                # Sales group only
├── EmployeeContracts/    # HR (rwx), Finance (read-only)
├── Management/           # Management group only
└── Marketing/            # All employees
    ├── Printable/        # PDF
    ├── Vector/           # SVG, AI, CDR
    ├── Image/            # JPG, GIF, HEIC
    └── Docs/             # DOC, DOCX
```

## Marketing Auto-Sort

### Manual
```bash
sort-marketing
```

### Automatic
- Every 5 minutes (cron job)
- PDF → Printable
- SVG/AI/CDR → Vector
- JPG/GIF/HEIC → Image
- DOC/DOCX → Docs

## WinSCP Configuration

```
File protocol: SFTP
Host: [server IP]
Port: 22
Username: [username]
Password: PurpleWire2026!
```

### After first login
1. Enter old password: `PurpleWire2026!`
2. Enter new password
3. Retype new password

## Security

- ✅ SFTP-only access (no terminal)
- ✅ fail2ban (ban after 3 attempts)
- ✅ Forced password change
- ✅ SSH Protocol 2
- ✅ Root login disabled

## Useful Commands

```bash
# See who logged in
last

# Check fail2ban
sudo systemctl status fail2ban

# See banned IPs
sudo fail2ban-client status sshd

# Restart SSH
sudo systemctl restart sshd

# See user's groups
groups username
```

## FAQ

### How to add new user?
```bash
sudo useradd -m -s /bin/bash new_user
echo "new_user:PurpleWire2026!" | sudo chpasswd
sudo chage -d 0 new_user
sudo usermod -aG employees,sftponly new_user
```

### How to reset password?
```bash
echo "username:NewPassword123!" | sudo chpasswd
sudo chage -d 0 username
```

### How to backup?
```bash
sudo tar -czf purplewire-backup-$(date +%Y%m%d).tar.gz /src/purplewire/
```

## Support

📧 support@purplewire.ai  
💬 @purplewire_support
