From: Boyd Waters <waters.boyd@gmail.com>
Subject: No space left on device, btrfsctl segmentation fault
Date: Tue, 23 Feb 2010 22:39:33 -0500
Message-ID: <2b0225fb1002231939q2020bf05g145f852e5b4c560@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Greetings!

I have a singe 2TB disk formatted with btrfs 0.19 on Ubuntu 10.04-alpha2:

# uname -a
Linux fan-ting 2.6.32-14-generic #20-Ubuntu SMP Sat Feb 20 05:18:19
UTC 2010 x86_64 GNU/Linux

# df -h /media/onlyhope/
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdi2             1.9T  1.7T  197G  90% /media/onlyhope


I'm getting "no space left on device" errors when I try to move files
to this volumes via rsync.

So I tried, as an experiment, to "defragment" the volume with btrfsctl:

# btrfsctl -d /media/onlyhope
Segmentation fault


I am a btrfs newbie. Clearly I am doing something wrong. Any
suggestions for generating a more meaningful error report?

Thanks!!
