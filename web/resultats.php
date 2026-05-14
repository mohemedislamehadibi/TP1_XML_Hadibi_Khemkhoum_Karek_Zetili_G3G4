<?php


$xml = simplexml_load_file('../club.xml');
$concoursSelectionne = $_GET['concours'] ?? '';
$resultats = [];
$scoreMax  = 0;
$titreConc = '';
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Résultats — Club Info_Tech</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

<header>
  <h1>🏆 Club Info_Tech</h1>
  <nav>
    <a href="index.php">📋 Concours</a>
    <a href="inscription.php">✍️ Inscription</a>
    <a href="resultats.php" class="active">🥇 Résultats</a>
    <a href="requetes.php">🔍 Requêtes libres</a>
  </nav>
</header>

<main>
  <h2>Résultats des Concours</h2>

  
  <form method="GET" action="resultats.php" class="form-inline">
    <label for="concours">Sélectionner un concours :</label>
    <select name="concours" id="concours">
      <option value="">-- Choisir --</option>
      <?php foreach ($xml->concours->concours as $c): ?>
        <option value="<?= $c['id'] ?>"
          <?= ($concoursSelectionne === (string)$c['id']) ? 'selected' : '' ?>>
          <?= $c['id'] ?> — <?= $c->titre ?>
        </option>
      <?php endforeach; ?>
    </select>
    <button type="submit" class="btn-primary">Afficher</button>
  </form>

  <?php
  
  if ($concoursSelectionne):
    foreach ($xml->concours->concours as $c) {
      if ((string)$c['id'] === $concoursSelectionne) {
        $titreConc = (string)$c->titre;
        $coef = (float)$c['coefficient'];

        // Calculer les scores de tous les participants
        foreach ($c->participants->participant as $p) {
          $membreRef = (string)$p['membreRef'];
          $nom = '';
          foreach ($xml->membres->membre as $m) {
            if ((string)$m['id'] === $membreRef) {
              $nom = $m->prenom . ' ' . $m->nom;
              break;
            }
          }
          $score = ((int)$p->complexite + (int)$p->tempsExecution) * $coef;
          $resultats[] = [
            'nom'         => $nom,
            'complexite'  => (int)$p->complexite,
            'temps'       => (int)$p->tempsExecution,
            'score'       => $score
          ];
          if ($score > $scoreMax) $scoreMax = $score;
        }
        break;
      }
    }

    
    usort($resultats, fn($a, $b) => $b['score'] <=> $a['score']);
  ?>

  <h3>📊 Résultats : <?= htmlspecialchars($titreConc) ?></h3>
  <table>
    <thead>
      <tr>
        <th>Rang</th>
        <th>Participant</th>
        <th>Complexité</th>
        <th>Temps (ms)</th>
        <th>Score</th>
        <th>Statut</th>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($resultats as $i => $r): ?>
        <tr class="<?= ($r['score'] === $scoreMax) ? 'vainqueur' : '' ?>">
          <td class="center"><?= $i + 1 ?></td>
          <td><?= htmlspecialchars($r['nom']) ?></td>
          <td class="center"><?= $r['complexite'] ?></td>
          <td class="center"><?= $r['temps'] ?></td>
          <td class="center"><strong><?= number_format($r['score'], 2) ?></strong></td>
          <td class="center">
            <?= ($r['score'] === $scoreMax) ? '🥇 Vainqueur' : '' ?>
          </td>
        </tr>
      <?php endforeach; ?>
    </tbody>
  </table>

  <?php endif; ?>

</main>

<footer>
  <p>Club Info_Tech — Hadibi | Khemkhoum | Karek | Zetili — G3/G4 — Université de Skikda</p>
</footer>

</body>
</html>
