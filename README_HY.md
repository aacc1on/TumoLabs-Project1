# PurpleWire Server Setup - Ուղեցույց

## Արագ Սկիզբ

```bash
# 1. Հիմնական կարգավորում
chmod +x setup_purplewire_complete.sh
sudo ./setup_purplewire_complete.sh

# 2. Vard CTO (շտապ)
chmod +x create_vard_cto.sh
sudo ./create_vard_cto.sh

# 3. Ստուգել համակարգը
chmod +x check_system.sh
sudo ./check_system.sh
```

## Օգտատերեր և Գաղտնաբառեր

### Ժամանակավոր գաղտնաբառ (բոլորի համար)
```
PurpleWire2026!
```

### Vard (CTO)
```
Username: vard
Password: TimeIsTheMostPreciousCommodity
Access: sudo (root)
```

**Կարևոր:** Բոլորը պետք է փոխեն գաղտնաբառը առաջին մուտքից հետո

## Օգտատերերի Իրավունքներ

| Օգտատեր | Մուտք |
|---------|-------|
| **ani** (CEO) | Ամբողջական մուտք բոլոր թղթապանակներ |
| **ruzan** | Finance, Management, EmployeeContracts (read-only), Marketing |
| **tatevik** | HR, Management, EmployeeContracts, Marketing |
| **yelena** | HR, EmployeeContracts, Marketing |
| **narine** | Sales, Marketing |
| **hovhannes** | Finance, Sales, Management, EmployeeContracts (read-only), Marketing |
| **vard** | Root access (sudo) |

## Թղթապանակների Կառուցվածք

```
/src/purplewire/
├── Finance/              # Միայն Finance խումբ
├── HR/                   # Միայն HR խումբ
├── Sales/                # Միայն Sales խումբ
├── EmployeeContracts/    # HR (rwx), Finance (read-only)
├── Management/           # Միայն Management խումբ
└── Marketing/            # Բոլոր աշխատակիցները
    ├── Printable/        # PDF
    ├── Vector/           # SVG, AI, CDR
    ├── Image/            # JPG, GIF, HEIC
    └── Docs/             # DOC, DOCX
```

## Marketing Ավտոմատ Դասակարգում

### Ձեռքով
```bash
sort-marketing
```

### Ավտոմատ
- Ամեն 5 րոպեն մեկ (cron job)
- PDF → Printable
- SVG/AI/CDR → Vector
- JPG/GIF/HEIC → Image
- DOC/DOCX → Docs

## WinSCP Կարգավորում

```
File protocol: SFTP
Host: [սերվերի IP]
Port: 22
Username: [օգտատիրոջ անուն]
Password: PurpleWire2026!
```

### Առաջին մուտքից հետո
1. Մուտքագրել հին գաղտնաբառ: `PurpleWire2026!`
2. Մուտքագրել նոր գաղտնաբառ
3. Կրկնել նոր գաղտնաբառը

## Անվտանգություն

- ✅ SFTP-only մուտք (առանց terminal-ի)
- ✅ fail2ban (3 փորձից հետո ban)
- ✅ Ստիպված գաղտնաբառի փոփոխություն
- ✅ SSH Protocol 2
- ✅ Root login անջատված

## Օգտակար Հրամաններ

```bash
# Տեսնել ով մուտք է գործել
last

# Ստուգել fail2ban
sudo systemctl status fail2ban

# Տեսնել banned IP-ները
sudo fail2ban-client status sshd

# Վերագործարկել SSH
sudo systemctl restart sshd

# Տեսնել մեկի խմբերը
groups username
```

## Հաճախ Տրվող Հարցեր

### Ինչպես ավելացնել նոր օգտատեր?
```bash
sudo useradd -m -s /bin/bash new_user
echo "new_user:PurpleWire2026!" | sudo chpasswd
sudo chage -d 0 new_user
sudo usermod -aG employees,sftponly new_user
```

### Ինչպես վերականգնել գաղտնաբառը?
```bash
echo "username:NewPassword123!" | sudo chpasswd
sudo chage -d 0 username
```

### Ինչպես backup անել?
```bash
sudo tar -czf purplewire-backup-$(date +%Y%m%d).tar.gz /src/purplewire/
```

## Աջակցություն

📧 support@purplewire.ai  
💬 @purplewire_support
