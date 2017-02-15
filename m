Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57397 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752358AbdBOV2n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:28:43 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3BE2AD39
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 21:28:41 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 7/8] btrfs: drop unused extent_op arg from btrfs_add_delayed_data_ref
Date: Wed, 15 Feb 2017 16:28:33 -0500
Message-Id: <1487194114-12786-8-git-send-email-jeffm@suse.com>
In-Reply-To: <1487194114-12786-1-git-send-email-jeffm@suse.com>
References: <1487194114-12786-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_add_delayed_data_ref is always called with a NULL extent_op,
so let's drop the argument.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/delayed-ref.c | 6 ++----
 fs/btrfs/delayed-ref.h | 3 +--
 fs/btrfs/extent-tree.c | 7 +++----
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ef724a5..c66f487 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -829,15 +829,13 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action,
-			       struct btrfs_delayed_extent_op *extent_op)
+			       u64 owner, u64 offset, u64 reserved, int action)
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_qgroup_extent_record *record = NULL;
 
-	BUG_ON(extent_op && !extent_op->is_data);
 	ref = kmem_cache_alloc(btrfs_delayed_data_ref_cachep, GFP_NOFS);
 	if (!ref)
 		return -ENOMEM;
@@ -859,7 +857,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	head_ref->extent_op = extent_op;
+	head_ref->extent_op = NULL;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 50947b5..8a0220f 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -250,8 +250,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-			       u64 owner, u64 offset, u64 reserved, int action,
-			       struct btrfs_delayed_extent_op *extent_op);
+			       u64 owner, u64 offset, u64 reserved, int action);
 int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 				struct btrfs_trans_handle *trans,
 				u64 bytenr, u64 num_bytes,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a557249..65507ec 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2095,7 +2095,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
 					num_bytes, parent, root_objectid,
 					owner, offset, 0,
-					BTRFS_ADD_DELAYED_REF, NULL);
+					BTRFS_ADD_DELAYED_REF);
 	}
 	return ret;
 }
@@ -7249,7 +7249,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 						num_bytes,
 						parent, root_objectid, owner,
 						offset, 0,
-						BTRFS_DROP_DELAYED_REF, NULL);
+						BTRFS_DROP_DELAYED_REF);
 	}
 	return ret;
 }
@@ -8198,8 +8198,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ret = btrfs_add_delayed_data_ref(fs_info, trans, ins->objectid,
 					 ins->offset, 0,
 					 root_objectid, owner, offset,
-					 ram_bytes, BTRFS_ADD_DELAYED_EXTENT,
-					 NULL);
+					 ram_bytes, BTRFS_ADD_DELAYED_EXTENT); 
 	return ret;
 }
 
-- 
2.7.1

