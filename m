Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:34177 "EHLO
	mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcG0N73 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 09:59:29 -0400
Received: by mail-ua0-f171.google.com with SMTP id 35so17796479uap.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jul 2016 06:59:29 -0700 (PDT)
MIME-Version: 1.0
From: Anatoly Pugachev <matorola@gmail.com>
Date: Wed, 27 Jul 2016 16:59:27 +0300
Message-ID: <CADxRZqyXtmf7LMB4ogwp8Af4Nd+Md7YtiTWRpC2xjM_fG3YKJw@mail.gmail.com>
Subject: [sparc64] mkfs.btrfs bus error / align issue?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

Running xfstests suite, got in logs mkfs.btrfs bus error, debugging it
shows the following :

mator@nvg5120:~/btrfs-progs$ git log -1 --oneline
40650bf Btrfs progs v4.6.1

root@nvg5120:/home/mator/xfstests# gdb
GNU gdb (Debian 7.11.1-2) 7.11.1
(gdb) file /opt/btrfs/bin/mkfs.btrfs
Reading symbols from /opt/btrfs/bin/mkfs.btrfs...done.
(gdb) set args -f -draid5 -mraid5 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
(gdb) run
Starting program: /opt/btrfs/bin/mkfs.btrfs -f -draid5 -mraid5
/dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/sparc64-linux-gnu/libthread_db.so.1".
btrfs-progs v4.6.1
See http://btrfs.wiki.kernel.org for more information.

ERROR: superblock checksum mismatch
ERROR: superblock checksum mismatch
ERROR: superblock checksum mismatch
Performing full device TRIM (2.00GiB) ...
Performing full device TRIM (2.00GiB) ...
Performing full device TRIM (2.00GiB) ...
Performing full device TRIM (2.00GiB) ...

Program received signal SIGBUS, Bus error.
0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570) at
volumes.c:2156
2156                                    *(unsigned long *)(p_eb->data + i) ^=
(gdb) bt
#0  0x000000000015e160 in write_raid56_with_parity (info=0x2b17b0,
eb=0x2c7fe0, multi=0x2c2870, stripe_len=65536, raid_map=0x2c2570)
    at volumes.c:2156
#1  0x0000000000119b30 in write_and_map_eb (trans=0x2cc250,
root=0x2c7d80, eb=0x2c7fe0) at disk-io.c:426
#2  0x0000000000119e74 in write_tree_block (trans=0x2cc250,
root=0x2c7d80, eb=0x2c7fe0) at disk-io.c:459
#3  0x000000000011a4ac in __commit_transaction (trans=0x2cc250,
root=0x2c7d80) at disk-io.c:562
#4  0x000000000011a7b8 in btrfs_commit_transaction (trans=0x2cc250,
root=0x2c7d80) at disk-io.c:598
#5  0x00000000001a2b04 in main (argc=8, argv=0x7fefffff698) at mkfs.c:1786
(gdb)

Can someone help please? Thanks.

PS: /dev/loop is ramdisk devices:

# mount tmpfs -t tmpfs -o size=12g /ramdisk
# fallocate -l 3.9G /ramdisk/testvol
# for i in 1 2 3 4; do fallocate -l 2G /ramdisk/scratch${i} ; done
# ls -lh /ramdisk/
total 12G
-rw-r--r-- 1 root root 2.0G Jul 27 16:16 scratch1
-rw-r--r-- 1 root root 2.0G Jul 27 16:16 scratch2
-rw-r--r-- 1 root root 2.0G Jul 27 16:16 scratch3
-rw-r--r-- 1 root root 2.0G Jul 27 16:16 scratch4
-rw-r--r-- 1 root root 3.9G Jul 27 16:15 testvol

# for i in /ramdisk/*; do echo -n "$i : "; losetup -f --show $i; done
/ramdisk/scratch1 : /dev/loop0
/ramdisk/scratch2 : /dev/loop1
/ramdisk/scratch3 : /dev/loop2
/ramdisk/scratch4 : /dev/loop3
/ramdisk/testvol : /dev/loop4
