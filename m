From: Jan Engelhardt <jengelh@medozas.de>
Subject: 32-bit readdir off_t problem again
Date: Mon, 23 Nov 2009 20:01:17 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911231956320.31541@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


back at http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00647.html 
there was a readdir problem with the last entry. This issue has 
resurfaced in 2.6.31.6 (yeah, yeah), with only slight differences. 
Instead of entries being returned with key 4294967295, they are not 
returned at all anymore.

19:56 borg:../fs/fuse > l
total 112
drwxr-xr-x 1 abuild abuild    30 Nov 23 13:55 .
drwxr-xr-x 1 abuild abuild    16 Nov 23 13:49 ..
-rw-r--r-- 1 root   root       0 Nov 23 13:55 a
-rw-r--r-- 1 abuild abuild 13481 Nov 23 13:40 cuse.ko
-rw-r--r-- 1 abuild abuild 95894 Nov 23 13:40 fuse.ko
19:56 borg:../fs/fuse > /dev/shm/a.out .
2 .
2 ..
3 cuse.ko
5 fuse.ko
19:56 borg:../fs/fuse > /dev/shm/a64 .
2 .
2 ..
3 cuse.ko
5 fuse.ko
9223372036854775807 a

(a.out/a64 being the testcase posted at the original post.)

Should I have compiled with -D_FILE_OFFSET_BITS=64? Perhaps:

borg> /dev/shm/a32 .
2 .
2 ..
3 cuse.ko
5 fuse.ko
-1 a

depmod(8) however seems to be compiled without FILE_OFFSET_BITS=64
however and as such *does* miss files (and valuable symbols) due to
btrfs.
