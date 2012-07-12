Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:33236 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933301Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 04/15] Btrfs: add helper for tree enumeration
Date: Thu, 12 Jul 2012 11:43:36 +0200
Message-Id: <2f38b3e1900634e64a186873b3388b1bf85dabc0.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Often no exact match is wanted but just the next lower or
higher item. There's a lot of duplicated code throughout
btrfs to deal with the corner cases. This patch adds a
helper function that can facilitate searching.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h |    3 ++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index bef68ab..fb21431 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2789,6 +2789,78 @@ done:
 }
 
 /*
+ * helper to use instead of search slot if no exact match is needed but
+ * instead the next or previous item should be returned.
+ * When find_higher is true, the next higher item is returned, the next lower
+ * otherwise.
+ * When return_any and find_higher are both true, and no higher item is found,
+ * return the next lower instead.
+ * When return_any is true and find_higher is false, and no lower item is found,
+ * return the next higher instead.
+ * It returns 0 if any item is found, 1 if none is found (tree empty), and
+ * < 0 on error
+ */
+int btrfs_search_slot_for_read(struct btrfs_root *root,
+			       struct btrfs_key *key, struct btrfs_path *p,
+			       int find_higher, int return_any)
+{
+	int ret;
+	struct extent_buffer *leaf;
+
+again:
+	ret = btrfs_search_slot(NULL, root, key, p, 0, 0);
+	if (ret <= 0)
+		return ret;
+	/*
+	 * a return value of 1 means the path is at the position where the
+	 * item should be inserted. Normally this is the next bigger item,
+	 * but in case the previous item is the last in a leaf, path points
+	 * to the first free slot in the previous leaf, i.e. at an invalid
+	 * item.
+	 */
+	leaf = p->nodes[0];
+
+	if (find_higher) {
+		if (p->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, p);
+			if (ret <= 0)
+				return ret;
+			if (!return_any)
+				return 1;
+			/*
+			 * no higher item found, return the next
+			 * lower instead
+			 */
+			return_any = 0;
+			find_higher = 0;
+			btrfs_release_path(p);
+			goto again;
+		}
+	} else {
+		if (p->slots[0] >= btrfs_header_nritems(leaf)) {
+			/* we're sitting on an invalid slot */
+			if (p->slots[0] == 0) {
+				ret = btrfs_prev_leaf(root, p);
+				if (ret <= 0)
+					return ret;
+				if (!return_any)
+					return 1;
+				/*
+				 * no lower item found, return the next
+				 * higher instead
+				 */
+				return_any = 0;
+				find_higher = 1;
+				btrfs_release_path(p);
+				goto again;
+			}
+			--p->slots[0];
+		}
+	}
+	return 0;
+}
+
+/*
  * adjust the pointers going up the tree, starting at level
  * making sure the right key of each node is points to 'key'.
  * This is used after shifting pointers to the left, so it stops
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 33088b0..27cf995 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2856,6 +2856,9 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      ins_len, int cow);
 int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 			  struct btrfs_path *p, u64 time_seq);
+int btrfs_search_slot_for_read(struct btrfs_root *root,
+			       struct btrfs_key *key, struct btrfs_path *p,
+			       int find_higher, int return_any);
 int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct extent_buffer *parent,
 		       int start_slot, int cache_only, u64 *last_ret,
-- 
1.7.3.4

