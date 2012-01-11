From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 01/11] Btrfs: add pinned extents to on-disk free space cache
 correctly
Date: Wed, 11 Jan 2012 13:52:04 +0800
Message-ID: <4F0D2384.2070304@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

I got this while running xfstests:

[24256.836098] block group 317849600 has an wrong amount of free space
[24256.836100] btrfs: failed to load free space cache for block group 317849600

We should clamp the extent returned by find_first_extent_bit(),
so the start of the extent won't smaller than the start of the
block group.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   41 ++++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ec23d43..01840ef 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -838,7 +838,7 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	struct io_ctl io_ctl;
 	struct list_head bitmap_list;
 	struct btrfs_key key;
-	u64 start, end, len;
+	u64 start, extent_start, extent_end, len;
 	int entries = 0;
 	int bitmaps = 0;
 	int ret;
@@ -857,25 +857,12 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 				     struct btrfs_free_cluster,
 				     block_group_list);
 
-	/*
-	 * We shouldn't have switched the pinned extents yet so this is the
-	 * right one
-	 */
-	unpin = root->fs_info->pinned_extents;
-
 	/* Lock all pages first so we can lock the extent safely. */
 	io_ctl_prepare_pages(&io_ctl, inode, 0);
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
 			 0, &cached_state, GFP_NOFS);
 
-	/*
-	 * When searching for pinned extents, we need to start at our start
-	 * offset.
-	 */
-	if (block_group)
-		start = block_group->key.objectid;
-
 	node = rb_first(&ctl->free_space_offset);
 	if (!node && cluster) {
 		node = rb_first(&cluster->root);
@@ -918,9 +905,20 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	 * We want to add any pinned extents to our free space cache
 	 * so we don't leak the space
 	 */
+
+	/*
+	 * We shouldn't have switched the pinned extents yet so this is the
+	 * right one
+	 */
+	unpin = root->fs_info->pinned_extents;
+
+	if (block_group)
+		start = block_group->key.objectid;
+
 	while (block_group && (start < block_group->key.objectid +
 			       block_group->key.offset)) {
-		ret = find_first_extent_bit(unpin, start, &start, &end,
+		ret = find_first_extent_bit(unpin, start,
+					    &extent_start, &extent_end,
 					    EXTENT_DIRTY);
 		if (ret) {
 			ret = 0;
@@ -928,20 +926,21 @@ int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 		}
 
 		/* This pinned extent is out of our range */
-		if (start >= block_group->key.objectid +
+		if (extent_start >= block_group->key.objectid +
 		    block_group->key.offset)
 			break;
 
-		len = block_group->key.objectid +
-			block_group->key.offset - start;
-		len = min(len, end + 1 - start);
+		extent_start = max(extent_start, start);
+		extent_end = min(block_group->key.objectid +
+				 block_group->key.offset, extent_end + 1);
+		len = extent_end - extent_start;
 
 		entries++;
-		ret = io_ctl_add_entry(&io_ctl, start, len, NULL);
+		ret = io_ctl_add_entry(&io_ctl, extent_start, len, NULL);
 		if (ret)
 			goto out_nospc;
 
-		start = end + 1;
+		start = extent_end;
 	}
 
 	/* Write out the bitmaps */
-- 
1.7.3.1
