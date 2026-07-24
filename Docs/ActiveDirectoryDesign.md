# Active Directory Design

## Project Information

**Company:** H24 Solutions

**Domain:** corp.lab

**NetBIOS:** CORP

---

# Organizational Units

```
corp.lab
│
├── Admins
├── Servers
├── Workstations
├── Employees
│   ├── IT
│   ├── HR
│   ├── Accounting
│   ├── Sales
│   ├── Support
│   └── Management
│
├── Groups
└── Service Accounts
```

---

# Naming Convention

## Users

firstname.lastname

Examples

- ivan.petrenko
- oleksandr.koval

---

## Servers

- DC01
- FS01
- APP01
- SQL01

---

## Security Groups

- GG_IT
- GG_HR
- GG_Accounting
- GG_Sales
- GG_Support
- GG_Management

---

## Service Accounts

- svc_backup
- svc_sql
- svc_monitor

---

# Goals

- Standardized Active Directory structure
- PowerShell automation
- Infrastructure as Code
- Enterprise administration