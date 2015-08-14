Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbbHNKdq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:46 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 13/23] Btrfs: add btrfs_read_dev_one_super() to read one specific SB
Date: Fri, 14 Aug 2015 18:32:58 +0800
Message-Id: <1439548388-29686-14-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This uses a chunk of code from btrfs_read_dev_super() and creates
a function called btrfs_read_dev_one_super() so that next patch
can use it for scratch superblock.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 54 ++++++++++++++++++++++++++++++++++--------------------
 fs/btrfs/disk-io.h |  2 ++
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index faf5b8d..2f2379d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3183,6 +3183,37 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	put_bh(bh);
 }
 
+int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
+			struct buffer_head **bh)
+{
+	struct buffer_head *bufhead;
+	struct btrfs_super_block *super;
+	u64 bytenr;
+
+	bytenr = btrfs_sb_offset(copy_num);
+	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
+		return -EINVAL;
+
+	bufhead = __bread(bdev, bytenr / 4096, BTRFS_SUPER_INFO_SIZE);
+	/*
+	 * If we fail to read from the underlaying drivers, as of now
+	 * the best option we have is to mark it EIO.
+	 */
+	if (!bufhead)
+		return -EIO;
+
+	super = (struct btrfs_super_block *)bufhead->b_data;
+	if (btrfs_super_bytenr(super) != bytenr ||
+		    btrfs_super_magic(super) != BTRFS_MAGIC) {
+		brelse(bufhead);
+		return -EINVAL;
+	}
+
+	*bh = bufhead;
+	return 0;
+}
+
+
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 {
 	struct buffer_head *bh;
@@ -3190,7 +3221,6 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	struct btrfs_super_block *super;
 	int i;
 	u64 transid = 0;
-	u64 bytenr;
 	int ret = -EINVAL;
 
 	/* we would like to check all the supers, but that would make
@@ -3199,28 +3229,12 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	for (i = 0; i < 1; i++) {
-		bytenr = btrfs_sb_offset(i);
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-					i_size_read(bdev->bd_inode))
-			break;
-		bh = __bread(bdev, bytenr / 4096,
-					BTRFS_SUPER_INFO_SIZE);
-		/*
-		 * If we fail to read from the underlaying drivers, as of now
-		 * the best option we have is to mark it EIO.
-		 */
-		if (!bh) {
-			ret = -EIO;
+
+		ret = btrfs_read_dev_one_super(bdev, i, &bh);
+		if (ret)
 			continue;
-		}
 
 		super = (struct btrfs_super_block *)bh->b_data;
-		if (btrfs_super_bytenr(super) != bytenr ||
-		    btrfs_super_magic(super) != BTRFS_MAGIC) {
-			brelse(bh);
-			ret = -EINVAL;
-			continue;
-		}
 
 		if (!latest || btrfs_super_generation(super) > transid) {
 			brelse(latest);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index d4cbfee..8dc9ff1 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -60,6 +60,8 @@ void close_ctree(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
+int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
+			struct buffer_head **bh);
 int btrfs_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 					    u64 bytenr);
-- 
2.4.1

