# 📋 Changelog

## FR

### 🆕 v1.2.1 - 2026-03-03

| Type | Changements |
|------|-------------|
| ✨ **Ajouts** | Ligne `Mise a jour` affichee sous le titre de l'application (etat de version logiciel) |
| ✨ **Ajouts** | Affichage des licences actives Windows et Office (nom + fin de cle masquee) |
| ✨ **Ajouts** | Affichage du nombre d'emplacements RAM libres (si detectables via CIM) |
| 🔧 **Ameliorations** | Verification de mise a jour GitHub avec cache local (evite les appels repetes) |
| 🔧 **Ameliorations** | Couverture EPYC et fallback serveur etendus (incluant EPYC 9555) |
| 🐛 **Corrections** | Activation Windows filtree correctement (evite confusion avec licence Office) |

### 🆕 v1.2 - 2026-03-01

| Type | Changements |
|------|-------------|
| ✨ **Ajouts** | Bilingue FR/EN avec picker de langue au demarrage |
| ✨ **Ajouts** | Profils d'usage (principal + secondaire): Gaming, CAO/CAD, Web/Bureautique |
| ✨ **Ajouts** | Bloc alertes `CRITIQUE` / `ATTENTION` / `INFO` |
| ✨ **Ajouts** | Classification du pilote GPU (`Gaming`, `CAD`, `Unknown`) pour orienter le profil principal |
| ✨ **Ajouts** | Controle lifecycle Windows/Office (Windows 10 fin de support 2025-10-14, scenarios Office) |
| ✨ **Ajouts** | Ligne Office dans `SYSTEME`: produits detectes + `Activation Office` |
| 🔧 **Ameliorations** | Detection Office renforcee: Uninstall + Click-to-Run (`ProductReleaseIds`) |
| 🔧 **Ameliorations** | Normalisation des libelles produits (ex: `OneNoteFreeRetail` -> `OneNote`) |
| 🔧 **Ameliorations** | SMART: interpretation plus juste selon type de disque (SSD/NVMe vs HDD) |
| 🔧 **Ameliorations** | Presentation RAID/RST/VMD plus claire |
| 🔧 **Ameliorations** | Export et ouverture de lien renforces (gestion d'erreurs explicite) |
| 🐛 **Corrections** | Placeholders UI (`__SUBTITLE__`, sections) corriges |
| 🐛 **Corrections** | Picker langue: correction d'un cas ou rien ne se lancait |
| 🐛 **Corrections** | Ligne Windows Update vide dans certains cas |
| 🐛 **Corrections** | Detection Office manquante sur certaines installations M365 Click-to-Run |
| 🐛 **Corrections** | Masquage du nom brut de licence Office (`Office 16`) pour eviter la confusion |

### v1.1 - 2026-02-26

| Type | Changements |
|------|-------------|
| ✨ **Ajouts** | Infos pilote GPU dans `SYSTEME` (nom, version, date) |
| ✨ **Ajouts** | Etat disque systeme (libre/capacite + alerte espace faible) |
| ✨ **Ajouts** | Infos energie (profil alim + secteur/batterie) |
| ✨ **Ajouts** | Bloc SMART (sante, temperature, compteurs, usure SSD si disponible) |
| 🔧 **Ameliorations** | Recalibrage scoring GPU gaming pour la hierarchie 2026 |
| 🔧 **Ameliorations** | Meilleure gestion CPU mobiles + detection boost |
| 🔧 **Ameliorations** | Fallback VRAM renforce (`nvidia-smi` -> registre -> `dxdiag` -> WMI) |
| 🐛 **Corrections** | Sous-evaluation CPU mobile haut de gamme corrigee |
| 🐛 **Corrections** | Interpretation SSD/HDD corrigee en environnements SATA/RAID |
| 🐛 **Corrections** | Nettoyage parsing/stabilite sur plusieurs blocs |

### v1.0 - 2026-02-24

| Type | Changements |
|------|-------------|
| 🚀 **Initial** | Premiere version publique |
| 🚀 **Initial** | Analyse CPU, RAM, GPU, stockage |
| 🚀 **Initial** | Score global + export rapport |

---

## EN

### 🆕 v1.2.1 - 2026-03-03

| Type | Changes |
|------|---------|
| ✨ **Added** | `Update` line shown under app title (software version status) |
| ✨ **Added** | Active Windows and Office license display (name + masked key ending) |
| ✨ **Added** | Free RAM slot count display (when detectable via CIM) |
| 🔧 **Improved** | GitHub update check with local cache (avoids repeated requests) |
| 🔧 **Improved** | Extended EPYC/server fallback coverage (including EPYC 9555) |
| 🐛 **Fixed** | Windows activation now correctly filtered (avoids Office license confusion) |

### 🆕 v1.2 - 2026-03-01

| Type | Changes |
|------|---------|
| ✨ **Added** | FR/EN bilingual UI with startup language picker |
| ✨ **Added** | Usage profiles (primary + secondary): Gaming, CAD/CAO, Web/Office |
| ✨ **Added** | Alert block with `CRITICAL` / `WARNING` / `INFO` |
| ✨ **Added** | GPU driver classification (`Gaming`, `CAD`, `Unknown`) used to bias primary profile |
| ✨ **Added** | Windows/Office lifecycle checks (Windows 10 support ended 2025-10-14, Office scenarios) |
| ✨ **Added** | Office lines in `SYSTEME`: detected products + `Office activation` |
| 🔧 **Improved** | Office detection hardening: Uninstall + Click-to-Run (`ProductReleaseIds`) |
| 🔧 **Improved** | Product label normalization (example: `OneNoteFreeRetail` -> `OneNote`) |
| 🔧 **Improved** | SMART interpretation tuned by drive type (SSD/NVMe vs HDD) |
| 🔧 **Improved** | Clearer RAID/RST/VMD presentation |
| 🔧 **Improved** | Export and external link handling hardened with explicit error handling |
| 🐛 **Fixed** | UI placeholder rendering issues (`__SUBTITLE__`, section labels) |
| 🐛 **Fixed** | Language picker edge case where selection did not launch the flow |
| 🐛 **Fixed** | Empty Windows Update line in specific contexts |
| 🐛 **Fixed** | Missing Office detection on some M365 Click-to-Run installs |
| 🐛 **Fixed** | Raw Office license display hidden (`Office 16`) to avoid confusion |

### v1.1 - 2026-02-26

| Type | Changes |
|------|---------|
| ✨ **Added** | GPU driver details in `SYSTEME` (name, version, date) |
| ✨ **Added** | System disk free/capacity status + low-space alert |
| ✨ **Added** | Power profile + AC/battery state |
| ✨ **Added** | SMART block (health, temperature, counters, SSD wear when available) |
| 🔧 **Improved** | Gaming GPU scoring recalibrated for 2026 hardware tiers |
| 🔧 **Improved** | Better mobile CPU handling and boost detection |
| 🔧 **Improved** | VRAM fallback chain improved (`nvidia-smi` -> registry -> `dxdiag` -> WMI) |
| 🐛 **Fixed** | High-end mobile CPU under-scoring |
| 🐛 **Fixed** | SSD/HDD interpretation issues in SATA/RAID setups |
| 🐛 **Fixed** | Parsing/stability cleanup in multiple blocks |

### v1.0 - 2026-02-24

| Type | Changes |
|------|---------|
| 🚀 **Initial** | First public release |
| 🚀 **Initial** | CPU, RAM, GPU, storage analysis |
| 🚀 **Initial** | Global score + report export |
