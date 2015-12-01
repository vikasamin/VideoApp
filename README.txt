Fist Step is to open the app.mk file and change the roku dev account & password : eg-
ROKU_DEV_TARGET=192.168.1.119
DEVPASSWORD =1234


Once you have followed the above step you can open a command prompt and navigate to the source folder
1) make install - will compile,install and run the app
2) make remove - will remove the app

Debug by using telnet 192.168.1.119 8085 
