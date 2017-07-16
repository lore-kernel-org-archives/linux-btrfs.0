Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35410 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751087AbdGPLTZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Jul 2017 07:19:25 -0400
Received: by mail-wm0-f44.google.com with SMTP id w126so53788078wme.0
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Jul 2017 04:19:24 -0700 (PDT)
Received: from [192.168.1.100] (athedsl-88769.home.otenet.gr. [87.203.100.15])
        by smtp.gmail.com with ESMTPSA id x98sm20797503wrb.47.2017.07.16.04.19.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jul 2017 04:19:22 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Tassos Mavroudeas <amavroudeas@yahoo.co.uk>
Subject: segfault on btrfs --repair
Message-ID: <4effea44-4fd2-c562-f7fb-17bc4623ced5@yahoo.co.uk>
Date: Sun, 16 Jul 2017 14:19:21 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

let me share with you a segfault on btrfs --repair

I have backups etc. latest kernel and progs.

[root@node ~]# uname -a
Linux node 4.12.2 #1 SMP Sun Jul 16 08:15:48 EEST 2017 x86_64 x86_64 
x86_64 GNU/Linux
[root@node ~]# btrfs version
btrfs-progs v4.11.1

GNU gdb (GDB) Red Hat Enterprise Linux 7.6.1-94.el7
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later 
<http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /usr/local/bin/btrfs...done.
(gdb) run
Starting program: /usr/local/bin/btrfs check --repair /dev/sda
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
enabling repair mode
Checking filesystem on /dev/sda
UUID: 1e8b84a5-efba-478e-a034-6262a460de63
checking extents
bad key ordering 0 1
bad block 3733972926464
ERROR: errors found in extent allocation tree or chunk allocation
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
bad key ordering 0 1
The following tree block(s) is corrupted in tree 5:
         tree block bytenr: 3733966553088, level: 0, node key: 
(3734066397184, 169, 0)
Try to repair the btree for root 5

Program received signal SIGSEGV, Segmentation fault.
0x00007f2f2a8e3f12 in __memmove_ssse3 () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install 
glibc-2.17-157.el7_3.4.x86_64 libblkid-2.23.2-33.el7_3.2.x86_64 
libuuid-2.23.2-33.el7_3.2.x86_64 lzo-2.06-8.el7.x86_64 
zlib-1.2.7-17.el7.x86_64
(gdb) backtrace
#0  0x00007f2f2a8e3f12 in __memmove_ssse3 () from /lib64/libc.so.6
#1  0x0000000000424705 in memmove (__len=141733920735, __src=0x91e58a1, 
__dest=0x91e5880) at /usr/include/bits/string3.h:57
#2  memmove_extent_buffer (dst=dst@entry=0x91e4be0, 
dst_offset=dst_offset@entry=3104, src_offset=src_offset@entry=3137, 
len=len@entry=141733920735) at extent_io.c:882
#3  0x000000000040edb1 in btrfs_del_ptr (root=root@entry=0x8a3470, 
path=path@entry=0x7fffffffde00, level=level@entry=0, slot=91) at 
ctree.c:2607
#4  0x0000000000452809 in repair_btree (corrupt_blocks=0x7fffffffdfa0, 
root=0x8a3470) at cmds-check.c:3847
#5  check_fs_root (root=root@entry=0x8a3470, 
root_cache=root_cache@entry=0x7fffffffe4b0, wc=wc@entry=0x7fffffffe200) 
at cmds-check.c:4009
#6  0x000000000045eda5 in check_fs_roots (root_cache=0x7fffffffe4b0, 
root=0x8a3470) at cmds-check.c:4115
#7  cmd_check (argc=<optimized out>, argv=<optimized out>) at 
cmds-check.c:13076
#8  0x000000000040abd4 in main (argc=3, argv=0x7fffffffe600) at btrfs.c:302


---
Αυτό το e-mail ελέγχθηκε για ιούς από το πρόγραμμα Avast antivirus.
https://www.avast.com/antivirus

