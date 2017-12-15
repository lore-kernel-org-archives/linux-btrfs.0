Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36008 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755406AbdLOT63 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Dec 2017 14:58:29 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBFJsRGD032595
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 11:58:28 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2evm2qr705-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 11:58:28 -0800
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.com>
Subject: [PATCH] btrfs: fix refcount_t usage when deleting btrfs_delayed_nodes
Date: Fri, 15 Dec 2017 11:58:27 -0800
Message-ID: <20171215195827.3952156-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcounts have a generic implementation and an asm optimized one.  The
generic version has extra debugging to make sure that once a refcount
goes to zero, refcount_inc won't increase it.

The btrfs delayed inode code wasn't expecting this, and we're tripping
over the warnings when the generic refcounts are used.  We ended up with
this race:

Process A                                         Process B
                                                  btrfs_get_delayed_node()
						  spin_lock(root->inode_lock)
						  radix_tree_lookup()
__btrfs_release_delayed_node()
refcount_dec_and_test(&delayed_node->refs)
our refcount is now zero
						  refcount_add(2) <---
						  warning here, refcount
                                                  unchanged

spin_lock(root->inode_lock)
radix_tree_delete()

With the generic refcounts, we actually warn again when process B above
tries to release his refcount because refcount_add() turned into a
no-op.

We saw this in production on older kernels without the asm optimized
refcounts.

The fix used here is to use refcount_inc_not_zero() to detect when the
object is in the middle of being freed and return NULL.  This is almost
always the right answer anyway, since we usually end up pitching the
delayed_node if it didn't have fresh data in it.

This also changes __btrfs_release_delayed_node() to remove the extra
check for zero refcounts before radix tree deletion.
btrfs_get_delayed_node() was the only path that was allowing refcounts
to go from zero to one.

Signed-off-by: Chris Mason <clm@fb.com>
Fixes: 6de5f18e7b0da
cc: <stable@vger.kernel.org> #4.12+
---
 fs/btrfs/delayed-inode.c | 45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5d73f79..84c54af 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -87,6 +87,7 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(
 
 	spin_lock(&root->inode_lock);
 	node = radix_tree_lookup(&root->delayed_nodes_tree, ino);
+
 	if (node) {
 		if (btrfs_inode->delayed_node) {
 			refcount_inc(&node->refs);	/* can be accessed */
@@ -94,9 +95,30 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(
 			spin_unlock(&root->inode_lock);
 			return node;
 		}
-		btrfs_inode->delayed_node = node;
-		/* can be accessed and cached in the inode */
-		refcount_add(2, &node->refs);
+
+		/* it's possible that we're racing into the middle of
+		 * removing this node from the radix tree.  In this case,
+		 * the refcount was zero and it should never go back
+		 * to one.  Just return NULL like it was never in the radix
+		 * at all; our release function is in the process of removing
+		 * it.
+		 *
+		 * Some implementations of refcount_inc refuse to
+		 * bump the refcount once it has hit zero.  If we don't do
+		 * this dance here, refcount_inc() may decide to
+		 * just WARN_ONCE() instead of actually bumping the refcount.
+		 *
+		 * If this node is properly in the radix, we want to
+		 * bump the refcount twice, once for the inode
+		 * and once for this get operation.
+		 */
+		if (refcount_inc_not_zero(&node->refs)) {
+			refcount_inc(&node->refs);
+			btrfs_inode->delayed_node = node;
+		} else {
+			node = NULL;
+		}
+
 		spin_unlock(&root->inode_lock);
 		return node;
 	}
@@ -254,17 +276,18 @@ static void __btrfs_release_delayed_node(
 	mutex_unlock(&delayed_node->mutex);
 
 	if (refcount_dec_and_test(&delayed_node->refs)) {
-		bool free = false;
 		struct btrfs_root *root = delayed_node->root;
+
 		spin_lock(&root->inode_lock);
-		if (refcount_read(&delayed_node->refs) == 0) {
-			radix_tree_delete(&root->delayed_nodes_tree,
-					  delayed_node->inode_id);
-			free = true;
-		}
+		/*
+		 * once our refcount goes to zero, nobody is allowed to
+		 * bump it back up.  We can delete it now
+		 */
+		ASSERT(refcount_read(&delayed_node->refs) == 0);
+		radix_tree_delete(&root->delayed_nodes_tree,
+				  delayed_node->inode_id);
 		spin_unlock(&root->inode_lock);
-		if (free)
-			kmem_cache_free(delayed_node_cache, delayed_node);
+		kmem_cache_free(delayed_node_cache, delayed_node);
 	}
 }
 
-- 
2.9.5

