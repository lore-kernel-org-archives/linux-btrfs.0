Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33070 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3DBAqH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 20:46:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id DAF739A0694
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2013 18:46:06 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id Bg8ER0jagzfcWvGO (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 01 Apr 2013 18:46:06 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: compare relevant parts of delayed tree refs
Date: Mon, 1 Apr 2013 20:46:04 -0400
Message-ID: <1364863564-3742-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a panic while running a balance.  What was happening was he was
relocating a block, which added the reference to the relocation tree.  Then
relocation would walk through the relocation tree and drop that reference and
free that block, and then it would walk down a snapshot which referenced the
same block and add another ref to the block.  The problem is this was all
happening in the same transaction, so the parent block was free'ed up when we
drop our reference which was immediately available for allocation, and then it
was used _again_ to add a reference for the same block from a different
snapshot.  This resulted in something like this in the delayed ref tree

add ref to 90234880, parent=2067398656, ref_root 1766, level 1
del ref to 90234880, parent=2067398656, ref_root 18446744073709551608, level 1
add ref to 90234880, parent=2067398656, ref_root 1767, level 1

as you can see the ref_root's don't match, because when we inc the ref we use
the header owner, which is the original tree the block belonged to, instead of
the data reloc tree.  Then when we remove the extent we use the reloc tree
objectid.  But none of this matters, since it is a shared reference which means
only the parent matters.  When the delayed ref stuff runs it adds all the
increments first, and then does all the drops, to make sure that we don't delete
the ref if we net a positive ref count.  But tree blocks aren't allowed to have
multiple refs from the same block, so this panics when it tries to add the
second ref.  We need the add and the drop to cancel each other out in memory so
we only do the final add.

So to fix this we need to adjust how the delayed refs are added to the tree.
Only the ref_root matters when it is a normal backref, and only the parent
matters when it is a shared backref.  So make our decision based on what ref
type we have.  This allows us to keep the ref_root in memory in case anybody
wants to use it for something else, and it allows the delayed refs to be merged
properly so we don't end up with this panic.

With this patch the users image no longer panics on mount, and it has a clean
fsck after a normal mount/umount cycle.  Thanks,

Cc: stable@vger.kernel.org
Reported-by: Roman Mamedov <rm@romanrm.ru>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/delayed-ref.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b7a0641..116abec 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -40,16 +40,19 @@ struct kmem_cache *btrfs_delayed_extent_op_cachep;
  * compare two delayed tree backrefs with same bytenr and type
  */
 static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
-			  struct btrfs_delayed_tree_ref *ref1)
+			  struct btrfs_delayed_tree_ref *ref1, int type)
 {
-	if (ref1->root < ref2->root)
-		return -1;
-	if (ref1->root > ref2->root)
-		return 1;
-	if (ref1->parent < ref2->parent)
-		return -1;
-	if (ref1->parent > ref2->parent)
-		return 1;
+	if (type == BTRFS_TREE_BLOCK_REF_KEY) {
+		if (ref1->root < ref2->root)
+			return -1;
+		if (ref1->root > ref2->root)
+			return 1;
+	} else {
+		if (ref1->parent < ref2->parent)
+			return -1;
+		if (ref1->parent > ref2->parent)
+			return 1;
+	}
 	return 0;
 }
 
@@ -113,7 +116,8 @@ static int comp_entry(struct btrfs_delayed_ref_node *ref2,
 	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY) {
 		return comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref2),
-				      btrfs_delayed_node_to_tree_ref(ref1));
+				      btrfs_delayed_node_to_tree_ref(ref1),
+				      ref1->type);
 	} else if (ref1->type == BTRFS_EXTENT_DATA_REF_KEY ||
 		   ref1->type == BTRFS_SHARED_DATA_REF_KEY) {
 		return comp_data_refs(btrfs_delayed_node_to_data_ref(ref2),
-- 
1.7.7.6

