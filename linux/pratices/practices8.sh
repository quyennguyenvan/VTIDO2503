#
# identifier the item of object, using case to catch
#


echo "recieved item: $1"
echo "info:: procesing to identifier object"

case $1 in

    "cat") echo "This is mew mew object";;
    "dog") echo "This is not mew mew object - dog ";;
    "pew") echo "This is gun, pew pew ";;
    "human") echo "This is human, human object";;
    *) echo "Can not identifier the object" ;;
esac