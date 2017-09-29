Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33047 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752556AbdI2To3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 15:44:29 -0400
Received: by mail-qk0-f193.google.com with SMTP id b82so20592qkc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Sep 2017 12:44:28 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 14/21] btrfs: remove type argument from comp_tree_refs
Date: Fri, 29 Sep 2017 15:43:58 -0400
Message-Id: <1506714245-23072-15-git-send-email-jbacik@fb.com>
In-Reply-To: <1506714245-23072-1-git-send-email-jbacik@fb.com>
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can get this from the ref we've passed in.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index b9b41c838da4..a2973340a94f 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -41,9 +41,9 @@ struct kmem_cache *btrfs_delayed_extent_op_cachep;
  * compare two delayed tree backrefs with same bytenr and type
  */
 static int comp_tree_refs(struct btrfs_delayed_tree_ref *ref2,
-			  struct btrfs_delayed_tree_ref *ref1, int type)
+			  struct btrfs_delayed_tree_ref *ref1)
 {
-	if (type == BTRFS_TREE_BLOCK_REF_KEY) {
+	if (ref1->node.type == BTRFS_TREE_BLOCK_REF_KEY) {
 		if (ref1->root < ref2->root)
 			return -1;
 		if (ref1->root > ref2->root)
@@ -223,8 +223,7 @@ static bool merge_ref(struct btrfs_trans_handle *trans,
 		if ((ref->type == BTRFS_TREE_BLOCK_REF_KEY ||
 		     ref->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
 		    comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref),
-				   btrfs_delayed_node_to_tree_ref(next),
-				   ref->type))
+				   btrfs_delayed_node_to_tree_ref(next)))
 			goto next;
 		if ((ref->type == BTRFS_EXTENT_DATA_REF_KEY ||
 		     ref->type == BTRFS_SHARED_DATA_REF_KEY) &&
@@ -409,8 +408,7 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
 	if ((exist->type == BTRFS_TREE_BLOCK_REF_KEY ||
 	     exist->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
 	    comp_tree_refs(btrfs_delayed_node_to_tree_ref(exist),
-			   btrfs_delayed_node_to_tree_ref(ref),
-			   ref->type))
+			   btrfs_delayed_node_to_tree_ref(ref)))
 		goto add_tail;
 	if ((exist->type == BTRFS_EXTENT_DATA_REF_KEY ||
 	     exist->type == BTRFS_SHARED_DATA_REF_KEY) &&
-- 
2.7.4

