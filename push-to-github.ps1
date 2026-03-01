# Script para fazer push automático para GitHub
# Uso: .\push-to-github.ps1 -RepoName "TFS-PokeLovers" -Username "seu_usuario_github"

param(
    [string]$RepoName = "TFS-PokeLovers",
    [string]$Username = "YOUR_GITHUB_USERNAME"
)

if ($Username -eq "YOUR_GITHUB_USERNAME") {
    Write-Host "❌ Configure seu nome de usuário GitHub primeiro!"
    Write-Host "Uso: .\push-to-github.ps1 -Username 'seu_username'"
    exit 1
}

$RepoUrl = "https://github.com/$Username/$RepoName.git"

Write-Host "📦 Push para GitHub" -ForegroundColor Cyan
Write-Host "Repository: $RepoUrl" -ForegroundColor Green
Write-Host ""

# Verificar se git está instalado
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git não está instalado ou não está no PATH" -ForegroundColor Red
    exit 1
}

# Verificar se estamos no diretório correto
if (-not (Test-Path ".github/workflows/build.yml")) {
    Write-Host "❌ Execute este script a partir de p:\TFS_SourceServer_Local" -ForegroundColor Red
    exit 1
}

# Inicializar Git se necessário
if (-not (Test-Path ".git")) {
    Write-Host "✨ Inicializando repositório Git..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Initial commit - TFS 0.3.6 sources with GitHub Actions build"
    Write-Host "✅ Repositório inicializado" -ForegroundColor Green
}

# Configurar remote
Write-Host "🔗 Configurando remote..." -ForegroundColor Yellow
git remote remove origin 2>$null
git remote add origin $RepoUrl

# Fazer push
Write-Host "📤 Fazendo push para GitHub (main branch)..." -ForegroundColor Yellow
git branch -M main
git push -u origin main

Write-Host ""
Write-Host "✅ Push concluído!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Acesse https://github.com/$Username/$RepoName/actions"
Write-Host "2. Aguarde a compilação terminar (checkmark verde)"
Write-Host "3. Clique na build → Artifacts → Baixe 'tfs-binary'"
Write-Host "4. Extraia o arquivo e use: scp tfs empire@192.168.1.101:~/pokelovers/tfs.new"
Write-Host ""
