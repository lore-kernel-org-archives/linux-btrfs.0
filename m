Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab3CFP4p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Mar 2013 10:56:45 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>,
        stable@kernel.org
Subject: [PATCH] btrfs: enhance superblock checks
Date: Wed,  6 Mar 2013 16:56:40 +0100
Message-Id: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The superblock checksum is not verified upon mount. <awkward silence>

Add that check and also reorder existing checks to a more logical
order.

Current mkfs.btrfs does not calculate the correct checksum of
super_block and thus a freshly created filesytem will fail to mount when
this patch is applied.

First transaction commit calculates correct superblock checksum and
saves it to disk.

Reproducer:
$ mfks.btrfs /dev/sda
$ mount /dev/sda /mnt
$ btrfs scrub start /mnt
$ btrfs scrub status /mnt
... super:2 ...

CC: stable@kernel.org
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c |   80 ++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 65 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d84651..d5c710c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -354,6 +354,42 @@ out:
 }
 
 /*
+ * Return 0 if the superblock checksum type matches the checksum value of that
+ * alghorithm. Pass the raw disk superblock data.
+ */
+static int btrfs_check_super_csum(char *raw_disk_sb)
+{
+	struct btrfs_super_block *disk_sb =
+		(struct btrfs_super_block *)raw_disk_sb;
+	u16 csum_type = btrfs_super_csum_type(disk_sb);
+
+	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		printk(KERN_ERR "btrfs: unsupported checksum algorithm %u\n",
+				csum_type);
+		return 1;
+	}
+
+	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
+		const int csum_size = btrfs_csum_sizes[csum_type];
+		u32 crc = ~(u32)0;
+		char result[csum_size];
+
+		/*
+		 * The super_block structure does not span the whole
+		 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space
+		 * is filled with zeros and is included in the checkum.
+		 */
+		crc = btrfs_csum_data(NULL, raw_disk_sb + BTRFS_CSUM_SIZE,
+				crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+		btrfs_csum_final(crc, result);
+
+		return !!memcmp(raw_disk_sb, result, csum_size);
+	}
+
+	return 1;
+}
+
+/*
  * helper to read a given tree block, doing retries as required when
  * the checksums don't match and we have alternate mirrors to try.
  */
@@ -2205,12 +2241,31 @@ int open_ctree(struct super_block *sb,
 		     fs_info, BTRFS_ROOT_TREE_OBJECTID);
 
 	invalidate_bdev(fs_devices->latest_bdev);
+
+	/*
+	 * Read super block and check the signature bytes only
+	 */
 	bh = btrfs_read_dev_super(fs_devices->latest_bdev);
 	if (!bh) {
 		err = -EINVAL;
 		goto fail_alloc;
 	}
 
+	/*
+	 * We want to check superblock checksum, the type is stored inside.
+	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
+	 */
+	if (btrfs_check_super_csum(bh->b_data)) {
+		printk(KERN_ERR "btrfs: superblock checksum mismatch\n");
+		err = -EINVAL;
+		goto fail_alloc;
+	}
+
+	/*
+	 * super_copy is zeroed at allocation time and we never touch the
+	 * following bytes up to INFO_SIZE, the checksum is calculated from
+	 * the whole block of INFO_SIZE
+	 */
 	memcpy(fs_info->super_copy, bh->b_data, sizeof(*fs_info->super_copy));
 	memcpy(fs_info->super_for_commit, fs_info->super_copy,
 	       sizeof(*fs_info->super_for_commit));
@@ -2218,6 +2273,13 @@ int open_ctree(struct super_block *sb,
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
 
+	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
+	if (ret) {
+		printk(KERN_ERR "btrfs: superblock contains fatal errors\n");
+		err = -EINVAL;
+		goto fail_alloc;
+	}
+
 	disk_super = fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
 		goto fail_alloc;
@@ -2226,13 +2288,6 @@ int open_ctree(struct super_block *sb,
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_ERROR)
 		set_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state);
 
-	ret = btrfs_check_super_valid(fs_info, sb->s_flags & MS_RDONLY);
-	if (ret) {
-		printk(KERN_ERR "btrfs: superblock contains fatal errors\n");
-		err = ret;
-		goto fail_alloc;
-	}
-
 	/*
 	 * run through our array of backup supers and setup
 	 * our ring pointer to the oldest one
@@ -3561,14 +3616,9 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 			      int read_only)
 {
-	if (btrfs_super_csum_type(fs_info->super_copy) >= ARRAY_SIZE(btrfs_csum_sizes)) {
-		printk(KERN_ERR "btrfs: unsupported checksum algorithm\n");
-		return -EINVAL;
-	}
-
-	if (read_only)
-		return 0;
-
+	/*
+	 * Placeholder for checks
+	 */
 	return 0;
 }
 
-- 
1.7.9

