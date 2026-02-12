# Session Context

## User Prompts

### Prompt 1

Implement the following plan:

# Plano: Distribuição via Homebrew

## Contexto

O Safo está completo (3 fases) mas não é instalável por outros. Precisamos de um caminho de distribuição para a equipa: `brew install` que instale o .app bundle (com URL scheme) e o CLI (`safo`).

## Estratégia

**Uma cask** no tap `andrefurt/homebrew-safo` que instala tudo: Safo.app em /Applications e o binário `safo` no PATH. Uma cask (não formula) porque precisamos distribuir o .app bundle pré-compilad...

### Prompt 2

faz commit e prepara o PR

