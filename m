Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:45345 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933092AbeAJFvT (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 10 Jan 2018 00:51:19 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Fix wrong chunk allocation type in btrfs_reserve_extent
Date: Wed, 10 Jan 2018 13:51:13 +0800
Message-Id: <20180110055113.18976-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_reserve_extent() will try to allocate new chunk if there is not
enough space (mostly meta space).

However when it tries to allocate new meta chunk, it will always try to
allocate SINGLE meta chunk, and if the fs is using other profile, it
will cause dead allocation which can't be really used.

And when trying to allocate new meta chunk for fs trees, it uses the
@num_bytes which is normally times larger than metadata space.

Fix it by using proper meta profile and calculate based on file extent
other than @num_bytes if we are allocating meta space for file extents.

And all such chunk allocation condition is not explained at all.
Add needed (although maybe a little overkilled) comment for it.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Needed prerequisite is pushed to github:
https://github.com/adam900710/btrfs-progs/tree/chunk_alloc_fixes

And unfortunately, the condition to trigger chunk allocation is pretty
hard to trigger.
For normal mkfs case, we will always have enough space, while for normal
usage, kernel will ensure there is enough space (global reservation) for
extent tree update, which is normally larger than the 2M headroom used in 
btrfs-progs.

So no easy test case here.
---
 extent-tree.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 90e792a3fe62..aab09d926043 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1907,7 +1907,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 		return 0;
 
 	ret = btrfs_alloc_chunk(trans, fs_info, &start, &num_bytes,
-	                        space_info->flags, false);
+	                        flags, false);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
 		return ret;
@@ -2652,8 +2652,11 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 	u64 search_start = 0;
 	u64 alloc_profile;
 	u64 profile;
+	u64 meta_profile;
 	struct btrfs_fs_info *info = root->fs_info;
 
+	meta_profile = info->avail_metadata_alloc_bits &
+		       info->metadata_alloc_profile;
 	if (is_data) {
 		alloc_profile = info->avail_data_alloc_bits &
 			        info->data_alloc_profile;
@@ -2663,21 +2666,57 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			        info->system_alloc_profile;
 		profile = BTRFS_BLOCK_GROUP_SYSTEM | alloc_profile;
 	} else {
-		alloc_profile = info->avail_metadata_alloc_bits &
-			        info->metadata_alloc_profile;
+		alloc_profile = meta_profile;
 		profile = BTRFS_BLOCK_GROUP_METADATA | alloc_profile;
 	}
 
+	/*
+	 * If we're modifying global trees likes extent/root/device tree
+	 * (whose ref_cows is 0), we shouldn't trigger chunk allocation AT ALL!
+	 *
+	 * The problem is, if root is extent tree, we trigger a chunk
+	 * allocation, then it will modify extent tree, causing a path deadlock.
+	 * (Although not implemented in btrfs-progs, it will still cause tree
+	 * modification screwed up)
+	 */
 	if (root->ref_cows) {
+		u64 meta_reserve;
+
 		if (!(profile & BTRFS_BLOCK_GROUP_METADATA)) {
-			ret = do_chunk_alloc(trans, info,
-					     num_bytes,
-					     BTRFS_BLOCK_GROUP_METADATA);
-			BUG_ON(ret);
+			/*
+			 * If we're modifying fs trees and allocating data
+			 * extent, we need to ensure we have enough metadata
+			 * space to insert new file extent item.
+			 *
+			 * Here we need to ensure we have enough space for the
+			 * following operations:
+			 * 1) Insert one file extent
+			 *    A full tree CoW + Leaf split should be enough.
+			 *
+			 * 2) Possible new chunk allocation
+			 *    4 trees are involved, chunk, device, extent and
+			 *    root tree.
+			 *    However chunk tree is counted as system chunk, and
+			 *    never
+			 *    really needs a new system chunk even for super
+			 *    large fs.
+			 *    Only 3 trees are need.
+			 *
+			 * So it's total 4 trees, subvolume, extent, device and
+			 * root tree.
+			 * Each tree needs a full tree CoW + Leaf split.
+			 */
+			meta_reserve = 4 * ( BTRFS_MAX_LEVEL + 1) *
+				       info->nodesize;
+			ret = do_chunk_alloc(trans, info, meta_reserve,
+				meta_profile | BTRFS_BLOCK_GROUP_METADATA);
 		}
+
+		/* Keep 2M as free space headroom */
 		ret = do_chunk_alloc(trans, info,
 				     num_bytes + SZ_2M, profile);
-		BUG_ON(ret);
+		if (ret < 0)
+			return ret;
 	}
 
 	WARN_ON(num_bytes < info->sectorsize);
-- 
2.15.1

