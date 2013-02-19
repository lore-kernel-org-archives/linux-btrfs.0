Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:40534 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3BSO5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 09:57:32 -0500
Received: from [192.168.2.123] (unknown [149.241.149.45])
	by smtp.webfaction.com (Postfix) with ESMTP id 93E3D2099436
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2013 14:57:31 +0000 (UTC)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1085)
Subject: Re: btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' failed.
From: Richard Cooper <richard@richardcooper.net>
In-Reply-To: <0400867D-6E5E-4D0F-8A06-B5AD3E58DEE6@richardcooper.net>
Date: Tue, 19 Feb 2013 14:57:29 +0000
Message-Id: <6CA8B0F1-D6CD-4DD7-994D-64BAB3B41AB1@richardcooper.net>
References: <0400867D-6E5E-4D0F-8A06-B5AD3E58DEE6@richardcooper.net>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 3 Jan 2013, at 12:26, Richard Cooper wrote:
> Hi All,
> 
> I'm trying to repair a broken fs using btrfsck and am hitting a failed assertion. I'd appreciate any suggestions for what to do next. Is there any thing I can do to help fix this bug? Any other information from my FS which would help? If the FS could be salvaged that would be a bonus, but I'm more interested in providing a useful bug report before wiping the disk.

After this error I reformatted and started again. A few days ago I hit exactly the same error in btrfsck again. Is it useful for me to report the same errors again? Would it make more sense for me to submit them to https://bugzilla.kernel.org? Is that tracker appropriate for btrfs-progs related bugs?

My versions are:
- OS - CentOS 6.3
- Kernel -  3.7.8-1 from http://elrepo.org/tiki/kernel-ml 
- btrfs-progs - v0.20-rc1-56-g6cd836d. Built from git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

# ./btrfs-progs/btrfs fi show /dev/md4
Label: none  uuid: fecad98e-63e8-47b7-9bc1-5d9351f15e76
	Total devices 1 FS bytes used 702.22GB
	devid    1 size 16.36TB used 723.04GB path /dev/md4

Btrfs v0.20-rc1-56-g6cd836d

# ./btrfsck --repair /dev/md4 
enabling repair mode
checking extents
incorrect offsets 2539 133611
bad block 694804008960
bad key ordering 26 27
bad block 710147256320
bad key ordering 29 30
bad block 710793940992
ref mismatch on [506097786880 8192] extent item 1, found 0
btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' failed.
Aborted
# echo $?
134

If i run btrfsck in non-repair mode I get:

# ./btrfsck /dev/md4 
checking extents
incorrect offsets 2539 133611
bad block 694804008960
bad key ordering 26 27
bad block 710147256320
bad key ordering 29 30
bad block 710793940992
ref mismatch on [506097786880 8192] extent item 1, found 0
Incorrect local backref count on 506097786880 root 257 owner 6201018 offset 0 found 0 wanted 1 back 0x72966380
backpointer mismatch on [506097786880 8192]
owner ref check failed [506097786880 8192]
ref mismatch on [506097795072 8192] extent item 1, found 0
Incorrect local backref count on 506097795072 root 257 owner 6201019 offset 0 found 0 wanted 1 back 0x72966460
backpointer mismatch on [506097795072 8192]
owner ref check failed [506097795072 8192]
ref mismatch on [506097803264 8192] extent item 1, found 0
Incorrect local backref count on 506097803264 root 257 owner 6201021 offset 0 found 0 wanted 1 back 0x72966540
backpointer mismatch on [506097803264 8192]
owner ref check failed [506097803264 8192]
ref mismatch on [506097811456 8192] extent item 1, found 0
Incorrect local backref count on 506097811456 root 257 owner 6201022 offset 0 found 0 wanted 1 back 0x72966620
backpointer mismatch on [506097811456 8192]
owner ref check failed [506097811456 8192]
ref mismatch on [686802194432 20480] extent item 1, found 0
Incorrect local backref count on 686802194432 root 257 owner 8037960 offset 0 found 0 wanted 1 back 0x82c1e2a0
backpointer mismatch on [686802194432 20480]
owner ref check failed [686802194432 20480]
ref mismatch on [686802214912 20480] extent item 1, found 0
Incorrect local backref count on 686802214912 root 257 owner 8037961 offset 0 found 0 wanted 1 back 0x82c1e380
backpointer mismatch on [686802214912 20480]
owner ref check failed [686802214912 20480]
ref mismatch on [686802235392 20480] extent item 1, found 0
Incorrect local backref count on 686802235392 root 257 owner 8037962 offset 0 found 0 wanted 1 back 0x82c1e460
backpointer mismatch on [686802235392 20480]
owner ref check failed [686802235392 20480]
ref mismatch on [686802255872 20480] extent item 1, found 0
Incorrect local backref count on 686802255872 root 257 owner 8037963 offset 0 found 0 wanted 1 back 0x82c1e540
backpointer mismatch on [686802255872 20480]
owner ref check failed [686802255872 20480]
ref mismatch on [686802276352 20480] extent item 1, found 0
Incorrect local backref count on 686802276352 root 257 owner 8037964 offset 0 found 0 wanted 1 back 0x82c1e620
backpointer mismatch on [686802276352 20480]
owner ref check failed [686802276352 20480]
ref mismatch on [686802296832 20480] extent item 1, found 0
Incorrect local backref count on 686802296832 root 257 owner 8037965 offset 0 found 0 wanted 1 back 0x82c1e700
backpointer mismatch on [686802296832 20480]
owner ref check failed [686802296832 20480]
ref mismatch on [686802317312 20480] extent item 1, found 0
Incorrect local backref count on 686802317312 root 257 owner 8037966 offset 0 found 0 wanted 1 back 0x82c1e7e0
backpointer mismatch on [686802317312 20480]
owner ref check failed [686802317312 20480]
owner ref check failed [694804008960 4096]
owner ref check failed [710147256320 4096]
owner ref check failed [710793940992 4096]
Errors found in extent allocation tree
checking fs roots
root 257 inode 6292865 errors 400
root 257 inode 6292867 errors 400
found 754001297408 bytes used err is 1
total csum bytes: 718173168
total tree bytes: 18407149568
total fs tree bytes: 16537788416
btree space waste bytes: 4527688532
file data blocks allocated: 735593959424
 referenced 735590412288
Btrfs v0.20-rc1-56-g6cd836d


