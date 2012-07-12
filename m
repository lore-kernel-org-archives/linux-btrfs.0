Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:20048 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933449Ab2GLJnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 05:43:49 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net
Subject: [PATCH v1 08/15] Btrfs: Test code to change the order of delayed-ref processing
Date: Thu, 12 Jul 2012 11:43:40 +0200
Message-Id: <709c0486b9fe9586736b108b7233bbce0300cfa5.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
References: <cover.1342083345.git.list.btrfs@jan-o-sch.net>
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
 fs/btrfs/extent-tree.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 94ce79f..b13f1fb 100644
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
@@ -2364,6 +2366,49 @@ static void wait_for_more_refs(struct btrfs_fs_info *fs_info,
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
@@ -2406,6 +2451,10 @@ again:
 	consider_waiting = 0;
 	spin_lock(&delayed_refs->lock);
 
+#ifdef SCRAMBLE_DELAYED_REFS
+	delayed_refs->run_delayed_start = find_middle(&delayed_refs->root);
+#endif
+
 	if (count == 0) {
 		count = delayed_refs->num_entries * 2;
 		run_most = 1;
-- 
1.7.3.4

