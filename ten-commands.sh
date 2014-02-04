A few simple utilities can make it easier to figure out and maintain other people's code.
This article presents a list of commands you should be able to find on any Linux installation. 
These are tools to help you improve your code and be more productive. The list comes from my own experience as a 
programmer and includes tools I've come to rely on repeatedly. Some tools help create code, some help debug code 
and some help reverse engineer code that's been dumped in your lap.

1. ctags
Those of you addicted to integrated development environments (IDEs) probably never heard of this tool, or if you did
you probably think it's obsolete. But a tags-aware editor is a productive programming tool.

Tagging your code allows editors like vi and Emacs to treat your code like hypertext (Figure 1). Each object 
in your
code becomes hyperlinked to its definition. For example, if you are browsing code in vi and want to know where the
variable foo was defined, type :ta foo. If your cursor is pointing to the variable, simply use Ctrl-right bracket.

The good news for the vi-impaired is ctags is not only for C and vi anymore. The GNU version of ctags produces 
tags that can be used with Emacs and many other editors that recognize tag files. In addition, ctags recognizes
many languages other than C and C++, including Perl and Python, and even hardware design languages, such as Verilog. 
It even can produce a human-readable cross-reference that can be useful for understanding code and performing metrics.

Even if you're not interested in using ctags in your editor, you might want to check out the 
human-readable cross-reference by typing ctags -x *.c*.

What I like about this tool is that you get useful information whether you input one file or one hundred files, 
unlike many IDEs that aren't useful unless they can see your entire application. It's not a program checker, so
garbage in, garbage out (GIGO) rules apply.

2. strace
strace lets you decipher what's going on when you have no debugger nor the source code. One of my pet peeves is a 
program that doesn't start and doesn't tell you why. Perhaps a required file is missing or has the wrong permissions.
strace can tell you what the program is doing right up to the point where it exits. It can tell you what system calls
the program is using and whether they pass or fail. It even can follow forks.

strace often gives me answers much more quickly than a debugger, especially if the code is unfamiliar.
On occasion, I have to debug code on a live system with no debugger. A quick run with strace sometimes can avoid
patching the system or littering my code with printfs. Here is a trivial example of me as an unprivileged user 
trying to delete a protected file:

strace -o strace.out rm -f /etc/yp.conf
The output shows where things went wrong:

lstat64("/etc/yp.conf", {st_mode=S_IFREG|0644,
st_size=361, ...}) = 0
access("/etc/yp.conf", W_OK) = -1 EACCES
(Permission denied)
unlink("/etc/yp.conf") = -1 EACCES (Permission
denied)
strace also lets you attach to processes for just-in-time debugging. Suppose a process seems to be spending 
a lot of time doing nothing. A quick way to find out what is going on is to type strace -c -p mypid. After a second
or two, press Ctrl-C and you might see a dump something like this:

% time    seconds  usecs/call     calls    errors  syscall
------ ----------- ----------- --------- --------- ----------------
 91.31    0.480456        3457       139           poll
  6.66    0.035025         361        97           write
  0.91    0.004794          16       304           futex
  0.52    0.002741          14       203           read
  0.31    0.001652           3       533           gettimeofday
  0.26    0.001361           4       374           ioctl
  0.01    0.000075           8        10           brk
  0.01    0.000064          64         1           clone
  0.00    0.000026          26         1           stat64
  0.00    0.000007           7         1           uname
  0.00    0.000005           5         1           sched_get_priority_max
  0.00    0.000002           2         1           sched_get_priority_min
------ ----------- ----------- --------- --------- ----------------
100.00    0.526208                  1665           total
In this case, it's spending most of its time in the poll system call—probably waiting on a socket.
