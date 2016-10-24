Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19343 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752013AbcJXHXH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 03:23:07 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Fix wrong tree block alignment for unalianged block group
Date: Mon, 24 Oct 2016 15:22:33 +0800
Message-Id: <20161024072233.31643-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 854437ca(btrfs-progs: extent-tree: avoid allocating tree block
that crosses stripe boundary) introduces check for logical bytenr not
crossing stripe boundary.

However that check is not completely correct.
It only checks if the logical bytenr and length agaist absolute logical
offset.
That's to say, it only check if a tree block lies in 64K logical stripe.

But in fact, it's possible a block group starts at bytenr unaligned with
64K, just like the following case.

Then btrfsck will give false alert.

0       32K       64K       96K        128K         160K ...
        |--------------- Block group A ---------------------
	|<-----TB 32K------>|
        |/Scrub stripe unit/|
|    WRONG UNIT   |

In that case, TB(tree block) at bytenr 32K in fact fits into the kernel
scrub stripe unit.
But doesn't fit into the pure logical 64K stripe.

Fix check_crossing_stripes() to compare bytenr to block group start, not
to absolute logical bytenr.

Reported-by: Jussi Kansanen <jussi.kansanen@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c  | 10 ++++++----
 extent-tree.c | 15 ++++++++++++---
 volumes.h     | 23 ++++++++++++++++++++---
 3 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 670ccd1..907d60c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4662,8 +4662,8 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
 	bytes_used += rec->nr;
 
 	if (tmpl->metadata)
-		rec->crossing_stripes = check_crossing_stripes(rec->start,
-				global_info->tree_root->nodesize);
+		rec->crossing_stripes = check_crossing_stripes(global_info,
+				rec->start, global_info->tree_root->nodesize);
 	check_extent_type(rec);
 	return ret;
 }
@@ -4764,7 +4764,8 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		 */
 		if (tmpl->metadata)
 			rec->crossing_stripes = check_crossing_stripes(
-				rec->start, global_info->tree_root->nodesize);
+					global_info, rec->start,
+					global_info->tree_root->nodesize);
 		check_extent_type(rec);
 		maybe_free_extent_rec(extent_cache, rec);
 		return ret;
@@ -9359,7 +9360,8 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 
 	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)
 		metadata = 1;
-	if (metadata && check_crossing_stripes(key.objectid, eb->len)) {
+	if (metadata && check_crossing_stripes(global_info, key.objectid,
+					       eb->len)) {
 		error("bad metadata [%llu, %llu) crossing stripe boundary",
 		      key.objectid, key.objectid + nodesize);
 		err |= CROSSING_STRIPE_BOUNDARY;
diff --git a/extent-tree.c b/extent-tree.c
index f6d0a7c..3b1577e 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2606,11 +2606,20 @@ check_failed:
 	}
 
 	if (!(data & BTRFS_BLOCK_GROUP_DATA)) {
-		if (check_crossing_stripes(ins->objectid, num_bytes)) {
-			search_start = round_down(ins->objectid + num_bytes,
-						  BTRFS_STRIPE_LEN);
+		if (check_crossing_stripes(info, ins->objectid, num_bytes)) {
+			struct btrfs_block_group_cache *bg_cache;
+			u64 bg_offset;
+
+			bg_cache = btrfs_lookup_block_group(info, ins->objectid);
+			if (!bg_cache)
+				goto no_bg_cache;
+			bg_offset = ins->objectid - bg_cache->key.objectid;
+
+			search_start = round_up(bg_offset + num_bytes,
+						BTRFS_STRIPE_LEN) + bg_offset;
 			goto new_group;
 		}
+no_bg_cache:
 		block_group = btrfs_lookup_block_group(info, ins->objectid);
 		if (block_group)
 			trans->block_group = block_group;
diff --git a/volumes.h b/volumes.h
index d7b7d3c..7cb38b0 100644
--- a/volumes.h
+++ b/volumes.h
@@ -155,11 +155,28 @@ struct map_lookup {
  * Check if the given range cross stripes.
  * To ensure kernel scrub won't causing bug on with METADATA in mixed
  * block group
+ *
+ * Return 1 if the range crosses STRIPE boundary
+ * Return 0 if the range doesn't cross STRIPE boundar or it
+ * doesn't belongs to any block group(no boundary to cross)
  */
-static inline int check_crossing_stripes(u64 start, u64 len)
+static inline int check_crossing_stripes(struct btrfs_fs_info *fs_info,
+					 u64 start, u64 len)
 {
-	return (start / BTRFS_STRIPE_LEN) !=
-	       ((start + len - 1) / BTRFS_STRIPE_LEN);
+	struct btrfs_block_group_cache *bg_cache;
+	u64 bg_offset;
+
+	bg_cache = btrfs_lookup_block_group(fs_info, start);
+	/*
+	 * not belongs to block group, no boundary to cross
+	 * although it's a bigger problem, but here we don't care.
+	 */
+	if (!bg_cache)
+		return 0;
+	bg_offset = start - bg_cache->key.objectid;
+
+	return (bg_offset / BTRFS_STRIPE_LEN !=
+		(bg_offset + len - 1) / BTRFS_STRIPE_LEN);
 }
 
 int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
-- 
2.10.1



