I am trying to replace Config Files with the UnixCommandline without using an Editor like vi or nano.

An example could be:

ServerAdmin mail@example.com
I want to find the first or all lines that start with ServerAdmin and replace them with:

ServerAdmin secret@secret.com
Is there any command to do something like this? It should be possible with the standart UNIX tools also available
in CygWin.


sed -i 's/^ServerAdmin .*$/ServerAdmin secret@secret.com/' in-filename
