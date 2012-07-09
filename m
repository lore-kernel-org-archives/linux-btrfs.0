Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:59356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2GIVXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 17:23:03 -0400
Message-ID: <4FFB4BB4.4080408@cv-sv.de>
Date: Mon, 09 Jul 2012 23:23:00 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfsck crashes
References: <4FF9B07C.8090209@cv-sv.de> <4FFA52BC.9010401@oracle.com>
In-Reply-To: <4FFA52BC.9010401@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain schrieb:>
 >
 >> What I have seen: buf is "0", after read_tree_block.
 >
 >   Yes since we not checking extent_buffer_uptodate for the csum_root_tree,
 >   that will pass the null buf, The following patch will avoid sending null
 >   buffer
 >     https://patchwork.kernel.org/patch/1148831/
 >
 >   However whether --init-csum-tree will build the good csum I think that
 >   will still depends on the corruption IMO.
 >
 > -Anand
 >

.)
The patch does not help.
This is false: !extent_buffer_uptodate(info->csum_root->node)

.)
Output btrfsck of git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git ,
patched at line 3552.

speedy:/tmp/btrfs/btrfs-progs # gdb ./btrfsck
GNU gdb (GDB) SUSE (7.3-41.1.2)
Copyright (C) 2011 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-suse-linux".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /tmp/btrfs/btrfs-progs/btrfsck...done.
(gdb) r /dev/md3
Starting program: /tmp/btrfs/btrfs-progs/btrfsck /dev/md3
Missing separate debuginfo for /lib64/ld-linux-x86-64.so.2
Try: zypper install -C "debuginfo(build-id)=f20c99249f5a5776e1377d3bd728502e3f455a3f"
Missing separate debuginfo for /lib64/libuuid.so.1
Try: zypper install -C "debuginfo(build-id)=24ae727f9cd5fb29f81b0f965859d3cf4668bf17"
Missing separate debuginfo for /lib64/libc.so.6
Try: zypper install -C "debuginfo(build-id)=7b169b1db50384b70e3e4b4884cd56432d5de796"
checking extents
checksum verify failed on 2327654400 wanted 89AAEA38 found 72
checksum verify failed on 2327654400 wanted 89AAEA38 found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 89AAEA38 found 72
Csum didn't match
owner ref check failed [2327654400 4096]
ref mismatch on [101138354176 98304] extent item 1, found 0
Incorrect local backref count on 101138354176 root 5 owner 1867898 offset 0 found 0 wanted 1 back 0x182ebd20
backpointer mismatch on [101138354176 98304]
owner ref check failed [101138354176 98304]
ref mismatch on [101138452480 106496] extent item 1, found 0
Incorrect local backref count on 101138452480 root 5 owner 1867899 offset 0 found 0 wanted 1 back 0xefb8d0
backpointer mismatch on [101138452480 106496]
owner ref check failed [101138452480 106496]
ref mismatch on [101138558976 8192] extent item 1, found 0
Incorrect local backref count on 101138558976 root 5 owner 1867901 offset 0 found 0 wanted 1 back 0x5a22350
backpointer mismatch on [101138558976 8192]
owner ref check failed [101138558976 8192]
ref mismatch on [101138567168 16384] extent item 1, found 0
Incorrect local backref count on 101138567168 root 5 owner 1867902 offset 0 found 0 wanted 1 back 0x5a22390
backpointer mismatch on [101138567168 16384]
owner ref check failed [101138567168 16384]
ref mismatch on [101138583552 16384] extent item 1, found 0
Incorrect local backref count on 101138583552 root 5 owner 1867903 offset 0 found 0 wanted 1 back 0x19dfaae0
backpointer mismatch on [101138583552 16384]
owner ref check failed [101138583552 16384]
Errors found in extent allocation tree
checking fs roots
checksum verify failed on 2327654400 wanted 89AAEA38 found 72
checksum verify failed on 2327654400 wanted 89AAEA38 found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 89AAEA38 found 72
Csum didn't match

Program received signal SIGSEGV, Segmentation fault.
0x0000000000402264 in btrfs_header_level (eb=0x0) at ctree.h:1540
1540    BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
(gdb)


.)
Against which git should I regular patch?
This git from the wiki seems to be not up to date:
  http://git.darksatanic.net/repo/btrfs-progs-unstable.git

This repository does not match from the line number:
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

.)
Strange for me: Why seems the same "number" 2327654400 wants
to have a different checksum?

checksum verify failed on 2327654400 wanted 89AAEA38 found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72


Thanks & regards,
Christian


>
> On 09/07/12 00:08, Christian Volkmann wrote:
>> Hi there,
>>
>> I have a corrupted filesystem. This filesystem crashes btrfsck.
>>
>> A gdb anaylsis showed me:
>> (gdb) bt
>> #0 0x0000000000402379 in btrfs_header_nritems (eb=0x0) at ctree.h:1426
>> #1 0x0000000000408c14 in run_next_block (root=0x73fb40, bits=0x740d50, bits_nr=1024, last=0x7fffffffd948, pending=0x7fffffffda40,
>> seen=0x7fffffffda50, reada=0x7fffffffda30, nodes=0x7fffffffda20, extent_cache=0x7fffffffda60) at btrfsck.c:2512
>> #2 0x00000000004099e2 in check_extents (root=0x73fb40) at btrfsck.c:2792
>> #3 0x0000000000409bec in main (ac=1, av=0x7fffffffdbe8) at btrfsck.c:2853
>>
>> What I have seen: buf is "0", after read_tree_block.
>>
>> btrfsck.c:2511 buf = read_tree_block(root, bytenr, size, 0);
>> 2512 nritems = btrfs_header_nritems(buf);
>>
>> So ctree.h crashes here with btrfs_header_nritems(buf)
>> ...
>> static inline u##bits btrfs_##name(struct extent_buffer *eb) \
>> { \
>> struct btrfs_header *h = (struct btrfs_header *)eb->data; \
>> return le##bits##_to_cpu(h->member); \
>> } \
>> ...
>>
>> I expect an error "eb == 0" is not covered by ctree.h.
>> May be another fix is required. E.g. harden btrfsck against "0".
>>
>> The file system crashes the kernel on some access. I did not follow up this,
>> cause the file system is corrupt.( Using openSUSE Tumbleweed 3.4.4-31-desktop)
>> May be the kernel code requires also checks for this?
>>
>> Please contact me, if I should do some further tests with this file system
>> or use some tools for a fix test. (developer knowledge given)
>>
>> Another minor issue: btrfsck uses much memory. But this might be normal.
>> ( > 800MB)
>>
>> Best regards,
>> Christian
>>
>>
>>
>> PS: Just if anyone is interested:
>> - History + tried: openSUSE btrfsck showed the messages below in the first step.
>> - /sbin/btrfsck /dev/md3 --repair removed some messages, except checksum.
>> - File system is mounted with:
>> /backup btrfs defaults,compress=zlib,noatime 1 2
>> - filesystem is used to back up some unix system with heavy usage of:
>> rsync -aH .... --link-dest=...
>> So each file should have regular multiple hard links.
>>
>> ===
>> Is there anybody interested in fixing this file system with me,
>> to check btrfsck speedy:/home/cv # /sbin/btrfsck /dev/md3
>> checking extents
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> Csum didn't match
>> owner ref check failed [2327654400 4096]
>> ref mismatch on [101138354176 98304] extent item 1, found 0
>> Incorrect local backref count on 101138354176 root 5 owner 1867898 offset 0 found 0 wanted 1 back 0x1f076d0
>> backpointer mismatch on [101138354176 98304]
>> owner ref check failed [101138354176 98304]
>> ref mismatch on [101138452480 106496] extent item 1, found 0
>> Incorrect local backref count on 101138452480 root 5 owner 1867899 offset 0 found 0 wanted 1 back 0x6aa85d0
>> backpointer mismatch on [101138452480 106496]
>> owner ref check failed [101138452480 106496]
>> ref mismatch on [101138558976 8192] extent item 1, found 0
>> Incorrect local backref count on 101138558976 root 5 owner 1867901 offset 0 found 0 wanted 1 back 0x6aa8610
>> backpointer mismatch on [101138558976 8192]
>> owner ref check failed [101138558976 8192]
>> ref mismatch on [101138567168 16384] extent item 1, found 0
>> Incorrect local backref count on 101138567168 root 5 owner 1867902 offset 0 found 0 wanted 1 back 0x1f8fa80
>> backpointer mismatch on [101138567168 16384]
>> owner ref check failed [101138567168 16384]
>> ref mismatch on [101138583552 16384] extent item 1, found 0
>> Incorrect local backref count on 101138583552 root 5 owner 1867903 offset 0 found 0 wanted 1 back 0x1f8fac0
>> backpointer mismatch on [101138583552 16384]
>> owner ref check failed [101138583552 16384]
>> Errors found in extent allocation tree
>> checking fs roots
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> checksum verify failed on 2327654400 wanted 73CDE79C found 72
>> Csum didn't match
>> Speicherzugriffsfehler
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

