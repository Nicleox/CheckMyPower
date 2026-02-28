# ⚡ CheckMyPower v1.2

> Analyse hardware complete avec scoring sur 10, interface Neo-Neon et profils d'usage intelligents.

[Image 1](./Capture1.jpg)  
[Image 2](./Capture2.jpg)  
[Image 3](./Capture3.jpg)

---

## FR

### 🔍 Fonctionnalites

| Module | Details |
|--------|---------|
| 🖥️ **Systeme** | PC, BIOS, OS, activation Windows, Windows Update, Secure Boot, TPM, antivirus, uptime, energie |
| ⚙️ **CPU** | Modele, coeurs/threads, base/boost, score /10 |
| 🧠 **RAM** | Capacite, type, frequence, mode canal, score /10 |
| 🎨 **GPU General** | VRAM + score global GPU |
| 🎮 **GPU Gaming** | Score gaming dedie + conseil de performance |
| 💾 **Stockage** | Type (NVMe/SSD/HDD), capacite, score |
| 🛡️ **SMART** | Sante, temperature, compteurs, usure SSD (si dispo) |
| 🧭 **Profils d'usage** | Profil principal + secondaire (Gaming, CAO/CAD, Web/Bureautique) |
| 🚨 **Alertes** | `CRITIQUE` / `ATTENTION` / `INFO` |
| 🌐 **Bilingue** | Choix FR/EN au demarrage |
| 🧾 **Office** | Produits detectes + statut `Activation Office` |
| 📅 **Lifecycle** | Controle support Windows/Office (ex: Windows 10 fin de support 2025-10-14) |

### 🚀 Installation (EXE uniquement)

1. Ouvre [Releases](../../releases)
2. Telecharge la derniere version `.exe`
3. Lance l'application (admin recommande pour les infos materielles completes)

### 📊 Bareme

| Score | Verdict |
|------:|---------|
| 9.0 - 10.0 | Excellent |
| 7.0 - 8.9  | Tres bien |
| 5.0 - 6.9  | Bon |
| 3.0 - 4.9  | Moyen |
| 0.0 - 2.9  | Faible |

### 📐 Formule du score global

`Score = CPU 25% + RAM 20% + GPU General 15% + GPU Gaming 15% + Stockage 25%`

### 📦 Actions

| Bouton | Action |
|--------|--------|
| 🔄 `Rafraichir` | Relance l'analyse complete |
| 📋 `Copier` | Copie le rapport dans le presse-papiers |
| 💾 `Exporter` | Exporte un fichier `.txt` sur le Bureau |

### ⚠️ Notes securite

- Analyse locale (pas de dependance cloud en fonctionnement normal).
- Des faux positifs antivirus peuvent arriver selon le packaging EXE.

---

## EN

### 🔍 Features

| Module | Details |
|--------|---------|
| 🖥️ **System** | PC, BIOS, OS, Windows activation, Windows Update, Secure Boot, TPM, antivirus, uptime, power |
| ⚙️ **CPU** | Model, cores/threads, base/boost, score /10 |
| 🧠 **RAM** | Capacity, type, speed, channel mode, score /10 |
| 🎨 **GPU General** | VRAM + general GPU score |
| 🎮 **GPU Gaming** | Dedicated gaming score + practical guidance |
| 💾 **Storage** | Type (NVMe/SSD/HDD), capacity, score |
| 🛡️ **SMART** | Health, temperature, counters, SSD wear (when available) |
| 🧭 **Usage profiles** | Primary + secondary profile (Gaming, CAD/CAO, Web/Office) |
| 🚨 **Alerts** | `CRITICAL` / `WARNING` / `INFO` |
| 🌐 **Bilingual** | FR/EN language picker at startup |
| 🧾 **Office** | Detected products + `Office activation` status |
| 📅 **Lifecycle** | Windows/Office support checks (example: Windows 10 support ended on 2025-10-14) |

### 🚀 Installation (EXE only)

1. Open [Releases](../../releases)
2. Download the latest `.exe`
3. Run the app (administrator mode recommended for full hardware visibility)

### 📊 Score scale

| Score | Verdict |
|------:|---------|
| 9.0 - 10.0 | Excellent |
| 7.0 - 8.9  | Very good |
| 5.0 - 6.9  | Good |
| 3.0 - 4.9  | Average |
| 0.0 - 2.9  | Low |

### 📐 Global score formula

`Score = CPU 25% + RAM 20% + GPU General 15% + GPU Gaming 15% + Storage 25%`

### 📦 Actions

| Button | Action |
|--------|--------|
| 🔄 `Refresh` | Reruns full analysis |
| 📋 `Copy` | Copies report to clipboard |
| 💾 `Export` | Exports `.txt` report to Desktop |

### ⚠️ Security notes

- Local hardware analysis tool (no cloud dependency in normal flow).
- Some antivirus engines may flag packed EXE builds (false positives).

---

## 📚 Project

- Changelog: [Changelog.md](./Changelog.md)
- License: [LICENSE](./LICENSE)

## 👤 Author

Nicleox - nicleox@cityx.link  
[☕ Buy me a coffee](https://buymeacoffee.com/nicleox)
