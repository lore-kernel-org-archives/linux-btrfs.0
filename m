From: Andrew Benton <b3nton@gmail.com>
Subject: chmod errors compiling on btrfs
Date: Sat, 07 Nov 2009 20:36:40 +0000
Message-ID: <4AF5DA58.1060600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello World.
I've created a btrfs partition and have tried compiling some programs on 
it, however, some of them fail with errors due to incorrect permissions. 
e2fsprogs fails like this:-

make[1]: Leaving directory `/mnt/btrfs/sources/e2fsprogs-1.41.9'
make[1]: Entering directory `/mnt/btrfs/sources/e2fsprogs-1.41.9/lib/et'
	SUBST compile_et
make[1]: Leaving directory `/mnt/btrfs/sources/e2fsprogs-1.41.9/lib/et'
make[1]: Entering directory `/mnt/btrfs/sources/e2fsprogs-1.41.9/lib/ext2fs'
	SUBST ext2_err.et
	COMPILE_ET ext2_err.et
chmod: ext2_err.h: new permissions are r--r--rw-, not r--r--r--
chmod: ext2_err.c: new permissions are r--r--rw-, not r--r--r--
make[1]: *** [ext2_err.h] Error 1
make[1]: Leaving directory `/mnt/btrfs/sources/e2fsprogs-1.41.9/lib/ext2fs'
make: *** [subs] Error 2
andy:/mnt/btrfs/sources/e2fsprogs-1.41.9$


and coreutils fails like this:-

   CCLD   hostname
   CCLD   setuidgid
   CCLD   getlimits
   CCLD   su
make[3]: Leaving directory `/mnt/btrfs/sources/coreutils-7.6/src'
make[2]: Leaving directory `/mnt/btrfs/sources/coreutils-7.6/src'
Making all in doc
make[2]: Entering directory `/mnt/btrfs/sources/coreutils-7.6/doc'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/mnt/btrfs/sources/coreutils-7.6/doc'
Making all in man
make[2]: Entering directory `/mnt/btrfs/sources/coreutils-7.6/man'
   GEN    hostname.1
chmod: hostname.1-t: new permissions are r--rw-rw-, not r--r--r--
make[2]: *** [hostname.1] Error 1
make[2]: Leaving directory `/mnt/btrfs/sources/coreutils-7.6/man'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/mnt/btrfs/sources/coreutils-7.6'
make: *** [all] Error 2
andy:/mnt/btrfs/sources$

Both times the files created were world writeable when they should have 
been read only. I get the same errors if I compile as myself or root. If 
I compile in my home folder (on a reiserfs partition) they compile with 
no problem. I'm using a self compiled vanila 2.6.31.4 kernel. I created 
the partition with btrfs-progs-0.19.

Andy
(Andrew Benton)
