Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40353 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754336AbeFUIjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 04:39:23 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 392CDADFA
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2018 08:39:22 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Streamline memory allocation failure handling in btrfs_add_delayed_tree_ref
Date: Thu, 21 Jun 2018 11:39:20 +0300
Message-Id: <1529570360-9260-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently the function uses 2 goto labels to properly handle allocation
failures. This could be simplified by simply re-arranging the code so
that allocations are the in the beginning of the function. This allows
to use simple return statements. No function changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Suggested-by: Su Yue <suy.fnst@cn.fujitsu.com>
Suggested-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/delayed-ref.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 03dec673d12a..c2c2634693e1 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -730,27 +730,33 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 	if (!ref)
 		return -ENOMEM;
 
+	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
+	if (!head_ref) {
+		kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+		return -ENOMEM;
+	}
+
+	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
+	    is_fstree(ref_root)) {
+		record = kmalloc(sizeof(*record), GFP_NOFS);
+		if (!record) {
+			kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
+			kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
+			return -ENOMEM;
+		}
+	}
+
 	if (parent)
 		ref_type = BTRFS_SHARED_BLOCK_REF_KEY;
 	else
 		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
+
 	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
 				ref_root, action, ref_type);
 	ref->root = ref_root;
 	ref->parent = parent;
 	ref->level = level;
 
-	head_ref = kmem_cache_alloc(btrfs_delayed_ref_head_cachep, GFP_NOFS);
-	if (!head_ref)
-		goto free_ref;
-
-	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags) &&
-	    is_fstree(ref_root)) {
-		record = kmalloc(sizeof(*record), GFP_NOFS);
-		if (!record)
-			goto free_head_ref;
-	}
-
 	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
 			      ref_root, 0, action, false, is_system);
 	head_ref->extent_op = extent_op;
@@ -779,13 +785,6 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		btrfs_qgroup_trace_extent_post(fs_info, record);
 
 	return 0;
-
-free_head_ref:
-	kmem_cache_free(btrfs_delayed_ref_head_cachep, head_ref);
-free_ref:
-	kmem_cache_free(btrfs_delayed_tree_ref_cachep, ref);
-
-	return -ENOMEM;
 }
 
 /*
-- 
2.7.4

