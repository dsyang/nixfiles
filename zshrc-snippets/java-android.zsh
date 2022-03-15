
#######
## java (embeded in Android Studio bumblebee+)
#######
export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'
export PATH="${JAVA_HOME}/bin:${PATH}"

##########
## Kotlin
##########
export KOTLIN_HOME="/Applications/Android Studio.app/Contents/plugins/Kotlin/kotlinc"
export PATH="${KOTLIN_HOME}/bin:${PATH}"

##########
## android
##########
export ANDROID_SDK=/Users/dsyang/Library/Android/sdk
#export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH="$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools"
export PATH="/Users/dsyang/bin/build-tools:$PATH"