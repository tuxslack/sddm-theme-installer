#!/bin/bash


clear

which sed          || exit
which sddm         || exit
which sddm-greeter || exit


NAME="delicious"
DIR="/usr/share/sddm/themes/$NAME/"
CFG="/etc/sddm.conf"


function changeCurrentTheme {
    sudo sed -i "s/^Current=.*/Current=$NAME/" $CFG
    echo -e "Tema atual alterado para $NAME"
}

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

function testTheme {

    echo -e "\nQuer testar o tema agora?"
    
    select sel in "Yes" "No"; do
        case $sel in
            Yes ) sddm-greeter --test-mode --theme $DIR; break;;
            No ) exit;;
        esac
    done
}

function createConfig {

    sddm --example-config | sudo tee $CFG > /dev/null
    echo -e "Arquivo de configuração criado em $CFG"
}

if sudo cp -R . $DIR; then

    echo -e "Tema instalado em $DIR"
    
else

    echo -e "Ocorreram erros durante a instalação, saindo"
    
    exit;
    
fi


if [ ! -f $CFG ]; then

    echo -e "\nO arquivo de configuração $CFG do SDDM não existe. Você deseja criá-lo com base na configuração atual?"
    
    select sel in "Yes" "No"; do
        case $sel in
            Yes ) createConfig; changeCurrentTheme; disableVirtualKeyboard; testTheme; break;;
            No )  echo -e "Tema instalado em $DIR, mas a configuração não foi alterada."; testTheme; break;;
        esac
    done
else
    changeCurrentTheme; disableVirtualKeyboard; testTheme;
fi


exit 0
