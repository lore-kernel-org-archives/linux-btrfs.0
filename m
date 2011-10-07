From: Marc Ballarin <ballarin.marc@gmx.de>
Subject: stat returns wrong block count
Date: Sat, 8 Oct 2011 01:10:58 +0200
Message-ID: <20111008011058.dc7a12c8cf36706369089882@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
recently I encountered weird (much too small) numbers returned by "du". It turns out that
on some files btrfs returns a wrong number of used blocks.

Two files, identical, non-zero, non-spare:
# ls -l
total 19296 <-- block count is wrong, sizes are correct
-rw-r--r-- 1 marc root 19759104 Oct  7 22:55 test.file
-rw-r--r-- 1 marc root 19759104 Oct  7 22:55 test0.file

# du *
19296   test.file
0       test0.file

# cmp test.file test0.file && echo identical
identical
# cmp test0.file /dev/zero
test0.file /dev/zero differ: char 3, line 1

from strace -v du
newfstatat(AT_FDCWD, "test.file", {..., st_blksize=4096, st_blocks=38592, st_size=19759104, ...}
newfstatat(AT_FDCWD, "test0.file", {..., st_blksize=4096, st_blocks=0, st_size=19759104, ...}
or
# stat -c "%n: %B * %b" *
test.file: 512 * 38592
test0.file: 512 * 0

Note that "test.file" was created by copying "test0.file", but using a fresh copy makes no
difference.

Some bigger files show a block count much too low, but not zero blocks:
# stat -c "%n: %B * %b" test-big.file
test-big.file: 512 * 276096
# cp test-big.file test-big2.file
# stat -c "%n: %B * %b" test-big2.file
test-big2.file: 512 * 1074928

The files were originally created by rsync, either over NFSv4 or CIFS (I think it was CIFS
at first and later switched to NFS) using kernel 3.0.0. Current kernel is 3.1-rc9.

The filesystem is on top of MD-RAID-5. Space cache was not enabled and using
clear_cache or anbling space_cache makes no difference.

Content of the files is completely intact. 

Is this a known issue?

Regards,
Marc
