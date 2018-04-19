Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752703AbeDSIGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 04:06:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68659AEA4
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 08:06:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Drop fs_info parameter from add_delayed_data_ref
Date: Thu, 19 Apr 2018 11:06:38 +0300
Message-Id: <1524125199-5435-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1524125199-5435-1-git-send-email-nborisov@suse.com>
References: <1524125199-5435-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index c0608cbf1354..f343ee0b143a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -701,8 +701,7 @@ add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
  * helper to insert a delayed data ref into the rbtree.
  */
 static noinline void
-add_delayed_data_ref(struct btrfs_fs_info *fs_info,
-		     struct btrfs_trans_handle *trans,
+add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		     struct btrfs_delayed_ref_head *head_ref,
 		     struct btrfs_delayed_ref_node *ref, u64 bytenr,
 		     u64 num_bytes, u64 parent, u64 ref_root, u64 owner,
@@ -719,7 +718,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	delayed_refs = &trans->transaction->delayed_refs;
 
 	if (is_fstree(ref_root))
-		seq = atomic64_read(&fs_info->tree_mod_seq);
+		seq = atomic64_read(&trans->fs_info->tree_mod_seq);
 
 	/* first set the basic ref node struct up */
 	refcount_set(&ref->refs, 1);
@@ -744,7 +743,7 @@ add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	full_ref->objectid = owner;
 	full_ref->offset = offset;
 
-	trace_add_delayed_data_ref(fs_info, ref, full_ref, action);
+	trace_add_delayed_data_ref(trans->fs_info, ref, full_ref, action);
 
 	ret = insert_delayed_ref(trans, delayed_refs, head_ref, ref);
 	if (ret > 0)
@@ -867,9 +866,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 					action, 1, &qrecord_inserted,
 					old_ref_mod, new_ref_mod);
 
-	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
-				   num_bytes, parent, ref_root, owner, offset,
-				   action);
+	add_delayed_data_ref(trans, head_ref, &ref->node, bytenr, num_bytes,
+			     parent, ref_root, owner, offset, action);
 	spin_unlock(&delayed_refs->lock);
 
 	if (qrecord_inserted)
-- 
2.7.4

