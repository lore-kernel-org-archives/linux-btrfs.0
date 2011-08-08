From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't try to commit in btrfs_block_rsv_check
Date: Mon,  8 Aug 2011 14:24:21 -0400
Message-ID: <1312827861-16472-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We will try and reserve metadata bytes in btrfs_block_rsv_check and if we cannot
because we have a transaction open it will return EAGAIN, so we do not need to
try and commit the transaction again.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   29 ++++-------------------------
 1 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e01cd8c..9e602d8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3708,7 +3708,6 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 			  u64 min_reserved, int min_factor)
 {
 	u64 num_bytes = 0;
-	int commit_trans = 0;
 	int ret = -ENOSPC;
 
 	if (!block_rsv)
@@ -3720,13 +3719,12 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 	if (min_reserved > num_bytes)
 		num_bytes = min_reserved;
 
-	if (block_rsv->reserved >= num_bytes) {
+	if (block_rsv->reserved >= num_bytes)
 		ret = 0;
-	} else {
+	else
 		num_bytes -= block_rsv->reserved;
-		commit_trans = 1;
-	}
 	spin_unlock(&block_rsv->lock);
+
 	if (!ret)
 		return 0;
 
@@ -3736,26 +3734,7 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 
-	if (commit_trans) {
-		struct btrfs_space_info *sinfo = block_rsv->space_info;
-
-		if (trans)
-			return -EAGAIN;
-
-		spin_lock(&sinfo->lock);
-		if (sinfo->bytes_pinned < num_bytes) {
-			spin_unlock(&sinfo->lock);
-			return -ENOSPC;
-		}
-		spin_unlock(&sinfo->lock);
-
-		trans = btrfs_join_transaction(root);
-		BUG_ON(IS_ERR(trans));
-		ret = btrfs_commit_transaction(trans, root);
-		return 0;
-	}
-
-	return -ENOSPC;
+	return ret;
 }
 
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
-- 
1.7.5.2

