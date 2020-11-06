## by soraka ##

##
mkdir ./files
clear
echo "Loading..."
service --status-all > ./files/services.txt
clear
##


Logo(){
	echo "
	╔═╗┌─┐┬─┐┬  ┬┬┌─┐┌─┐┌─┐  ┌┬┐┌─┐┌┐┌┌─┐┌─┐┌─┐┬─┐
	╚═╗├┤ ├┬┘└┐┌┘││  ├┤ └─┐  │││├─┤│││├─┤│ ┬├┤ ├┬┘
	╚═╝└─┘┴└─ └┘ ┴└─┘└─┘└─┘  ┴ ┴┴ ┴┘└┘┴ ┴└─┘└─┘┴└─
	"
}

# Load open , cloesd services and add it to txt files
Load_Services(){
	echo 'Loading services please wait...'
	cat ./files/services.txt | grep "\[ + \]" > ./files/opened.txt
	cat ./files/services.txt | grep "\[ - \]" > ./files/closed.txt
}


##########################
# Add services to start up
Add(){
	clear
	Logo
	echo " " > './files/STstart.sh'
	services=()
	# read file and input service to stop
	cat ./files/closed.txt | while read line; do
		echo "$line "
	done
	echo "Write service name you would to add"
	echo "[exit] to end proccess"
	# input services to shutdown
	for ((i=0; i<=99; i++)); do
		echo -n ">>>> " && read f </dev/tty
		# exit proccess when $f = exit
		if [[ $f == 'exit' ]]; then
			rm -rf './files/STstop.sh'
			break
		fi
		printf "sudo service start $f \n" >> './files/STstart.sh'
		services+=($f)
	done
}




###############################
# Remove Services from start up
Remove(){
	clear
	Logo
	echo " " > './files/STstop.sh'
	services=()
	cat ./files/opened.txt | while read line; do
		echo $line
	done
	echo "Write service name you would to stop"
	echo "[exit] to end proccess"
	for ((i=0; i<=99; i++)); do
		echo -n ">>>> "
		read f </dev/tty
		if [ $f == 'exit' ];then
			rm -rf './files/STstart.sh'
			break
		fi
		printf "sudo service stop $f \n">> './files/STstop.sh'
		services+=($f)
	done


}

#######################

# Starts with program
Logo
echo "Do you want to add[0] or remove[1] services from startup? [0/1]"
echo -n "-->" && read f
if [[ $f == 0 || $f == 'add' ]]; then
	Load_Services
	Add
elif [[ $f == 1 || $f == 'remove' ]]; then
	Load_Services
	Remove
fi

#########################

# Start in end of program
clear
Logo
sleep 0.6
echo " Where do you want to change startup services ?"
sleep 1.3
echo " root user[0] / in current user[1] ? "
read f
f=${f^^}
if [[ $f == 0 || $f == "ROOT" ]]; then
	sudo mv ./files/STstop.sh /etc/init.d/
	sudo mv ./files/STstart.sh /etc/init.d/
elif [[ $f == 1 || $f == "USER" ]]; then
	sudo mv ./files/STstop.sh ~/.config/upstart/
	sudo mv ./files/STstart.sh ~/.config/upstart/
fi
