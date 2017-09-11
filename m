Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36331 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdIKVM6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 17:12:58 -0400
Received: by mail-qk0-f196.google.com with SMTP id i14so6150826qke.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 14:12:58 -0700 (PDT)
From: josef@toxicpanda.com
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 09/10] btrfs: add a comp_refs() helper
Date: Mon, 11 Sep 2017 17:12:35 -0400
Message-Id: <1505164356-13474-10-git-send-email-jbacik@fb.com>
In-Reply-To: <1505164356-13474-1-git-send-email-jbacik@fb.com>
References: <1505164356-13474-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Instead of open-coding the delayed ref comparisons, add a helper to do
the comparisons generically and use that everywhere.  We compare
sequence numbers last for following patches.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 54 ++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index c5de6c7..da209cb 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -85,6 +85,34 @@ static int comp_data_refs(struct btrfs_delayed_data_ref *ref1,
 	return 0;
 }
 
+static int comp_refs(struct btrfs_delayed_ref_node *ref1,
+		     struct btrfs_delayed_ref_node *ref2,
+		     bool check_seq)
+{
+	int ret = 0;
+	if (ref1->type < ref2->type)
+		return -1;
+	if (ref1->type > ref2->type)
+		return 1;
+	if (ref1->type == BTRFS_TREE_BLOCK_REF_KEY ||
+	    ref1->type == BTRFS_SHARED_BLOCK_REF_KEY)
+		ret = comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref1),
+				     btrfs_delayed_node_to_tree_ref(ref2));
+	else
+		ret = comp_data_refs(btrfs_delayed_node_to_data_ref(ref1),
+				     btrfs_delayed_node_to_data_ref(ref2));
+	if (ret)
+		return ret;
+	if (check_seq) {
+		if (ref1->seq < ref2->seq)
+			return -1;
+		if (ref1->seq > ref2->seq)
+			return 1;
+	}
+	return 0;
+}
+
+
 /* insert a new ref to head ref rbtree */
 static struct btrfs_delayed_ref_head *htree_insert(struct rb_root *root,
 						   struct rb_node *node)
@@ -217,18 +245,7 @@ static bool merge_ref(struct btrfs_trans_handle *trans,
 		if (seq && next->seq >= seq)
 			goto next;
 
-		if (next->type != ref->type)
-			goto next;
-
-		if ((ref->type == BTRFS_TREE_BLOCK_REF_KEY ||
-		     ref->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
-		    comp_tree_refs(btrfs_delayed_node_to_tree_ref(ref),
-				   btrfs_delayed_node_to_tree_ref(next)))
-			goto next;
-		if ((ref->type == BTRFS_EXTENT_DATA_REF_KEY ||
-		     ref->type == BTRFS_SHARED_DATA_REF_KEY) &&
-		    comp_data_refs(btrfs_delayed_node_to_data_ref(ref),
-				   btrfs_delayed_node_to_data_ref(next)))
+		if (comp_refs(ref, next, false))
 			goto next;
 
 		if (ref->action == next->action) {
@@ -402,18 +419,7 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
 	exist = list_entry(href->ref_list.prev, struct btrfs_delayed_ref_node,
 			   list);
 	/* No need to compare bytenr nor is_head */
-	if (exist->type != ref->type || exist->seq != ref->seq)
-		goto add_tail;
-
-	if ((exist->type == BTRFS_TREE_BLOCK_REF_KEY ||
-	     exist->type == BTRFS_SHARED_BLOCK_REF_KEY) &&
-	    comp_tree_refs(btrfs_delayed_node_to_tree_ref(exist),
-			   btrfs_delayed_node_to_tree_ref(ref)))
-		goto add_tail;
-	if ((exist->type == BTRFS_EXTENT_DATA_REF_KEY ||
-	     exist->type == BTRFS_SHARED_DATA_REF_KEY) &&
-	    comp_data_refs(btrfs_delayed_node_to_data_ref(exist),
-			   btrfs_delayed_node_to_data_ref(ref)))
+	if (comp_refs(exist, ref, true))
 		goto add_tail;
 
 	/* Now we are sure we can merge */
-- 
2.7.4

