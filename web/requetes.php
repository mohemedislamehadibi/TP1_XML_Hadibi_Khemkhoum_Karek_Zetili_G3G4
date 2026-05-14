<?php
// ═══════════════════════════════════════════════════════
//  requetes.php — Requêtes XQuery via BaseX shell_exec
//  AUTEURS : Hadibi Mohamed Islam (G3) — Khemkhoum Fethi (G3)
//            Karek Abdenasser (G3) — Zetili Mossaab (G4)
// ═══════════════════════════════════════════════════════

$resultat = '';
$erreur   = '';
$xquery   = $_POST['xquery'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $xquery) {

    $basex   = '"C:\\Program Files (x86)\\BaseX\\bin\\basex.bat"';
    $xmlPath = realpath(__DIR__ . '/../club.xml');
    $xmlPath = str_replace('\\', '/', $xmlPath);
    $query   = str_replace('doc("club.xml")', 'doc("' . $xmlPath . '")', $xquery);
    $tmpFile = sys_get_temp_dir() . '\\query_tmp.xq';

    file_put_contents($tmpFile, $query);

    $cmd    = $basex . ' "' . $tmpFile . '" 2>&1';
    $output = shell_exec($cmd);

    if ($output === null || trim($output) === '') {
        $erreur = 'تعذّر تشغيل BaseX. تحقق من المسار: ' . $basex;
    } else {
        $resultat = htmlspecialchars(trim($output));
    }
}

$exemples = [
    'Q1 — أسماء الأعضاء' => 'for $m in doc("club.xml")//membre return <m>{$m/prenom/text()} {$m/nom/text()}</m>',
    'Q3 — حساب النقاط'   => 'for $c in doc("club.xml")//concours/concours for $p in $c//participant let $s := (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * xs:decimal($c/@coefficient) return <score membre="{$p/@membreRef}">{format-number($s,"0.00")}</score>',
    'Q4 — الفائز'        => 'for $c in doc("club.xml")//concours/concours let $coef := xs:decimal($c/@coefficient) let $scores := for $p in $c//participant return (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef let $max := max($scores) for $p in $c//participant let $s := (xs:decimal($p/complexite) + xs:decimal($p/tempsExecution)) * $coef where $s = $max return <vainqueur concours="{$c/titre/text()}">{doc("club.xml")//membre[@id=$p/@membreRef]/nom/text()}</vainqueur>',
];
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Requêtes — Club Info_Tech</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

<header>
  <h1>🏆 Club Info_Tech</h1>
  <nav>
    <a href="index.php">📋 Concours</a>
    <a href="inscription.php">✍️ Inscription</a>
    <a href="resultats.php">🥇 Résultats</a>
    <a href="requetes.php" class="active">🔍 Requêtes libres</a>
  </nav>
</header>

<main>
  <h2>Requêtes XQuery Libres</h2>

  <div class="exemples">
    <strong>Exemples :</strong>
    <?php foreach ($exemples as $label => $q): ?>
      <a href="?ex=<?= urlencode($q) ?>" class="badge"><?= $label ?></a>
    <?php endforeach; ?>
  </div>

  <?php if (isset($_GET['ex'])): $xquery = urldecode($_GET['ex']); endif; ?>

  <form method="POST" action="requetes.php">
    <div class="form-group">
      <label for="xquery">Requête XQuery :</label>
      <textarea name="xquery" id="xquery" rows="6"
                placeholder="for $m in doc(&quot;club.xml&quot;)//membre return $m/nom/text()"><?= htmlspecialchars($xquery) ?></textarea>
    </div>
    <button type="submit" class="btn-primary">▶ Exécuter</button>
  </form>

  <?php if ($erreur): ?>
    <div class="alert error"><?= $erreur ?></div>
  <?php endif; ?>

  <?php if ($resultat): ?>
    <h3>Résultat :</h3>
    <pre class="result-box"><?= $resultat ?></pre>
  <?php endif; ?>

</main>

<footer>
  <p>Club Info_Tech — Hadibi | Khemkhoum | Karek | Zetili — G3/G4 — Université de Skikda</p>
</footer>

</body>
</html>
