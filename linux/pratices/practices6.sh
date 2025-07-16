#
# enter a file from keyboard and validate -w -r -x of file
#

echo "test wrx file: $1"

if [ -r $1 ]; then 
    echo "file with enable -r"
fi 

if [ -x $1 ]; then 
    echo "file with enable -x"
fi 

if [ -w $1 ]; then 
    echo "file with enable -w"
fi 

ls -lna  $1