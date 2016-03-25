Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50255 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbcCYLCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 07:02:33 -0400
MIME-Version: 1.0
Message-ID: <trinity-17ca2179-b6d5-4eb0-9255-81cd338d02e8-1458903748979@3capp-gmx-bs05>
From: "Jan Koester" <jan.koester@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: Aw: cannot repair raid6 volume rescue zero-log crashed
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Mar 2016 12:02:29 +0100
In-Reply-To: <trinity-bf6c2c0d-170a-40b8-9658-c5ed72e8b58f-1456564286770@3capp-gmx-bs71>
References: <trinity-bf6c2c0d-170a-40b8-9658-c5ed72e8b58f-1456564286770@3capp-gmx-bs71>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


 
with btrfs tools 4.5 i got this message:

Starting program: /root/btrfs-progs/btrfsck --repair --init-extent-tree /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
enabling repair mode
repair mode will force to clear out log tree, Are you sure? [y/N]: y
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs check(btrfs_reserve_extent+0x99e)[0x4500e6]
btrfs check(btrfs_alloc_free_block+0x60)[0x450479]
btrfs check(__btrfs_cow_block+0x1a7)[0x43f394]
btrfs check(btrfs_cow_block+0x102)[0x43fe19]
btrfs check[0x4458a2]
btrfs check(btrfs_commit_transaction+0xec)[0x447758]
btrfs check(cmd_check+0x633)[0x42c2a9]
btrfs check(main+0x155)[0x40a193]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7ffff6f8ea40]
btrfs check(_start+0x29)[0x409d89]
[Inferior 1 (process 5460) exited with code 01]

Starting program: /root/btrfs-progs/btrfs rescue zero-log /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
parent transid verify failed on 2280450637824 wanted 861168 found 860380
parent transid verify failed on 2280450637824 wanted 861168 found 860380
checksum verify failed on 2280450637824 found BF5F5D16 wanted AE725F92
checksum verify failed on 2280450637824 found BF5F5D16 wanted AE725F92
bytenr mismatch, want=2280450637824, have=15938376490240
Clearing log on /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32, previous log_root 2280534142976, level 0
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
extent-tree.c:2728: alloc_reserved_tree_block: Assertion `ret` failed.
/root/btrfs-progs/btrfs[0x44ba64]
/root/btrfs-progs/btrfs[0x44bce3]
/root/btrfs-progs/btrfs(btrfs_alloc_free_block+0x23b)[0x450654]
/root/btrfs-progs/btrfs(__btrfs_cow_block+0x1a7)[0x43f394]
/root/btrfs-progs/btrfs(btrfs_cow_block+0x102)[0x43fe19]
/root/btrfs-progs/btrfs[0x4458a2]
/root/btrfs-progs/btrfs(btrfs_commit_transaction+0xec)[0x447758]
/root/btrfs-progs/btrfs[0x432888]
/root/btrfs-progs/btrfs(handle_command_group+0x5d)[0x40a039]
/root/btrfs-progs/btrfs(cmd_rescue+0x15)[0x4328bc]
/root/btrfs-progs/btrfs(main+0x155)[0x40a193]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7ffff6f8ea40]
/root/btrfs-progs/btrfs(_start+0x29)[0x409d89]
 

Gesendet: Samstag, 27. Februar 2016 um 10:11 Uhr
Von: "Jan Koester" <jan.koester@gmx.net>
An: linux-btrfs@vger.kernel.org
Betreff: cannot repair raid6 volume rescue zero-log crashed
Hi,
 
cannot recover my home filesystem.
 
Linux dibsi 4.2.0-30-generic #35-Ubuntu SMP Fri Feb 19 13:52:26 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
 
btrfs --version
btrfs-progs v4.4

btrfs fi show
Label: 'root' uuid: 3d279e92-d021-4a57-92b8-db3bfcbba79d
Total devices 1 FS bytes used 74.47GiB
devid 1 size 111.79GiB used 82.02GiB path /dev/sdf1

Label: none uuid: 73d4dc77-6ff3-412f-9b0a-0d11458faf32
Total devices 5 FS bytes used 1.17TiB
devid 1 size 931.51GiB used 420.78GiB path /dev/sdb
devid 2 size 931.51GiB used 420.78GiB path /dev/sdc
devid 3 size 931.51GiB used 420.78GiB path /dev/sdd
devid 4 size 931.51GiB used 420.78GiB path /dev/sde
devid 5 size 931.51GiB used 420.78GiB path /dev/sda

 
btrfs rescue zero-log:

root@dibsi:/home/jan# gdb --args btrfs rescue zero-log /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
GNU gdb (Ubuntu 7.10-1ubuntu2) 7.10
Copyright (C) 2015 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html[https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fgnu.org%2Flicenses%2Fgpl.html[https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fgnu.org%2Flicenses%2Fgpl.html]]>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/[http://www.gnu.org/software/gdb/bugs/][https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fbugs%2F[https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fbugs%2F]]>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/[http://www.gnu.org/software/gdb/documentation/][https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fdocumentation%2F[https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fdocumentation%2F]]>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from btrfs...done.
(gdb) r
Starting program: /usr/local/bin/btrfs rescue zero-log /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
parent transid verify failed on 2280450637824 wanted 861168 found 860380
parent transid verify failed on 2280450637824 wanted 861168 found 860380
checksum verify failed on 2280450637824 found BF5F5D16 wanted AE725F92
checksum verify failed on 2280450637824 found BF5F5D16 wanted AE725F92
bytenr mismatch, want=2280450637824, have=15938376490240
Clearing log on /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32, previous log_root 2280534142976, level 0
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
parent transid verify failed on 2280260939776 wanted 861166 found 860368
parent transid verify failed on 2280260939776 wanted 861166 found 860368
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
checksum verify failed on 2280260939776 found 816E966C wanted CB60A223
bytenr mismatch, want=2280260939776, have=15937230354176
btrfs unable to find ref byte nr 2280388792320 parent 0 root 2  owner 3 offset 0
parent transid verify failed on 2280394903552 wanted 861168 found 860376
parent transid verify failed on 2280394903552 wanted 861168 found 860376
checksum verify failed on 2280394903552 found 49326465 wanted 1DF607C0
checksum verify failed on 2280394903552 found 49326465 wanted 1DF607C0
bytenr mismatch, want=2280394903552, have=15938169211392
btrfs unable to find ref byte nr 2280244973568 parent 0 root 2  owner 0 offset 0
parent transid verify failed on 2280389988352 wanted 861168 found 860375
parent transid verify failed on 2280389988352 wanted 861168 found 860375
checksum verify failed on 2280389988352 found 9EFF3657 wanted C933E8C1
checksum verify failed on 2280389988352 found 9EFF3657 wanted C933E8C1
bytenr mismatch, want=2280389988352, have=15938306902528
btrfs unable to find ref byte nr 2280388808704 parent 0 root 2  owner 2 offset 0
parent transid verify failed on 2280389992448 wanted 861168 found 860375
parent transid verify failed on 2280389992448 wanted 861168 found 860375
checksum verify failed on 2280389992448 found 1AF14813 wanted B3ED8CAB
checksum verify failed on 2280389992448 found 1AF14813 wanted B3ED8CAB
bytenr mismatch, want=2280389992448, have=15938306939392
btrfs unable to find ref byte nr 2280388935680 parent 0 root 2  owner 1 offset 0
Failed to find [2280445247488, 168, 4096]
btrfs unable to find ref byte nr 2280445247488 parent 0 root 2  owner 0 offset 0
Failed to find [2280463486976, 168, 4096]
btrfs unable to find ref byte nr 2280463486976 parent 0 root 2  owner 1 offset 0
Failed to find [2280463491072, 168, 4096]
btrfs unable to find ref byte nr 2280463491072 parent 0 root 2  owner 0 offset 0
parent transid verify failed on 2280458645504 wanted 861168 found 860380
parent transid verify failed on 2280458645504 wanted 861168 found 860380
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
bytenr mismatch, want=2280458645504, have=15938383793408
btrfs unable to find ref byte nr 2280458211328 parent 0 root 1  owner 1 offset 0
parent transid verify failed on 2280458645504 wanted 861168 found 860380
parent transid verify failed on 2280458645504 wanted 861168 found 860380
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
bytenr mismatch, want=2280458645504, have=15938383793408
parent transid verify failed on 2280458645504 wanted 861168 found 860380
parent transid verify failed on 2280458645504 wanted 861168 found 860380
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
checksum verify failed on 2280458645504 found 609E8D90 wanted 62B88736
bytenr mismatch, want=2280458645504, have=15938383793408
Program received signal SIGSEGV, Segmentation fault.
alloc_reserved_tree_block (trans=trans@entry=0x69b230, root=root@entry=0x69c850, root_objectid=root_objectid@entry=1,
    generation=generation@entry=861169, flags=flags@entry=0, key=key@entry=0x7fffffffe070, level=0, ins=0x7fffffffdf50) at extent-tree.c:2731
warning: Source file is more recent than executable.
2731            extent_item = btrfs_item_ptr(leaf, path->slots[0],
(gdb) bt
#0  alloc_reserved_tree_block (trans=trans@entry=0x69b230, root=root@entry=0x69c850, root_objectid=root_objectid@entry=1,
    generation=generation@entry=861169, flags=flags@entry=0, key=key@entry=0x7fffffffe070, level=0, ins=0x7fffffffdf50) at extent-tree.c:2731
#1  0x000000000044b2a9 in alloc_tree_block (ins=0x7fffffffdf50, search_end=18446744073709551615, hint_byte=2279553892352, empty_size=0,
    level=0, key=0x7fffffffe070, flags=0, generation=861169, root_objectid=1, num_bytes=4096, root=0x69c850, trans=0x69b230)
    at extent-tree.c:2794
#2  btrfs_alloc_free_block (trans=trans@entry=0x69b230, root=root@entry=0x69c850, blocksize=4096, root_objectid=1,
    key=key@entry=0x7fffffffe070, level=level@entry=0, hint=2279553892352, empty_size=0) at extent-tree.c:2817
#3  0x000000000043a55c in __btrfs_cow_block (trans=0x69b230, root=0x69c850, buf=0x6b1260, parent=0x6c3d40, parent_slot=0,
    cow_ret=0x7fffffffe2a8, search_start=2279553892352, empty_size=0) at ctree.c:278
#4  0x000000000043afe1 in btrfs_cow_block (trans=trans@entry=0x69b230, root=root@entry=0x69c850, buf=<optimized out>,
    parent=<optimized out>, parent_slot=<optimized out>, cow_ret=cow_ret@entry=0x7fffffffe2a8) at ctree.c:371
#5  0x000000000043da90 in btrfs_search_slot (trans=trans@entry=0x69b230, root=root@entry=0x69c850, key=key@entry=0x69cc77,
    p=p@entry=0x6cefe0, ins_len=ins_len@entry=0, cow=cow@entry=1) at ctree.c:1122
#6  0x000000000044f3a9 in btrfs_update_root (trans=trans@entry=0x69b230, root=root@entry=0x69c850, key=key@entry=0x69cc77,
    item=item@entry=0x69cac0) at root-tree.c:78
#7  0x0000000000440935 in update_cowonly_root (root=0x69cab0, trans=0x69b230) at disk-io.c:492
#8  commit_tree_roots (trans=trans@entry=0x69b230, fs_info=fs_info@entry=0x69c5f0) at disk-io.c:523
#9  0x000000000044271f in btrfs_commit_transaction (trans=0x69b230, root=root@entry=0x6b7330) at disk-io.c:582
#10 0x0000000000430d0a in cmd_rescue_zero_log (argc=<optimized out>, argv=<optimized out>) at cmds-rescue.c:195
#11 0x0000000000409e39 in handle_command_group (grp=grp@entry=0x694380 <rescue_cmd_group>, argc=2, argv=<optimized out>) at btrfs.c:135
#12 0x0000000000430d3a in cmd_rescue (argc=<optimized out>, argv=<optimized out>) at cmds-rescue.c:218
#13 0x0000000000409f93 in main (argc=3, argv=0x7fffffffe600) at btrfs.c:243
 
btrfsck --repair :
 
root@dibsi:/home/jan# gdb --args btrfsck --repair --init-extent-tree /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
GNU gdb (Ubuntu 7.10-1ubuntu2) 7.10
Copyright (C) 2015 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html[http://gnu.org/licenses/gpl.html][https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fgnu.org%2Flicenses%2Fgpl.html[https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fgnu.org%2Flicenses%2Fgpl.html]]>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/[http://www.gnu.org/software/gdb/bugs/][https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fbugs%2F[https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fbugs%2F]]>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/[http://www.gnu.org/software/gdb/documentation/][https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fdocumentation%2F[https://deref-gmx.net/mail/client/dereferrer/?redirectUrl=http%3A%2F%2Fwww.gnu.org%2Fsoftware%2Fgdb%2Fdocumentation%2F]]>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from btrfsck...done.
(gdb) r
Starting program: /usr/local/bin/btrfsck --repair --init-extent-tree /dev/disk/by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
enabling repair mode
repair mode will force to clear out log tree, Are you sure? [y/N]: y
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs check(btrfs_reserve_extent+0x99e)[0x44ad51]
btrfs check(btrfs_alloc_free_block+0x60)[0x44b0e4]
btrfs check(__btrfs_cow_block+0x1a7)[0x43a55c]
btrfs check(btrfs_cow_block+0x102)[0x43afe1]
btrfs check[0x440880]
btrfs check(btrfs_commit_transaction+0xec)[0x44271f]
btrfs check(cmd_check+0x65b)[0x42a35d]
btrfs check(main+0x155)[0x409f93]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7ffff6f8ea40]
btrfs check(_start+0x29)[0x409b89]
[Inferior 1 (process 1916) exited with code 01]
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html[http://vger.kernel.org/majordomo-info.html]
