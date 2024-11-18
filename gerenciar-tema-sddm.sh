#!/bin/bash
#
# Autor:           Fernando Souza - https://www.youtube.com/@fernandosuporte/
# Data:            18/11/2024 as 02:08:57
# Atualização em:  https://github.com/tuxslack/scripts
# Script:          gerenciar-tema-sddm.sh
# Versão:          0.1
#
# Instala, remove e testa os temas para SDDM.
# 
#
# Data da atualização: 
#
# Licença:  GPL - https://www.gnu.org/
# 


# https://plus.diolinux.com.br/t/trocar-tema-do-sddm-no-ubuntu/39780
# https://github.com/stuomas/sddm-theme-installer


clear

# ----------------------------------------------------------------------------------------


# Verificar se os programas estão instalados:


which yad            1> /dev/null 2> /dev/null || { echo "Programa Yad não esta instalado."      ; exit ; }

which sed            1> /dev/null 2> /dev/null || { yad --center --window-icon "$logo" --image=dialog-error --timeout="10" --no-buttons --title "Aviso" --text "Programa sed não esta instalado."           --width 450 --height 100 2>/dev/null   ; exit ; }
which sddm           1> /dev/null 2> /dev/null || { yad --center --window-icon "$logo" --image=dialog-error --timeout="10" --no-buttons --title "Aviso" --text "Programa sddm não esta instalado."          --width 450 --height 100 2>/dev/null   ; exit ; }
which sddm-greeter   1> /dev/null 2> /dev/null || { yad --center --window-icon "$logo" --image=dialog-error --timeout="10" --no-buttons --title "Aviso" --text "Programa sddm-greeter não esta instalado."  --width 450 --height 100 2>/dev/null   ; exit ; }

# ----------------------------------------------------------------------------------------

# Arquivo de log

log="/tmp/extrair.log"


# Pasta para os temas SDDM

DIR="/usr/share/sddm/themes"



# Tipo de arquivo compactado

tipo_de_arquivo_compactado="*.tar.gz *.zip *.tar.gz *.tar.bz2 *.tgz *. *.tar *.rar *.gz *.7z"


logo=""

titulo="Gerenciador de tema SDDM"


# Arquivo de configuração do SDDM

CFG="/etc/sddm.conf"



# ----------------------------------------------------------------------------------------

# Função verificar_root

verificar_root(){

if [ "$(id -u)" != "0" ]; then

       echo -e "\e[1;31m\n[ERROR] Você deve executar este script como Root! \n\e[0m"
        
yad \
--center \
--title='Aviso' \
--window-icon "$logo" \
--image=dialog-error \
--text='\n\nVocê deve executar este script como Root!\n\n' \
--timeout="10" \
--no-buttons \
2>/dev/null

exit 

else


        echo -e "\e[01;32m\nVerificação de Root [OK] \n\e[0m"

        sleep 2

fi

}


verificar_root


# ----------------------------------------------------------------------------------------


echo -e "\e[01;32m\n================== GERENCIADOR DE TEMA PARA O SDDM ==================\e[0m"
echo -e "\nAutor: Fernando Souza - https://www.youtube.com/@fernandosuporte \nAno: 2024\n"
echo -e "Atualização em: https://github.com/tuxslack/scripts\n"
echo -e "\e[01;32m=====================================================================\e[0m"
echo -e "\nOlá Usuário, bem vindo ao utilitário de gerenciamento de tema sddm.\nEsse script vai instalar ou remove os arquivos de tema para o sddm.\nO programa fechará automáticamente quando as atualizações forem concluídas.\n"

yad \
--center \
--window-icon "$logo" \
--image=gtk-dialog-info \
--title="$titulo" \
--text='

Autor: Fernando Souza - https://www.youtube.com/@fernandosuporte
Ano: 2024
Atualização em: https://github.com/tuxslack/scripts

Olá Usuário, bem vindo ao utilitário de gerenciamento de tema sddm.

Esse script vai instalar ou remove os arquivos de tema para o sddm.

O programa fechará automáticamente quando as atualizações forem concluídas.
' \
--button=Cancelar:1 \
--button=OK:0 \
--width="600" --height="100" \
2>/dev/null



if [ "$?" == "1" ];
then 
     clear
     exit
     
fi


# clear



# ----------------------------------------------------------------------------------------

function ajuda {


echo -e 'Uso:

1. Edite "'$DIR'" e "'$CFG'" quando necessário
2. Execute "./gerenciar-tema-sddm.sh" na raiz do diretório do seu tema

O script de instalação move a pasta do tema por padrão para "/usr/share/sddm/themes/" e modifica "/etc/sddm.conf" para definir este tema como o tema atual. Se o arquivo "/etc/sddm.conf" não existir, o usuário será solicitado a criar um automaticamente com base nas configurações ativas no momento. O usuário será solicitado a desabilitar o teclado virtual do SDDM se estiver habilitado, porque ele não é bem suportado pelo tema e, por algum motivo, está habilitado no SDDM por padrão. Depois disso, o script sugerirá testar o tema. Você também pode mover manualmente os arquivos para o local correto. Se você usa o KDE Plasma, pode definir o novo tema em Configurações do Sistema → Inicialização e Desligamento → Tela de Login (SDDM).
'


yad \
--center \
--window-icon "$logo" \
--image=gtk-dialog-info \
--title="$titulo" \
--text="

Uso:

1. Edite $DIR e $CFG quando necessário
2. Execute ./gerenciar-tema-sddm.sh na raiz do diretório do seu tema

O script de instalação move a pasta do tema por padrão para /usr/share/sddm/themes/ e modifica /etc/sddm.conf para definir este tema como o tema atual. Se o arquivo /etc/sddm.conf não existir, o usuário será solicitado a criar um automaticamente com base nas configurações ativas no momento. O usuário será solicitado a desabilitar o teclado virtual do SDDM se estiver habilitado, porque ele não é bem suportado pelo tema e, por algum motivo, está habilitado no SDDM por padrão. Depois disso, o script sugerirá testar o tema. Você também pode mover manualmente os arquivos para o local correto. Se você usa o KDE Plasma, pode definir o novo tema em Configurações do Sistema → Inicialização e Desligamento → Tela de Login (SDDM).

" \
--button=Cancelar:1 \
--button=OK:0 \
--width="600" --height="100" \
2>/dev/null



}

# ----------------------------------------------------------------------------------------

function listar {


     echo -e "\e[01;32m\nEsses são os temas atualmente instalados no seu sistema: \n\e[0m"

     ls -l "$DIR" | grep ^d | awk '{print $9}'

}

# https://www.vivaolinux.com.br/dica/Como-listar-somente-os-diretorios-no-Linux

# ----------------------------------------------------------------------------------------


function disableVirtualKeyboard {
    if ! grep -wq "InputMethod=" $CFG; then
    
        echo -e "\nVocê quer desabilitar o teclado virtual na tela no SDDM? Selecione sim se você tiver um teclado físico"
        
        select sel in "Yes" "No"; do
            case $sel in
                Yes ) 
                if grep -q "^InputMethod=qtvirtualkeyboard" $CFG; then
                
                    sudo sed -i "s/^InputMethod=qtvirtualkeyboard/InputMethod=/" $CFG;
                    
                    echo -e "Teclado virtual desabilitado (entrada InputMethod modificada)";
                    
                elif ! grep -q "^InputMethod=" $CFG; then
                
                    sudo sed -i 's/^\[General\]/\[General\]\nInputMethod=/' $CFG;
                    
                    echo -e "Teclado virtual desabilitado (criou uma entrada InputMethod vazia)";
                fi
                break;;
                No ) break;;
            esac
        done
    fi
}



# ----------------------------------------------------------------------------------------

function TestarTema {



yad \
--center \
--window-icon "$logo" \
--image=gtk-dialog-info \
--title="$titulo" \
--text='
Quer testar o tema agora?
' \
--button="Não":1 \
--button="Sim":0 \
--width="600" --height="100" \
2>/dev/null



if [ "$?" == "0" ];
then 
     clear

listar

echo -e "\nQual o nome do tema para testar? Nota: use alt+tab para alternar entre os processos e depois ctrl+c para fecha o teste do tema."
read tema

     sddm-greeter --test-mode --theme "$tema"

else

clear

exit
   
fi


}

# ----------------------------------------------------------------------------------------


function createConfig {

    sddm --example-config | sudo tee $CFG > /dev/null

    echo -e "\e[01;32m\nArquivo de configuração criado em $CFG \n\e[0m"

}


# ----------------------------------------------------------------------------------------

function instalar {



# ----------------------------------------------------------------------------------------

# Exemplo para selecionar um arquivo

arquivo_compactado=$(yad \
   --center \
   --window-icon "$logo" \
   --file \
   --filename="$PWD"  \
   --multiple --separator="\n"  \
   --file-filter="Arquivo compactado | $tipo_de_arquivo_compactado" \
   --title="Selecione o arquivo de tema do SDDM para instalar" \
   --button=Cancelar:1 \
   --button=OK:0 \
   --width="800" \
   --height="600" \
   2>/dev/null
)



if [ "$?" == "1" ];
then 

     exit
     
fi

# ----------------------------------------------------------------------------------------


    echo -e "\e[01;32m\nArquivo selecionado: `basename "$arquivo_compactado"` \n\e[0m"



# Descompactar arquivos .tar.gz


( tar -zxpvf "$arquivo_compactado" -C "$DIR" 2> "$log"


# [-s ARQUIVO] 	Verdadeiro se o ARQUIVO existe e tem um tamanho maior que zero.

[ -s "$log" ] && cat "$log"  | yad --title="$titulo" --text-info --tail --height=200 --width=1200  2> /dev/null


) | yad --center --title "$titulo" --progress --progress-text="Descompactando o arquivo $arquivo_compactado...." --pulsate --no-buttons --auto-close --width=450 --height=300 2> /dev/null






# Altera o nome do tema no arquivo de configuração


# ----------------------------------------------------------------------------------------

# Uma função é uma sub-rotina, um bloco de código que implementa um conjunto de operações. 

function mudar_tema_atual {

echo "
Qual o nome deste tema do arquivo `basename "$arquivo_compactado"`"
read tema


    sed -i "s/^Current=.*/Current=$tema/" $CFG | tee -a "$log"

    echo -e "\e[01;32m\nTema atual alterado para $tema\e[0m"

    notify-send -t 100000 -i /usr/share/icons/gnome/48x48/emblems/emblem-default.png  "$titulo" "\n\nTema atual alterado para $tema \n\n "

}

# ----------------------------------------------------------------------------------------


mudar_tema_atual




# Verificar o tamanho do arquivo "$log"

tamanho=$(ls -sh "$log" | cut -d "K" -f 1 | cut -d" " -f1)

if [ "$tamanho" == "0" ]; then 

    echo -e "Tema $tema instalado em $DIR"
    
else

    echo -e "\e[1;31m\n[ERROR] Ocorreram erros durante a instalação, saindo... \n\e[0m"

    cat "$log"

    exit
    
fi






# if [ ! -f $CFG ]; then

#     echo -e "\nO arquivo de configuração $CFG do SDDM não existe. Você deseja criá-lo com base na configuração atual?"
    
#     select sel in "Yes" "No"; do
#         case $sel in
#             Yes ) createConfig; mudar_tema_atual; disableVirtualKeyboard; TestarTema; break;;
#             No )  echo -e "Tema instalado em $DIR, mas a configuração não foi alterada."; TestarTema; break;;
#         esac
#     done
# else
#     mudar_tema_atual; disableVirtualKeyboard; TestarTema;
# fi



rm -Rf "$log"


# https://www.vivaolinux.com.br/topico/Shell-Script/Verificar-tamanho-de-arquivo


}


# ----------------------------------------------------------------------------------------

function remover {

rm -Rf "$log"


listar

echo "
Qual o nome do tema  que deseja remove?"
read tema

echo -e "Removendo o tema $tema em $DIR"

rm -Rf  "$DIR/$tema" 2>> "$log"

if [ $? == "0" ]; then

    echo -e "Tema $tema removido em $DIR"

    cat "$log"

else

    echo -e "\e[1;31m\n[ERROR] Ocorreram erros durante a remoção do tema $tema, saindo... \n\e[0m"

    exit
    
fi


# Altera o nome do tema no arquivo de configuração


# ----------------------------------------------------------------------------------------

# Uma função é uma sub-rotina, um bloco de código que implementa um conjunto de operações. 

function mudar_tema_atual {

listar

echo "
Qual o nome do tema que deseja definir como padrão?"
read tema


    sed -i "s/^Current=.*/Current=$tema/" $CFG | tee -a "$log"

    echo -e "\e[01;32m\nTema atual alterado para $tema\e[0m"

    notify-send -t 100000 -i /usr/share/icons/gnome/48x48/emblems/emblem-default.png  "$titulo" "\n\nTema atual alterado para $tema \n\n "

}

# ----------------------------------------------------------------------------------------


mudar_tema_atual


# https://www.shellscriptx.com/2016/12/trabalhando-com-funcoes.html


}


# ----------------------------------------------------------------------------------------

clear

# Inicio do loop

while : ; do


clear


# Mostra o menu na tela, com as ações disponíveis

opcao=$(yad \
--center \
--window-icon "$logo" \
--list \
--radiolist \
--title "$titulo" \
--text "O que deseja fazer?" \
--column "Opção" --column "descrição" \
--width="700" --height="500" \
--button=Cancelar:252 \
--button=OK:0 \
false "Instalar tema" \
false "Remover tema" \
false "Testar o tema atual" \
false "Ajuda" \
true "Sair" )




# while : ; do

# Percebi que ao apertar ESC ou Cancelar, ele parava a execução fechando a janela, mas 
# não liberava o terminal, eu tinha que dar um CTRL+C para liberar. Acrescentei uma 
# expressão para resolver isso.

# Se apertar CANCELAR ou ESC, então vamos sair...

# [ $? -ne 0 ] # ; exit

# De acordo com a opção escolhida, dispara programas
#opcao=$(echo $opcao | egrep -o '^[0-3]')
#case "$opcao" in



# Para corrigir o problema do menu em yad que não fecha, você pode adicionar um comando para lidar com a situação de cancelamento ou pressionar a tecla ESC.

if [ $? -eq 252 ]; then

break

fi


##########################################################################################


if echo "$opcao" | grep $"Instalar tema" 1> /dev/null  ; then

clear

instalar

fi

##########################################################################################

# 

if echo "$opcao" | grep $"Remover tema" 1> /dev/null  ; then

clear

remover

fi


##########################################################################################

# 

if echo "$opcao" | grep $"Testar o tema atual" 1> /dev/null ; then

clear

TestarTema

fi

##########################################################################################

# Ajuda

if echo "$opcao" | grep $"Ajuda" 1> /dev/null ; then

clear

ajuda

fi


##########################################################################################

# Sair

if echo "$opcao" | grep $"Sair" 1> /dev/null ; then

clear

exit

fi

##########################################################################################


done

# Fim do loop


exit 0

