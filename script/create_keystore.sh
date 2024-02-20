# !/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

createAndroidKeystore() {
	name=$(bash -c 'read -e -p "What is the file name?: " tmp; echo $tmp')
	alias_name=$(bash -c 'read -e -p "What is the alias?: " tmp; echo $tmp')
	echo "${GREEN}keytool -genkey -v -keystore $name -alias $alias_name -keyalg RSA -keysize 2048 -validity 10000${NC}"
	keytool -genkey -v -keystore $name -alias $alias_name -keyalg RSA -keysize 2048 -validity 10000
}

createAndroidKeystore
