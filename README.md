# tmgit - Time Machine via Git

## Uma máquina do tempo que utiliza git e cron, escrita em shell script


### Uso:

```
./tmgit.sh [diretorio a ser versionado] <diretorio de versionamento do tmgit> (opcional)
```

Por exemplo: 
1. `./tmgit.sh /home/usuario` ─ ele criará o "gitdir" em /home/usuario/.tmgit
2. `./tmgit.sh /home/usuario /home/usuario/.meugitdir` ─ ele criará o "gitdir" em /home/usuario/.meugitdir

---

### Funcionamento: 

Este projeto é uma reescrita do original [linux-time-machine](https://github.com/elisboa/linux-time-machine.sh). A ideia é tornar o código mais legível e ter um controle maior dos erros. Não significa que o código será exatamente menor nem mais eficiente.

Neste item, vamos descrever o funcionamento do projeto e então dividi-lo entre as 4 funções principais:
1. `fm_preflight`
2. `fm_climb`
3. `fm_fly`
4. `fm_land`

Basicamente, a máquina do tempo executa as seguintes funções:
- recebe um ou dois parâmetros: diretório a ser versionado (obrigatório); diretório do git (opcional)
- verifica se o diretório já está versionado (git status)
- se não estiver versionado, tenta criar o diretório de versionamento (git init)
- se estiver versionado, verifica alterações no repositório, como: arquivos alterados ou arquivos a serem removidos
- realiza o versionamento das alterações (commit)

Estas funções todas devem estar organizadas dentro das quatro funções macro mencionadas anteriormente: fm_preflight; fm_climb; fm_fly e fm_land. Para saber mais sobre o papel de cada uma, consulte o guia de boas práticas de programação [modo-avião](http://modo-aviao.hackbox.link/). Este projeto é uma prova-de-conceito para validar tais práticas.

#### fm_preflight: 
- validação de parâmetros recebidos
- inicialização de variáveis

#### fm_climb
- validação da existência do repositório e seu funcionamento: git status & git init
- verificação da branch atual e alteração para a branch correspondente ao dia de hoje
- preparação para o "voo" (git add; git remove etc)

#### fm_fly
- efetivação das mudanças: git add; git remove; git commit
- em caso de parâmetros adicionais, executá-los aqui, como: version-all; push-remote; add-files etc

#### fm_land
- tratamento de erros
- limpeza de arquivos temporários
- encerramento da execução do programa

Via de regra, o programa **sempre será encerrado com a chamada da função `fm_land`**, que deverá estar pronta para finalizar o funcionamento a qualquer momento.

---

### Avisos

— O código ainda não está funcional! Mas se você gostou da ideia, pode experimentar o [linux-time-machine](https://github.com/elisboa/linux-time-machine.sh), que já conta inclusive com backup para um repositório remoto — caso você o adicione (via `git remote add`)

— Este projeto é baseado no [linux-time-machine](https://github.com/elisboa/linux-time-machine.sh), porém escrito de maneira a implementar um controle de erro mais elaborado. Em segundo plano — mas também importante — está a missão de criar um código mais legível; o que já é algo bem mais difícil de se conseguir, considerando que não sou um programador profissional

— Esta versão conta com mensagens em português, e preza mais pela legibilidade do código do que pela funcionalidade

— Este projeto segue o guia de boas práticas [modo-avião](https://github.com/elisboa/modo-aviao), que ainda está em desenvolvimento. Passe lá e contribua!
