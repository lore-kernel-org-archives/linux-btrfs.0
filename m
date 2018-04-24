Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56606 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758366AbeDXOSa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 10:18:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BE23EAF27
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 14:18:29 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 2/8] btrfs: Use init_delayed_ref_common in add_delayed_tree_ref
Date: Tue, 24 Apr 2018 17:18:18 +0300
Message-Id: <1524579504-30304-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1524579504-30304-1-git-send-email-nborisov@suse.com>
References: <1524579504-30304-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the newly introduced common helper.  No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index a0dc255792c7..1c27d3322198 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -708,38 +708,25 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_delayed_tree_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	u64 seq = 0;
+	u8 ref_type;
 	int ret;
 
-	if (action == BTRFS_ADD_DELAYED_EXTENT)
-		action = BTRFS_ADD_DELAYED_REF;
-
-	if (is_fstree(ref_root))
-		seq = atomic64_read(&fs_info->tree_mod_seq);
 	delayed_refs = &trans->transaction->delayed_refs;
-
-	/* first set the basic ref node struct up */
-	refcount_set(&ref->refs, 1);
-	ref->bytenr = bytenr;
-	ref->num_bytes = num_bytes;
-	ref->ref_mod = 1;
-	ref->action = action;
-	ref->is_head = 0;
-	ref->in_tree = 1;
-	ref->seq = seq;
-	RB_CLEAR_NODE(&ref->ref_node);
-	INIT_LIST_HEAD(&ref->add_list);
-
 	full_ref = btrfs_delayed_node_to_tree_ref(ref);
-	full_ref->parent = parent;
-	full_ref->root = ref_root;
 	if (parent)
-		ref->type = BTRFS_SHARED_BLOCK_REF_KEY;
+	        ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
 	else
-		ref->type = BTRFS_TREE_BLOCK_REF_KEY;
+	        ref_type = BTRFS_TREE_BLOCK_REF_KEY;
+
+	init_delayed_ref_common(fs_info, ref, bytenr, num_bytes, ref_root,
+				action, ref_type);
+	full_ref->root = ref_root;
+	full_ref->parent = parent;
 	full_ref->level = level;
 
-	trace_add_delayed_tree_ref(fs_info, ref, full_ref, action);
+	trace_add_delayed_tree_ref(fs_info, ref, full_ref,
+				   action == BTRFS_ADD_DELAYED_EXTENT ?
+				   BTRFS_ADD_DELAYED_REF : action);
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, ref);
 
-- 
2.7.4

