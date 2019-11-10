# tmgit - Time Machine via Git

## Uma máquina do tempo que utiliza git e cron, escrita em shell script


### Uso:

```
./main.sh [diretorio a ser versionado] <diretorio de versionamento do tmgit> (opcional)
```

Por exemplo: 
1. `./main.sh /home/usuario` ─ ele criará o "gitdir" em /home/usuario/.tmgit
2. `./main.sh /home/usuario /home/usuario/.meugitdir` ─ ele criará o "gitdir" em /home/usuario/.meugitdir

---

### Avisos

— O código ainda não está funcional! Mas se você gostou da ideia, pode experimentar o [linux-time-machine](https://github.com/elisboa/linux-time-machine.sh), que já conta inclusive com backup para um repositório remoto — caso você o adicione (via `git remote add`)

— Este projeto é baseado no [linux-time-machine](https://github.com/elisboa/linux-time-machine.sh), porém escrito de maneira a implementar um controle de erro mais elaborado. Em segundo plano — mas também importante — está a missão de criar um código mais legível; o que já é algo bem mais difícil de se conseguir, considerando que não sou um programador profissional

— Esta versão conta com mensagens em português, e preza mais pela legibilidade do código do que pela funcionalidade

— Este projeto segue o guia de boas práticas [modo-avião](https://github.com/elisboa/modo-aviao), que ainda está em desenvolvimento. Passe lá e contribua!
