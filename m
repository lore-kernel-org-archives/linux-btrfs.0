From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 28/99] btrfs: clear_extent_bit error push-up
Date: Wed, 23 Nov 2011 19:36:01 -0500
Message-ID: <20111124004223.061443403@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 clear_extent_bit can fail with -ENOMEM for a specific case but will BUG
 on other memory allocation failures.

 This patch returns -ENOMEM for memory allocation failures and handles them
 with BUG_ON in callers which don't handle it already.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: source/fs/btrfs/extent_io.c
===================================================================
--- source.orig/fs/btrfs/extent_io.c	2011-11-21 14:40:44.000000000 -0500
+++ source/fs/btrfs/extent_io.c	2011-11-21 14:40:45.000000000 -0500
@@ -503,7 +503,7 @@ static int __clear_extent_bit(struct ext
 	struct rb_node *next_node;
 	struct rb_node *node;
 	u64 last_end;
-	int err;
+	int err = 0;
 	int clear = 0;
 
 	if (delete)
@@ -568,7 +568,10 @@ hit_next:
 	if (state->start < start) {
 		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -593,7 +596,10 @@ hit_next:
 	if (state->start <= end && state->end > end) {
 		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -629,7 +635,7 @@ out:
 	if (prealloc)
 		free_extent_state(prealloc);
 
-	return 0;
+	return err;
 
 search_again:
 	if (start > end)


