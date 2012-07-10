Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2GJJNk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 05:13:40 -0400
Date: Tue, 10 Jul 2012 11:13:38 +0200 (CEST)
From: "haveaniceday@cv-sv.de" <haveaniceday@cv-sv.de>
Reply-To: "haveaniceday@cv-sv.de" <haveaniceday@cv-sv.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <1462124570.240756.1341911618590.JavaMail.open-xchange@email.1und1.de>
In-Reply-To: <4FFBCC1A.8020800@oracle.com>
References: <4FF9B07C.8090209@cv-sv.de> <4FFA52BC.9010401@oracle.com> <4FFB4BB4.4080408@cv-sv.de> <4FFBCC1A.8020800@oracle.com>
Subject: Re: btrfsck crashes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




Anand Jain <Anand.Jain@oracle.com> hat am 10. Juli 2012 um 08:30 geschrieben:

>
> Christian,
>
>   line # is still confusing to me as well. patch was to avoid seg
>   fault when csum_root node is null and it might not be the case
>   here then.
>
>   (If the original problem stack-trace has remained the same
>   which is as below)..

Hi Anand,

I have used git clone
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

The stack looks now like below.  I expect the first "0" in path->nodes
 generates the problem.
(gdb) p path->nodes
$2 = {0x0, 0x27ad82e0, 0x3893a930, 0x3dc24f0, 0x75efa0, 0x0, 0x0, 0x0}



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
Try: zypper install -C
"debuginfo(build-id)=f20c99249f5a5776e1377d3bd728502e3f455a3f"
Missing separate debuginfo for /lib64/libuuid.so.1
Try: zypper install -C
"debuginfo(build-id)=24ae727f9cd5fb29f81b0f965859d3cf4668bf17"
Missing separate debuginfo for /lib64/libc.so.6
Try: zypper install -C
"debuginfo(build-id)=7b169b1db50384b70e3e4b4884cd56432d5de796"
checking extents
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
Csum didn't match
owner ref check failed [2327654400 4096]
ref mismatch on [101138354176 98304] extent item 1, found 0
Incorrect local backref count on 101138354176 root 5 owner 1867898 offset 0
found 0 wanted 1 back 0x19e025d0
backpointer mismatch on [101138354176 98304]
owner ref check failed [101138354176 98304]
ref mismatch on [101138452480 106496] extent item 1, found 0
Incorrect local backref count on 101138452480 root 5 owner 1867899 offset 0
found 0 wanted 1 back 0x19e02610
backpointer mismatch on [101138452480 106496]
owner ref check failed [101138452480 106496]
ref mismatch on [101138558976 8192] extent item 1, found 0
Incorrect local backref count on 101138558976 root 5 owner 1867901 offset 0
found 0 wanted 1 back 0x5a60f90
backpointer mismatch on [101138558976 8192]
owner ref check failed [101138558976 8192]
ref mismatch on [101138567168 16384] extent item 1, found 0
Incorrect local backref count on 101138567168 root 5 owner 1867902 offset 0
found 0 wanted 1 back 0x5a60fd0
backpointer mismatch on [101138567168 16384]
owner ref check failed [101138567168 16384]
ref mismatch on [101138583552 16384] extent item 1, found 0
Incorrect local backref count on 101138583552 root 5 owner 1867903 offset 0
found 0 wanted 1 back 0x19e04420
backpointer mismatch on [101138583552 16384]
owner ref check failed [101138583552 16384]
Errors found in extent allocation tree
checking fs roots
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
Csum didn't match

Program received signal SIGSEGV, Segmentation fault.
0x0000000000402264 in btrfs_header_level (eb=0x0) at ctree.h:1540
1540    BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
(gdb) bt
#0  0x0000000000402264 in btrfs_header_level (eb=0x0) at ctree.h:1540
#1  0x000000000040531f in walk_down_tree (root=0x6f6c540, path=0x7fffffffde70,
wc=0x7fffffffdf40,
    level=0x7fffffffdf00) at btrfsck.c:1176
#2  0x0000000000406bf6 in check_fs_root (root=0x6f6c540,
root_cache=0x7fffffffe0c0, wc=0x7fffffffdf40)
    at btrfsck.c:1702
#3  0x0000000000406ecb in check_fs_roots (root=0x75ee00,
root_cache=0x7fffffffe0c0) at btrfsck.c:1773
#4  0x000000000040b49c in main (ac=1, av=0x7fffffffe1f8) at btrfsck.c:3576
(gdb) l
1535    BTRFS_SETGET_HEADER_FUNCS(header_generation, struct btrfs_header,
1536                              generation, 64);
1537    BTRFS_SETGET_HEADER_FUNCS(header_owner, struct btrfs_header, owner, 64);
1538    BTRFS_SETGET_HEADER_FUNCS(header_nritems, struct btrfs_header, nritems,
32);
1539    BTRFS_SETGET_HEADER_FUNCS(header_flags, struct btrfs_header, flags, 64);
1540    BTRFS_SETGET_HEADER_FUNCS(header_level, struct btrfs_header, level, 8);
1541
1542    static inline int btrfs_header_flag(struct extent_buffer *eb, u64 flag)
1543    {
1544            return (btrfs_header_flags(eb) & flag) == flag;
(gdb) up
#1  0x000000000040531f in walk_down_tree (root=0x6f6c540, path=0x7fffffffde70,
wc=0x7fffffffdf40,
    level=0x7fffffffdf00) at btrfsck.c:1176
1176                    if (btrfs_header_level(cur) != *level)
(gdb) l
1171            while (*level >= 0) {
1172                    WARN_ON(*level < 0);
1173                    WARN_ON(*level >= BTRFS_MAX_LEVEL);
1174                    cur = path->nodes[*level];
1175
1176                    if (btrfs_header_level(cur) != *level)
1177                            WARN_ON(1);
1178
1179                    if (path->slots[*level] >= btrfs_header_nritems(cur))
1180                            break;
(gdb) p cur
$1 = (struct extent_buffer *) 0x0
(gdb) p path->nodes
$2 = {0x0, 0x27ad82e0, 0x3893a930, 0x3dc24f0, 0x75efa0, 0x0, 0x0, 0x0}
(gdb) p *level
$3 = 0
(gdb)

Best regards,
Christian



