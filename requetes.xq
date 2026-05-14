(: ════════════════════════════════════════════════════════════
   FICHIER  : requetes.xq
   PROJET   : Club Info_Tech — TP XML / XQuery
   AUTEURS  : Hadibi Mohamed Islam (G3) — Khemkhoum Fethi (G3)
              Karek Abdenasser (G3) — Zetili Mossaab (G4)
   MODULE   : Données semi-structurées
   BASE     : club.xml  (chargée dans BaseX → Database → New)
   USAGE    :
     1. Ouvrir BaseX GUI
     2. Database → New → pointer vers club.xml → OK
     3. File → Open → ouvrir ce fichier
     4. Sélectionner UNE requête à la fois → F5 pour exécuter
════════════════════════════════════════════════════════════ :)


(: ╔══════════════════════════════════════════════════════╗
   ║  Q1 — Liste complète des membres avec leur catégorie ║
   ║  Points : 1 pt                                       ║
   ╚══════════════════════════════════════════════════════╝ :)

(: Résultat attendu : un élément XML <membres> contenant
   tous les membres avec leur nom complet, email et catégorie :)

<membres>
{
  (: ── FOR : itérer sur chaque élément <membre> du document ── :)
  for $membre in doc("club.xml")//membre

  (: ── LET : récupérer la catégorie via jointure sur l'attribut @id ── :)
  (: On cherche la <categorie> dont @id = @categorieRef du membre courant :)
  let $cat := doc("club.xml")//categorie[@id = $membre/@categorieRef]

  (: ── RETURN : construire un élément XML de résultat pour ce membre ── :)
  return
    <membre id="{$membre/@id}">
      (: Concaténation du prénom et du nom en un seul texte :)
      <nomComplet>{$membre/prenom/text()} {$membre/nom/text()}</nomComplet>
      <email>{$membre/email/text()}</email>
      (: Afficher le libellé lisible de la catégorie (pas juste son id) :)
      <categorie>{$cat/@libelle/string()}</categorie>
    </membre>
}
</membres>


(: ╔══════════════════════════════════════════════════════╗
   ║  Q2 — Liste des concours triés par date croissante   ║
   ║  Points : 1 pt                                       ║
   ╚══════════════════════════════════════════════════════╝ :)

(: Résultat attendu : liste des concours triée du plus ancien
   au plus récent, avec le libellé de leur catégorie :)

<listeConcours>
{
  (: ── FOR : itérer sur chaque <concours> item (enfant de la liste) ── :)
  (: Note : //concours/concours car <concours> liste contient des <concours> items :)
  for $c in doc("club.xml")//concours/concours

  (: ── LET : récupérer le libellé de la catégorie du concours ── :)
  let $cat := doc("club.xml")//categorie[@id = $c/@categorieRef]

  (: ── ORDER BY : trier par date en convertissant l'attribut en xs:date ── :)
  (: Sans conversion xs:date, le tri serait alphabétique (incorrect) :)
  order by xs:date($c/@date) ascending

  (: ── RETURN : construire l'élément XML résultat pour ce concours ── :)
  return
    <concours id="{$c/@id}">
      <titre>{$c/titre/text()}</titre>
      <date>{$c/@date/string()}</date>
      <coefficient>{$c/@coefficient/string()}</coefficient>
      (: Jointure vers la catégorie pour afficher son nom lisible :)
      <categorie>{$cat/@libelle/string()}</categorie>
    </concours>
}
</listeConcours>


(: ╔══════════════════════════════════════════════════════╗
   ║  Q3 — Calcul du score de chaque participant          ║
   ║  Formule : score = (complexite + tempsExecution)     ║
   ║            × coefficient                             ║
   ║  Points : 2 pts                                      ║
   ╚══════════════════════════════════════════════════════╝ :)

(: Résultat attendu : pour chaque concours, la liste des
   participants avec leur score calculé selon la formule du sujet :)

<resultats>
{
  (: ── FOR niveau 1 : itérer sur chaque concours ── :)
  for $c in doc("club.xml")//concours/concours

  (: ── LET : extraire le coefficient en xs:decimal pour le calcul ── :)
  (: La conversion est nécessaire car @coefficient est un string dans le XML :)
  let $coef := xs:decimal($c/@coefficient)

  return
    <concours titre="{$c/titre/text()}">
    {
      (: ── FOR niveau 2 : itérer sur chaque participant du concours courant ── :)
      for $p in $c//participant

      (: ── LET (1) : jointure pour récupérer le <membre> correspondant ── :)
      (: On cherche le membre dont @id = @membreRef du participant :)
      let $membre := doc("club.xml")//membre[@id = $p/@membreRef]

      (: ── LET (2) : appliquer la formule score = (complexite + temps) × coef ── :)
      (: Conversion en xs:decimal pour éviter les erreurs de type XQuery :)
      let $score := (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef

      (: ── RETURN : afficher les détails du participant et son score ── :)
      return
        <participant>
          <nom>{$membre/prenom/text()} {$membre/nom/text()}</nom>
          <complexite>{$p/complexite/text()}</complexite>
          <tempsExecution>{$p/tempsExecution/text()}</tempsExecution>
          (: format-number("0.00") garantit 2 décimales dans l'affichage :)
          <score>{format-number($score, "0.00")}</score>
        </participant>
    }
    </concours>
}
</resultats>


(: ╔══════════════════════════════════════════════════════╗
   ║  Q4 — Vainqueur de chaque concours                   ║
   ║  (participant avec le score maximum)                 ║
   ║  Points : 2 pts                                      ║
   ╚══════════════════════════════════════════════════════╝ :)

(: Résultat attendu : pour chaque concours, le ou les vainqueurs
   (gère les ex-aequo) avec leur score maximum :)

<vainqueurs>
{
  (: ── FOR : itérer sur chaque concours ── :)
  for $c in doc("club.xml")//concours/concours

  (: ── LET (1) : extraire le coefficient du concours en décimal ── :)
  let $coef := xs:decimal($c/@coefficient)

  (: ── LET (2) : calculer la séquence de tous les scores du concours ── :)
  (: Cette séquence XQuery sera passée à la fonction max() ci-dessous :)
  let $scores :=
    for $p in $c//participant
    return (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef

  (: ── LET (3) : extraire le score maximum via la fonction max() ── :)
  let $scoreMax := max($scores)

  (: ── RETURN : construire le bloc résultat du concours ── :)
  return
    <concours titre="{$c/titre/text()}" scoreMax="{format-number($scoreMax, '0.00')}">
    {
      (: ── FOR imbriqué : reparcourir les participants pour trouver le/les max ── :)
      for $p in $c//participant

      (: ── LET : recalculer le score individuel pour comparaison ── :)
      let $scorePart := (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef

      (: ── WHERE : garder UNIQUEMENT les participants dont score = scoreMax ── :)
      (: Ce filtre gère automatiquement les cas d'ex-aequo :)
      where $scorePart = $scoreMax

      (: ── LET : récupérer les informations du membre vainqueur ── :)
      let $membre := doc("club.xml")//membre[@id = $p/@membreRef]

      (: ── RETURN : afficher le vainqueur avec son score ── :)
      return
        <vainqueur>
          <prenom>{$membre/prenom/text()}</prenom>
          <nom>{$membre/nom/text()}</nom>
          <score>{format-number($scorePart, "0.00")}</score>
        </vainqueur>
    }
    </concours>
}
</vainqueurs>


(: ╔══════════════════════════════════════════════════════╗
   ║  Q5 — Membres d'une catégorie triés alphabétiquement ║
   ║  Points : 2 pts                                      ║
   ╚══════════════════════════════════════════════════════╝ :)

(: Résultat attendu : membres de la catégorie choisie,
   triés par nom puis prénom en ordre alphabétique A→Z :)

(: ── LET global (1) : définir la catégorie à filtrer ── :)
(: 🔧 Modifier cette valeur pour changer la catégorie affichée :)
let $categorie := "Intelligence Artificielle"

(: ── LET global (2) : retrouver l'@id à partir du libellé de la catégorie ── :)
(: Evite de coder en dur "C1" et rend la requête générique et réutilisable :)
let $idCat := doc("club.xml")//categorie[@libelle = $categorie]/@id

(: ── RETURN : construire l'élément racine avec l'attribut catégorie ── :)
return
<membresCategorie categorie="{$categorie}">
{
  (: ── FOR : itérer sur les membres appartenant à la catégorie cible ── :)
  (: Le prédicat [@categorieRef = $idCat] filtre directement dans le FOR :)
  for $m in doc("club.xml")//membre[@categorieRef = $idCat]

  (: ── ORDER BY : tri alphabétique — primaire sur nom, secondaire sur prénom ── :)
  (: "ascending" est le défaut XQuery mais on l'écrit pour la clarté :)
  order by $m/nom/text() ascending, $m/prenom/text() ascending

  (: ── RETURN : afficher les informations du membre ── :)
  return
    <membre id="{$m/@id}">
      <nom>{$m/nom/text()}</nom>
      <prenom>{$m/prenom/text()}</prenom>
      <email>{$m/email/text()}</email>
    </membre>
}
</membresCategorie>
