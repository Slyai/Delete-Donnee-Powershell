# Définir le chemin du dossier de profil de Chrome
$chromeProfilePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"

if ((Get-Date).DayOfWeek -ne 'Friday') {
    exit
}

# Vérifier si le dossier existe
if (Test-Path $chromeProfilePath) {
    # Supprimer les fichiers d'historique de navigation
    Remove-Item "$chromeProfilePath\History" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\History-journal" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\History Provider Cache" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\Cookies" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\IndexedDB\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\Local Storage\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\Session Storage\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\Login Data" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$chromeProfilePath\Login Data For Account" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "L'historique de navigation et les données de Chrome ont été supprimés."
} else {
    Write-Host "Le dossier de profil de Chrome n'a pas été trouvé."
}
