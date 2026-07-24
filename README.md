# H24-Lab

Enterprise Active Directory Lab built with PowerShell, Windows Server 2025 and Microsoft Azure.

---

## Overview

H24-Lab is my personal infrastructure automation project focused on Windows Server administration and PowerShell.

The purpose of this repository is to build and automate a complete Enterprise Active Directory environment using Infrastructure as Code (IaC) principles. Instead of configuring everything manually, the entire lab can be deployed automatically from code.

This repository is continuously expanded as I learn new Windows Server technologies and enterprise administration practices.

---

## Features

- Automated Organizational Unit deployment
- Automated Security Group deployment
- Automated User deployment
- CSV user provisioning
- JSON configuration
- PowerShell logging module
- Automatic group membership
- One-command deployment
- Git version control

---

## Technologies

- Windows Server 2025
- Active Directory Domain Services
- PowerShell
- Microsoft Azure
- Git
- GitHub

---

## Project Structure

```text
H24-Lab
│
├── Assets
│   ├── deployment.png
│   ├── groups.png
│   ├── ou-structure.png
│   └── users.png
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

## Deployment

Clone the repository:

```powershell
git clone https://github.com/m47116339-a11y/H24-Lab.git
```

Open the Scripts directory:

```powershell
cd H24-Lab\Scripts
```

Run the deployment:

```powershell
.\Deploy-H24Lab.ps1
```

The deployment script automatically:

- Creates Organizational Units
- Creates Security Groups
- Imports users from CSV
- Creates Active Directory users
- Adds users to their department groups
- Writes deployment logs

---

## Example Output

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

## Project Preview

### Active Directory Structure

![Active Directory Structure](Assets/ou-structure.png)

---

### Security Groups

![Security Groups](Assets/groups.png)

---

### Users

![Users](Assets/users.png)

---

### Deployment Output

![Deployment Output](Assets/deployment.png)

---

## Roadmap

### Completed

- [x] Active Directory design
- [x] Organizational Unit deployment
- [x] Security Group deployment
- [x] User deployment
- [x] CSV user provisioning
- [x] Logging module
- [x] Automated deployment

### Planned

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

## Project Status

**Current version:** `v1.0`

The Active Directory deployment workflow is fully functional. Future versions will focus on Windows Server infrastructure services and automation.

---

## Author

Created by **Maxim** as part of my Windows Server and PowerShell learning journey.