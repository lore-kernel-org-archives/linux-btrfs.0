Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46301 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab2ETQGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:42 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 14/24] Btrfs: add helper for tree enumeration
Date: Sun, 20 May 2012 18:06:25 +0200
Message-Id: <56c0e15828bdeaad0215a5c3c48dda2c7d5b9c8d.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
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
index 67d716e..bf6df35 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2641,6 +2641,78 @@ done:
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
index 3961b7e..283c992 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2806,6 +2806,9 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
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

