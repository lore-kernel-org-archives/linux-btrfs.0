From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 03/12 v5] Btrfs: update block generation if should_cow_block fails
Date: Sat, 6 Aug 2011 17:37:38 +0800
Message-ID: <1312623467-31487-4-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Cause we've added sub transaction, if it do not want to cow a block, we also
need to get new sub transid recorded.  Thus we need to acquire write lock
ahead.

This is used for log code to find the most uptodate file extents.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |   52 ++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 41d1d17..548246c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -511,6 +511,33 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+static inline void update_block_generation(struct btrfs_trans_handle *trans,
+					   struct btrfs_root *root,
+					   struct extent_buffer *buf,
+					   struct extent_buffer *parent,
+					   int slot)
+{
+	/*
+	 * If it does not need to cow this block, we still need to
+	 * update the block's generation, for transid may have been
+	 * changed during fsync.
+	*/
+	if (btrfs_header_generation(buf) == trans->transid)
+		return;
+
+	if (buf == root->node) {
+		btrfs_set_header_generation(buf, trans->transid);
+		btrfs_mark_buffer_dirty(buf);
+		add_root_to_dirty_list(root);
+	} else {
+		btrfs_set_node_ptr_generation(parent, slot,
+					      trans->transid);
+		btrfs_set_header_generation(buf, trans->transid);
+		btrfs_mark_buffer_dirty(parent);
+		btrfs_mark_buffer_dirty(buf);
+	}
+}
+
 static inline int should_cow_block(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct extent_buffer *buf)
@@ -551,6 +578,7 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	}
 
 	if (!should_cow_block(trans, root, buf)) {
+		update_block_generation(trans, root, buf, parent, parent_slot);
 		*cow_ret = buf;
 		return 0;
 	}
@@ -1699,16 +1727,6 @@ again:
 		 */
 		if (cow) {
 			/*
-			 * if we don't really need to cow this block
-			 * then we don't want to set the path blocking,
-			 * so we test it here
-			 */
-			if (!should_cow_block(trans, root, b))
-				goto cow_done;
-
-			btrfs_set_path_blocking(p);
-
-			/*
 			 * must have write locks on this node and the
 			 * parent
 			 */
@@ -1718,6 +1736,20 @@ again:
 				goto again;
 			}
 
+			/*
+			 * if we don't really need to cow this block
+			 * then we don't want to set the path blocking,
+			 * so we test it here
+			 */
+			if (!should_cow_block(trans, root, b)) {
+				update_block_generation(trans, root, b,
+							p->nodes[level + 1],
+							p->slots[level + 1]);
+				goto cow_done;
+			}
+
+			btrfs_set_path_blocking(p);
+
 			err = btrfs_cow_block(trans, root, b,
 					      p->nodes[level + 1],
 					      p->slots[level + 1], &b);
-- 
1.6.5.2

