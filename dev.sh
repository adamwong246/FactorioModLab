rm ~/Library/Application\ Support/factorio/mods/$1_$2.zip
killall factorio 
sh build.sh $1 
sh install.sh ./mods/$1/$1_$2.zip 
sleep 1 
open ~/Library/Application\ Support/Steam/steamapps/common/Factorio/factorio.app