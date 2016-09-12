Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.famsik.de ([109.75.188.245]:52740 "EHLO www.hamsked.org"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758860AbcILOd7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 10:33:59 -0400
Received: from pd9fb57c4.dip0.t-ipconnect.de ([217.251.87.196] helo=[192.168.2.102])
        by www.hamsked.org with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.72)
        (envelope-from <matthias.krueger@famsik.de>)
        id 1bjRj6-00039j-63
        for linux-btrfs@vger.kernel.org; Mon, 12 Sep 2016 15:56:48 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Matthias_Kr=c3=bcger?= <matthias.krueger@famsik.de>
Subject: fsck-tests: heap use after free in repair_inode_backrefs()
Message-ID: <ce638a6a-14d6-bb51-b1c1-922e34e139e6@famsik.de>
Date: Mon, 12 Sep 2016 15:56:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I ran tests on the devel branch ( 
2b7c507d1de764002763190afe219746bb710098 ) of the github repo.

Compiling btrfs with "-g3 -fsanitize=address -fno-common" using gcc 
6.1.1-3 (fedora 24) reveals a heap use after free in 
repair_inode_backrefs().


These fsck tests failed (crashed due to ASAN):
004-no-dir-index
005-bad-item-offset
007-bad-offset-snapshots
008-bad-dir-index-name
015-check-bad-memory-access


This is the stacktrace of 004-no-dir-index:

############### /home/matthias/vcs/github/btrfs-progs/btrfs check 
--repair 
/home/matthias/vcs/github/btrfs-progs/tests/fsck-tests/004-no-dir-index/default_case.img.restored
Fixed 0 roots.
checking free space cache
checking fs roots
repairing missing dir index item for inode 265
=================================================================
==29044==ERROR: AddressSanitizer: heap-use-after-free on address 
0x60600000e550 at pc 0x000000450aa6 bp 0x7fffab169590 sp 0x7fffab169580
READ of size 1 at 0x60600000e550 thread T0
     #0 0x450aa5 in repair_inode_backrefs 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:2396
     #1 0x4540d8 in check_inode_recs 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3036
     #2 0x458b32 in check_fs_root 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3723
     #3 0x459237 in check_fs_roots 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3809
     #4 0x4800d5 in cmd_check 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:11533
     #5 0x40b3d7 in main /home/matthias/vcs/github/btrfs-progs/btrfs.c:243
     #6 0x7f979b4fe730 in __libc_start_main (/lib64/libc.so.6+0x20730)
     #7 0x40a9a8 in _start 
(/home/matthias/vcs/github/btrfs-progs/btrfs+0x40a9a8)

0x60600000e550 is located 16 bytes inside of 58-byte region 
[0x60600000e540,0x60600000e57a)
freed by thread T0 here:
     #0 0x7f979c403ac0 in free (/lib64/libasan.so.3+0xc6ac0)
     #1 0x450a62 in repair_inode_backrefs 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:2391
     #2 0x4540d8 in check_inode_recs 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3036
     #3 0x458b32 in check_fs_root 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3723
     #4 0x459237 in check_fs_roots 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3809
     #5 0x4800d5 in cmd_check 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:11533
     #6 0x40b3d7 in main /home/matthias/vcs/github/btrfs-progs/btrfs.c:243
     #7 0x7f979b4fe730 in __libc_start_main (/lib64/libc.so.6+0x20730)

previously allocated by thread T0 here:
     #0 0x7f979c403e20 in malloc (/lib64/libasan.so.3+0xc6e20)
     #1 0x446c3f in get_inode_backref 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:1043
     #2 0x446ded in add_inode_backref 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:1065
     #3 0x449ee4 in process_dir_item 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:1494
     #4 0x44c397 in process_one_leaf 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:1807
     #5 0x44d28c in walk_down_tree 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:1958
     #6 0x45854c in check_fs_root 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3668
     #7 0x459237 in check_fs_roots 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:3809
     #8 0x4800d5 in cmd_check 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:11533
     #9 0x40b3d7 in main /home/matthias/vcs/github/btrfs-progs/btrfs.c:243
     #10 0x7f979b4fe730 in __libc_start_main (/lib64/libc.so.6+0x20730)

SUMMARY: AddressSanitizer: heap-use-after-free 
/home/matthias/vcs/github/btrfs-progs/cmds-check.c:2396 in 
repair_inode_backrefs
Shadow bytes around the buggy address:
   0x0c0c7fff9c50: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
   0x0c0c7fff9c60: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
   0x0c0c7fff9c70: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
   0x0c0c7fff9c80: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
   0x0c0c7fff9c90: fd fd fd fd fd fd fd fa fa fa fa fa fd fd fd fd
=>0x0c0c7fff9ca0: fd fd fd fa fa fa fa fa fd fd[fd]fd fd fd fd fd
   0x0c0c7fff9cb0: fa fa fa fa 00 00 00 00 00 00 00 fa fa fa fa fa
   0x0c0c7fff9cc0: fd fd fd fd fd fd fd fd fa fa fa fa fd fd fd fd
   0x0c0c7fff9cd0: fd fd fd fa fa fa fa fa fd fd fd fd fd fd fd fd
   0x0c0c7fff9ce0: fa fa fa fa fd fd fd fd fd fd fd fa fa fa fa fa
   0x0c0c7fff9cf0: fd fd fd fd fd fd fd fd fa fa fa fa fd fd fd fd
Shadow byte legend (one shadow byte represents 8 application bytes):
   Addressable:           00
   Partially addressable: 01 02 03 04 05 06 07
   Heap left redzone:       fa
   Heap right redzone:      fb
   Freed heap region:       fd
   Stack left redzone:      f1
   Stack mid redzone:       f2
   Stack right redzone:     f3
   Stack partial redzone:   f4
   Stack after return:      f5
   Stack use after scope:   f8
   Global redzone:          f9
   Global init order:       f6
   Poisoned by user:        f7
   Container overflow:      fc
   Array cookie:            ac
   Intra object redzone:    bb
   ASan internal:           fe
   Left alloca redzone:     ca
   Right alloca redzone:    cb
==29044==ABORTING
failed: /home/matthias/vcs/github/btrfs-progs/btrfs check --repair 
/home/matthias/vcs/github/btrfs-progs/tests/fsck-tests/004-no-dir-index/default_case.img.restored



Kind regards,

Matthias

