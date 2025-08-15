#
# list all file in a folder, the folder path come from the keyboard, list the file is can wrx
#

echo "folder path is: $1"
current_working_dict=$(pwd)

echo "accessing the folder: $1"
cd $1
$(pwd)

files=$(ls -lna $1)

for file in $files
do
    if [ -f $file -a -s $file ]; then 
        echo "INFO:: test file: $file"
        if [ -r $1 ]; then 
            echo "file with enable -r"
        fi 
        if [ -x $1 ]; then 
            echo "file with enable -x"
        fi 
        if [ -w $1 ]; then 
            echo "file with enable -w"
        fi 
    # else
    #     echo "the item $file not match condition is file or non empty"
    fi 
done 

echo "Completed task. exit folder"

cd ${current_working_dict}