From: Travis Shivers <ttshivers@gmail.com>
Subject: Btrfs Array Recovery
Date: Thu, 12 Apr 2012 16:25:49 -0500
Message-ID: <CAPeorG9SqVbg=ciH++P5SjPAGp5t=-B7gnSYUQ80UFQ3HGK91Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A few months ago, my btrfs storage array became corrupted because of a
power failure. A while ago, I made this thread to try and resolve the
problem. (http://www.digipedia.pl/usenet/thread/11904/15955/) You can
find detailed information about the problem in the previous thread,
but I am happy to provide any other details. It didn't really go
anywhere in the way of solving my problem. The thread ended in me
waiting for a patch that would allow me to mount my corrupted array
which was around 2 months ago.

While I have been waiting, I have tried several things. One of the
things that I tried was installing the latest Linux kernel (3.4 RC1)
with the btrfs integrity checking enabled. I read about this module
here: (http://lwn.net/Articles/466493/) With the option compiled in, I
have had severe mounting problems. I can only try to mount the array
once before it does some strange things. The first time I try and
mount it, it fails, but logs this in dmesg:
(http://pastebin.com/YwAsdjhs) It looks like there is a bug in this
integrity checking code. After I try to mount the drive after the
first time, it just hangs and doesn't return anything or log anything
in dmesg. Even trying to mount the drive without the integrity
checking problem hangs and has the same problems.

I have also grabbed the latest version of btrfs-progs since I saw that
btrfsck could now repair some corruptions. I built the utilities and
executed btrfsck. This is the result of the command:
(http://pastebin.com/CEyvy17r) I saw that there was an error occurring
in the code at line 1864, so I commented out that line which had the
text: BUG_ON(rec->is_root);
I then recompiled the utilities and executed btrfsck again and got
this: (http://pastebin.com/ihYmuCAm) I also tried btrfsck with the
repair option with these results: (http://pastebin.com/gnrStyqh)

Another thing that I have experimented with is btrfs-restore. I have
been somewhat successful in using this tool to restore the files. The
main problem that I have is that it cannot restore over half of the
files on the array and just puts an empty file with a size of 0. It
does restore the other half of the array perfectly. On the files that
it cannot restore, it returns a return code of -3. For example, here
is an example of a file which is unable to be restored by this tool:
(http://pastebin.com/Rg5a0xdG) I read more about this tool here
(http://btrfs.ipv5.de/index.php?title=Restore) I tried this tool with
'-u 1' and '-u 2' flags, which did not help anything. I do not think
that half of my array is corrupted since it was just a power failure
and the drive is also mirrored, which should provide some redundancy.
