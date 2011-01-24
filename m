From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/3] Btrfs: use the global block reserve if we cannot reserve space
Date: Mon, 24 Jan 2011 16:43:20 -0500
Message-ID: <1295905400-1417-4-git-send-email-josef@redhat.com>
References: <1295905400-1417-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295905400-1417-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

We call use_block_rsv right before we make an allocation in order to make sure
we have enough space.  Now normally people have called btrfs_start_transaction()
with the appropriate amount of space that we need, so we just use some of that
pre-reserved space and move along happily.  The problem is where people use
btrfs_join_transaction(), which doesn't actually reserve any space.  So we try
and reserve space here, but we cannot flush delalloc, so this forces us to
return -ENOSPC when in reality we have plenty of space.  The most common symptom
is seeing a bunch of "couldn't dirty inode" messages in syslog.  With
xfstests 224 we end up falling back to start_transaction and then doing all the
flush delalloc stuff which causes to hang for a very long time.

So instead steal from the global reserve, which is what this is meant for
anyway.  With this patch and the other 2 I have sent xfstests 224 now passes
successfully.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 7aed7bf..355665b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5656,6 +5656,7 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	      struct btrfs_root *root, u32 blocksize)
 {
 	struct btrfs_block_rsv *block_rsv;
+	struct btrfs_block_rsv *global_rsv = &root->fs_info->global_block_rsv;
 	int ret;
 
 	block_rsv = get_block_rsv(trans, root);
@@ -5663,14 +5664,39 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	if (block_rsv->size == 0) {
 		ret = reserve_metadata_bytes(trans, root, block_rsv,
 					     blocksize, 0);
-		if (ret)
+		/*
+		 * If we couldn't reserve metadata bytes try and use some from
+		 * the global reserve.
+		 */
+		if (ret && block_rsv != global_rsv) {
+			ret = block_rsv_use_bytes(global_rsv, blocksize);
+			if (!ret)
+				return global_rsv;
+			return ERR_PTR(ret);
+		} else if (ret) {
 			return ERR_PTR(ret);
+		}
 		return block_rsv;
 	}
 
 	ret = block_rsv_use_bytes(block_rsv, blocksize);
 	if (!ret)
 		return block_rsv;
+	if (ret) {
+		WARN_ON(1);
+		ret = reserve_metadata_bytes(trans, root, block_rsv, blocksize,
+					     0);
+		if (!ret) {
+			spin_lock(&block_rsv->lock);
+			block_rsv->size += blocksize;
+			spin_unlock(&block_rsv->lock);
+			return block_rsv;
+		} else if (ret && block_rsv != global_rsv) {
+			ret = block_rsv_use_bytes(global_rsv, blocksize);
+			if (!ret)
+				return global_rsv;
+		}
+	}
 
 	return ERR_PTR(-ENOSPC);
 }
-- 
1.6.6.1

