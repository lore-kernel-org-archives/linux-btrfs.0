Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35391 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbcCYR0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 13:26:09 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u2PHKjbi021158
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:08 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 21vva22wgv-1
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 10:26:08 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 02/14] Btrfs: fix callers of btrfs_block_rsv_migrate
Date: Fri, 25 Mar 2016 13:25:48 -0400
Message-ID: <1458926760-17563-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1458926760-17563-1-git-send-email-jbacik@fb.com>
References: <1458926760-17563-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So btrfs_block_rsv_migrate just unconditionally calls block_rsv_migrate_bytes.
Not only this but it unconditionally changes the size of the block_rsv.  This
isn't a bug strictly speaking, but it makes truncate block rsv's look funny
because every time we migrate bytes over its size grows, even though we only
want it to be a specific size.  So collapse this into one function that takes an
update_size argument and make truncate and evict not update the size for
consistency sake.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.h         |  4 ++--
 fs/btrfs/delayed-inode.c |  8 ++++----
 fs/btrfs/extent-tree.c   | 18 ++++++------------
 fs/btrfs/file.c          |  4 ++--
 fs/btrfs/inode.c         |  7 +++----
 fs/btrfs/relocation.c    |  2 +-
 6 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84a6a5b..b675066 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3646,8 +3646,8 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 			   struct btrfs_block_rsv *block_rsv, u64 min_reserved,
 			   enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
-			    struct btrfs_block_rsv *dst_rsv,
-			    u64 num_bytes);
+			    struct btrfs_block_rsv *dst_rsv, u64 num_bytes,
+			    int update_size);
 int btrfs_cond_migrate_bytes(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_rsv *dest, u64 num_bytes,
 			     int min_factor);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 6cef006..d3cda0f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -553,7 +553,7 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 	dst_rsv = &root->fs_info->delayed_block_rsv;
 
 	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
-	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
+	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 	if (!ret) {
 		trace_btrfs_space_reservation(root->fs_info, "delayed_item",
 					      item->key.objectid,
@@ -649,7 +649,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 		if (!ret)
 			goto out;
 
-		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
+		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 		if (!ret)
 			goto out;
 
@@ -663,12 +663,12 @@ static int btrfs_delayed_inode_reserve_metadata(
 		 * since this really shouldn't happen that often.
 		 */
 		ret = btrfs_block_rsv_migrate(&root->fs_info->global_block_rsv,
-					      dst_rsv, num_bytes);
+					      dst_rsv, num_bytes, 1);
 		goto out;
 	}
 
 migrate:
-	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
+	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 
 out:
 	/*
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c357c96..06f4e7b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5192,8 +5192,9 @@ static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 	}
 }
 
-static int block_rsv_migrate_bytes(struct btrfs_block_rsv *src,
-				   struct btrfs_block_rsv *dst, u64 num_bytes)
+int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src,
+			    struct btrfs_block_rsv *dst, u64 num_bytes,
+			    int update_size)
 {
 	int ret;
 
@@ -5201,7 +5202,7 @@ static int block_rsv_migrate_bytes(struct btrfs_block_rsv *src,
 	if (ret)
 		return ret;
 
-	block_rsv_add_bytes(dst, num_bytes, 1);
+	block_rsv_add_bytes(dst, num_bytes, update_size);
 	return 0;
 }
 
@@ -5308,13 +5309,6 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
-			    struct btrfs_block_rsv *dst_rsv,
-			    u64 num_bytes)
-{
-	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
-}
-
 void btrfs_block_rsv_release(struct btrfs_root *root,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes)
@@ -5494,7 +5488,7 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
 	trace_btrfs_space_reservation(root->fs_info, "orphan",
 				      btrfs_ino(inode), num_bytes, 1);
-	return block_rsv_migrate_bytes(src_rsv, dst_rsv, num_bytes);
+	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 }
 
 void btrfs_orphan_release_metadata(struct inode *inode)
@@ -5549,7 +5543,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				  BTRFS_RESERVE_FLUSH_ALL);
 
 	if (ret == -ENOSPC && use_global_rsv)
-		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes);
+		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes, 1);
 
 	if (ret && *qgroup_reserved)
 		btrfs_qgroup_free_meta(root, *qgroup_reserved);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15a09cb..0ce4bb3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2474,7 +2474,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	}
 
 	ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv, rsv,
-				      min_size);
+				      min_size, 0);
 	BUG_ON(ret);
 	trans->block_rsv = rsv;
 
@@ -2517,7 +2517,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv,
-					      rsv, min_size);
+					      rsv, min_size, 0);
 		BUG_ON(ret);	/* shouldn't happen */
 		trans->block_rsv = rsv;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 41a5688..723e4bb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5239,7 +5239,7 @@ void btrfs_evict_inode(struct inode *inode)
 		if (steal_from_global) {
 			if (!btrfs_check_space_for_delayed_refs(trans, root))
 				ret = btrfs_block_rsv_migrate(global_rsv, rsv,
-							      min_size);
+							      min_size, 0);
 			else
 				ret = -ENOSPC;
 		}
@@ -9072,7 +9072,7 @@ static int btrfs_truncate(struct inode *inode)
 
 	/* Migrate the slack space for the truncate to our reserve */
 	ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv, rsv,
-				      min_size);
+				      min_size, 0);
 	BUG_ON(ret);
 
 	/*
@@ -9112,7 +9112,7 @@ static int btrfs_truncate(struct inode *inode)
 		}
 
 		ret = btrfs_block_rsv_migrate(&root->fs_info->trans_block_rsv,
-					      rsv, min_size);
+					      rsv, min_size, 0);
 		BUG_ON(ret);	/* shouldn't happen */
 		trans->block_rsv = rsv;
 	}
@@ -9133,7 +9133,6 @@ static int btrfs_truncate(struct inode *inode)
 		ret = btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(root);
 	}
-
 out:
 	btrfs_free_block_rsv(root, rsv);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2bd0011..61efa5f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4644,7 +4644,7 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 	if (rc->merge_reloc_tree) {
 		ret = btrfs_block_rsv_migrate(&pending->block_rsv,
 					      rc->block_rsv,
-					      rc->nodes_relocated);
+					      rc->nodes_relocated, 1);
 		if (ret)
 			return ret;
 	}
-- 
2.5.0

