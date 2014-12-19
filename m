Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44742 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaLSRim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:38:42 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9EECAAC18
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 17:38:41 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4] btrfs: update message levels during failed mount
Date: Fri, 19 Dec 2014 18:38:41 +0100
Message-Id: <af55b94b0ef3d05c40155a9fda1729546b91fbfb.1419010347.git.dsterba@suse.cz>
In-Reply-To: <cover.1419010347.git.dsterba@suse.cz>
References: <cover.1419010347.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All error conditions from open_ctree shall be ERR. Warning would
suggest that something's wrong and we can continue.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8beb74ffb075..3b694192a4a9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2523,7 +2523,7 @@ int open_ctree(struct super_block *sb,
 	 */
 	if ((features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS) &&
 	    (sectorsize != nodesize)) {
-		printk(KERN_WARNING "BTRFS: unequal leaf/node/sector sizes "
+		printk(KERN_ERR "BTRFS: unequal leaf/node/sector sizes "
 				"are not allowed for mixed block groups on %s\n",
 				sb->s_id);
 		goto fail_alloc;
@@ -2631,12 +2631,12 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
 	if (btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
-		printk(KERN_INFO "BTRFS: valid FS not found on %s\n", sb->s_id);
+		printk(KERN_ERR "BTRFS: valid FS not found on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
 
 	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_WARNING "BTRFS: Incompatible sector size(%lu) "
+		printk(KERN_ERR "BTRFS: incompatible sector size (%lu) "
 		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
 		goto fail_sb_buffer;
 	}
@@ -2645,7 +2645,7 @@ int open_ctree(struct super_block *sb,
 	ret = btrfs_read_sys_array(tree_root);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
-		printk(KERN_WARNING "BTRFS: failed to read the system "
+		printk(KERN_ERR "BTRFS: failed to read the system "
 		       "array on %s\n", sb->s_id);
 		goto fail_sb_buffer;
 	}
@@ -2660,7 +2660,7 @@ int open_ctree(struct super_block *sb,
 					   generation);
 	if (!chunk_root->node ||
 	    !test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
-		printk(KERN_WARNING "BTRFS: failed to read chunk root on %s\n",
+		printk(KERN_ERR "BTRFS: failed to read chunk root on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
 	}
@@ -2672,7 +2672,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_read_chunk_tree(chunk_root);
 	if (ret) {
-		printk(KERN_WARNING "BTRFS: failed to read chunk tree on %s\n",
+		printk(KERN_ERR "BTRFS: failed to read chunk tree on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
 	}
@@ -2684,7 +2684,7 @@ int open_ctree(struct super_block *sb,
 	btrfs_close_extra_devices(fs_info, fs_devices, 0);
 
 	if (!fs_devices->latest_bdev) {
-		printk(KERN_CRIT "BTRFS: failed to read devices on %s\n",
+		printk(KERN_ERR "BTRFS: failed to read devices on %s\n",
 		       sb->s_id);
 		goto fail_tree_roots;
 	}
@@ -2768,7 +2768,7 @@ retry_root_backup:
 
 	ret = btrfs_recover_balance(fs_info);
 	if (ret) {
-		printk(KERN_WARNING "BTRFS: failed to recover balance\n");
+		printk(KERN_ERR "BTRFS: failed to recover balance\n");
 		goto fail_block_groups;
 	}
 
-- 
2.1.3

