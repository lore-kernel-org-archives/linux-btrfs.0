From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: btrfs failed to delete reference
Date: Mon, 16 Nov 2009 09:15:27 +0100
Message-ID: <20091116081527.GA1711@arch.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Last night the following line was logged:
Nov 16 04:01:07 arch kernel: btrfs failed to delete reference to ammintrin.h, inode 118665 parent 2687784

This file is part of an rsnapshot backup directory:
/var/.snapshots/hourly.5/localhost/usr/local/lib/gcc/x86_64-unknown-linux-gnu/4.2.1/install-tools/include

arch include # find . -inum 118665
find: `./ammintrin.h': No such file or directory

arch include # ls -al
ls: cannot access ammintrin.h: No such file or directory
total 0
drwxr-xr-x 1 root root 22 2009-11-16 08:39 .
drwxr-xr-x 1 root root 14 2009-11-16 04:01 ..
-????????? ? ?    ?     ?                ? ammintrin.h

arch include # ..
arch install-tools # rm -fr include
rm: cannot remove directory `include': Directory not empty

How can I get rid of that file?

-- 
Markus
