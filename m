Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29708 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752208AbbGWJS0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 05:18:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: convert: Avoid allocating metadata extent crossing stripe boundary
Date: Thu, 23 Jul 2015 17:18:10 +0800
Message-ID: <1437643090-13920-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1437643090-13920-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As convert implement its own alloc extent, avoid such metadata problem
too.

Reported-by: Chris Murphy <lists@colorremedies.com>
Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 15 ++++++++++++---
 ctree.h         |  2 +-
 extent-tree.c   |  2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index b89c685..c97068e 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -207,7 +207,8 @@ static int cache_free_extents(struct btrfs_root *root, ext2_filsys ext2_fs)
 }
 
 static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
-			       u64 hint_byte, struct btrfs_key *ins)
+			       u64 hint_byte, struct btrfs_key *ins,
+			       int metadata)
 {
 	u64 start;
 	u64 end;
@@ -246,6 +247,14 @@ static int custom_alloc_extent(struct btrfs_root *root, u64 num_bytes,
 			continue;
 		}
 
+		if (metadata) {
+			BUG_ON(num_bytes != root->nodesize);
+			if (check_crossing_stripes(start, num_bytes)) {
+				last = round_down(start + num_bytes,
+						  BTRFS_STRIPE_LEN);
+				continue;
+			}
+		}
 		clear_extent_dirty(&root->fs_info->free_space_cache,
 				   start, start + num_bytes - 1, 0);
 
@@ -1280,7 +1289,7 @@ static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
 	 * special, we can't rely on relocate_extents_range to relocate it.
 	 */
 	for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
-		ret = custom_alloc_extent(root, sectorsize, 0, &key);
+		ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
 		if (ret)
 			goto fail;
 		ret = copy_disk_extent(root, key.objectid, last_byte,
@@ -1938,7 +1947,7 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 			ret = get_state_private(reloc_tree, bytenr, &new_pos);
 			BUG_ON(ret);
 		} else {
-			ret = custom_alloc_extent(root, sectorsize, 0, &key);
+			ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
 			if (ret)
 				goto fail;
 			new_pos = key.objectid;
diff --git a/ctree.h b/ctree.h
index 227a00b..bcad2b9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -946,7 +946,7 @@ struct btrfs_block_group_cache {
 
 struct btrfs_extent_ops {
        int (*alloc_extent)(struct btrfs_root *root, u64 num_bytes,
-		           u64 hint_byte, struct btrfs_key *ins);
+			   u64 hint_byte, struct btrfs_key *ins, int metadata);
        int (*free_extent)(struct btrfs_root *root, u64 bytenr,
 		          u64 num_bytes);
 };
diff --git a/extent-tree.c b/extent-tree.c
index 6f07e4b..0c8152a 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2654,7 +2654,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 
 	if (info->extent_ops) {
 		struct btrfs_extent_ops *ops = info->extent_ops;
-		ret = ops->alloc_extent(root, num_bytes, hint_byte, ins);
+		ret = ops->alloc_extent(root, num_bytes, hint_byte, ins, !data);
 		BUG_ON(ret);
 		goto found;
 	}
-- 
2.4.6

