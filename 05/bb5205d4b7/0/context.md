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

### Prompt 3

merge o PR

### Prompt 4

cria o release v0.1.0, adicionar readme no github, tags, labels, descrição titulo. ficar com a página completa

### Prompt 5

o que é o sha? não é info sensivel? o que falta fazer?

### Prompt 6

sim, cria e faz push

### Prompt 7

basicamente tenho 2 repos agora? e se fizer actualizações os users recebem notificação para fazer update?

### Prompt 8

cria o github action para automatizar

