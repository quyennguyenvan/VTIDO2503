Create 3 username withname a.b.c (anynames...) (adduser/useradd)

should have password for them and one account should disable or lock (state -L)

have an account with name **exploit**( account 4th ) should have permission write data into folder **/home/b** and **/home/c** with permission **3** and **5** to write and reading data. (CHMOD)

account a should have default shell is /bin/sh.
account b,c and exploit should default shell is /bin/bash

account a should have home directory with name /home/data/test with 750
account exploit should have owner the home directory of account a

account b and c should have permission write data into home directory account a