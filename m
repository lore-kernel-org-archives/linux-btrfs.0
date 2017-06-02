Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751242AbdFBQ7t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA4F4ABBD
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:47 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 7/8] btrfs: opencode trivial compressed_bio_alloc, simplify error handling
Date: Fri,  2 Jun 2017 18:58:47 +0200
Message-Id: <c1045c6859c18ce20d4f55e162399b708f9bfcf4.1496422340.git.dsterba@suse.com>
In-Reply-To: <cover.1496422340.git.dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

compressed_bio_alloc is now a trivial wrapper around btrfs_bio_alloc, no
point keeping it. The error handling can be simplified, as we know
btrfs_bio_alloc will never fail.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 7ad0a1c4be68..2df080c4ece0 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -53,12 +53,6 @@ static inline int compressed_bio_size(struct btrfs_fs_info *fs_info,
 		(DIV_ROUND_UP(disk_size, fs_info->sectorsize)) * csum_size;
 }
 
-static struct bio *compressed_bio_alloc(struct block_device *bdev,
-					u64 first_byte, gfp_t gfp_flags)
-{
-	return btrfs_bio_alloc(bdev, first_byte >> 9);
-}
-
 static int check_compressed_csum(struct btrfs_inode *inode,
 				 struct compressed_bio *cb,
 				 u64 disk_start)
@@ -311,11 +305,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 	bdev = fs_info->fs_devices->latest_bdev;
 
-	bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
-	if (!bio) {
-		kfree(cb);
-		return -ENOMEM;
-	}
+	bio = btrfs_bio_alloc(bdev, first_byte >> 9);
 	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
@@ -362,8 +352,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 			bio_put(bio);
 
-			bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
-			BUG_ON(!bio);
+			bio = btrfs_bio_alloc(bdev, first_byte >> 9);
 			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			bio->bi_private = cb;
 			bio->bi_end_io = end_compressed_bio_write;
@@ -606,9 +595,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	/* include any pages we added in add_ra-bio_pages */
 	cb->len = bio->bi_iter.bi_size;
 
-	comp_bio = compressed_bio_alloc(bdev, cur_disk_byte, GFP_NOFS);
-	if (!comp_bio)
-		goto fail2;
+	comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte >> 9);
 	bio_set_op_attrs (comp_bio, REQ_OP_READ, 0);
 	comp_bio->bi_private = cb;
 	comp_bio->bi_end_io = end_compressed_bio_read;
@@ -659,9 +646,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 			bio_put(comp_bio);
 
-			comp_bio = compressed_bio_alloc(bdev, cur_disk_byte,
-							GFP_NOFS);
-			BUG_ON(!comp_bio);
+			comp_bio = btrfs_bio_alloc(bdev, cur_disk_byte >> 9);
 			bio_set_op_attrs(comp_bio, REQ_OP_READ, 0);
 			comp_bio->bi_private = cb;
 			comp_bio->bi_end_io = end_compressed_bio_read;
-- 
2.12.0

