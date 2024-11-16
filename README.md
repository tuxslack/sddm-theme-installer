## Uso

1. Edite `$NAME`, `$DIR` e `$CFG` quando necessário
2. Execute `./install.sh` na raiz do diretório do seu tema

O script de instalação move a pasta do tema por padrão para `/usr/share/sddm/themes/$NAME` e modifica `/etc/sddm.conf` para definir este tema como o tema atual. Se o arquivo `/etc/sddm.conf` não existir, o usuário será solicitado a criar um automaticamente com base nas configurações ativas no momento. O usuário será solicitado a desabilitar o teclado virtual do SDDM se estiver habilitado, porque ele não é bem suportado pelo tema e, por algum motivo, está habilitado no SDDM por padrão. Depois disso, o script sugerirá testar o tema. Você também pode mover manualmente os arquivos para o local correto. Se você usa o KDE Plasma, pode definir o novo tema em Configurações do Sistema → Inicialização e Desligamento → Tela de Login (SDDM).

