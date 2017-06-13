Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752156AbdFMJTz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:55 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 12/19] btrfs-progs: Refactor btrfs_check_chunk_valid to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:28 +0800
Message-ID: <20170613091935.23277-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 6 +++---
 volumes.c    | 9 +++++----
 volumes.h    | 2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index bd6c4e75..b10d0020 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6629,7 +6629,7 @@ static int process_chunk_item(struct cache_tree *chunk_cache,
 	 * wrong onwer(3) out of chunk tree, to pass both chunk tree check
 	 * and owner<->key_type check.
 	 */
-	ret = btrfs_check_chunk_valid(global_info->tree_root, eb, chunk, slot,
+	ret = btrfs_check_chunk_valid(global_info, eb, chunk, slot,
 				      key->offset);
 	if (ret < 0) {
 		error("chunk(%llu, %llu) is not valid, ignore it",
@@ -10930,7 +10930,7 @@ static int check_dev_extent_item(struct btrfs_fs_info *fs_info,
 
 	l = path.nodes[0];
 	chunk = btrfs_item_ptr(l, path.slots[0], struct btrfs_chunk);
-	ret = btrfs_check_chunk_valid(chunk_root, l, chunk, path.slots[0],
+	ret = btrfs_check_chunk_valid(fs_info, l, chunk, path.slots[0],
 				      chunk_key.offset);
 	if (ret < 0)
 		goto out;
@@ -11188,7 +11188,7 @@ static int check_chunk_item(struct btrfs_fs_info *fs_info,
 	chunk = btrfs_item_ptr(eb, slot, struct btrfs_chunk);
 	length = btrfs_chunk_length(eb, chunk);
 	chunk_end = chunk_key.offset + length;
-	ret = btrfs_check_chunk_valid(extent_root, eb, chunk, slot,
+	ret = btrfs_check_chunk_valid(fs_info, eb, chunk, slot,
 				      chunk_key.offset);
 	if (ret < 0) {
 		error("chunk[%llu %llu) is invalid", chunk_key.offset,
diff --git a/volumes.c b/volumes.c
index 700def64..d8b4e993 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1680,7 +1680,7 @@ static struct btrfs_device *fill_missing_device(u64 devid)
  * slot == -1: SYSTEM chunk
  * return -EIO on error, otherwise return 0
  */
-int btrfs_check_chunk_valid(struct btrfs_root *root,
+int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 			    struct extent_buffer *leaf,
 			    struct btrfs_chunk *chunk,
 			    int slot, u64 logical)
@@ -1691,7 +1691,7 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 	u16 sub_stripes;
 	u64 type;
 	u32 chunk_ondisk_size;
-	u32 sectorsize = root->fs_info->sectorsize;
+	u32 sectorsize = fs_info->sectorsize;
 
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
@@ -1787,7 +1787,8 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk, int slot)
 {
-	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct map_lookup *map;
 	struct cache_extent *ce;
 	u64 logical;
@@ -1802,7 +1803,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	length = btrfs_chunk_length(leaf, chunk);
 	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 	/* Validation check */
-	ret = btrfs_check_chunk_valid(root, leaf, chunk, slot, logical);
+	ret = btrfs_check_chunk_valid(fs_info, leaf, chunk, slot, logical);
 	if (ret) {
 		error("%s checksums match, but it has an invalid chunk, %s",
 		      (slot == -1) ? "Superblock" : "Metadata",
diff --git a/volumes.h b/volumes.h
index 6f164e7f..d2e9cbc0 100644
--- a/volumes.h
+++ b/volumes.h
@@ -242,7 +242,7 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			     struct extent_buffer *eb,
 			     struct btrfs_multi_bio *multi,
 			     u64 stripe_len, u64 *raid_map);
-int btrfs_check_chunk_valid(struct btrfs_root *root,
+int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 			    struct extent_buffer *leaf,
 			    struct btrfs_chunk *chunk,
 			    int slot, u64 logical);
-- 
2.13.1



