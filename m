Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39381 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbeACHNX (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 3 Jan 2018 02:13:23 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/5] btrfs-progs: Use bool parameter to determine if we're allocating data extent
Date: Wed,  3 Jan 2018 15:13:02 +0800
Message-Id: <20180103071306.11500-2-wqu@suse.com>
In-Reply-To: <20180103071306.11500-1-wqu@suse.com>
References: <20180103071306.11500-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_reserve_extent() uses int @data to determine if we're allocating
data extent, while reuse the parameter later to pass it as profile
(data/meta/sys).

It's a little confusing, this patch will follow kernel parameter to use
bool @is_data to replace it.
And in btrfs_reserve_extent(), use dedicated u64 @profile.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h       |  2 +-
 extent-tree.c | 17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/ctree.h b/ctree.h
index b92df1c1a518..61d9f9fc9dff 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2435,7 +2435,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 num_bytes, u64 empty_size,
 			 u64 hint_byte, u64 search_end,
-			 struct btrfs_key *ins, int data);
+			 struct btrfs_key *ins, bool is_data);
 int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 void btrfs_pin_extent(struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes);
diff --git a/extent-tree.c b/extent-tree.c
index 055582c36da6..58b64a21d226 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2652,36 +2652,37 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 num_bytes, u64 empty_size,
 			 u64 hint_byte, u64 search_end,
-			 struct btrfs_key *ins, int data)
+			 struct btrfs_key *ins, bool is_data)
 {
 	int ret;
 	u64 search_start = 0;
 	u64 alloc_profile;
+	u64 profile;
 	struct btrfs_fs_info *info = root->fs_info;
 
-	if (data) {
+	if (is_data) {
 		alloc_profile = info->avail_data_alloc_bits &
 			        info->data_alloc_profile;
-		data = BTRFS_BLOCK_GROUP_DATA | alloc_profile;
+		profile = BTRFS_BLOCK_GROUP_DATA | alloc_profile;
 	} else if (info->system_allocs == 1 || root == info->chunk_root) {
 		alloc_profile = info->avail_system_alloc_bits &
 			        info->system_alloc_profile;
-		data = BTRFS_BLOCK_GROUP_SYSTEM | alloc_profile;
+		profile = BTRFS_BLOCK_GROUP_SYSTEM | alloc_profile;
 	} else {
 		alloc_profile = info->avail_metadata_alloc_bits &
 			        info->metadata_alloc_profile;
-		data = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
+		profile = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
 	}
 
 	if (root->ref_cows) {
-		if (!(data & BTRFS_BLOCK_GROUP_METADATA)) {
+		if (!(profile & BTRFS_BLOCK_GROUP_METADATA)) {
 			ret = do_chunk_alloc(trans, info,
 					     num_bytes,
 					     BTRFS_BLOCK_GROUP_METADATA);
 			BUG_ON(ret);
 		}
 		ret = do_chunk_alloc(trans, info,
-				     num_bytes + SZ_2M, data);
+				     num_bytes + SZ_2M, profile);
 		BUG_ON(ret);
 	}
 
@@ -2689,7 +2690,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
 			       search_start, search_end, hint_byte, ins,
 			       trans->alloc_exclude_start,
-			       trans->alloc_exclude_nr, data);
+			       trans->alloc_exclude_nr, profile);
 	if (ret < 0)
 		return ret;
 	clear_extent_dirty(&info->free_space_cache,
-- 
2.15.1

