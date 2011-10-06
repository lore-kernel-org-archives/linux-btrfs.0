From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 10/18] btrfs: Test code to change the order of delayed-ref processing
Date: Thu,  6 Oct 2011 17:54:20 +0200
Message-ID: <1521e6ae5f4b0b2bd957cafc2df9c92241ad9c02.1317915011.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Normally delayed refs get processed in ascending bytenr order. This
correlates in most cases to the order added. To expose dependencies
on this order, we start to process the tree in the middle instead of
the beginning.
This code is only effective when SCRAMBLE_DELAYED_REFS is defined.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 29ac93e..e3b69ce 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -33,6 +33,8 @@
 #include "locking.h"
 #include "free-space-cache.h"
 
+#undef SCRAMBLE_DELAYED_REFS
+
 /* control flags for do_chunk_alloc's force field
  * CHUNK_ALLOC_NO_FORCE means to only allocate a chunk
  * if we really need one.
@@ -2241,6 +2243,49 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 	return count;
 }
 
+#ifdef SCRAMBLE_DELAYED_REFS
+/*
+ * Normally delayed refs get processed in ascending bytenr order. This
+ * correlates in most cases to the order added. To expose dependencies on this
+ * order, we start to process the tree in the middle instead of the beginning
+ */
+static u64 find_middle(struct rb_root *root)
+{
+	struct rb_node *n = root->rb_node;
+	struct btrfs_delayed_ref_node *entry;
+	int alt = 1;
+	u64 middle;
+	u64 first = 0, last = 0;
+
+	n = rb_first(root);
+	if (n) {
+		entry = rb_entry(n, struct btrfs_delayed_ref_node, rb_node);
+		first = entry->bytenr;
+	}
+	n = rb_last(root);
+	if (n) {
+		entry = rb_entry(n, struct btrfs_delayed_ref_node, rb_node);
+		last = entry->bytenr;
+	}
+	n = root->rb_node;
+
+	while (n) {
+		entry = rb_entry(n, struct btrfs_delayed_ref_node, rb_node);
+		WARN_ON(!entry->in_tree);
+
+		middle = entry->bytenr;
+
+		if (alt)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+
+		alt = 1 - alt;
+	}
+	return middle;
+}
+#endif
+
 /*
  * this starts processing the delayed reference count updates and
  * extent insertions we have queued up so far.  count can be
@@ -2266,6 +2311,11 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&cluster);
 again:
 	spin_lock(&delayed_refs->lock);
+
+#ifdef SCRAMBLE_DELAYED_REFS
+delayed_refs->run_delayed_start = find_middle(&delayed_refs->root);
+#endif
+
 	if (count == 0) {
 		count = delayed_refs->num_entries * 2;
 		run_most = 1;
-- 
1.7.3.4

