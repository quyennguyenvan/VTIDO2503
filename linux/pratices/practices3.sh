#
#   Writing a simple program to allow enter 2 number (interger number (n > 0) and run a + b / a : b / a * b and a - b)
# print the result to screen/
#

echo "please enter number a"
read a
echo "please enter number b"
read b

echo "${a} + ${b} = `expr ${a} + ${b}`"
echo "${a} - ${b} = `expr ${a} - ${b}`"
echo "${a} * ${b} = `expr ${a} \* ${b}`"
echo "${a} / ${b} = `expr ${a} / ${b}`"

thumuc:
    tep1
    tep2 
thucmucb:
    temp3
    temp4