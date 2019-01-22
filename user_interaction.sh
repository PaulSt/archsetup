
read -r -p "" response

PS3='Please enter your choice: '
select opt in ""'Option 1'  'Option 2' 'Option 3' 'Quit'""
do
    case $opt in
        "Option 1")
            echo "you chose choice 1"
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


read -r -p "Are you sure? [Y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$|^$ ]]
then
    echo "yes"
else
    echo "no"
fi



read -r -p "Write answer to file? [Y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$|^$ ]]
then
    echo "yes" > ./ngq.txt
else
    echo "ok"
fi

ngq="$(cat ngq.txt)"
rm ngq.txt
if [[ "$ngq" =~ "yes" ]]
then
    echo "file write ok"
fi
