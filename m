From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] Btrfs: don't add extent 0 to the free space cache
Date: Wed, 25 Nov 2009 16:55:19 +0800
Message-ID: <4B0CF0F7.7070206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If block group 0 is completely free, btrfs_read_block_groups will
add extent [0, BTRFS_SUPER_INFO_OFFSET) to the free space cache.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-11-23 13:59:11.415598041 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-11-25 16:20:52.865565692 +0800
@@ -195,6 +195,14 @@ static int exclude_super_stripes(struct 
 	int stripe_len;
 	int i, nr, ret;
 
+	if (cache->key.objectid < BTRFS_SUPER_INFO_OFFSET) {
+		stripe_len = BTRFS_SUPER_INFO_OFFSET - cache->key.objectid;
+		cache->bytes_super += stripe_len;
+		ret = add_excluded_extent(root, cache->key.objectid,
+					  stripe_len);
+		BUG_ON(ret);
+	}
+
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
 		ret = btrfs_rmap_block(&root->fs_info->mapping_tree,
