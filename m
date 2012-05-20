Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46306 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab2ETQGl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:41 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 18/24] Btrfs: Test code to change the order of delayed-ref processing
Date: Sun, 20 May 2012 18:06:29 +0200
Message-Id: <97860eb6d06289f51d806d34e53c393f8a761cca.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

Normally delayed refs get processed in ascending bytenr order. This
correlates in most cases to the order added. To expose dependencies
on this order, we start to process the tree in the middle instead of
the beginning.
This code is only effective when SCRAMBLE_DELAYED_REFS is defined.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/extent-tree.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b68eb7a..a7f980b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -34,6 +34,8 @@
 #include "locking.h"
 #include "free-space-cache.h"
 
+#undef SCRAMBLE_DELAYED_REFS
+
 /*
  * control flags for do_chunk_alloc's force field
  * CHUNK_ALLOC_NO_FORCE means to only allocate a chunk
@@ -2347,7 +2349,6 @@ next:
 	return count;
 }
 
-
 static void wait_for_more_refs(struct btrfs_delayed_ref_root *delayed_refs,
 			unsigned long num_refs)
 {
@@ -2364,6 +2365,49 @@ static void wait_for_more_refs(struct btrfs_delayed_ref_root *delayed_refs,
 	spin_lock(&delayed_refs->lock);
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
@@ -2404,6 +2448,11 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 again:
 	consider_waiting = 0;
 	spin_lock(&delayed_refs->lock);
+
+#ifdef SCRAMBLE_DELAYED_REFS
+	delayed_refs->run_delayed_start = find_middle(&delayed_refs->root);
+#endif
+
 	if (count == 0) {
 		count = delayed_refs->num_entries * 2;
 		run_most = 1;
-- 
1.7.3.4

