From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/9] Btrfs: update block generation if should_cow_block fails
Date: Thu, 19 May 2011 16:11:25 +0800
Message-ID: <1305792692-10635-3-git-send-email-liubo2009@cn.fujitsu.com>
References: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <josef@redhat.com>, <chris.mason@oracle.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305792692-10635-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Cause we've added sub transaction, if it do not want to cow a block, we also
need to get new sub transid recorded.  This is used for log code to find the
most uptodate file extents.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0c3b515..7e21fa9 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -484,6 +484,33 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
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
@@ -524,6 +551,7 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	}
 
 	if (!should_cow_block(trans, root, buf)) {
+		update_block_generation(trans, root, buf, parent, parent_slot);
 		*cow_ret = buf;
 		return 0;
 	}
@@ -1639,8 +1667,12 @@ again:
 			 * then we don't want to set the path blocking,
 			 * so we test it here
 			 */
-			if (!should_cow_block(trans, root, b))
+			if (!should_cow_block(trans, root, b)) {
+				update_block_generation(trans, root, b,
+							p->nodes[level + 1],
+							p->slots[level + 1]);
 				goto cow_done;
+			}
 
 			btrfs_set_path_blocking(p);
 
-- 
1.6.5.2

