Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaJ0MwY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 08:52:24 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id BAC5EAC8D
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 12:52:22 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: use macro accessors in superblock validation checks
Date: Mon, 27 Oct 2014 13:52:21 +0100
Message-Id: <1414414341-26472-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The initial patch c926093ec516f5d316 (btrfs: add more superblock checks)
did not properly use the macro accessors that wrap endianness and the
code would not work correctly on big endian machines.

Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ad0f47ac850..1bf9f897065d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3817,19 +3817,19 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	int ret = 0;
 
-	if (sb->root_level > BTRFS_MAX_LEVEL) {
-		printk(KERN_ERR "BTRFS: tree_root level too big: %d > %d\n",
-				sb->root_level, BTRFS_MAX_LEVEL);
+	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: tree_root level too big: %d >= %d\n",
+				btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
 		ret = -EINVAL;
 	}
-	if (sb->chunk_root_level > BTRFS_MAX_LEVEL) {
-		printk(KERN_ERR "BTRFS: chunk_root level too big: %d > %d\n",
-				sb->chunk_root_level, BTRFS_MAX_LEVEL);
+	if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: chunk_root level too big: %d >= %d\n",
+				btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
 		ret = -EINVAL;
 	}
-	if (sb->log_root_level > BTRFS_MAX_LEVEL) {
-		printk(KERN_ERR "BTRFS: log_root level too big: %d > %d\n",
-				sb->log_root_level, BTRFS_MAX_LEVEL);
+	if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: log_root level too big: %d >= %d\n",
+				btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
 		ret = -EINVAL;
 	}
 
@@ -3837,15 +3837,15 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
 	 * items yet, they'll be verified later. Issue just a warning.
 	 */
-	if (!IS_ALIGNED(sb->root, 4096))
+	if (!IS_ALIGNED(btrfs_super_root(sb), 4096))
 		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
 				sb->root);
-	if (!IS_ALIGNED(sb->chunk_root, 4096))
+	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096))
 		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
 				sb->chunk_root);
-	if (!IS_ALIGNED(sb->log_root, 4096))
+	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096))
 		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
-				sb->log_root);
+				btrfs_super_log_root(sb));
 
 	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
 		printk(KERN_ERR "BTRFS: dev_item UUID does not match fsid: %pU != %pU\n",
@@ -3857,13 +3857,13 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
 	 * done later
 	 */
-	if (sb->num_devices > (1UL << 31))
+	if (btrfs_super_num_devices(sb) > (1UL << 31))
 		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
-				sb->num_devices);
+				btrfs_super_num_devices(sb));
 
-	if (sb->bytenr != BTRFS_SUPER_INFO_OFFSET) {
+	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
 		printk(KERN_ERR "BTRFS: super offset mismatch %llu != %u\n",
-				sb->bytenr, BTRFS_SUPER_INFO_OFFSET);
+				btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
 		ret = -EINVAL;
 	}
 
@@ -3871,14 +3871,15 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * The generation is a global counter, we'll trust it more than the others
 	 * but it's still possible that it's the one that's wrong.
 	 */
-	if (sb->generation < sb->chunk_root_generation)
+	if (btrfs_super_generation(sb) < btrfs_super_chunk_root_generation(sb))
 		printk(KERN_WARNING
 			"BTRFS: suspicious: generation < chunk_root_generation: %llu < %llu\n",
-			sb->generation, sb->chunk_root_generation);
-	if (sb->generation < sb->cache_generation && sb->cache_generation != (u64)-1)
+			btrfs_super_generation(sb), btrfs_super_chunk_root_generation(sb));
+	if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
+	    && btrfs_super_cache_generation(sb) != (u64)-1)
 		printk(KERN_WARNING
 			"BTRFS: suspicious: generation < cache_generation: %llu < %llu\n",
-			sb->generation, sb->cache_generation);
+			btrfs_super_generation(sb), btrfs_super_cache_generation(sb));
 
 	return ret;
 }
-- 
1.8.4.5

