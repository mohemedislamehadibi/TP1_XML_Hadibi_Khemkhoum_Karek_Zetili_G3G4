

(: ==== Q1 : liste de tous les membres avec leur categorie ==== :)


<membres>
{
  for $membre in doc("club.xml")//membre
  let $cat := doc("club.xml")//categorie[@id = $membre/@categorieRef]
  return
    <membre id="{$membre/@id}">
      <nomComplet>{$membre/prenom/text()} {$membre/nom/text()}</nomComplet>
      <email>{$membre/email/text()}</email>
      <categorie>{$cat/@libelle/string()}</categorie>
    </membre>
}
</membres>


(: ==== Q2 : concours tries par date (du plus ancien au plus recent) ==== :)


<listeConcours>
{
  for $c in doc("club.xml")//concours/concours
  let $cat := doc("club.xml")//categorie[@id = $c/@categorieRef]
  order by xs:date($c/@date) ascending
  return
    <concours id="{$c/@id}">
      <titre>{$c/titre/text()}</titre>
      <date>{$c/@date/string()}</date>
      <coefficient>{$c/@coefficient/string()}</coefficient>
      <categorie>{$cat/@libelle/string()}</categorie>
    </concours>
}
</listeConcours>


(: ==== Q3 : score de chaque participant ====
   formule : score = (complexite + tempsExecution) * coefficient
:)

<resultats>
{
  for $c in doc("club.xml")//concours/concours
  let $coef := xs:decimal($c/@coefficient)
  return
    <concours titre="{$c/titre/text()}">
    {
      for $p in $c//participant
      let $membre := doc("club.xml")//membre[@id = $p/@membreRef]
      let $score  := (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef
      return
        <participant>
          <nom>{$membre/prenom/text()} {$membre/nom/text()}</nom>
          <complexite>{$p/complexite/text()}</complexite>
          <tempsExecution>{$p/tempsExecution/text()}</tempsExecution>
          <score>{format-number($score, "0.00")}</score>
        </participant>
    }
    </concours>
}
</resultats>


(: ==== Q4 : vainqueur(s) de chaque concours ====
   on recalcule tous les scores pour trouver le max
   si ex-aequo le WHERE affiche les deux
:)

<vainqueurs>
{
  for $c in doc("club.xml")//concours/concours
  let $coef := xs:decimal($c/@coefficient)
  let $scores :=
    for $p in $c//participant
    return (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef
  let $scoreMax := max($scores)
  return
    <concours titre="{$c/titre/text()}" scoreMax="{format-number($scoreMax, '0.00')}">
    {
      for $p in $c//participant
      let $scorePart := (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef
      where $scorePart = $scoreMax
      let $membre := doc("club.xml")//membre[@id = $p/@membreRef]
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


(: ==== Q5 : membres d'une categorie, tries alphabetiquement ====
   changer $categorie pour filtrer sur une autre
:)

let $categorie := "Intelligence Artificielle"
let $idCat     := doc("club.xml")//categorie[@libelle = $categorie]/@id
return
<membresCategorie categorie="{$categorie}">
{
  for $m in doc("club.xml")//membre[@categorieRef = $idCat]
  order by $m/nom/text() ascending, $m/prenom/text() ascending
  return
    <membre id="{$m/@id}">
      <nom>{$m/nom/text()}</nom>
      <prenom>{$m/prenom/text()}</prenom>
      <email>{$m/email/text()}</email>
    </membre>
}
</membresCategorie>
