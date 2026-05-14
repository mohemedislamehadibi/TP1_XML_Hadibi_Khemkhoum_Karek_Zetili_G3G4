<?php
// ═══════════════════════════════════════════════════════
//  inscription.php — Inscription d'un membre à un concours
// ═══════════════════════════════════════════════════════

$xml = simplexml_load_file('../club.xml');
$message = '';
$typeMsg = '';

// ── Traitement du formulaire (soumission POST) ──
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $membreRef  = htmlspecialchars($_POST['membre']  ?? '');
    $concoursId = htmlspecialchars($_POST['concours'] ?? '');
    $complexite = intval($_POST['complexite'] ?? 0);
    $temps      = intval($_POST['temps'] ?? 0);

    // Validation des données
    if (!$membreRef || !$concoursId) {
        $message = "Veuillez sélectionner un membre et un concours.";
        $typeMsg = 'error';
    } elseif ($complexite < 0 || $complexite > 100) {
        $message = "La complexité doit être entre 0 et 100.";
        $typeMsg = 'error';
    } elseif ($temps <= 0) {
        $message = "Le temps d'exécution doit être supérieur à 0.";
        $typeMsg = 'error';
    } else {
        // Trouver le concours cible
        $concoursTarget = null;
        foreach ($xml->concours->concours as $c) {
            if ((string)$c['id'] === $concoursId) {
                $concoursTarget = $c;
                break;
            }
        }

        // Trouver le membre
        $membreCatRef = '';
        foreach ($xml->membres->membre as $m) {
            if ((string)$m['id'] === $membreRef) {
                $membreCatRef = (string)$m['categorieRef'];
                break;
            }
        }

        // Vérifier que le membre est dans la même catégorie que le concours
        if ($concoursTarget && (string)$concoursTarget['categorieRef'] !== $membreCatRef) {
            $message = "Ce membre n'appartient pas à la catégorie de ce concours !";
            $typeMsg = 'error';
        } else {
            // Vérifier si le membre participe déjà
            $dejaInscrit = false;
            foreach ($concoursTarget->participants->participant as $p) {
                if ((string)$p['membreRef'] === $membreRef) {
                    $dejaInscrit = true;
                    break;
                }
            }

            if ($dejaInscrit) {
                $message = "Ce membre est déjà inscrit à ce concours.";
                $typeMsg = 'error';
            } else {
                // Ajouter le nouveau participant dans le XML
                $nouveauParticipant = $concoursTarget->participants->addChild('participant');
                $nouveauParticipant->addAttribute('membreRef', $membreRef);
                $nouveauParticipant->addChild('complexite', $complexite);
                $nouveauParticipant->addChild('tempsExecution', $temps);

                // Sauvegarder le fichier XML mis à jour
                $xml->asXML('../club.xml');

                $message = "✅ Inscription réussie ! $membreRef ajouté au concours $concoursId.";
                $typeMsg = 'success';

                // Recharger le XML
                $xml = simplexml_load_file('../club.xml');
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inscription — Club Info_Tech</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

<header>
  <h1>🏆 Club Info_Tech</h1>
  <nav>
    <a href="index.php">📋 Concours</a>
    <a href="inscription.php" class="active">✍️ Inscription</a>
    <a href="resultats.php">🥇 Résultats</a>
    <a href="requetes.php">🔍 Requêtes libres</a>
  </nav>
</header>

<main>
  <h2>Inscription à un Concours</h2>

  <?php if ($message): ?>
    <div class="alert <?= $typeMsg ?>"><?= $message ?></div>
  <?php endif; ?>

  <div class="form-container">
    <form method="POST" action="inscription.php">

      <!-- Sélection du membre -->
      <div class="form-group">
        <label for="membre">👤 Membre</label>
        <select name="membre" id="membre" required>
          <option value="">-- Choisir un membre --</option>
          <?php foreach ($xml->membres->membre as $m): ?>
            <option value="<?= $m['id'] ?>">
              <?= $m['id'] ?> — <?= $m->prenom ?> <?= $m->nom ?>
              (<?= $m['categorieRef'] ?>)
            </option>
          <?php endforeach; ?>
        </select>
      </div>

      <!-- Sélection du concours -->
      <div class="form-group">
        <label for="concours">🏅 Concours</label>
        <select name="concours" id="concours" required>
          <option value="">-- Choisir un concours --</option>
          <?php foreach ($xml->concours->concours as $c): ?>
            <option value="<?= $c['id'] ?>">
              <?= $c['id'] ?> — <?= $c->titre ?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>

      <!-- Score complexité -->
      <div class="form-group">
        <label for="complexite">⚙️ Complexité (0–100)</label>
        <input type="number" name="complexite" id="complexite"
               min="0" max="100" placeholder="ex. 85" required>
      </div>

      <!-- Temps d'exécution -->
      <div class="form-group">
        <label for="temps">⏱️ Temps d'exécution (ms)</label>
        <input type="number" name="temps" id="temps"
               min="1" placeholder="ex. 120" required>
      </div>

      <button type="submit" class="btn-primary">Inscrire le membre</button>
    </form>
  </div>
</main>

<footer>
  <p>Club Info_Tech — Hadibi | Khemkhoum | Karek | Zetili — G3/G4 — Université de Skikda</p>
</footer>

</body>
</html>
