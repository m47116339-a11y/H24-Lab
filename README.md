# H24-Lab

Enterprise Active Directory Lab built with PowerShell, Windows Server 2025 and Microsoft Azure.

---

# Overview

H24-Lab is my personal learning project focused on Windows Server administration and infrastructure automation.

The purpose of this repository is to build a complete Active Directory environment using Infrastructure as Code principles. Instead of configuring everything manually, the entire lab can be deployed automatically with PowerShell.

This project is continuously expanded as I learn new Windows Server technologies.

---

# Features

- Automated Organizational Unit deployment
- Automated Security Group deployment
- Automated User deployment
- User provisioning from CSV
- JSON configuration
- PowerShell logging module
- Automatic group membership
- One-command deployment
- Git version control

---

# Technologies

- Windows Server 2025
- Active Directory Domain Services
- PowerShell
- Microsoft Azure
- Git
- GitHub

---

# Project Structure

```text
H24-Lab
│
├── Config
│   └── Company.json
│
├── Docs
│   └── ActiveDirectoryDesign.md
│
├── Logs
│   └── Deploy.log
│
├── Modules
│   └── H24.ActiveDirectory.psm1
│
├── Scripts
│   ├── Create-OUs.ps1
│   ├── Create-Groups.ps1
│   ├── Create-Users.ps1
│   └── Deploy-H24Lab.ps1
│
├── Users
│   └── Users.csv
│
└── README.md
```

---

# Deployment

Clone the repository

```powershell
git clone https://github.com/m47116339-a11y/H24-Lab.git
```

Go to the project

```powershell
cd H24-Lab\Scripts
```

Run deployment

```powershell
.\Deploy-H24Lab.ps1
```

The deployment script will:

- Create Organizational Units
- Create Security Groups
- Import users from CSV
- Create Active Directory users
- Add users to the correct groups
- Save deployment logs

---

# Example Output

```text
[INFO] Starting H24 Lab deployment

[INFO] OU already exists: Employees
[INFO] Group created: GG_IT
[INFO] User created: ipetrenko
[INFO] Added ipetrenko to GG_IT

[INFO] User deployment completed.

[INFO] H24 Lab deployment completed.
```

---

# Screenshots

# Screenshots

## Active Directory Structure

![Active Directory Structure](Assets/ou-structure.png)

---

## Security Groups

![Security Groups](Assets/groups.png)

---

## Users

![Users](Assets/users.png)

---

## Deployment Output

![Deployment Output](Assets/deployment.png)

---

# Roadmap

## Completed

- [x] Active Directory design
- [x] Organizational Unit deployment
- [x] Security Group deployment
- [x] User deployment
- [x] CSV user provisioning
- [x] Logging module
- [x] Automated deployment

## Planned

- [ ] Group Policy deployment
- [ ] File Server automation
- [ ] NTFS permissions
- [ ] Shared folders
- [ ] DNS automation
- [ ] DHCP automation
- [ ] Home folders
- [ ] Pester tests
- [ ] GitHub Actions

---

# Author

Created by **Maxim** as part of my Windows Server and PowerShell learning journey.