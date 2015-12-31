Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 144.45.188.64.static.ipv4.dnsptr.net ([64.188.45.144]:33661
	"EHLO mail.mended-drum.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbbLaX7n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 18:59:43 -0500
Received: from http by mail.mended-drum.net with local (Exim 4.86)
	(envelope-from <http@mended-drum.net>)
	id 1aEmly-0003E2-BJ
	for linux-btrfs@vger.kernel.org; Thu, 31 Dec 2015 23:36:46 +0000
To: linux-btrfs@vger.kernel.org
Subject: Unrecoverable fs corruption?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 01 Jan 2016 00:36:46 +0100
From: Alexander Duscheleit <alexander.duscheleit@gmail.com>
Message-ID: <4bfedb90694d34a9a311d532715560d1@mail.mended-drum.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had a power fail today at my home server and after the reboot the 
btrfs RAID1 won't come back up.

When trying to mount one of the 2 disks of the array I get the following 
error:
[ 4126.316396] BTRFS info (device sdb2): disk space caching is enabled
[ 4126.316402] BTRFS: has skinny extents
[ 4126.337324] BTRFS: failed to read chunk tree on sdb2
[ 4126.353027] BTRFS: open_ctree failed

a btrfs check segfaults after a few seconds with the following message:
(0:29)[root@hera]~  # ❯❯❯ btrfs check /dev/sdb2
warning devid 1 not found already
bad key ordering 68 69
Checking filesystem on /dev/sdb2
UUID: d55fa866-3baa-4e73-bf3e-5fda29672df3
checking extents
bad key ordering 68 69
bad block 6513625202688
Errors found in extent allocation tree or chunk allocation
[1]    11164 segmentation fault  btrfs check /dev/sdb2

I have 2 btrfs-images (one with -w, one without) but they are 6.1G and 
1.1G repectively, I don't know
if I can upload them at all and also not where to store such large 
files.

I did try a btrfs check --repair on one of the disks which gave the 
following result:
enabling repair mode
warning devid 1 not found already
bad key ordering 68 69
repair mode will force to clear out log tree, Are you sure? [y/N]: y
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.
btrfs[0x44161e]
btrfs(btrfs_reserve_extent+0xa7b)[0x4463db]
btrfs(btrfs_alloc_free_block+0x5f)[0x44649f]
btrfs(__btrfs_cow_block+0xc4)[0x437d64]
btrfs(btrfs_cow_block+0x35)[0x438365]
btrfs[0x43d3d6]
btrfs(btrfs_commit_transaction+0x95)[0x43f125]
btrfs(cmd_check+0x5ec)[0x429cdc]
btrfs(main+0x82)[0x40ef32]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f881f983610]
btrfs(_start+0x29)[0x40f039]


That's all I tried so far.
btrfs restore -viD seems to find most of the files accessible but since 
I don't have a spare hdd of
sufficient size I would have to break the array and reformat and use one 
of the disk as restore
target. I'm not prepared to do this before I know there is no other way 
to fix the drives since I'm
essentially destroying one more chance at saving the data.

Is there anything I can do to get the fs out of this mess?
-- 
Alexander Duscheleit
