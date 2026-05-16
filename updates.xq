


(: ---- OPERATION 1  ----
   on insere M012 dans la categorie Developpement Web (C2)
   avant : 11 membres  /  apres : 12 membres
:)

insert node
  <membre id="M012" categorieRef="C2">
    <nom>Ferhat</nom>
    <prenom>Ines</prenom>
    <email>i.ferhat@club.dz</email>
  </membre>
into doc("club.xml")//membres


(: ---- OPERATION 2  ----
   on passe de 1.2 a 2.0
   ca va changer tous les scores calcules pour ce concours
:)

replace value of node
  doc("club.xml")//concours[@id = "CO2"]/@coefficient
with "2.0"


(: ---- OPERATION 3  ----
   M007 = Karim Rahmani
   apres suppression CO3 aura seulement M008 et M009
   note : on supprime sa participation, pas le membre lui-meme
:)

delete node
  doc("club.xml")//concours[@id = "CO3"]//participant[@membreRef = "M007"]
