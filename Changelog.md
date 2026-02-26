# 📋 Changelog

## v1.1 — 2026.02.26

### ✨ Nouveautés
- Ajout des informations **pilote GPU** dans le panneau Système (nom GPU, version, date du driver)
- Ajout de l'état du **disque système** (espace libre / capacité / pourcentage + alerte si espace faible)
- Ajout des informations **énergie** (profil d'alimentation actif + état secteur/batterie)

### 🔧 Améliorations
- Recalibrage des scores **GPU gaming** pour mieux refléter la hiérarchie 2026 (haut de gamme récent)
- Ajustement doux des scores **CPU mobiles** (facteur 0.95, plafond 9.4) pour limiter la pénalisation
- Renforcement de la détection VRAM via `dxdiag` (chemin explicite System32, fichier temporaire unique, nettoyage garanti)

### 🐛 Corrections
- Nettoyage de plusieurs artefacts de formatage dans les tables de scores
- Correction de bloc(s) de script instable(s) afin de garantir un parsing PowerShell propre (`Parse OK`)

### ✨ Nouveautés
- Ajout de la section **GPU Gaming** avec score dédié et conseil de performance
- Ajout de la section **S.M.A.R.T** (santé disque, température, heures d'utilisation, erreurs)
- Ajout du **Secure Boot** et **TPM** dans les infos système
- Ajout de la **langue**, **uptime** et **nom utilisateur** dans le panneau système
- Splash screen animé pendant le chargement
- Calcul du score sur 10, basé sur des analyses matérielles, jusqu’au premier trimestre 2026 (Q1 2026).

### 🔧 Améliorations
- Score CPU amélioré : meilleure détection des CPU mobiles haut de gamme (i7/i9 11e-12e gen)
- Table de référence CPU étendue (boost + scores pour processeurs mobiles)
- Table GPU Gaming complète (NVIDIA, AMD, Intel Arc, iGPU)
- Détection VRAM via registre Windows (plus précis)
- Détection type RAM améliorée (LPDDR4x, DDR5, LPDDR5)
- Score global pondéré (CPU 25%, RAM 20%, GPU 15%, Gaming 15%, Stockage 25%)

### 🎨 Interface
- Nouveau design **Neo-Neon** avec bordures colorées par catégorie
- Barres de progression colorées dynamiquement selon le score
- Bouton **Exporter** le rapport sur le Bureau
- Bouton **Copier** le rapport dans le presse-papier
- Bouton ☕ **Buy me a coffee** (PayPal)

### 🐛 Corrections
- Correction du score CPU pour les processeurs mobiles (était sous-évalué)
- Meilleure détection SSD vs HDD sur bus SATA/RAID

## v1.0 — 2026.02.24
- Version initiale
- Analyse CPU, RAM, GPU, Stockage
- Score global sur 9,9 (comme Winsat à l'époque)
