Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48875 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751472AbeCUIpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 04:45:17 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88343ACFC
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 08:45:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/8] btrfs: Use init_delayed_ref_common in add_delayed_data_ref
Date: Wed, 21 Mar 2018 10:45:07 +0200
Message-Id: <1521621912-25065-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1521621912-25065-1-git-send-email-nborisov@suse.com>
References: <1521621912-25065-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the newly introduced helper and remove the duplicate code.
No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 4e009b3f0ec9..7ec2282d2fe0 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -763,41 +763,27 @@ add_delayed_data_ref(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_delayed_data_ref *full_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
-	u64 seq = 0;
+	u8 ref_type;
 	int ret;
 
-	if (action == BTRFS_ADD_DELAYED_EXTENT)
-		action = BTRFS_ADD_DELAYED_REF;
 
 	delayed_refs = &trans->transaction->delayed_refs;
-
-	if (is_fstree(ref_root))
-		seq = atomic64_read(&trans->fs_info->tree_mod_seq);
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
 	full_ref = btrfs_delayed_node_to_data_ref(ref);
-	full_ref->parent = parent;
-	full_ref->root = ref_root;
 	if (parent)
-		ref->type = BTRFS_SHARED_DATA_REF_KEY;
+	        ref_type = BTRFS_SHARED_DATA_REF_KEY;
 	else
-		ref->type = BTRFS_EXTENT_DATA_REF_KEY;
+	        ref_type = BTRFS_EXTENT_DATA_REF_KEY;
 
+	init_delayed_ref_common(trans->fs_info, ref, bytenr, num_bytes,
+				ref_root, action, ref_type);
+	full_ref->root = ref_root;
+	full_ref->parent = parent;
 	full_ref->objectid = owner;
 	full_ref->offset = offset;
 
-	trace_add_delayed_data_ref(trans->fs_info, ref, full_ref, action);
+	trace_add_delayed_data_ref(trans->fs_info, ref, full_ref,
+				   action == BTRFS_ADD_DELAYED_EXTENT ?
+				   BTRFS_ADD_DELAYED_REF : action);
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, ref);
 	if (ret > 0)
-- 
2.7.4

