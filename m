Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbaJOArH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 20:47:07 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 21F89AB07
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 00:47:06 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: add more superblock checks
Date: Wed, 15 Oct 2014 02:47:04 +0200
Message-Id: <1413334024-8536-1-git-send-email-dsterba@suse.cz>
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
V2: use the accessor macros, use >= for the tree level checks

 fs/btrfs/disk-io.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a1d36e62179c..7da15d6f9a1d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3814,10 +3814,74 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 			      int read_only)
 {
+	struct btrfs_super_block *sb = fs_info->super_copy;
+	int ret = 0;
+
+	if (btrfs_super_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: tree_root level too big: %d >= %d\n",
+				btrfs_super_root_level(sb), BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+	if (btrfs_super_chunk_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: chunk_root level too big: %d >= %d\n",
+				btrfs_super_chunk_root_level(sb), BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+	if (btrfs_super_log_root_level(sb) >= BTRFS_MAX_LEVEL) {
+		printk(KERN_ERR "BTRFS: log_root level too big: %d >= %d\n",
+				btrfs_super_log_root_level(sb), BTRFS_MAX_LEVEL);
+		ret = -EINVAL;
+	}
+
 	/*
-	 * Placeholder for checks
+	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
+	 * items yet, they'll be verified later. Issue just a warning.
 	 */
-	return 0;
+	if (!IS_ALIGNED(btrfs_super_root(sb), 4096))
+		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
+				btrfs_super_root(sb));
+	if (!IS_ALIGNED(btrfs_super_chunk_root(sb), 4096))
+		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
+				btrfs_super_chunk_root(sb));
+	if (!IS_ALIGNED(btrfs_super_log_root(sb), 4096))
+		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
+				btrfs_super_log_root(sb));
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
+	if (btrfs_super_num_devices(sb) > (1UL << 31))
+		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
+				btrfs_super_num_devices(sb));
+
+	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
+		printk(KERN_ERR "BTRFS: super offset mismatch %llu != %u\n",
+				btrfs_super_bytenr(sb), BTRFS_SUPER_INFO_OFFSET);
+		ret = -EINVAL;
+	}
+
+	/*
+	 * The generation is a global counter, we'll trust it more than the others
+	 * but it's still possible that it's the one that's wrong.
+	 */
+	if (btrfs_super_generation(sb) < btrfs_super_chunk_root_generation(sb))
+		printk(KERN_WARNING
+			"BTRFS: suspicious: generation < chunk_root_generation: %llu < %llu\n",
+			btrfs_super_generation(sb), btrfs_super_chunk_root_generation(sb));
+	if (btrfs_super_generation(sb) < btrfs_super_cache_generation(sb)
+	    && btrfs_super_cache_generation(sb) != (u64)-1)
+		printk(KERN_WARNING
+			"BTRFS: suspicious: generation < cache_generation: %llu < %llu\n",
+			btrfs_super_generation(sb), btrfs_super_cache_generation(sb));
+
+	return ret;
 }
 
 static void btrfs_error_commit_super(struct btrfs_root *root)
-- 
1.8.4.5

