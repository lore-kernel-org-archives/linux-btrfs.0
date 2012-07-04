Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38056 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2GDNiw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 09:38:52 -0400
Received: by mail-bk0-f46.google.com with SMTP id j10so2632560bkw.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 06:38:52 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Arne Jansen <sensille@gmx.net>
Subject: [RFC PATCH 2/7] Btrfs: add helper for tree enumeration
Date: Wed,  4 Jul 2012 15:38:23 +0200
Message-Id: <1341409108-13567-3-git-send-email-ablock84@googlemail.com>
In-Reply-To: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Often no exact match is wanted but just the next lower or
higher item. There's a lot of duplicated code throughout
btrfs to deal with the corner cases. This patch adds a
helper function that can facilitate searching.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.c |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ctree.h |    3 +++
 2 files changed, 77 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 15cbc2b..33c8a03 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2724,6 +2724,80 @@ done:
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
+		if (p->slots[0] == 0) {
+			ret = btrfs_prev_leaf(root, p);
+			if (ret < 0)
+				return ret;
+			if (!ret) {
+				p->slots[0] = btrfs_header_nritems(leaf) - 1;
+				return 0;
+			}
+			if (!return_any)
+				return 1;
+			/*
+			 * no lower item found, return the next
+			 * higher instead
+			 */
+			return_any = 0;
+			find_higher = 1;
+			btrfs_release_path(p);
+			goto again;
+		} else {
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
index fa5c45b..8cfde93 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2711,6 +2711,9 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
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
1.7.10

