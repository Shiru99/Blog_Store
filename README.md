# Android_Dev
 
***JAVA INSTALLATIONS***

- Install java 8

```sh
$ sudo apt install openjdk-8-jdk
```

- java version

```sh
$ java -version
```

- select Java version
```sh
$ sudo update-alternatives --config java
```
```sh
$ sudo update-alternatives --config javac
```

```sh
$ echo 'JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"' >> ~/.bashrc
```
 Done :)
---



***Flutter INSTALLATIONS***

- Install Flutter using snapd

```sh
$ sudo snap install flutter --classic
```



- Install Flutter manually

Download the installation bundle to get the latest stable release of the Flutter SDK:
https://flutter.dev/docs/get-started/install/linux

```sh
$ mkdir ~/app
```
```sh
$ cd ~/app
```
```sh
$ tar xf ~/Downloads/flutter_linu[PRESS_TAB]
```
```sh
$ echo 'export PATH="$PATH:/home/USER_NAME/app/flutter/bin"' >> ~/.bashrc
```

Run ''' $ flutter config --no-analytics ''' if you don't want to send analytics to Google

Run ''' $ flutter precache ''' to install the dev tools locally

Run ''' $ flutter doctor ''' to check if the installation is complete

 Done :)
---

***Android-Studio INSTALLATIONS***

- Install Flutter manually

Download the installation bundle to get the latest stable release of the Android-Studio:

https://developer.android.com/studio?authuser=2#    (Download the files : android-studio-ide-###-linux.tar.gz)


```sh
$ tar xf ~/Downloads/android-studio-ide[PRESS_TAB]
```
```sh
$ echo 'export PATH="$PATH:/home/USER_NAME/app/android-studio/bin"' >> ~/.bashrc
```

```sh
$ source ~/.bashrc
```
```sh
$ studio.sh
```

 Done :)
---
