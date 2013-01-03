Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:33854 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3ACMud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2013 07:50:33 -0500
Received: from [192.168.2.123] (unknown [149.241.124.191])
	by smtp.webfaction.com (Postfix) with ESMTP id 50C5A66EE01E
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2013 06:26:40 -0600 (CST)
From: Richard Cooper <richard@richardcooper.net>
Content-Type: text/plain; charset=us-ascii
Subject: btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' failed.
Date: Thu, 3 Jan 2013 12:26:38 +0000
Message-Id: <0400867D-6E5E-4D0F-8A06-B5AD3E58DEE6@richardcooper.net>
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1085)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I'm trying to repair a broken fs using btrfsck and am hitting a failed assertion. I'd appreciate any suggestions for what to do next. Is there any thing I can do to help fix this bug? Any other information from my FS which would help? If the FS could be salvaged that would be a bonus, but I'm more interested in providing a useful bug report before wiping the disk.

My versions are:
- OS - CentOS 6.3
- Kernel - 3.7.1-2 from http://elrepo.org/tiki/kernel-ml 
- btrfs-progs - v0.20-rc1-37-g91d9eec. Built today from git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

The failure is:

# ./btrfsck --repair /dev/md4 
enabling repair mode
checking extents
leaf parent key incorrect 183603200
bad block 183603200
leaf parent key incorrect 183640064
bad block 183640064
warning, start mismatch 152387469312 762175488
block 152387469312 rec extent_item_refs 1, passed 1
warning, start mismatch 449606139904 427217858560
block 427217858560 rec extent_item_refs 1, passed 1
ref mismatch on [32215040 4096] extent item 30, found 31
btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' failed.
Aborted

If i run btrfsck in non-repair mode I get:

# ./btrfsck /dev/md4 
checking extents
leaf parent key incorrect 183603200
bad block 183603200
leaf parent key incorrect 183640064
bad block 183640064
warning, start mismatch 152387469312 762175488
checksum verify failed on 34390753280 wanted 26D779EB found 40
checksum verify failed on 34390753280 wanted 26D779EB found 40
block 152387469312 rec extent_item_refs 1, passed 1
warning, start mismatch 449606139904 427217858560
block 427217858560 rec extent_item_refs 1, passed 1
ref mismatch on [32215040 4096] extent item 30, found 31
Backref 32215040 parent 427255582720 root 427255582720 not found in extent tree
backpointer mismatch on [32215040 4096]

... [snipped several thousand lines similar to the previous three] ...

ref mismatch on [477808889856 4096] extent item 11, found 12
Backref 477808889856 parent 427202011136 root 427202011136 not found in extent tree
backpointer mismatch on [477808889856 4096]
Errors found in extent allocation tree
checking fs roots
root 256 inode 140337 errors 400
root 256 inode 169441 errors 400
root 256 inode 169442 errors 400
root 256 inode 1843202 errors 400
warning line 1789
found 651533594626 bytes used err is 1
total csum bytes: 624739028
total tree bytes: 11639873536
total fs tree bytes: 10394214400
btree space waste bytes: 2925577458
file data blocks allocated: 741854191616
 referenced 741832200192
Btrfs v0.20-rc1-37-g91d9eec]

