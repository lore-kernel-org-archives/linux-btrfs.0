Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751865AbdF2D4Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 23:56:24 -0400
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, jeffm@suse.com, linux-btrfs@vger.kernel.org,
        lufq.fnst@cn.fujitsu.com
Subject: [PATCH v2 13/13] btrfs: clean up extraneous computations in add_delayed_refs
Date: Wed, 28 Jun 2017 21:57:05 -0600
Message-Id: <20170629035705.1589-14-enadolski@suse.com>
In-Reply-To: <20170629035705.1589-1-enadolski@suse.com>
References: <20170629035705.1589-1-enadolski@suse.com>
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
index 5011b2f..7393a6f 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -764,7 +764,7 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	struct btrfs_key tmp_op_key;
 	struct btrfs_key *op_key = NULL;
-	int sgn;
+	int count;
 	int ret = 0;
 
 	if (extent_op && extent_op->update_key) {
@@ -783,15 +783,15 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
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
@@ -800,9 +800,8 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 			ref = btrfs_delayed_node_to_tree_ref(node);
 			ret = add_indirect_ref(fs_info, preftrees, ref->root,
 					       &tmp_op_key, ref->level + 1,
-					       node->bytenr,
-					       node->ref_mod * sgn,
-					       sc, GFP_ATOMIC);
+					       node->bytenr, count, sc,
+					       GFP_ATOMIC);
 			break;
 		}
 		case BTRFS_SHARED_BLOCK_REF_KEY: {
@@ -811,9 +810,8 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 
 			ref = btrfs_delayed_node_to_tree_ref(node);
 
-			ret = add_direct_ref(fs_info, preftrees,
-					     ref->level + 1, ref->parent,
-					     node->bytenr, node->ref_mod * sgn,
+			ret = add_direct_ref(fs_info, preftrees, ref->level + 1,
+					     ref->parent, node->bytenr, count,
 					     sc, GFP_ATOMIC);
 			break;
 		}
@@ -836,9 +834,8 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
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
@@ -847,10 +844,9 @@ static int add_delayed_refs(const struct btrfs_fs_info *fs_info,
 
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

