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

### Prompt 9

este token é para o homebrew safo ou o safo?

### Prompt 10

sim, merge. Antes disso, preciso que cries a documentação sobre esse processo de release. Talvez colocar no claude.md para não ficar esquecido. decide que melhor sitio por. também queria saber qual é a relação entre o homebrew e o repo normal, o que acontece (trabalho no repo normal se ouver novos updates, actualiza automaticamente o homebrew), explica. e outra coisa, não dá para mudar o nome do repo homebrew para outra coisa? ser só safo o publico e o outro ser safo qualquer coisa?

### Prompt 11

cria o secret

### Prompt 12

qual repo faço isso e em que repo gravo?

### Prompt 13

mas já criei essa HOMEBREW_TAP_TOKEN e guardei no repo homebrew

### Prompt 14

e apago o outro do homebrew?

### Prompt 15

já está, já gravei o token

### Prompt 16

antes de testares com uma release, documenta esse processo. documenta o processo de releases e must follow no claude.md se for o sitio mais adequado.

### Prompt 17

sim, testa

