Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55095 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751406AbdGRPls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:41:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F11D7AABA
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 15:41:46 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: use named constant for bdev blocksize
Date: Tue, 18 Jul 2017 17:40:32 +0200
Message-Id: <7adbfa6d79e035b9953109ff950bd508967c6d4f.1500391979.git.dsterba@suse.com>
In-Reply-To: <cover.1500391979.git.dsterba@suse.com>
References: <cover.1500391979.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Superblock is read and written using buffer heads, we need to set the
bdev blocksize. The magic constant has been hardcoded in several places,
so replace it with a named constant.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/check-integrity.c |  6 +++---
 fs/btrfs/disk-io.c         | 11 ++++++-----
 fs/btrfs/disk-io.h         |  8 ++++++++
 fs/btrfs/volumes.c         |  6 +++---
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index e3b1d08dd03c..060893141fe9 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -795,12 +795,12 @@ static int btrfsic_process_superblock_dev_mirror(
 	dev_bytenr = btrfs_sb_offset(superblock_mirror_num);
 	if (dev_bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 		return -1;
-	bh = __bread(superblock_bdev, dev_bytenr / 4096,
+	bh = __bread(superblock_bdev, dev_bytenr / BTRFS_BDEV_BLOCKSIZE,
 		     BTRFS_SUPER_INFO_SIZE);
 	if (NULL == bh)
 		return -1;
 	super_tmp = (struct btrfs_super_block *)
-	    (bh->b_data + (dev_bytenr & 4095));
+	    (bh->b_data + (dev_bytenr & (BTRFS_BDEV_BLOCKSIZE - 1)));
 
 	if (btrfs_super_bytenr(super_tmp) != dev_bytenr ||
 	    btrfs_super_magic(super_tmp) != BTRFS_MAGIC ||
@@ -2758,7 +2758,7 @@ int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
 	    (op == REQ_OP_WRITE) && bh->b_size > 0) {
 		u64 dev_bytenr;
 
-		dev_bytenr = 4096 * bh->b_blocknr;
+		dev_bytenr = BTRFS_BDEV_BLOCKSIZE * bh->b_blocknr;
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			pr_info("submit_bh(op=0x%x,0x%x, blocknr=%llu (bytenr %llu), size=%zu, data=%p, bdev=%p)\n",
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index df4772918ebb..aa94b6578c36 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2694,8 +2694,8 @@ int open_ctree(struct super_block *sb,
 	btrfs_init_balance(fs_info);
 	btrfs_init_async_reclaim_work(&fs_info->async_reclaim_work);
 
-	sb->s_blocksize = 4096;
-	sb->s_blocksize_bits = blksize_bits(4096);
+	sb->s_blocksize = BTRFS_BDEV_BLOCKSIZE;
+	sb->s_blocksize_bits = blksize_bits(BTRFS_BDEV_BLOCKSIZE);
 
 	btrfs_init_btree_inode(fs_info);
 
@@ -3321,7 +3321,7 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
 		return -EINVAL;
 
-	bh = __bread(bdev, bytenr / 4096, BTRFS_SUPER_INFO_SIZE);
+	bh = __bread(bdev, bytenr / BTRFS_BDEV_BLOCKSIZE, BTRFS_SUPER_INFO_SIZE);
 	/*
 	 * If we fail to read from the underlying devices, as of now
 	 * the best option we have is to mark it EIO.
@@ -3414,7 +3414,7 @@ static int write_dev_supers(struct btrfs_device *device,
 		btrfs_csum_final(crc, sb->csum);
 
 		/* One reference for us, and we leave it for the caller */
-		bh = __getblk(device->bdev, bytenr / 4096,
+		bh = __getblk(device->bdev, bytenr / BTRFS_BDEV_BLOCKSIZE,
 			      BTRFS_SUPER_INFO_SIZE);
 		if (!bh) {
 			btrfs_err(device->fs_info,
@@ -3473,7 +3473,8 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 		    device->commit_total_bytes)
 			break;
 
-		bh = __find_get_block(device->bdev, bytenr / 4096,
+		bh = __find_get_block(device->bdev,
+				      bytenr / BTRFS_BDEV_BLOCKSIZE,
 				      BTRFS_SUPER_INFO_SIZE);
 		if (!bh) {
 			errors++;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 4654d129aa76..995d0aa0abe4 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -25,6 +25,14 @@
 #define BTRFS_SUPER_MIRROR_MAX	 3
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
+/*
+ * Fixed blocksize for all devices, applies to specific ways of reading
+ * metadata like superblock. Must meet the set_blocksize requirements.
+ *
+ * Do not change.
+ */
+#define BTRFS_BDEV_BLOCKSIZE	(4096)
+
 enum btrfs_wq_endio_type {
 	BTRFS_WQ_ENDIO_DATA = 0,
 	BTRFS_WQ_ENDIO_METADATA = 1,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c3eafc8367d5..327b05c14592 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -303,7 +303,7 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 
 	if (flush)
 		filemap_write_and_wait((*bdev)->bd_inode->i_mapping);
-	ret = set_blocksize(*bdev, 4096);
+	ret = set_blocksize(*bdev, BTRFS_BDEV_BLOCKSIZE);
 	if (ret) {
 		blkdev_put(*bdev, flags);
 		goto error;
@@ -2400,7 +2400,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->is_tgtdev_for_dev_replace = 0;
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
-	set_blocksize(device->bdev, 4096);
+	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
@@ -2605,7 +2605,7 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 	device->is_tgtdev_for_dev_replace = 1;
 	device->mode = FMODE_EXCL;
 	device->dev_stats_valid = 1;
-	set_blocksize(device->bdev, 4096);
+	set_blocksize(device->bdev, BTRFS_BDEV_BLOCKSIZE);
 	device->fs_devices = fs_info->fs_devices;
 	list_add(&device->dev_list, &fs_info->fs_devices->devices);
 	fs_info->fs_devices->num_devices++;
-- 
2.13.0

