Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751927AbdFTQGV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 12:06:21 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A994CAC2F
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 16:06:09 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 13/13] btrfs: clean up extraneous computations in add_delayed_refs
Date: Tue, 20 Jun 2017 10:06:53 -0600
Message-Id: <20170620160653.19907-14-enadolski@suse.com>
In-Reply-To: <20170620160653.19907-1-enadolski@suse.com>
References: <20170620160653.19907-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Repeating the same computation in multiple places is not
necessary.

Signed-off-by: Edmund Nadolski <enadolski@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7f02c51..05f37bb 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -761,7 +761,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
 	struct btrfs_key key;
 	struct btrfs_key op_key = {0};
-	int sgn;
+	int count;
 	int ret = 0;
 
 	if (extent_op && extent_op->update_key)
@@ -778,15 +778,15 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			WARN_ON(1);
 			continue;
 		case BTRFS_ADD_DELAYED_REF:
-			sgn = 1;
+			count = node->ref_mod;
 			break;
 		case BTRFS_DROP_DELAYED_REF:
-			sgn = -1;
+			count = node->ref_mod * -1;
 			break;
 		default:
 			BUG_ON(1);
 		}
-		*total_refs += (node->ref_mod * sgn);
+		*total_refs += count;
 		switch (node->type) {
 		case BTRFS_TREE_BLOCK_REF_KEY: {
 			/* NORMAL INDIRECT METADATA backref */
@@ -795,9 +795,8 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			ref = btrfs_delayed_node_to_tree_ref(node);
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
 					       &op_key, ref->level + 1,
-					       node->bytenr,
-					       node->ref_mod * sgn,
-					       sc, GFP_ATOMIC);
+					       node->bytenr, count, sc,
+					       GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_SHARED_BLOCK_REF_KEY: {
@@ -806,9 +805,8 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
 
-			ret = add_direct_ref(fs_info, preftrees,
-					     ref->level + 1, ref->parent,
-					     node->bytenr, node->ref_mod * sgn,
+			ret = add_direct_ref(fs_info, preftrees, ref->level + 1,
+					     ref->parent, node->bytenr, count,
 					     sc, GFP_ATOMIC);
 			break;
 		}
@@ -831,9 +829,8 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			}
 
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
-					       &key, 0, node->bytenr,
-					       node->ref_mod * sgn,
-					       sc, GFP_ATOMIC);
+					       &key, 0, node->bytenr, count, sc,
+					       GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_SHARED_DATA_REF_KEY: {
@@ -842,10 +839,9 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 
 			ref = btrfs_delayed_node_to_data_ref(node);
 
-			ret = add_direct_ref(fs_info, preftrees, 0,
-					     ref->parent, node->bytenr,
-					     node->ref_mod * sgn,
-					     sc, GFP_ATOMIC);
+			ret = add_direct_ref(fs_info, preftrees, 0, ref->parent,
+					     node->bytenr, count, sc,
+					     GFP_ATOMIC);
 			break;
 		}
 		default:
-- 
2.10.2

