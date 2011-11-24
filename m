From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 27/99] btrfs: set_extent_bit should return -ENOMEM on GFP_ATOMIC failures
Date: Wed, 23 Nov 2011 19:36:00 -0500
Message-ID: <20111124004222.945444476@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 The only failure condition is for GFP_ATOMIC allocations. Push up to
 callers which are already handling it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

Index: linux-3.0-SLE11-SP2/fs/btrfs/extent_io.c
===================================================================
--- linux-3.0-SLE11-SP2.orig/fs/btrfs/extent_io.c	2011-11-21 14:09:59.000000000 -0500
+++ linux-3.0-SLE11-SP2/fs/btrfs/extent_io.c	2011-11-21 14:11:54.000000000 -0500
@@ -765,6 +765,9 @@ static void uncache_state(struct extent_
  * part of the range already has the desired bits set.  The start of the
  * existing range is returned in failed_start in this case.
  *
+ * It may also fail with -ENOMEM if memory cannot be obtained for extent_state
+ * structures when called with mask == GFP_ATOMIC.
+ *
  * [start, end] is inclusive This takes the tree lock.
  */
 
@@ -803,7 +806,11 @@ again:
 	if (!node) {
 		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = insert_state(tree, prealloc, start, end, &bits);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -873,7 +880,11 @@ hit_next:
 
 		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -907,7 +918,10 @@ hit_next:
 
 		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		/*
 		 * Avoid to free 'prealloc' if it can be merged with
@@ -938,7 +952,11 @@ hit_next:
 
 		assert_atomic_alloc(prealloc, mask);
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);


