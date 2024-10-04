$lockFilePath = "$env:LOCALAPPDATA\LastRun.txt"
$fichierJournal = "$env:LOCALAPPDATA\SuppressionLog.txt"

# Nom de l'utilisateur dont on veut supprimer les données
$utilisateur = "NomUtilisateur"

# Dossiers à nettoyer
$dossierBureau = "C:\Users\$utilisateur\Desktop"
$dossierDocuments = "C:\Users\$utilisateur\Documents"
$dossierTelechargements = "C:\Users\$utilisateur\Downloads"
$dossierPhotos = "C:\Users\$utilisateur\Pictures"
$dossierVideos = "C:\Users\$utilisateur\Videos"
$dossierMusique = "C:\Users\$utilisateur\Music"

# Vérification du jour pour les utilisateur étant la plusieurs jours
if ((Get-Date).DayOfWeek -ne 'Monday') {
    exit
}

# Lire la date de la dernière exécution pour éviter la double execution le même jour
$lastRunDate = $null
if (Test-Path $lockFilePath) {
    $lastRunDateString = Get-Content $lockFilePath | Out-String
    $lastRunDateString = $lastRunDateString.Trim()
    $lastRunDate = Get-Date $lastRunDateString -ErrorAction SilentlyContinue
    if ($lastRunDate -and $lastRunDate -ge (Get-Date).AddDays(-1)) {
        exit
    }
}

# Fonction pour supprimer les fichiers et dossiers dans les dossier selectionner
function Supprimer-Contenu {
    param (
        [string]$dossier
    )

    # Vérifiez si le dossier existe
    if (-Not (Test-Path $dossier)) {
        Add-Content -Path $fichierJournal -Value "Dossier non trouvé : $dossier - $(Get-Date)"
        return
    }

    # Obtenir tous les fichiers et dossiers dans le dossier, sauf les fichiers .lnk et .url
    $contenu = Get-ChildItem -Path $dossier | Where-Object { $_.Extension -ne ".lnk" -and $_.Extension -ne ".url" }

    # Supprimer chaque élément trouvé
    foreach ($element in $contenu) {
        try {
            Remove-Item -Path $element.FullName -Recurse -Force
            Add-Content -Path $fichierJournal -Value "Supprimé : $($element.FullName) - $(Get-Date)"
        } catch {
            Add-Content -Path $fichierJournal -Value "Erreur lors de la suppression de : $($element.FullName) - $_ - $(Get-Date)"
        }
    }
}

# Supprimer les fichiers et dossiers des différents dossiers
Supprimer-Contenu -dossier $dossierBureau
Supprimer-Contenu -dossier $dossierDocuments
Supprimer-Contenu -dossier $dossierTelechargements
Supprimer-Contenu -dossier $dossierPhotos
Supprimer-Contenu -dossier $dossierVideos
Supprimer-Contenu -dossier $dossierMusique

# Mettre à jour le fichier de verrouillage avec la date actuelle
(Get-Date).ToString("o") | Out-File $lockFilePath -Force
