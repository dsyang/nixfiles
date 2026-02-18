
#######
## java (embeded in Android Studio electric eel+)
#######
# export JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
export PATH="${JAVA_HOME}/bin:${PATH}"

##########
## Kotlin
##########
# no chmod +x possible with most recent Android Studio
#export KOTLIN_HOME="/Applications/Android Studio.app/Contents/plugins/Kotlin/kotlinc"
#export PATH="${KOTLIN_HOME}/bin:${PATH}"

##########
## android
##########
export ANDROID_SDK=/Users/dsyang/Library/Android/sdk
export ANDROID_HOME=${ANDROID_SDK}
export PATH="$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools"
export PATH="/Users/dsyang/bin/build-tools:$PATH"

##########
## gradle
##########
export GRADLE_USER_HOME=/Users/dsyang/.gradle

function android_reverse_ports() {

  # Capture the devices
  local devices=($(adb devices | awk '{ print $1 }'))

  # Iterate over the devices and reverse the ports
  for device_id in "${devices[@]:1}"; do
      # Database debugging http://localhost:8080
      adb -s "$device_id" forward tcp:8080 tcp:8080
      adb -s "$device_id" reverse tcp:8081 tcp:8081
      adb -s "$device_id" reverse tcp:3000 tcp:3000
      adb -s "$device_id" reverse tcp:3001 tcp:3001
      adb -s "$device_id" reverse tcp:3003 tcp:3003
  done
}

alias gwlint="./gradlew formatKotlin"
alias gw="./gradlew"