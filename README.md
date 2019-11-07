# tmgit

## Uma máquina do tempo que utiliza git e cron escrita em shell script

---

## Uso:
```
./main.sh [diretorio a ser versionado] <diretorio de versionamento do tmgit> (opcional)
```

Por exemplo: 
1. `./main.sh /home/usuario` ─ ele armazenará o "gitdir" em /home/usuario/.tmgit
2. `./main.sh /home/usuario /home/usuario/.git` ─ ele armazenará o "gitdir" em /home/usuario/.git

---

#### Avisos

- Este projeto ainda não está funcional! Utilize o [linux-time-machine](https://github.com/elisboa/linux-time-machine.sh), que já está funcional e conta inclusive com backup para um repositório remoto, caso você o adicione.

- Este projeto é baseado no [linux-time-machine](https://github.com/elisboa/linux-time-machine.sh), porém está sendo reescrito de maneira a deixar o código mais legível.

- Esta versão conta com mensagens em português, e preza mais pela legibilidade do código do que pela funcionalidade.

- Este projeto segue o guia de boas práticas [modo-avião](https://github.com/elisboa/modo-aviao), que ainda está em desenvolvimento.
