# Script para fazer deploy do novo binário TFS compilado
# Uso depois de baixar o artifact do GitHub Actions

param(
    [string]$TfsBinaryPath = "./tfs",
    [string]$ServerUser = "empire",
    [string]$ServerHost = "192.168.1.101",
    [string]$ServerPath = "~/pokelovers"
)

Write-Host "🚀 Deploy TFS para Servidor" -ForegroundColor Cyan
Write-Host ""

# Verificar se o binário existe
if (-not (Test-Path $TfsBinaryPath)) {
    Write-Host "❌ Binário não encontrado: $TfsBinaryPath" -ForegroundColor Red
    Write-Host "   Certifique-se de extrair o arquivo 'tfs-binary' do GitHub Actions artifact" -ForegroundColor Yellow
    exit 1
}

# Verificar se SCP está disponível
if (-not (Get-Command scp -ErrorAction SilentlyContinue)) {
    Write-Host "❌ SCP não encontrado. Git Bash ou OpenSSH deve estar instalado." -ForegroundColor Red
    exit 1
}

$FileSize = (Get-Item $TfsBinaryPath).Length / 1MB
Write-Host "📦 Binary: $TfsBinaryPath ($([math]::Round($FileSize, 2)) MB)" -ForegroundColor Green
Write-Host "🎯 Destino: $ServerUser@$ServerHost" -ForegroundColor Green
Write-Host ""

# Fazer backup no servidor e upload do novo binário
Write-Host "⏳ Fazendo backup do binário antigo..." -ForegroundColor Yellow
ssh "$ServerUser@$ServerHost" "cd $ServerPath && cp tfs tfs.backup.$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss')" | Out-Null

Write-Host "📤 Enviando novo binário..." -ForegroundColor Yellow
scp $TfsBinaryPath "$ServerUser@$ServerHost`:$ServerPath/tfs.new"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Upload concluído!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔄 Ativando novo binário..." -ForegroundColor Yellow
    
    # Mover para produção
    ssh "$ServerUser@$ServerHost" @"
      cd $ServerPath
      chmod +x tfs.new
      mv tfs tfs.old
      mv tfs.new tfs
      echo "✅ Novo binário ativado!"
      echo "⏳ Aguardando auto-restart..."
      sleep 2
      pgrep -f './tfs' && echo "✅ Servidor iniciando..." || echo "⚠️ Verificar manualmente"
"@
    
    Write-Host "✅ Deploy concluído com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Status:" -ForegroundColor Cyan
    Write-Host "- Binário antigo: tfs.old" -ForegroundColor Gray
    Write-Host "- Binários de backup: tfs.backup.* em $ServerPath" -ForegroundColor Gray
    Write-Host "- Server auto-restart: Ativo (10s cycles)" -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao fazer upload!" -ForegroundColor Red
    exit 1
}
