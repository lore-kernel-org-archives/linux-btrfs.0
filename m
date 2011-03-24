From: Li Dongyang <lidongyang@novell.com>
Subject: [PATCH V4 3/4] Btrfs: adjust btrfs_discard_extent() return errors and trimmed bytes
Date: Thu, 24 Mar 2011 18:24:27 +0800
Message-ID: <1300962268-12774-4-git-send-email-lidongyang@novell.com>
References: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300962268-12774-1-git-send-email-lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

Callers of btrfs_discard_extent() should check if we are mounted with -o discard,
as we want to make fitrim to work even the fs is not mounted with -o discard.
Also we should use REQ_DISCARD to map the free extent to get a full mapping,
last we only return errors if
1. the error is not a EOPNOTSUPP
2. no device supports discard

Signed-off-by: Li Dongyang <lidongyang@novell.com>
---
 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/disk-io.c     |    5 ++++-
 fs/btrfs/extent-tree.c |   45 ++++++++++++++++++++++++++-------------------
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2c84551..94bb772 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2229,7 +2229,7 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
 int btrfs_error_unpin_extent_range(struct btrfs_root *root,
 				   u64 start, u64 end);
 int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
-			       u64 num_bytes);
+			       u64 num_bytes, u64 *actual_bytes);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root, u64 type);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 100b07f..98b60b0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2947,7 +2947,10 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
 			break;
 
 		/* opt_discard */
-		ret = btrfs_error_discard_extent(root, start, end + 1 - start);
+		if (btrfs_test_opt(root, DISCARD))
+			ret = btrfs_error_discard_extent(root, start,
+							 end + 1 - start,
+							 NULL);
 
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
 		btrfs_error_unpin_extent_range(root, start, end);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index caa4254..10e542a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1738,40 +1738,44 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static void btrfs_issue_discard(struct block_device *bdev,
+static int btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
-	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL, 0);
+	return blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL, 0);
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
-				u64 num_bytes)
+				u64 num_bytes, u64 *actual_bytes)
 {
 	int ret;
-	u64 map_length = num_bytes;
+	u64 discarded_bytes = 0;
 	struct btrfs_multi_bio *multi = NULL;
 
-	if (!btrfs_test_opt(root, DISCARD))
-		return 0;
-
 	/* Tell the block device(s) that the sectors can be discarded */
-	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-			      bytenr, &map_length, &multi, 0);
+	ret = btrfs_map_block(&root->fs_info->mapping_tree, REQ_DISCARD,
+			      bytenr, &num_bytes, &multi, 0);
 	if (!ret) {
 		struct btrfs_bio_stripe *stripe = multi->stripes;
 		int i;
 
-		if (map_length > num_bytes)
-			map_length = num_bytes;
-
 		for (i = 0; i < multi->num_stripes; i++, stripe++) {
-			btrfs_issue_discard(stripe->dev->bdev,
-					    stripe->physical,
-					    map_length);
+			ret = btrfs_issue_discard(stripe->dev->bdev,
+						  stripe->physical,
+						  stripe->length);
+			if (!ret)
+				discarded_bytes += stripe->length;
+			else if (ret != -EOPNOTSUPP)
+				break;
 		}
 		kfree(multi);
 	}
 
+	if (discarded_bytes && ret == -EOPNOTSUPP)
+		ret = 0;
+
+	if (actual_bytes)
+		*actual_bytes = discarded_bytes;
+
 	return ret;
 }
 
@@ -4361,7 +4365,9 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
 		if (ret)
 			break;
 
-		ret = btrfs_discard_extent(root, start, end + 1 - start);
+		if (btrfs_test_opt(root, DISCARD))
+			ret = btrfs_discard_extent(root, start,
+						   end + 1 - start, NULL);
 
 		clear_extent_dirty(unpin, start, end, GFP_NOFS);
 		unpin_extent_range(root, start, end);
@@ -5410,7 +5416,8 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
 		return -ENOSPC;
 	}
 
-	ret = btrfs_discard_extent(root, start, len);
+	if (btrfs_test_opt(root, DISCARD))
+		ret = btrfs_discard_extent(root, start, len, NULL);
 
 	btrfs_add_free_space(cache, start, len);
 	btrfs_update_reserved_bytes(cache, len, 0, 1);
@@ -8728,7 +8735,7 @@ int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 }
 
 int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
-			       u64 num_bytes)
+			       u64 num_bytes, u64 *actual_bytes)
 {
-	return btrfs_discard_extent(root, bytenr, num_bytes);
+	return btrfs_discard_extent(root, bytenr, num_bytes, actual_bytes);
 }
-- 
1.7.4.1

