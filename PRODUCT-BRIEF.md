# Safo - Product Brief

## Problem Statement

Developers que trabalham no terminal com ferramentas AI (Claude Code) produzem e consomem markdown constantemente, mas as ferramentas de preview existentes ou renderizam em monospace com limitações visuais (Glow, mdcat), ou são apps pesadas sem integração CLI (Typora, Marked 2), ou têm bugs crónicos (QLMarkdown, MacDown). Nenhuma ferramenta combina CLI-first com GUI nativa e tipografia rica num formato leve e integrado no workflow de terminal.

## Target User

```
Name: Terminal-Native Creator
Goal: Ver markdown com tipografia rica sem sair do contexto de trabalho
Context: Trabalha no terminal (Claude Code, git, vim). Produz markdown como artefacto de trabalho
         (specs, docs, plans), não como documento final. Alterna constantemente entre gerar e ler.
Frustration: Glow é monospaced e limitado. Abrir Typora/Marked 2 quebra o flow. Browser tabs
             são ruído. Quick Look é medíocre.
Constraint: Não quer configurar nada. Não quer apps pesadas. Quer que funcione no instante.
LOVE stage: Value (produtividade no core loop diário)
Quote: "Quero ver o que gerei. Agora. Bonito. Sem sair daqui."
Confidence: High
```

## LOVE Stage Focus

**Value**. Este produto resolve um problema de produtividade no core loop diário: gerar markdown com AI, ver o resultado formatado, iterar. Não há barreira de Learn (o user já sabe o que é markdown). Onboard é trivial (comando CLI ou hook automático). O valor está na execução repetida do ciclo ver/ler/copiar.

## Core Features (Prioritized)

### Must

- **CLI launcher**: `safo file.md` abre a app com o ficheiro. Confidence: H
- **Markdown rendering completo**: GFM (headings, bold, italic, strikethrough, links, blockquotes, tables, task lists, code blocks com syntax highlighting language-specific, horizontal rules). Confidence: H
- **Dark/light mode automático**: segue o system theme do macOS. Confidence: H
- **File watching**: atualiza o preview em tempo real quando o ficheiro muda no disco. Confidence: H
- **Copy button**: copia o markdown source do ficheiro para o clipboard. Confidence: H
- **Sidebar minimal**: lista de ficheiros .md na pasta actual e subpastas. Toggle via icon no topo. Confidence: H
- **Prev/next navigation**: navega sequencialmente pela lista de .md. Confidence: H
- **Janela posicionada à direita**: abre com 40% da largura do ecrã, altura total, posicionada à direita. Redimensionável e repositionável depois. Confidence: H
- **Single window**: se a app já está aberta e recebe novo ficheiro, navega para ele na mesma janela. Confidence: H

### Should

- **Claude Code hook**: hook automático que abre Safo quando Claude Code escreve um .md. Confidence: M (depende da API de hooks do Claude Code)
- **Render last message**: comando para salvar a última mensagem do Claude como .md temporário e abrir no Safo. Confidence: M (depende de integração com Claude Code)
- **Scroll position preservation**: ao mudar entre ficheiros e voltar, manter scroll position. Confidence: H

### Could

- **Keyboard shortcuts**: cmd+] / cmd+[ para prev/next. Escape para fechar. Confidence: H
- **Search within file**: cmd+F para procurar texto no ficheiro actual. Confidence: H
- **Breadcrumb path**: mostrar o path do ficheiro actual no topo. Confidence: H

### Won't (this version)

- **Settings UI**: sem painel de configuração. Estilos são hardcoded.
- **Export (PDF/HTML)**: não é o propósito. Copy basta.
- **Rendering de imagens**: text-only para v1.
- **Edição de markdown**: isto é um viewer, não um editor.
- **Navegação entre pastas**: nunca navega para fora da pasta/subpastas do ficheiro aberto.
- **Tabs/múltiplas janelas**: single window, single file focus.

## What We Are NOT Building

- **Um editor markdown.** Safo é read-only. Edição acontece no terminal/editor do user.
- **Um replacement do Finder.** A sidebar mostra .md da pasta actual, não é um file browser.
- **Uma app configurável.** Sem settings, sem temas, sem plugins. Os estilos são opinião do produto.
- **Uma app cross-platform.** macOS only. SwiftUI nativo.
- **Uma app pública (por agora).** Uso interno equipa Significa.

## Domain Model

```
ACTORS              OBJECTS           ACTIONS              RULES
User (terminal) >   File (.md)    >   Open (via CLI)   >   Só aceita .md
                                      View              >   Renderiza GFM completo
                                      Copy              >   Copia markdown source
                                      Navigate          >   Dentro da pasta/subpastas
                                                            Prev/next na lista

Claude Code     >   File (.md)    >   Create/Write     >   Trigger: hook detecta write
                                                            Safo abre/navega auto

System (macOS)  >   Theme         >   Change            >   Safo segue dark/light
                    File (.md)    >   Modify            >   File watcher atualiza preview

Safo            >   Sidebar       >   Toggle            >   Icon no topo abre/fecha
                    Window        >   Position          >   40% largura, direita, altura total
                                      Resize            >   Livre após abertura
                                      Close             >   App termina
                                                            |
                                                          EVENTS
                                                          File Created (.md) > Safo abre/navega
                                                          File Modified > Preview atualiza
                                                          Theme Changed > UI atualiza
                                                          CLI invoked > Abre/navega para ficheiro
```

## Success Metrics

- **Time to preview**: < 500ms entre `safo file.md` e conteúdo visível. How: cronómetro manual.
- **File watch latency**: < 200ms entre save no disco e preview atualizado. How: teste com file write.
- **Memory footprint**: < 50MB em uso normal. How: Activity Monitor.
- **Adoption interna**: equipa Significa usa diariamente em 2 semanas. How: feedback directo.

## Open Questions and Risks

- **Hook do Claude Code**: o sistema de hooks suporta trigger em file write? Impact: sem isto, o Modo 1 (auto-open) não funciona. Resolution: investigar a API de hooks do Claude Code antes de implementar.
- **Syntax highlighting library**: qual library Swift usar para highlighting language-specific? Impact: afecta qualidade dos code blocks. Resolution: avaliar Splash, Highlightr, ou TreeSitter na fase de build plan.
- **Markdown parsing**: usar cmark-gfm (C library) ou swift-markdown (Apple)? Impact: afecta que features de GFM são suportadas. Resolution: avaliar na fase de build plan.
- **Window positioning API**: NSWindow positioning à direita do ecrã é straightforward, mas comportamento em múltiplos monitores precisa de teste. Resolution: testar com setup multi-monitor.
- **"Render last message"**: requer que Claude Code exponha a última mensagem como texto. Pode não ser possível via hooks. Impact: feature "Should" fica comprometida. Resolution: investigar.

## Confidence Summary

- Must features: 100% High
- Overall brief confidence: High
- Blocking items: nenhum. As questões abertas afectam implementação, não scope.

## Decision Log

| Decision | Reasoning | Confidence | Made by |
|---|---|---|---|
| Nome "Safo" | Poeta grega, 4 chars, funciona como CLI command, feminino, ligado à escrita | H | User approved |
| Sem settings UI | Zero config é feature, não limitação. Estilos são opinião do produto. Alinhado com Dieter Rams. | H | User |
| Copy = markdown source | User cola em Slack/Notion/GitHub. Markdown source é mais útil que rich text. | H | User confirmed |
| Single window, não tabs | Simplicidade. Um ficheiro em foco de cada vez. Sidebar para navegar. | H | Strategist, user confirmed |
| Sidebar com subpastas | Flexibilidade quando aberto via Finder/double-click. Mas nunca sai da pasta raiz. | H | User |
| Text-only, sem imagens | Simplifica v1. Markdown é artefacto de trabalho, imagens são raras neste contexto. | H | User |
| 40% largura, direita | Referência visual: painel ao lado do terminal. User pode repositionar depois. | H | User |
| Dark/light segue sistema | Zero decisão para o user. Consistente com macOS. | H | User |
| macOS only, SwiftUI | Alinhado com target (developers macOS). Nativo = leve e rápido. | H | Strategist |
| File watching activo | Core do workflow: Claude escreve, Safo atualiza. Sem refresh manual. | H | User |

## Prototype Direction

Flows to prototype (ordered by risk, riskiest first):

1. **CLI open + render**: `safo file.md` abre janela à direita com markdown renderizado. Valida que o core loop funciona e que a tipografia/estilos satisfazem. Persona: Terminal-Native Creator. LOVE: Value.

2. **File watching**: editar/escrever no ficheiro e ver o preview atualizar em tempo real. Valida a latência e fiabilidade do watcher. Persona: Terminal-Native Creator. LOVE: Value.

3. **Sidebar navigation**: toggle sidebar, navegar entre .md na pasta. Valida que a navegação é útil e não intrusiva. Persona: Terminal-Native Creator. LOVE: Value.

4. **Claude Code hook**: configurar hook que auto-abre Safo quando Claude escreve .md. Valida a integração end-to-end. Persona: Terminal-Native Creator. LOVE: Onboard.

Core entities for prototype:

- **MarkdownFile**: path, content, lastModified. States: loading, rendered, error.
- **FileList**: directoryPath, files (filtered .md). States: collapsed (sidebar hidden), expanded.
- **Window**: position, size, currentFile. States: initial (40% right), user-repositioned.

Validation criteria per flow:

- **CLI open + render**: Success = ficheiro abre em < 500ms com tipografia correcta (proporcional, hierarquia de headings, tables estilizadas). Failure = delay perceptível ou rendering incorrecto de GFM.
- **File watching**: Success = alteração no disco reflecte no preview em < 200ms sem flicker. Failure = delay > 1s ou necessidade de refresh manual.
- **Sidebar navigation**: Success = toggle suave, lista legível, click navega instantaneamente. Failure = sidebar obstrui o conteúdo ou navegação é lenta.
- **Claude Code hook**: Success = Claude escreve .md e Safo abre automaticamente sem intervenção. Failure = hook não dispara ou abre com delay > 2s.

What the prototype is NOT testing:

- Performance com ficheiros muito grandes (> 10K linhas). Optimização é posterior.
- Multi-monitor behavior. Testar manualmente depois.
- "Render last message" feature. Depende de investigação do Claude Code.
