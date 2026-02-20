# PurpleWire Server Setup - Guide (FIXED VERSION)

## Quick Start

```bash
# 1. Main setup (FIXED - No password change required)
chmod +x setup_purplewire_complete.sh
sudo ./setup_purplewire_complete.sh

# 2. Check system
chmod +x check_system.sh
sudo ./check_system.sh
```

## Users and Passwords

### Password for all employees (NO CHANGE REQUIRED)
```
PurpleWire2026!
```

### Vard (CTO)
```
Username: vard
Password: TimeIsTheMostPreciousCommodity
Access: sudo (root)
```

**✅ FIXED:** Users can login immediately - NO forced password change!

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

### Login Process
1. Enter username
2. Enter password: `PurpleWire2026!`
3. ✅ Connected! (No password change required)

## Security

- ✅ SFTP-only access (no terminal)
- ✅ fail2ban (ban after 3 attempts)
- ✅ NO forced password change (FIXED)
- ✅ NO chroot jail (FIXED - passwd works)
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

# Re-run full setup (already includes fixes)
sudo ./setup_purplewire_complete.sh
```

## Troubleshooting

### "Connection has been unexpectedly closed"
**Solution:**
```bash
ssh vard@192.168.56.101
sudo ./setup_purplewire_complete.sh
```

### "passwd: No such file or directory"
**Cause:** Chroot jail was blocking the passwd command  
**Solution:** Re-run `setup_purplewire_complete.sh` (it already removes legacy chroot settings)

### "Password expired" message
**Solution:**
```bash
# As vard (CTO)
sudo chage -d 99999 username
```

## FAQ

### How to add new user?
```bash
sudo useradd -m -s /bin/bash new_user
echo "new_user:PurpleWire2026!" | sudo chpasswd
sudo usermod -aG employees,sftponly new_user
# NO chage -d 0 needed!
```

### How to reset password?
```bash
echo "username:NewPassword123!" | sudo chpasswd
# Password is changed immediately, no forced change
```

### How to backup?
```bash
sudo tar -czf purplewire-backup-$(date +%Y%m%d).tar.gz /src/purplewire/
```

## Changes from Original Version

### ✅ What was fixed:
1. **Removed forced password change** - Users can login immediately
2. **Removed chroot jail** - passwd command now works
3. **Simplified login process** - No password change required on first login

### 🔒 Security still maintained:
- SFTP-only access (no terminal for regular users)
- fail2ban protection (3 failed attempts = 1 hour ban)
- Group-based permissions
- Root login disabled
- SSH Protocol 2

## Support

📧 support@purplewire.ai  
💬 @purplewire_support

---

**Last Updated:** Fixed version - No login issues