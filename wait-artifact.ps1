Write-Host "Aguardando artifact estar disponivel..." -ForegroundColor Yellow
Write-Host "Isso pode levar 1-2 minutos..."

$runId = "22533883433"
$apiUrl = "https://api.github.com/repos/JlFron/TFS-PokeLovers/actions/runs/$runId/artifacts"
$maxAttempts = 20
$attempt = 0

while ($attempt -lt $maxAttempts) {
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing -ErrorAction SilentlyContinue
        
        if ($response.artifacts -and $response.artifacts.Count -gt 0) {
            $artifact = $response.artifacts[0]
            Write-Host "[OK] Artifact encontrado: $($artifact.name)" -ForegroundColor Green
            
            $downloadUrl = $artifact.archive_download_url
            $outputZip = "tfs-binary.zip"
            
            Write-Host "Baixando..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $downloadUrl -OutFile $outputZip -Headers @{"Accept"="application/vnd.github+json"} -UseBasicParsing
            
            $size = (Get-Item $outputZip).Length / 1MB
            Write-Host "[OK] Download $size MB completo!" -ForegroundColor Green
            
            Write-Host "Extraindo..." -ForegroundColor Cyan
            Expand-Archive -Path $outputZip -DestinationPath tfs-extract -Force
            
            $binary = Get-ChildItem -Path tfs-extract -Name "theforgottenserver" -Recurse -ErrorAction SilentlyContinue
            if ($binary) {
                Copy-Item (Join-Path tfs-extract $binary) tfs -Force
                Write-Host "[OK] Binario pronto!" -ForegroundColor Green
                
                Remove-Item $outputZip -Force
                Remove-Item tfs-extract -Recurse -Force
                Write-Host ""
                Write-Host "PRONTO PARA DEPLOY!" -ForegroundColor Green
                Write-Host "Execute: .\deploy-to-server.ps1" -ForegroundColor Yellow
                exit 0
            }
            break
        }
    } catch {
        # Silent
    }
    
    $attempt++
    Write-Host "Tentativa $attempt/$maxAttempts..." -NoNewline
    Start-Sleep -Seconds 3
    Write-Host " OK"
}

Write-Host ""
Write-Host "Se nao conseguir, acesse:" -ForegroundColor Cyan
Write-Host "https://github.com/JlFron/TFS-PokeLovers/actions/runs/$runId" -ForegroundColor Blue
