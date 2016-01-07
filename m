Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46302 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752401AbcAGBIq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:46 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 841AF41887CD
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:22 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 06/16] btrfs: delayed_ref: Add support for handle dedup hash
Date: Thu, 7 Jan 2016 09:08:07 +0800
Message-ID: <1452128897-5433-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support for delayed_ref to handle dedup_hash.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v3:
  Newly introduced.
---
 fs/btrfs/ctree.h       |  4 +++-
 fs/btrfs/delayed-ref.c |  3 ++-
 fs/btrfs/delayed-ref.h |  9 ++++++++-
 fs/btrfs/extent-tree.c | 17 ++++++++++++-----
 fs/btrfs/inode.c       |  2 +-
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 450790b..aa7f5fb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -48,6 +48,7 @@ extern struct kmem_cache *btrfs_bit_radix_cachep;
 extern struct kmem_cache *btrfs_path_cachep;
 extern struct kmem_cache *btrfs_free_space_cachep;
 struct btrfs_ordered_sum;
+struct btrfs_dedup_hash;
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 #define STATIC noinline
@@ -3436,7 +3437,8 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
 				     u64 offset, u64 ram_bytes,
-				     struct btrfs_key *ins);
+				     struct btrfs_key *ins,
+				     struct btrfs_dedup_hash *hash);
 int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   u64 root_objectid, u64 owner, u64 offset,
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 94609ec..fb9f47b 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -812,7 +812,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
-			       int atomic)
+			       int atomic, struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_delayed_data_ref *ref;
 	struct btrfs_delayed_ref_head *head_ref;
@@ -846,6 +846,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	}
 
 	head_ref->extent_op = NULL;
+	ref->hash = hash;
 
 	delayed_refs = &trans->transaction->delayed_refs;
 
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 8928fe7..d67766b 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -24,6 +24,7 @@
 #define BTRFS_ADD_DELAYED_EXTENT 3 /* record a full extent allocation */
 #define BTRFS_UPDATE_DELAYED_HEAD 4 /* not changing ref count on head ref */
 
+struct btrfs_dedup_hash;
 /*
  * XXX: Qu: I really hate the design that ref_head and tree/data ref shares the
  * same ref_node structure.
@@ -152,6 +153,12 @@ struct btrfs_delayed_data_ref {
 	u64 parent;
 	u64 objectid;
 	u64 offset;
+
+	/*
+	 * For dedup hash miss case, to add it into dedup tree at
+	 * run_delayed_ref() time.
+	 */
+	struct btrfs_dedup_hash *hash;
 };
 
 struct btrfs_delayed_ref_root {
@@ -249,7 +256,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
 			       u64 owner, u64 offset, u64 reserved, int action,
-			       int atomic);
+			       int atomic, struct btrfs_dedup_hash *hash);
 int btrfs_add_delayed_qgroup_reserve(struct btrfs_fs_info *fs_info,
 				     struct btrfs_trans_handle *trans,
 				     u64 ref_root, u64 bytenr, u64 num_bytes);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d80f74d..a2e4c2b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -36,6 +36,7 @@
 #include "math.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -2089,7 +2090,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
 					num_bytes, parent, root_objectid,
 					owner, offset, 0,
-					BTRFS_ADD_DELAYED_REF, 0);
+					BTRFS_ADD_DELAYED_REF, 0, NULL);
 	}
 	return ret;
 }
@@ -2109,7 +2110,7 @@ int btrfs_inc_extent_ref_atomic(struct btrfs_trans_handle *trans,
 		return -EINVAL;
 	return btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
 			num_bytes, parent, root_objectid,
-			owner, offset, 0, BTRFS_ADD_DELAYED_REF, 1);
+			owner, offset, 0, BTRFS_ADD_DELAYED_REF, 1, NULL);
 }
 
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
@@ -2196,6 +2197,10 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 		parent = ref->parent;
 	ref_root = ref->root;
 
+	/* Add dedup hash into hash tree and free it */
+	btrfs_dedup_add(trans, root, ref->hash);
+	kfree(ref->hash);
+
 	if (node->action == BTRFS_ADD_DELAYED_REF && insert_reserved) {
 		if (extent_op)
 			flags |= extent_op->flags_to_set;
@@ -6854,7 +6859,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 						num_bytes,
 						parent, root_objectid, owner,
 						offset, 0,
-						BTRFS_DROP_DELAYED_REF, 0);
+						BTRFS_DROP_DELAYED_REF, 0,
+						NULL);
 	}
 	return ret;
 }
@@ -7786,7 +7792,8 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     u64 root_objectid, u64 owner,
 				     u64 offset, u64 ram_bytes,
-				     struct btrfs_key *ins)
+				     struct btrfs_key *ins,
+				     struct btrfs_dedup_hash *hash)
 {
 	int ret;
 
@@ -7796,7 +7803,7 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 					 ins->offset, 0,
 					 root_objectid, owner, offset,
 					 ram_bytes, BTRFS_ADD_DELAYED_EXTENT,
-					 0);
+					 0, hash);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f82d1f4..832a733 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2134,7 +2134,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ret = btrfs_alloc_reserved_file_extent(trans, root,
 					root->root_key.objectid,
 					btrfs_ino(inode), file_pos,
-					ram_bytes, &ins);
+					ram_bytes, &ins, NULL);
 	/*
 	 * Release the reserved range from inode dirty range map, as it is
 	 * already moved into delayed_ref_head
-- 
2.6.4



