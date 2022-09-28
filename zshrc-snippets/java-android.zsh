
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
export ANDROID_HOME=${ANDROID_SDK}
export PATH="$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools"
export PATH="/Users/dsyang/bin/build-tools:$PATH"


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