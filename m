Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58727 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439AbcE3PUx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 11:20:53 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] Btrfs: fix race between device replace and read repair
Date: Mon, 30 May 2016 16:19:36 +0100
Message-Id: <1464621576-20234-2-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1464621576-20234-1-git-send-email-fdmanana@kernel.org>
References: <1464621576-20234-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

While we are finishing a device replace operation we can have a concurrent
task trying to do a read repair operation, in which case it will call
btrfs_map_block() to get a struct btrfs_bio which can have a stripe that
points to the source device of the device replace operation. This allows
for the read repair task to dereference the stripe's device pointer after
the device replace operation has freed the source device, resulting in
an invalid memory access. This is similar to the problem solved by my
previous patch in the same series and named "Btrfs: fix race between
device replace and discard".

So fix this by surrounding the call to btrfs_map_block() and the code
that uses the returned struct btrfs_bio with calls to
btrfs_bio_counter_inc_blocked() and btrfs_bio_counter_dec(), giving the
proper serialization with the finishing phase of the device replace
operation.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3cd5782..6e953de 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2025,9 +2025,16 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 	bio->bi_iter.bi_size = 0;
 	map_length = length;
 
+	/*
+	 * Avoid races with device replace and make sure our bbio has devices
+	 * associated to its stripes that don't go away while we are doing the
+	 * read repair operation.
+	 */
+	btrfs_bio_counter_inc_blocked(fs_info);
 	ret = btrfs_map_block(fs_info, WRITE, logical,
 			      &map_length, &bbio, mirror_num);
 	if (ret) {
+		btrfs_bio_counter_dec(fs_info);
 		bio_put(bio);
 		return -EIO;
 	}
@@ -2037,6 +2044,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 	dev = bbio->stripes[mirror_num-1].dev;
 	btrfs_put_bbio(bbio);
 	if (!dev || !dev->bdev || !dev->writeable) {
+		btrfs_bio_counter_dec(fs_info);
 		bio_put(bio);
 		return -EIO;
 	}
@@ -2045,6 +2053,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 
 	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio)) {
 		/* try to remap that extent elsewhere? */
+		btrfs_bio_counter_dec(fs_info);
 		bio_put(bio);
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
 		return -EIO;
@@ -2054,6 +2063,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
 				  btrfs_ino(inode), start,
 				  rcu_str_deref(dev->name), sector);
+	btrfs_bio_counter_dec(fs_info);
 	bio_put(bio);
 	return 0;
 }
-- 
2.7.0.rc3

