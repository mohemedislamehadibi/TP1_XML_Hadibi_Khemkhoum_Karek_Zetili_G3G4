# 🏆 Club Info_Tech — TP Mini-Projet XML / XQuery

**Université 20 Août 1955 — Skikda | Licence 3 ISIL**
**Module : Données semi-structurées**

---

## 👥 Membres du groupe

| Nom Prénom | Groupe |
|---|---|
| Hadibi Mohamed Islam | G3 |
| Khemkhoum Fethi | G3 |
| Karek Abdenasser | G3 |
| Zetili Mossaab | G4 |

---

## 📁 Arborescence du projet (§4.1)

```
TP1_XML_Hadibi_Khemkhoum_Karek_Zetili_G3G4/
│
├── club.xml              ← Base de données XML (4 catégories, 11 membres, 3 concours)
├── club.xsd              ← Schéma de validation XSD
├── requetes.xq           ← 5 requêtes XQuery commentées (Q1 à Q5)
├── updates.xq            ← 3 opérations de mise à jour XQuery
│
├── capture/              ← Captures d'écran de démonstration
│   └── GUIDE_SCREENSHOTS.md
│
└── web/                  ← Application PHP (bonus 5 pts)
    ├── index.php         ← Page 1 : Liste des concours
    ├── inscription.php   ← Page 2 : Inscription membre/concours
    ├── resultats.php     ← Page 3 : Résultats et vainqueur
    ├── requetes.php      ← Page 4 : Requêtes XQuery libres
    └── style.css         ← Feuille de style commune
```

---

## 🛠️ Technologies utilisées

| Technologie | Usage |
|---|---|
| XML 1.0 | Stockage des données du club |
| XSD | Validation du schéma XML |
| XQuery 3.1 | Requêtes et mises à jour |
| BaseX 10.x | Moteur d'exécution XQuery |
| PHP 8.x | Application web (bonus) |
| XAMPP | Serveur local PHP |

---

## ▶️ Comment exécuter

### Prérequis
- [BaseX](https://basex.org/download/) installé
- XAMPP installé (pour la partie web)

### Étapes
1. **Cloner le dépôt**
   ```bash
   git clone https://github.com/VOTRE_USERNAME/TP1_XML_NomPrenom1_NomPrenom2_Gxx.git
   ```

2. **Charger club.xml dans BaseX**
   - Ouvrir BaseX GUI
   - `Database → New` → nommer la base "club" → sélectionner `club.xml` → OK

3. **Exécuter les requêtes**
   - `File → Open → requetes.xq`
   - Sélectionner une requête → `F5`

4. **Exécuter les mises à jour**
   - `Options → Preferences → Allow Updates` → cocher → OK
   - `File → Open → updates.xq`
   - Sélectionner une opération → `F5`

5. **Lancer l'application web**
   - Copier le dossier `web/` dans `C:\xampp\htdocs\club_infotech\`
   - Démarrer XAMPP (Apache)
   - Ouvrir `http://localhost/club_infotech/web/`

---

## 📊 Récapitulatif des requêtes

| Requête | Description | Points |
|---|---|---|
| Q1 | Liste de tous les membres avec leur catégorie | 1 pt |
| Q2 | Liste des concours triés par date croissante | 1 pt |
| Q3 | Calcul du score : `(complexite + temps) × coefficient` | 2 pts |
| Q4 | Vainqueur de chaque concours (score max, ex-aequo inclus) | 2 pts |
| Q5 | Membres d'une catégorie triés alphabétiquement | 2 pts |
| INSERT | Ajout du membre M012 (Ines Ferhat) dans C2 | 1.5 pts |
| MODIFY | Modification du coefficient de CO2 : 1.2 → 2.0 | 1.5 pts |
| DELETE | Suppression du participant M007 du concours CO3 | 1 pt |
| Web PHP | Application 4 pages (bonus) | 5 pts |

**Total : 15 pts + 5 pts bonus**

---

## 🎬 Démonstration YouTube

🔗 **Lien vidéo :** [À compléter après enregistrement]

---

## 📧 Soumission

Envoyé à : **kasdata2609@gmail.com**
- ✅ Lien GitHub
- ✅ Lien YouTube
