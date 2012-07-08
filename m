Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51274 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2GHQIa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jul 2012 12:08:30 -0400
Message-ID: <4FF9B07C.8090209@cv-sv.de>
Date: Sun, 08 Jul 2012 18:08:28 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfsck crashes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I have a corrupted filesystem. This filesystem crashes btrfsck.

A gdb anaylsis showed me:
(gdb) bt
#0  0x0000000000402379 in btrfs_header_nritems (eb=0x0) at ctree.h:1426
#1  0x0000000000408c14 in run_next_block (root=0x73fb40, bits=0x740d50, bits_nr=1024, last=0x7fffffffd948, pending=0x7fffffffda40,
     seen=0x7fffffffda50, reada=0x7fffffffda30, nodes=0x7fffffffda20, extent_cache=0x7fffffffda60) at btrfsck.c:2512
#2  0x00000000004099e2 in check_extents (root=0x73fb40) at btrfsck.c:2792
#3  0x0000000000409bec in main (ac=1, av=0x7fffffffdbe8) at btrfsck.c:2853

What I have seen: buf is "0", after read_tree_block.

btrfsck.c:2511 buf = read_tree_block(root, bytenr, size, 0);
           2512 nritems = btrfs_header_nritems(buf);

So ctree.h crashes here with btrfs_header_nritems(buf)
...
static inline u##bits btrfs_##name(struct extent_buffer *eb)            \
{                                                                       \
         struct btrfs_header *h = (struct btrfs_header *)eb->data;       \
         return le##bits##_to_cpu(h->member);                            \
}                                                                       \
...

I expect an error "eb == 0" is not covered by ctree.h.
May be another fix is required. E.g. harden btrfsck against "0".

The file system crashes the kernel on some access. I did not follow up this,
cause the file system is corrupt.( Using  openSUSE Tumbleweed 3.4.4-31-desktop)
May be the kernel code requires also checks for this?

Please contact me, if I should do some further tests with this file system
or use some tools for a fix test. (developer knowledge given)

Another minor issue: btrfsck uses much memory. But this might be normal.
( > 800MB)

Best regards,
Christian



PS: Just if anyone is interested:
- History + tried: openSUSE btrfsck showed the messages below in the first step.
- /sbin/btrfsck /dev/md3 --repair removed some messages, except checksum.
- File system is mounted with:
   /backup              btrfs      defaults,compress=zlib,noatime             1 2
- filesystem is used to back up some unix system with heavy usage of:
   rsync -aH .... --link-dest=...
   So each file should have regular multiple hard links.

===
Is there anybody interested in fixing this file system with me,
to check btrfsck speedy:/home/cv # /sbin/btrfsck /dev/md3
checking extents
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
Csum didn't match
owner ref check failed [2327654400 4096]
ref mismatch on [101138354176 98304] extent item 1, found 0
Incorrect local backref count on 101138354176 root 5 owner 1867898 offset 0 found 0 wanted 1 back 0x1f076d0
backpointer mismatch on [101138354176 98304]
owner ref check failed [101138354176 98304]
ref mismatch on [101138452480 106496] extent item 1, found 0
Incorrect local backref count on 101138452480 root 5 owner 1867899 offset 0 found 0 wanted 1 back 0x6aa85d0
backpointer mismatch on [101138452480 106496]
owner ref check failed [101138452480 106496]
ref mismatch on [101138558976 8192] extent item 1, found 0
Incorrect local backref count on 101138558976 root 5 owner 1867901 offset 0 found 0 wanted 1 back 0x6aa8610
backpointer mismatch on [101138558976 8192]
owner ref check failed [101138558976 8192]
ref mismatch on [101138567168 16384] extent item 1, found 0
Incorrect local backref count on 101138567168 root 5 owner 1867902 offset 0 found 0 wanted 1 back 0x1f8fa80
backpointer mismatch on [101138567168 16384]
owner ref check failed [101138567168 16384]
ref mismatch on [101138583552 16384] extent item 1, found 0
Incorrect local backref count on 101138583552 root 5 owner 1867903 offset 0 found 0 wanted 1 back 0x1f8fac0
backpointer mismatch on [101138583552 16384]
owner ref check failed [101138583552 16384]
Errors found in extent allocation tree
checking fs roots
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
checksum verify failed on 2327654400 wanted 73CDE79C found 72
Csum didn't match
Speicherzugriffsfehler
