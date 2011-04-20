From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH v2 1/2] Btrfs: allocate extent state and check the result
 properly
Date: Wed, 20 Apr 2011 14:44:57 +0800
Message-ID: <4DAE80E9.2010102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It doesn't allocate extent_state and check the result properly:
- in set_extent_bit, it doesn't allocate extent_state if the path is not
  allowed wait

- in clear_extent_bit, it doesn't check the result after atomic-ly allocate,
  we trigger BUG_ON() if it's fail

- if allocate fail, we trigger BUG_ON instead of returning -ENOMEM since
  the return value of clear_extent_bit() is ignored by many callers

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5ae0bff..f36e284 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -439,6 +439,15 @@ static int clear_state_bit(struct extent_io_tree *tree,
 	return ret;
 }
 
+static struct extent_state *
+alloc_extent_state_atomic(struct extent_state *prealloc)
+{
+	if (!prealloc)
+		prealloc = alloc_extent_state(GFP_ATOMIC);
+
+	return prealloc;
+}
+
 /*
  * clear some bits on a range in the tree.  This may require splitting
  * or inserting elements in the tree, so the gfp mask is used to
@@ -476,8 +485,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
-		if (!prealloc)
-			return -ENOMEM;
+		BUG_ON(!prealloc);
 	}
 
 	spin_lock(&tree->lock);
@@ -529,8 +537,8 @@ hit_next:
 	 */
 
 	if (state->start < start) {
-		if (!prealloc)
-			prealloc = alloc_extent_state(GFP_ATOMIC);
+		prealloc = alloc_extent_state_atomic(prealloc);
+		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
@@ -551,8 +559,8 @@ hit_next:
 	 * on the first half
 	 */
 	if (state->start <= end && state->end > end) {
-		if (!prealloc)
-			prealloc = alloc_extent_state(GFP_ATOMIC);
+		prealloc = alloc_extent_state_atomic(prealloc);
+		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
 		if (wake)
@@ -725,8 +733,7 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
-		if (!prealloc)
-			return -ENOMEM;
+		BUG_ON(!prealloc);
 	}
 
 	spin_lock(&tree->lock);
@@ -743,6 +750,8 @@ again:
 	 */
 	node = tree_search(tree, start);
 	if (!node) {
+		prealloc = alloc_extent_state_atomic(prealloc);
+		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, end, &bits);
 		prealloc = NULL;
 		BUG_ON(err == -EEXIST);
@@ -811,6 +820,9 @@ hit_next:
 			err = -EEXIST;
 			goto out;
 		}
+
+		prealloc = alloc_extent_state_atomic(prealloc);
+		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
@@ -841,6 +853,9 @@ hit_next:
 			this_end = end;
 		else
 			this_end = last_start - 1;
+
+		prealloc = alloc_extent_state_atomic(prealloc);
+		BUG_ON(!prealloc);
 		err = insert_state(tree, prealloc, start, this_end,
 				   &bits);
 		BUG_ON(err == -EEXIST);
@@ -865,6 +880,9 @@ hit_next:
 			err = -EEXIST;
 			goto out;
 		}
+
+		prealloc = alloc_extent_state_atomic(prealloc);
+		BUG_ON(!prealloc);
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
 
-- 
1.7.4.2
