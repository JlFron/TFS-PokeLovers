# TFS 0.3.6 - Servidor Pokemon

Código-fonte do The Forgotten Server versão 0.3.6 com compilação automática via GitHub Actions.

## Como Usar

### 1. Criar repositório no GitHub

```powershell
# No Windows PowerShell
cd p:\TFS_SourceServer_Local

# Inicializar Git
git init
git add .
git commit -m "Initial commit - TFS 0.3.6 sources"

# Criar repositório no GitHub em https://github.com/new
# Nomear como: TFS-PokeLovers (ou outro nome)

# Fazer push
git remote add origin https://github.com/SEU_USUARIO/TFS-PokeLovers.git
git branch -M main
git push -u origin main
```

### 2. GitHub Actions compilará automaticamente

- Acesse: `https://github.com/SEU_USUARIO/TFS-PokeLovers/actions`
- Aguarde a compilação (leva ~5-10 minutos)
- Quando terminar (checkmark verde), clique na build
- Vá em "Artifacts" e baixe `tfs-binary`

### 3. Fazer deploy no servidor

```powershell
# Extraia o binary `tfs` do artifact
# Depois faça upload para o servidor:

scp tfs empire@192.168.1.101:~/pokelovers/tfs.new

# No servidor, faça backup e substitua:
ssh empire@192.168.1.101 "
  cd ~/pokelovers
  cp tfs tfs.old
  mv tfs.new tfs
  chmod +x tfs
  # Restart (o script auto-restart já vai rearrancar)
"
```

## Build Local (se quiser compilar localmente)

Após instalar WSL2 Ubuntu-22.04:

```bash
cd /mnt/p/TFS_SourceServer_Local
sudo apt-get install -y build-essential libxml2-dev libboost-all-dev automake autoconf pkg-config libtool
autoreconf -fiv
./configure
make -j4
```

## Status Atual

✅ Lua Configuration: FIXED (100% working)
⚠️ C++ Binary: Precisa recompilação para corrigir boost thread crash após 10-15s
✅ Auto-restart: Running @10s intervals

## Próximos Passos

1. Fazer push do código para GitHub
2. Aguardar GitHub Actions compilar
3. Baixar binário compilado
4. Deploy no servidor
