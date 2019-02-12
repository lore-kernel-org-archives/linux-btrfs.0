Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B2FC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:03:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7487921773
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfBLHD0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 02:03:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:60330 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726059AbfBLHDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 02:03:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E08B8B03F;
        Tue, 12 Feb 2019 07:03:23 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     =?UTF-8?q?Jakob=20Sch=C3=B6ttl?= <jschoett@gmail.com>
Subject: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded rw mount
Date:   Tue, 12 Feb 2019 15:03:19 +0800
Message-Id: <20190212070319.30619-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[PROBLEM]
The following script can easily create unnecessary SINGLE or DUP chunks:
  #!/bin/bash

  dev1="/dev/test/scratch1"
  dev2="/dev/test/scratch2"
  dev3="/dev/test/scratch3"
  mnt="/mnt/btrfs"

  umount $dev1 $dev2 $dev3 $mnt &> /dev/null

  mkfs.btrfs -f $dev1 $dev2 -d raid1 -m raid1

  mount $dev1 $mnt
  umount $dev1

  wipefs -fa $dev2

  mount $dev1 -o degraded $mnt
  btrfs replace start -Bf 2 $dev3 $mnt
  umount $dev1
  btrfs ins dump-tree -t chunk $dev1

With the following chunks in chunk tree:
  leaf 3016753152 items 11 free space 14900 generation 9 owner CHUNK_TREE
  leaf 3016753152 flags 0x1(WRITTEN) backref revision 1
  fs uuid 7c5fc730-5c16-4a2b-ad39-c26e85951426
  chunk uuid 1c64265b-253e-411e-b164-b935a45d474b
  	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
  	item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
  	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 15975 itemsize 112
  		length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
  		...
  	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863 itemsize 112
  		length 1073741824 owner 2 stripe_len 65536 type METADATA|RAID1
  	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 1104150528) itemoff 15751 itemsize 112
  		length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1
  	item 5 key (FIRST_CHUNK_TREE CHUNK_ITEM 2177892352) itemoff 15671 itemsize 80
  		length 268435456 owner 2 stripe_len 65536 type METADATA
  							       ^^^ SINGLE
  	item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 2446327808) itemoff 15591 itemsize 80
  		length 33554432 owner 2 stripe_len 65536 type SYSTEM
  							      ^^^ SINGLE
  	item 7 key (FIRST_CHUNK_TREE CHUNK_ITEM 2479882240) itemoff 15511 itemsize 80
  		length 536870912 owner 2 stripe_len 65536 type DATA
  							       ^^^ SINGLE
  	item 8 key (FIRST_CHUNK_TREE CHUNK_ITEM 3016753152) itemoff 15399 itemsize 112
  		length 33554432 owner 2 stripe_len 65536 type SYSTEM|DUP
  							      ^^^ DUP
  	item 9 key (FIRST_CHUNK_TREE CHUNK_ITEM 3050307584) itemoff 15287 itemsize 112
  		length 268435456 owner 2 stripe_len 65536 type METADATA|DUP
  							       ^^^ DUP
  	item 10 key (FIRST_CHUNK_TREE CHUNK_ITEM 3318743040) itemoff 15175 itemsize 112
  		length 536870912 owner 2 stripe_len 65536 type DATA|DUP
  							       ^^^ DUP

[CAUSE]
When degraded mounted, no matter whether we're mounting RW or RO,
missing devices are never considered RW, as we're acting as we only have
one rw device.

So any write to the degraded fs will cause btrfs to create new SINGLE or
DUP chunks to restore newly written data.

[FIX]
At mount time, btrfs has already done chunk level degradation check,
thus we can write to degraded chunks without problem.

So we only need to consider missing devices as writable, and calculate
our chunk allocation profile with missing devices too.

Then every thing should work as expected, without annoying SINGLE/DUP
chunks blocking later degraded mount.

With fix applied, the above replace will result the following chunk
layout instead:
leaf 22036480 items 5 free space 15626 generation 5 owner CHUNK_TREE
leaf 22036480 flags 0x1(WRITTEN) backref revision 1
fs uuid 7b825e77-e694-4474-9bfe-7bd7565fde0e
chunk uuid 2c2d9e94-a819-4479-8f16-ab529c0a4f62
	item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
	item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 15975 itemsize 112
		length 8388608 owner 2 stripe_len 65536 type SYSTEM|RAID1
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 15863 itemsize 112
		length 1073741824 owner 2 stripe_len 65536 type METADATA|RAID1
	item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 1104150528) itemoff 15751 itemsize 112
		length 1073741824 owner 2 stripe_len 65536 type DATA|RAID1

Reported-by: Jakob Schöttl <jschoett@gmail.com>
Cc: Jakob Schöttl <jschoett@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 13 +++++++++++++
 fs/btrfs/volumes.c     |  7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0dde0cbc1622..bf691ecb6c70 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4081,6 +4081,13 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_fs_info *fs_info, u64 flags)
 	u64 raid_type;
 	u64 allowed = 0;
 
+	/*
+	 * For degraded mount, still count missing devices as rw devices
+	 * to avoid alloc SINGLE/DUP chunks
+	 */
+	if (btrfs_test_opt(fs_info, DEGRADED))
+		num_devices += fs_info->fs_devices->missing_devices;
+
 	/*
 	 * see if restripe for this chunk_type is in progress, if so
 	 * try to reduce to the target profile
@@ -9626,6 +9633,12 @@ static u64 update_block_group_flags(struct btrfs_fs_info *fs_info, u64 flags)
 		return extended_to_chunk(stripped);
 
 	num_devices = fs_info->fs_devices->rw_devices;
+	/*
+	 * For degraded mount, still count missing devices as rw devices
+	 * to avoid alloc SINGLE/DUP chunks
+	 */
+	if (btrfs_test_opt(fs_info, DEGRADED))
+		num_devices += fs_info->fs_devices->missing_devices;
 
 	stripped = BTRFS_BLOCK_GROUP_RAID0 |
 		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 03f223aa7194..8e8b3581877f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6660,6 +6660,13 @@ static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
 	set_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state);
 	fs_devices->missing_devices++;
 
+	/*
+	 * For degraded mount, still count missing devices as writable to
+	 * avoid unnecessary SINGLE/DUP chunks
+	 */
+	if (btrfs_test_opt(fs_devices->fs_info, DEGRADED))
+		set_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
+
 	return device;
 }
 
-- 
2.20.1

