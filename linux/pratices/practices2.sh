#
# writing a simple curl to the endpoint and get the response code of command and print it out to screen
# example curl  google-123.com
# with dynamic url
#

curl ${1} > /dev/null 2>&1
echo "status code $?"