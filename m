Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35385 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbDWSdT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 14:33:19 -0400
Received: by lbbuc2 with SMTP id uc2so19803845lbb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 11:33:18 -0700 (PDT)
MIME-Version: 1.0
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Thu, 23 Apr 2015 20:32:57 +0200
Message-ID: <CAJF-kYmZUX7PuzQzr-BDk1B84rd7=rPnjF1N6Y056siOmG4qTg@mail.gmail.com>
Subject: Crafted BTRFS-image causes use of unitialized memory in btrfs-progs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

See also https://bugzilla.kernel.org/show_bug.cgi?id=97171

Running btrfs-progs v3.19.1

The btrfs-image attached to this bug causes the btrfs-userland tool to
use uninitialized memory and ultimately overwrite what seems to be
arbitrary memory locations, dying in the process. Reproduced on x86-64
and i686.

The kernel seems to be less affected and fails to mount the image. If
/usr/sbin/btrfs is not setuid (which it probably never is), things
should be safe. I didn't investigate further though.

gdb output:

GNU gdb (GDB) Fedora 7.8.2-38.fc21
[... lots of other errors...]
Ignoring transid failure
root 5 inode 260 errors 1000, some csum missing
unresolved ref dir 256 index 7 namelen 5 name b.bin filetype 1 errors
2, no dir index
unresolved ref dir 256 index 7 namelen 5 name b.fin filetype 1 errors
5, no dir item, no inode ref
root 5 inode 261 errors 200, dir isize wrong

Program received signal SIGSEGV, Segmentation fault.
0x000000000089bb70 in ?? ()
(gdb) bt
#0  0x000000000089bb70 in ?? ()
#1  0x00007fffffffdb50 in ?? ()
#2  0x0000000000894b20 in ?? ()
#3  0x00000032629b88e0 in _IO_2_1_stdout_ () from /lib64/libc.so.6
#4  0x000000000088c010 in ?? ()
#5  0x0000000000000000 in ?? ()


valgrind output:

[...lots of errors...]
==12638== Conditional jump or move depends on uninitialised value(s)
==12638==    at 0x436E77: check_block.part.14 (ctree.c:548)
==12638==    by 0x438954: UnknownInlinedFun (kerncompat.h:91)
==12638==    by 0x438954: btrfs_search_slot (ctree.c:1120)
==12638==    by 0x40DD1F: count_csum_range (cmds-check.c:1419)
==12638==    by 0x40DD1F: process_file_extent (cmds-check.c:1551)
==12638==    by 0x40DD1F: process_one_leaf (cmds-check.c:1617)
==12638==    by 0x40DD1F: walk_down_tree (cmds-check.c:1742)
==12638==    by 0x40DD1F: check_fs_root (cmds-check.c:3380)
==12638==    by 0x40DD1F: check_fs_roots.isra.51 (cmds-check.c:3516)
==12638==    by 0x4C64B0F: ???
==12638==    by 0x4C30A2F: ???
==12638==    by 0x4C468CF: ???
==12638==    by 0x32629B88DF: ??? (in /usr/lib64/libc-2.20.so)
==12638==    by 0x4C3657F: ???
==12638==
[...lots of warnings...]
==12638==
==12638== Use of uninitialised value of size 8
==12638==    at 0x4A0B3A0: memcpy@@GLIBC_2.14 (in
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==12638==    by 0x436E99: UnknownInlinedFun (ctree.h:1613)
==12638==    by 0x436E99: check_block.part.14 (ctree.c:550)
==12638==    by 0x438954: UnknownInlinedFun (kerncompat.h:91)
==12638==    by 0x438954: btrfs_search_slot (ctree.c:1120)
==12638==    by 0x40DD1F: count_csum_range (cmds-check.c:1419)
==12638==    by 0x40DD1F: process_file_extent (cmds-check.c:1551)
==12638==    by 0x40DD1F: process_one_leaf (cmds-check.c:1617)
==12638==    by 0x40DD1F: walk_down_tree (cmds-check.c:1742)
==12638==    by 0x40DD1F: check_fs_root (cmds-check.c:3380)
==12638==    by 0x40DD1F: check_fs_roots.isra.51 (cmds-check.c:3516)
==12638==    by 0x4C64B0F: ???
==12638==    by 0x4C30A2F: ???
==12638==    by 0x4C468CF: ???
==12638==    by 0x32629B88DF: ??? (in /usr/lib64/libc-2.20.so)
==12638==    by 0x4C3657F: ???
==12638==
==12638== Invalid read of size 1
==12638==    at 0x4A0B3A0: memcpy@@GLIBC_2.14 (in
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==12638==    by 0x436E99: UnknownInlinedFun (ctree.h:1613)
==12638==    by 0x436E99: check_block.part.14 (ctree.c:550)
==12638==    by 0x438954: UnknownInlinedFun (kerncompat.h:91)
==12638==    by 0x438954: btrfs_search_slot (ctree.c:1120)
==12638==    by 0x40DD1F: count_csum_range (cmds-check.c:1419)
==12638==    by 0x40DD1F: process_file_extent (cmds-check.c:1551)
==12638==    by 0x40DD1F: process_one_leaf (cmds-check.c:1617)
==12638==    by 0x40DD1F: walk_down_tree (cmds-check.c:1742)
==12638==    by 0x40DD1F: check_fs_root (cmds-check.c:3380)
==12638==    by 0x40DD1F: check_fs_roots.isra.51 (cmds-check.c:3516)
==12638==    by 0x4C64B0F: ???
==12638==    by 0x4C30A2F: ???
==12638==    by 0x4C468CF: ???
==12638==    by 0x32629B88DF: ??? (in /usr/lib64/libc-2.20.so)
==12638==    by 0x4C3657F: ???
==12638==  Address 0xa25c9de9 is not stack'd, malloc'd or (recently) free'd
==12638==
==12638==
==12638== Process terminating with default action of signal 11 (SIGSEGV)
==12638==  Access not within mapped region at address 0xA25C9DE9
==12638==    at 0x4A0B3A0: memcpy@@GLIBC_2.14 (in
/usr/lib64/valgrind/vgpreload_memcheck-amd64-linux.so)
==12638==    by 0x436E99: UnknownInlinedFun (ctree.h:1613)
==12638==    by 0x436E99: check_block.part.14 (ctree.c:550)
==12638==    by 0x438954: UnknownInlinedFun (kerncompat.h:91)
==12638==    by 0x438954: btrfs_search_slot (ctree.c:1120)
==12638==    by 0x40DD1F: count_csum_range (cmds-check.c:1419)
==12638==    by 0x40DD1F: process_file_extent (cmds-check.c:1551)
==12638==    by 0x40DD1F: process_one_leaf (cmds-check.c:1617)
==12638==    by 0x40DD1F: walk_down_tree (cmds-check.c:1742)
==12638==    by 0x40DD1F: check_fs_root (cmds-check.c:3380)
==12638==    by 0x40DD1F: check_fs_roots.isra.51 (cmds-check.c:3516)
==12638==    by 0x4C64B0F: ???
==12638==    by 0x4C30A2F: ???
==12638==    by 0x4C468CF: ???
==12638==    by 0x32629B88DF: ??? (in /usr/lib64/libc-2.20.so)
==12638==    by 0x4C3657F: ???
