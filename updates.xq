(: ════════════════════════════════════════════════════════════
   FICHIER  : updates.xq
   PROJET   : Club Info_Tech — TP XML / XQuery Update Facility
   AUTEURS  : Hadibi Mohamed Islam (G3) — Khemkhoum Fethi (G3)
              Karek Abdenasser (G3) — Zetili Mossaab (G4)
   USAGE    :
     Dans BaseX GUI :
     1. Options → Preferences → cocher "Allow Updates" → OK
     2. Ouvrir ce fichier
     3. Sélectionner UNE opération à la fois → F5 pour exécuter
     4. Vérifier le résultat dans club.xml après chaque exécution
════════════════════════════════════════════════════════════ :)


(: ╔══════════════════════════════════════════════════════╗
   ║  OPÉRATION 1 — INSERTION (insert node)               ║
   ║  Ajouter un nouveau membre dans la catégorie C2      ║
   ║  Points : 1.5 pt                                     ║
   ╚══════════════════════════════════════════════════════╝

   AVANT  : <membres> contient M001 à M011 → 11 membres
   APRÈS  : <membres> contiendra M001 à M012 → 12 membres
            M012 appartient à "Développement Web" (C2)
:)

(: ── Construire le nœud XML à insérer (nouveau membre M012) ── :)
(: L'attribut categorieRef="C2" doit correspondre à un id existant dans club.xml :)
insert node
  <membre id="M012" categorieRef="C2">
    (: Informations personnelles du nouveau membre :)
    <nom>Ferhat</nom>
    <prenom>Ines</prenom>
    <email>i.ferhat@club.dz</email>
  </membre>
(: ── Destination : à l'intérieur de l'élément <membres> ── :)
(: "into" ajoute le nœud comme dernier enfant de <membres> :)
into doc("club.xml")//membres


(: ╔══════════════════════════════════════════════════════╗
   ║  OPÉRATION 2 — MODIFICATION (replace value of node)  ║
   ║  Changer le coefficient du concours CO2              ║
   ║  Points : 1.5 pt                                     ║
   ╚══════════════════════════════════════════════════════╝

   AVANT  : <concours id="CO2" ... coefficient="1.2">
   APRÈS  : <concours id="CO2" ... coefficient="2.0">
   IMPACT : Les scores CO2 sont maintenant multipliés par 2.0
:)

(: ── Sélectionner l'attribut @coefficient du concours ciblé ── :)
(: Le prédicat [@id = "CO2"] identifie uniquement le concours voulu :)
replace value of node
  doc("club.xml")//concours[@id = "CO2"]/@coefficient
(: ── Remplacer la valeur actuelle "1.2" par la nouvelle valeur "2.0" ── :)
with "2.0"


(: ╔══════════════════════════════════════════════════════╗
   ║  OPÉRATION 3 — SUPPRESSION (delete node)             ║
   ║  Supprimer le participant M007 du concours CO3       ║
   ║  Points : 1 pt                                       ║
   ╚══════════════════════════════════════════════════════╝

   AVANT  : CO3 a 3 participants : M007, M008, M009
   APRÈS  : CO3 a 2 participants : M008 (Nadia Saoudi), M009 (Riad Tabet)
   NOTE   : Le concours CO3 lui-même n'est pas supprimé
:)

(: ── Sélectionner le nœud <participant> à supprimer ── :)
(: Double prédicat : d'abord le concours CO3, puis le participant M007 :)
delete node
  doc("club.xml")//concours[@id = "CO3"]
    //participant[@membreRef = "M007"]
(: ── Après exécution : M007 (Karim Rahmani) ne participe plus à CO3 ── :)
