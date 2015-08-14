Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37891 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbbHNKdb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:31 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 06/23] Btrfs: SB read failure should return EIO for __bread failure
Date: Fri, 14 Aug 2015 18:32:51 +0800
Message-Id: <1439548388-29686-7-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will return EIO when __bread() fails to read SB,
instead of EINVAL.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 18 +++++++++++++++---
 fs/btrfs/volumes.c |  8 ++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8571025..faf5b8d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2648,8 +2648,8 @@ int open_ctree(struct super_block *sb,
 	 * Read super block and check the signature bytes only
 	 */
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
-	if (!bh) {
-		err = -EINVAL;
+	if (IS_ERR(bh)) {
+		err = PTR_ERR(bh);
 		goto fail_alloc;
 	}
 
@@ -3191,6 +3191,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 	int i;
 	u64 transid = 0;
 	u64 bytenr;
+	int ret = -EINVAL;
 
 	/* we would like to check all the supers, but that would make
 	 * a btrfs mount succeed after a mkfs from a different FS.
@@ -3204,13 +3205,20 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 			break;
 		bh = __bread(bdev, bytenr / 4096,
 					BTRFS_SUPER_INFO_SIZE);
-		if (!bh)
+		/*
+		 * If we fail to read from the underlaying drivers, as of now
+		 * the best option we have is to mark it EIO.
+		 */
+		if (!bh) {
+			ret = -EIO;
 			continue;
+		}
 
 		super = (struct btrfs_super_block *)bh->b_data;
 		if (btrfs_super_bytenr(super) != bytenr ||
 		    btrfs_super_magic(super) != BTRFS_MAGIC) {
 			brelse(bh);
+			ret = -EINVAL;
 			continue;
 		}
 
@@ -3222,6 +3230,10 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
 			brelse(bh);
 		}
 	}
+
+	if (!latest)
+		return ERR_PTR(ret);
+
 	return latest;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8368393..a3fde18 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -211,8 +211,8 @@ btrfs_get_bdev_and_sb(const char *device_path, fmode_t flags, void *holder,
 	}
 	invalidate_bdev(*bdev);
 	*bh = btrfs_read_dev_super(*bdev);
-	if (!*bh) {
-		ret = -EINVAL;
+	if (IS_ERR(*bh)) {
+		ret = PTR_ERR(*bh);
 		blkdev_put(*bdev, flags);
 		goto error;
 	}
@@ -6842,8 +6842,8 @@ int btrfs_scratch_superblock(struct btrfs_device *device)
 	struct btrfs_super_block *disk_super;
 
 	bh = btrfs_read_dev_super(device->bdev);
-	if (!bh)
-		return -EINVAL;
+	if (IS_ERR(bh))
+		return PTR_ERR(bh);
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 
 	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
-- 
2.4.1

