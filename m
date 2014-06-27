Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62006 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752941AbaF0Dw5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 23:52:57 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5R3qn3s026236
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 11:52:49 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC] btrfs: Use backup superblocks if and only if the first superblock is valid but corrupted.
Date: Fri, 27 Jun 2014 11:53:54 +0800
Message-ID: <1403841234-10393-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current btrfs will only use the first superblock, making the backup
superblocks only useful for 'btrfs rescue super' command.

The old problem is that if we use backup superblocks when the first
superblock is not valid, we will be able to mount a none btrfs
filesystem, which used to contains btrfs but other fs is made on it.

The old problem can be solved related easily by checking the first
superblock in a special way:
1) If the magic number in the first superblock does not match:
   This filesystem is not btrfs anymore, just exit.
   If end-user consider it's really btrfs, then old 'btrfs rescue super'
   method is still available.

2) If the magic number in the first superblock matches but checksum does
   not match:
   This filesystem is btrfs but first superblock is corrupted, use
   backup roots. Just continue searching remaining superblocks.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dbfb2a3..1f4a264 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2394,16 +2394,6 @@ int open_ctree(struct super_block *sb,
 	}
 
 	/*
-	 * We want to check superblock checksum, the type is stored inside.
-	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
-	 */
-	if (btrfs_check_super_csum(bh->b_data)) {
-		printk(KERN_ERR "BTRFS: superblock checksum mismatch\n");
-		err = -EINVAL;
-		goto fail_alloc;
-	}
-
-	/*
 	 * super_copy is zeroed at allocation time and we never touch the
 	 * following bytes up to INFO_SIZE, the checksum is calculated from
 	 * the whole block of INFO_SIZE
@@ -3067,12 +3057,14 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	u64 transid = 0;
 	u64 bytenr;
 
-	/* we would like to check all the supers, but that would make
-	 * a btrfs mount succeed after a mkfs from a different FS.
-	 * So, we need to add a special mount option to scan for
-	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
+	/*
+	 * We check the first superblock first.
+	 * 1) If first superblock's magic is not btrfs magic
+	 *    This means this is not a btrfs fs, just exit.
+	 * 2) If first superblock's magic is good but csum mismatch
+	 *    This means first superblock is corrupted, use backup if possible
 	 */
-	for (i = 0; i < 1; i++) {
+	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
 					i_size_read(bdev->bd_inode))
@@ -3083,6 +3075,22 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 			continue;
 
 		super = (struct btrfs_super_block *)bh->b_data;
+		/*
+		 * First superblock needs special check routine,
+		 * to avoid btrfs mount succeeding after a mkfs from a
+		 * different FS.
+		 */
+		if (i == 0) {
+			if (btrfs_super_magic(super) != BTRFS_MAGIC) {
+				brelse(bh);
+				break;
+			}
+		}
+		if (btrfs_check_super_csum(bh->b_data)) {
+			pr_warn("BTRFS: superblock %d checksum mismatch\n", i);
+			brelse(bh);
+			continue;
+		}
 		if (btrfs_super_bytenr(super) != bytenr ||
 		    btrfs_super_magic(super) != BTRFS_MAGIC) {
 			brelse(bh);
@@ -3097,6 +3105,8 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 			brelse(bh);
 		}
 	}
+	if (!latest)
+		pr_err("BTRFS: No valid btrfs superblock found or all superblocks are corrupted\n");
 	return latest;
 }
 
-- 
2.0.1

