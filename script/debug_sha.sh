# !/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

debug_sha() {
        echo "${GREEN}keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android${NC}"
        keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
}

debug_sha
