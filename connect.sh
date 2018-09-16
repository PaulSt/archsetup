
#wldev="$(ip link | grep -o 'wl.*:')"
#wldev=${wldev%?}

#echo "ctrl_interface=/run/wpa_supplicant
#update_config=1
#'network={
#ssid="eduroam"
#scan_ssid=1
#key_mgmt=WPA-EAP
#eap=PEAP
#identity="hodorh3@univie.ac.at"
#ca_cert="/path/to/univie-eduroam/ca.crt"
#password="lePassw0rd"
#phase1="peaplabel=0"
#phase2="auth=MSCHAPV2"
#}'
#" > /etc/wpa_supplicant/wpa_supplicant.conf

#wpa_supplicant -B -i "$wldev" -c /etc/wpa_supplicant/wpa_supplicant.conf

#wpa_cli 

#dhcpcd "$wldev"

