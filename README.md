# ⚡ CheckMyPower v1.2

> Analyse hardware complete de votre PC avec scoring sur 10, interface Neo-Neon.

[Image 1](./Capture1.jpg)  
[Image 2](./Capture2.jpg)

---

## 🔍 Fonctionnalités

| Module | Détails |
|--------|---------|
| 🖥️ **Systeme** | PC, BIOS, OS, activation, Secure Boot, TPM, antivirus, energie, uptime |
| ⚙️ **CPU** | Modele, coeurs/threads, frequence base/boost, score /10 |
| 🧠 **RAM** | Capacite, type (DDR/LPDDR), frequence, mode canal, score /10 |
| 🎨 **GPU General** | Modele, VRAM, score /10 |
| 🎮 **GPU Gaming** | Score gaming dedie + conseil de performance |
| 💾 **Stockage** | Type (NVMe/SSD/HDD), capacite, score /10 |
| 🛡️ **S.M.A.R.T** | Sante disque, temperature, heures ON, erreurs, usure SSD |
| ⚡ **Score Global** | Moyenne ponderee sur 10 avec verdict |
| 🌐 **Bilingue FR/EN** | Choix de langue au demarrage |
| 🧭 **Profils d'usage** | Profil principal + secondaire (Gaming, CAO, Web/Bureautique) |
| 🚨 **Alertes** | CRITIQUE / ATTENTION / INFO selon les signaux detectes |

---

## 🚀 Installation

### Executable
1. Va dans [Releases](../../releases)
2. Telecharge la version la plus recente (v1.2+)
3. Lance l'application en administrateur

---

## 📊 Barème des verdicts

| Score | Verdict |
|-------|---------|
| 9.0 - 10 | Excellent |
| 7.0 - 8.9 | Tres bien |
| 5.0 - 6.9 | Bon |
| 3.0 - 4.9 | Moyen |
| 0 - 2.9 | Faible |

---

## 📐 Calcul du score global

`Score = (CPU x 25%) + (RAM x 20%) + (GPU General x 15%) + (GPU Gaming x 15%) + (Stockage x 25%)`

---

## 📋 Export

- `Copier` -> copie le rapport complet dans le presse-papiers
- `Exporter` -> sauvegarde un fichier `.txt` sur le Bureau
- `Rafraichir` -> relance l'analyse complete

---

## ⚠️ Notes securite

- Faux positif antivirus possible avec certains builds PS2EXE.
- Le code source est lisible et verifiable dans ce depot.

---

## 📝 Changelog

Voir [Changelog.md](./Changelog.md)

---

## 👤 Auteur

Nicleox - nicleox@cityx.link  
[☕ Buy me a coffee](https://buymeacoffee.com/nicleox)
