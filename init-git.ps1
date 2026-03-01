# Script de inicialização Git simples
# Execute uma única vez antes de fazer push

Write-Host "🚀 Inicializando repositório Git" -ForegroundColor Cyan
Write-Host ""

# Verificar Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Git não instalado!" -ForegroundColor Red
    Write-Host "   Baixe em: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# Configurar Git globalmente (uma vez)
Write-Host "⚙️  Configurando Git..." -ForegroundColor Yellow

$email = Read-Host "Email GitHub"
$name = Read-Host "Nome (para commits)"

git config --global user.email $email
git config --global user.name $name

# Inicializar repositório local
Write-Host ""
Write-Host "📦 Inicializando repositório..." -ForegroundColor Yellow

if (Test-Path ".git") {
    Write-Host "   ℹ️  .git ja existe, pulando init" -ForegroundColor Gray
} else {
    git init
}

# Adicionar todos os arquivos
Write-Host "📝 Adicionando arquivos..." -ForegroundColor Yellow
git add .

# Primeiro commit
$message = Read-Host "Mensagem do commit (default: 'Initial commit')"
if ([string]::IsNullOrWhiteSpace($message)) {
    $message = "Initial commit - TFS 0.3.6 sources with GitHub Actions build"
}

git commit -m $message

Write-Host ""
Write-Host "✅ Git inicializado!" -ForegroundColor Green
Write-Host ""
Write-Host "📖 Próximo passo:" -ForegroundColor Cyan
Write-Host "   .\push-to-github.ps1 -Username 'seu_usuario_github'" -ForegroundColor Yellow
Write-Host ""
