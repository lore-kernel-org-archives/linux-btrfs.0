Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55091 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751385AbdGRPlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:41:45 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C1D5AABA
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 15:41:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: split write_dev_supers to two functions
Date: Tue, 18 Jul 2017 17:40:30 +0200
Message-Id: <a6a59d0ba71918482b482191294b1d9c2cab4e6e.1500391979.git.dsterba@suse.com>
In-Reply-To: <cover.1500391979.git.dsterba@suse.com>
References: <cover.1500391979.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two independent parts, one that writes the superblocks and
another that waits for completion. No functional changes, but cleanups,
reformatting and comment updates.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 129 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 73 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 075beedb4352..df4772918ebb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3378,19 +3378,17 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 }
 
 /*
- * this should be called twice, once with wait == 0 and
- * once with wait == 1.  When wait == 0 is done, all the buffer heads
- * we write are pinned.
+ * Write superblock @sb to the @device. Do not wait for completion, all the
+ * buffer heads we write are pinned.
  *
- * They are released when wait == 1 is done.
- * max_mirrors must be the same for both runs, and it indicates how
- * many supers on this one device should be written.
+ * Write @max_mirrors copies of the superblock, where 0 means default that fit
+ * the expected device size at commit time. Note that max_mirrors must be
+ * same for write and wait phases.
  *
- * max_mirrors == 0 means to write them all.
+ * Return number of errors when buffer head is not found or submission fails.
  */
 static int write_dev_supers(struct btrfs_device *device,
-			    struct btrfs_super_block *sb,
-			    int wait, int max_mirrors)
+			    struct btrfs_super_block *sb, int max_mirrors)
 {
 	struct buffer_head *bh;
 	int i;
@@ -3408,57 +3406,33 @@ static int write_dev_supers(struct btrfs_device *device,
 		    device->commit_total_bytes)
 			break;
 
-		if (wait) {
-			bh = __find_get_block(device->bdev, bytenr / 4096,
-					      BTRFS_SUPER_INFO_SIZE);
-			if (!bh) {
-				errors++;
-				continue;
-			}
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				errors++;
+		btrfs_set_super_bytenr(sb, bytenr);
 
-			/* drop our reference */
-			brelse(bh);
+		crc = ~(u32)0;
+		crc = btrfs_csum_data((const char *)sb + BTRFS_CSUM_SIZE, crc,
+				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+		btrfs_csum_final(crc, sb->csum);
 
-			/* drop the reference from the wait == 0 run */
-			brelse(bh);
+		/* One reference for us, and we leave it for the caller */
+		bh = __getblk(device->bdev, bytenr / 4096,
+			      BTRFS_SUPER_INFO_SIZE);
+		if (!bh) {
+			btrfs_err(device->fs_info,
+			    "couldn't get super buffer head for bytenr %llu",
+			    bytenr);
+			errors++;
 			continue;
-		} else {
-			btrfs_set_super_bytenr(sb, bytenr);
-
-			crc = ~(u32)0;
-			crc = btrfs_csum_data((const char *)sb +
-					      BTRFS_CSUM_SIZE, crc,
-					      BTRFS_SUPER_INFO_SIZE -
-					      BTRFS_CSUM_SIZE);
-			btrfs_csum_final(crc, sb->csum);
-
-			/*
-			 * one reference for us, and we leave it for the
-			 * caller
-			 */
-			bh = __getblk(device->bdev, bytenr / 4096,
-				      BTRFS_SUPER_INFO_SIZE);
-			if (!bh) {
-				btrfs_err(device->fs_info,
-				    "couldn't get super buffer head for bytenr %llu",
-				    bytenr);
-				errors++;
-				continue;
-			}
+		}
 
-			memcpy(bh->b_data, sb, BTRFS_SUPER_INFO_SIZE);
+		memcpy(bh->b_data, sb, BTRFS_SUPER_INFO_SIZE);
 
-			/* one reference for submit_bh */
-			get_bh(bh);
+		/* one reference for submit_bh */
+		get_bh(bh);
 
-			set_buffer_uptodate(bh);
-			lock_buffer(bh);
-			bh->b_end_io = btrfs_end_buffer_write_sync;
-			bh->b_private = device;
-		}
+		set_buffer_uptodate(bh);
+		lock_buffer(bh);
+		bh->b_end_io = btrfs_end_buffer_write_sync;
+		bh->b_private = device;
 
 		/*
 		 * we fua the first super.  The others we allow
@@ -3477,6 +3451,49 @@ static int write_dev_supers(struct btrfs_device *device,
 }
 
 /*
+ * Wait for write completion of superblocks done by write_dev_supers,
+ * @max_mirrors same for write and wait phases.
+ *
+ * Return number of errors when buffer head is not found or not marked up to
+ * date.
+ */
+static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
+{
+	struct buffer_head *bh;
+	int i;
+	int errors = 0;
+	u64 bytenr;
+
+	if (max_mirrors == 0)
+		max_mirrors = BTRFS_SUPER_MIRROR_MAX;
+
+	for (i = 0; i < max_mirrors; i++) {
+		bytenr = btrfs_sb_offset(i);
+		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
+		    device->commit_total_bytes)
+			break;
+
+		bh = __find_get_block(device->bdev, bytenr / 4096,
+				      BTRFS_SUPER_INFO_SIZE);
+		if (!bh) {
+			errors++;
+			continue;
+		}
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			errors++;
+
+		/* drop our reference */
+		brelse(bh);
+
+		/* drop the reference from the writing run */
+		brelse(bh);
+	}
+
+	return errors < i ? 0 : -1;
+}
+
+/*
  * endio for the write_dev_flush, this will wake anyone waiting
  * for the barrier when it is done
  */
@@ -3737,7 +3754,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
 
-		ret = write_dev_supers(dev, sb, 0, max_mirrors);
+		ret = write_dev_supers(dev, sb, max_mirrors);
 		if (ret)
 			total_errors++;
 	}
@@ -3760,7 +3777,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
-		ret = write_dev_supers(dev, sb, 1, max_mirrors);
+		ret = wait_dev_supers(dev, max_mirrors);
 		if (ret)
 			total_errors++;
 	}
-- 
2.13.0

