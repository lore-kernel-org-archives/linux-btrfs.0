Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaI3RQw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 13:16:52 -0400
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add more superblock checks
Date: Tue, 30 Sep 2014 19:16:47 +0200
Message-Id: <1412097407-29093-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Populate btrfs_check_super_valid() with checks that try to verify
consistency of superblock by additional conditions that may arise from
corrupted devices or bitflips. Some of tests are only hints and issue
warnings instead of failing the mount, basically when the checks are
derived from the data found in the superblock.

Tested on a broken image provided by Qu.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d36e62179c..bfb00cb1c84c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3814,10 +3814,73 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 			      int read_only)
 {
+	struct btrfs_super_block *sb = fs_info->super_copy;
+	int ret = 0;
+
+	if (sb->root_level > BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: tree_root level too big: %d > %d\n",
+				sb->root_level, BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+	if (sb->chunk_root_level > BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: chunk_root level too big: %d > %d\n",
+				sb->chunk_root_level, BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+	if (sb->log_root_level > BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: log_root level too big: %d > %d\n",
+				sb->log_root_level, BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+
 	/*
-	 * Placeholder for checks
+	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
+	 * items yet, they'll be verified later. Issue just a warning.
 	 */
-	return 0;
+	if (!IS_ALIGNED(sb->root, 4096))
+		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
+				sb->root);
+	if (!IS_ALIGNED(sb->chunk_root, 4096))
+		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
+				sb->chunk_root);
+	if (!IS_ALIGNED(sb->log_root, 4096))
+		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
+				sb->log_root);
+
+	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
+		printk(KERN_ERR "BTRFS: dev_item UUID does not match fsid: %pU != %pU\n",
+				fs_info->fsid, sb->dev_item.fsid);
+		ret = -EINVAL;
+	}
+
+	/*
+	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
+	 * done later
+	 */
+	if (sb->num_devices > (1UL << 31))
+		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
+				sb->num_devices);
+
+	if (sb->bytenr != BTRFS_SUPER_INFO_OFFSET) {
+		printk(KERN_ERR "BTRFS: super offset mismatch %llu != %u\n",
+				sb->bytenr, BTRFS_SUPER_INFO_OFFSET);
+		ret = -EINVAL;
+	}
+
+	/*
+	 * The generation is a global counter, we'll trust it more than the others
+	 * but it's still possible that it's the one that's wrong.
+	 */
+	if (sb->generation < sb->chunk_root_generation)
+		printk(KERN_WARNING
+			"BTRFS: suspicious: generation < chunk_root_generation: %llu < %llu\n",
+			sb->generation, sb->chunk_root_generation);
+	if (sb->generation < sb->cache_generation && sb->cache_generation != (u64)-1)
+		printk(KERN_WARNING
+			"BTRFS: suspicious: generation < cache_generation: %llu < %llu\n",
+			sb->generation, sb->cache_generation);
+
+	return ret;
 }
 
 static void btrfs_error_commit_super(struct btrfs_root *root)
-- 
1.8.4.5

