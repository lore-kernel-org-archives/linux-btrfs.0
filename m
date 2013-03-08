Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab3CHNPv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Mar 2013 08:15:51 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C2C58A3A49
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Mar 2013 14:15:49 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: enhance superblock checks
Date: Fri,  8 Mar 2013 14:15:38 +0100
Message-Id: <1362748538-12873-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
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
$ sleep 5
$ btrfs scrub status /mnt
... super:2 ...

Signed-off-by: David Sterba <dsterba@suse.cz>
---

v1->v2:
- updated reproducer with sleep 5
- convert check_super_csum to one return point
- remove BUG_ON from btrfs_super_csum_size

 fs/btrfs/ctree.h   |    6 ++-
 fs/btrfs/disk-io.c |   82 ++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 71 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e91959a..a4d572a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2774,8 +2774,10 @@ BTRFS_SETGET_STACK_FUNCS(super_cache_generation, struct btrfs_super_block,
 
 static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 {
-	int t = btrfs_super_csum_type(s);
-	BUG_ON(t >= ARRAY_SIZE(btrfs_csum_sizes));
+	u16 t = btrfs_super_csum_type(s);
+	/*
+	 * csum type is validated at mount time
+	 */
 	return btrfs_csum_sizes[t];
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7d4dcb6..c52f52b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -354,6 +354,44 @@ out:
 }
 
 /*
+ * Return 0 if the superblock checksum type matches the checksum value of that
+ * algorithm. Pass the raw disk superblock data.
+ */
+static int btrfs_check_super_csum(char *raw_disk_sb)
+{
+	struct btrfs_super_block *disk_sb =
+		(struct btrfs_super_block *)raw_disk_sb;
+	u16 csum_type = btrfs_super_csum_type(disk_sb);
+	int ret = 0;
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
+		if (memcmp(raw_disk_sb, result, csum_size))
+			ret = 1;
+	}
+
+	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
+		printk(KERN_ERR "btrfs: unsupported checksum algorithm %u\n",
+				csum_type);
+		ret = 1;
+	}
+
+	return ret;
+}
+
+/*
  * helper to read a given tree block, doing retries as required when
  * the checksums don't match and we have alternate mirrors to try.
  */
@@ -2205,12 +2243,31 @@ int open_ctree(struct super_block *sb,
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
@@ -2218,6 +2275,13 @@ int open_ctree(struct super_block *sb,
 
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
@@ -2226,13 +2290,6 @@ int open_ctree(struct super_block *sb,
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
@@ -3564,14 +3621,9 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
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

