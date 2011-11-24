From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 05/99] btrfs: Remove set bits return from clear_extent_bit
Date: Wed, 23 Nov 2011 19:35:38 -0500
Message-ID: <20111124004220.396576561@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 There is only one caller of clear_extent_bit that checks the return value
 and it only checks if it's negative. Since there are no users of the
 returned bits functionality of clear_extent_bit, stop returning it
 and avoid complicating error handling.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent_io.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -460,8 +460,7 @@ NORET_TYPE void extent_io_tree_panic(str
  *
  * the range [start, end] is inclusive.
  *
- * This takes the tree lock, and returns < 0 on error, > 0 if any of the
- * bits were already set, or zero if none of the bits were already set.
+ * This takes the tree lock, and returns 0 on success and < 0 on error.
  */
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     int bits, int wake, int delete,
@@ -475,7 +474,6 @@ int clear_extent_bit(struct extent_io_tr
 	struct rb_node *node;
 	u64 last_end;
 	int err;
-	int set = 0;
 	int clear = 0;
 
 	if (delete)
@@ -551,7 +549,7 @@ hit_next:
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			set |= clear_state_bit(tree, state, &bits, wake);
+			clear_state_bit(tree, state, &bits, wake);
 			if (last_end == (u64)-1)
 				goto out;
 			start = last_end + 1;
@@ -574,7 +572,7 @@ hit_next:
 		if (wake)
 			wake_up(&state->wq);
 
-		set |= clear_state_bit(tree, prealloc, &bits, wake);
+		clear_state_bit(tree, prealloc, &bits, wake);
 
 		prealloc = NULL;
 		goto out;
@@ -585,7 +583,7 @@ hit_next:
 	else
 		next_node = NULL;
 
-	set |= clear_state_bit(tree, state, &bits, wake);
+	clear_state_bit(tree, state, &bits, wake);
 	if (last_end == (u64)-1)
 		goto out;
 	start = last_end + 1;
@@ -602,7 +600,7 @@ out:
 	if (prealloc)
 		free_extent_state(prealloc);
 
-	return set;
+	return 0;
 
 search_again:
 	if (start > end)



