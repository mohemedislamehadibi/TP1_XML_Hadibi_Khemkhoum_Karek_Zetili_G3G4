<?php


$xml = simplexml_load_file('../club.xml');
if (!$xml) {
    die("<p style='color:red'>Erreur : impossible de charger club.xml</p>");
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Club Info_Tech</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

<header>
  <h1>🏆 Club Info_Tech</h1>
  <nav>
    <a href="index.php" class="active">📋 Concours</a>
    <a href="inscription.php">✍️ Inscription</a>
    <a href="resultats.php">🥇 Résultats</a>
    <a href="requetes.php">🔍 Requêtes libres</a>
  </nav>
</header>

<main>
  <h2>Liste des Concours</h2>

  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Titre</th>
        <th>Date</th>
        <th>Catégorie</th>
        <th>Coefficient</th>
        <th>Participants</th>
      </tr>
    </thead>
    <tbody>
    <?php
    
    foreach ($xml->concours->concours as $c) {
        $idCat = (string)$c['categorieRef'];

        
        $libelle = '';
        foreach ($xml->categories->categorie as $cat) {
            if ((string)$cat['id'] === $idCat) {
                $libelle = (string)$cat['libelle'];
                break;
            }
        }

        
        $nbPart = count($c->participants->participant);

        echo "<tr>
                <td>{$c['id']}</td>
                <td>{$c->titre}</td>
                <td>{$c['date']}</td>
                <td><span class='badge'>{$libelle}</span></td>
                <td class='center'>{$c['coefficient']}</td>
                <td class='center'>{$nbPart}</td>
              </tr>";
    }
    ?>
    </tbody>
  </table>
</main>

<footer>
  <p>Club Info_Tech — Hadibi | Khemkhoum | Karek | Zetili — G3/G4 — Université de Skikda</p>
</footer>

</body>
</html>
