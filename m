Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33662 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdLLHfE (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 12 Dec 2017 02:35:04 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, jeffm@suse.com
Subject: [PATCH 07/14] btrfs: qgroup: Split meta rsv type into meta_prealloc and meta_pertrans
Date: Tue, 12 Dec 2017 15:34:29 +0800
Message-Id: <20171212073436.16447-8-wqu@suse.com>
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
References: <20171212073436.16447-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs uses 2 different method to resever metadata qgroup space.
1) Reserve at btrfs_start_transaction() time
   This is quite straightforward, caller will use the trans handler
   allocated to modify b-trees.

   In this case, reserved metadata should be kept until qgroup numbers
   are updated.

2) Reserve by using block_rsv first, and later btrfs_join_transaction()
   This is more complicated, caller will reserve space using block_rsv
   first, and then later call btrfs_join_transaction() to get a trans
   handler.

   In this case, before we modify trees, the reserved space can be
   modified on demand, and after btrfs_join_transaction(), such reserved
   space should also be kept until qgroup numbers are updated.

Since this two types behaves quite different to each other, split the
original "META" reservation type into 2 sub-types:
  META_PERTRANS:
    For above case 1)

  META_PREALLOC:
    For reservation happened before btrfs_join_transaction() of case 2)

NOTE: This patch will only convert existing qgroup meta reservation
callers according to its situation, not ensuring all callers are at
correct timing.
Such fix will be address in later patches.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c       |  8 +++---
 fs/btrfs/qgroup.c            | 22 +++++++-------
 fs/btrfs/qgroup.h            | 68 ++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/transaction.c       |  8 +++---
 include/trace/events/btrfs.h |  5 ++--
 5 files changed, 86 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 784d41e95ed9..32ce99574a2d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5996,7 +5996,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 		/* One for parent inode, two for dir entries */
 		num_bytes = 3 * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta(root, num_bytes, true);
+		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
 		if (ret)
 			return ret;
 	} else {
@@ -6015,7 +6015,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes, 1);
 
 	if (ret && *qgroup_reserved)
-		btrfs_qgroup_free_meta(root, *qgroup_reserved);
+		btrfs_qgroup_free_meta_prealloc(root, *qgroup_reserved);
 
 	return ret;
 }
@@ -6091,7 +6091,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 	spin_unlock(&inode->lock);
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-		ret = btrfs_qgroup_reserve_meta(root,
+		ret = btrfs_qgroup_reserve_meta_prealloc(root,
 				nr_extents * fs_info->nodesize, true);
 		if (ret)
 			goto out_fail;
@@ -6099,7 +6099,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 
 	ret = btrfs_inode_rsv_refill(inode, flush);
 	if (unlikely(ret)) {
-		btrfs_qgroup_free_meta(root,
+		btrfs_qgroup_free_meta_prealloc(root,
 				       nr_extents * fs_info->nodesize);
 		goto out_fail;
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 39bdf5341372..0b85ec21ac1d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -69,8 +69,10 @@ static const char *qgroup_rsv_type_str(enum btrfs_qgroup_rsv_type type)
 {
 	if (type == BTRFS_QGROUP_RSV_DATA)
 		return "data";
-	if (type == BTRFS_QGROUP_RSV_META)
-		return "meta";
+	if (type == BTRFS_QGROUP_RSV_META_PERTRANS)
+		return "meta_pertrans";
+	if (type == BTRFS_QGROUP_RSV_META_PREALLOC)
+		return "meta_prealloc";
 	return NULL;
 }
 #endif
@@ -3076,8 +3078,8 @@ int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len)
 	return __btrfs_qgroup_release_data(inode, NULL, start, len, 0);
 }
 
-int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-			      bool enforce)
+int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+				enum btrfs_qgroup_rsv_type type, bool enforce)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -3088,14 +3090,14 @@ int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
 
 	BUG_ON(num_bytes != round_down(num_bytes, fs_info->nodesize));
 	trace_qgroup_meta_reserve(root, (s64)num_bytes);
-	ret = qgroup_reserve(root, num_bytes, enforce, BTRFS_QGROUP_RSV_META);
+	ret = qgroup_reserve(root, num_bytes, enforce, type);
 	if (ret < 0)
 		return ret;
 	atomic64_add(num_bytes, &root->qgroup_meta_rsv);
 	return ret;
 }
 
-void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
+void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 reserved;
@@ -3109,10 +3111,11 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
 		return;
 	trace_qgroup_meta_reserve(root, -(s64)reserved);
 	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved,
-				  BTRFS_QGROUP_RSV_META);
+				  BTRFS_QGROUP_RSV_META_PERTRANS);
 }
 
-void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
+void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
+			      enum btrfs_qgroup_rsv_type type)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
@@ -3124,8 +3127,7 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 	WARN_ON(atomic64_read(&root->qgroup_meta_rsv) < num_bytes);
 	atomic64_sub(num_bytes, &root->qgroup_meta_rsv);
 	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
-	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes,
-				  BTRFS_QGROUP_RSV_META);
+	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes, type);
 }
 
 /*
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index c8c81b923674..b47740e2e017 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -61,9 +61,30 @@ struct btrfs_qgroup_extent_record {
 	struct ulist *old_roots;
 };
 
+/*
+ * Qgroup reservation types:
+ * DATA:
+ *	space reserved for data
+ *
+ * META_PERTRANS:
+ * 	Space reserved for metadata (per-transaction)
+ * 	Due to the fact that qgroup data is only updated at transaction commit
+ * 	time, reserved space for metadata must be kept until transaction
+ * 	commitment.
+ * 	Any metadata reserved used in btrfs_start_transaction() should be this
+ * 	type.
+ *
+ * META_PREALLOC:
+ *	There are cases where metadata space is reserved before starting
+ *	transaction, and then btrfs_join_transaction() to get a trans handler.
+ *	Any metadata reserved for such usage should be this type.
+ *	And after join_transaction() part (or all) of such reservation should
+ *	be converted into META_PERTRANS.
+ */
 enum btrfs_qgroup_rsv_type {
 	BTRFS_QGROUP_RSV_DATA = 0,
-	BTRFS_QGROUP_RSV_META,
+	BTRFS_QGROUP_RSV_META_PERTRANS,
+	BTRFS_QGROUP_RSV_META_PREALLOC,
 	BTRFS_QGROUP_RSV_LAST,
 };
 
@@ -270,9 +291,46 @@ int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
 
-int btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
-			      bool enforce);
-void btrfs_qgroup_free_meta_all(struct btrfs_root *root);
-void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes);
+int __btrfs_qgroup_reserve_meta(struct btrfs_root *root, int num_bytes,
+				enum btrfs_qgroup_rsv_type type, bool enforce);
+/* Reserve metadata space for pertrans and prealloc type*/
+static inline int btrfs_qgroup_reserve_meta_pertrans(struct btrfs_root *root,
+				int num_bytes, bool enforce)
+{
+	return __btrfs_qgroup_reserve_meta(root, num_bytes,
+			BTRFS_QGROUP_RSV_META_PERTRANS, enforce);
+}
+static inline int btrfs_qgroup_reserve_meta_prealloc(struct btrfs_root *root,
+				int num_bytes, bool enforce)
+{
+	return __btrfs_qgroup_reserve_meta(root, num_bytes,
+			BTRFS_QGROUP_RSV_META_PREALLOC, enforce);
+}
+
+void __btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes,
+			     enum btrfs_qgroup_rsv_type type);
+
+/* Free per-transaction meta reservation for error handler */
+static inline void btrfs_qgroup_free_meta_pertrans(struct btrfs_root *root,
+						   int num_bytes)
+{
+	__btrfs_qgroup_free_meta(root, num_bytes,
+			BTRFS_QGROUP_RSV_META_PERTRANS);
+}
+
+/* Pre-allocated meta reservation can be freed at need */
+static inline void btrfs_qgroup_free_meta_prealloc(struct btrfs_root *root,
+						   int num_bytes)
+{
+	__btrfs_qgroup_free_meta(root, num_bytes,
+			BTRFS_QGROUP_RSV_META_PREALLOC);
+}
+
+/*
+ * Per-transaction meta reservation should be all freed at transaction commit
+ * time
+ */
+void btrfs_qgroup_free_meta_all_pertrans(struct btrfs_root *root);
+
 void btrfs_qgroup_check_reserved_leak(struct inode *inode);
 #endif /* __BTRFS_QGROUP__ */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5a8c2649af2f..ddae813c01dd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -508,8 +508,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	 */
 	if (num_items && root != fs_info->chunk_root) {
 		qgroup_reserved = num_items * fs_info->nodesize;
-		ret = btrfs_qgroup_reserve_meta(root, qgroup_reserved,
-						enforce_qgroups);
+		ret = btrfs_qgroup_reserve_meta_pertrans(root, qgroup_reserved,
+				enforce_qgroups);
 		if (ret)
 			return ERR_PTR(ret);
 
@@ -606,7 +606,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		btrfs_block_rsv_release(fs_info, &fs_info->trans_block_rsv,
 					num_bytes);
 reserve_fail:
-	btrfs_qgroup_free_meta(root, qgroup_reserved);
+	btrfs_qgroup_free_meta_pertrans(root, qgroup_reserved);
 	return ERR_PTR(ret);
 }
 
@@ -1298,7 +1298,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans,
 			spin_lock(&fs_info->fs_roots_radix_lock);
 			if (err)
 				break;
-			btrfs_qgroup_free_meta_all(root);
+			btrfs_qgroup_free_meta_all_pertrans(root);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 56bf8d59b954..e05f794ae60b 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -72,8 +72,9 @@ TRACE_DEFINE_ENUM(COMMIT_TRANS);
 
 #define show_qgroup_rsv_type(type)					\
 	__print_symbolic(type,						\
-		{ BTRFS_QGROUP_RSV_DATA,	"DATA"	},		\
-		{ BTRFS_QGROUP_RSV_META,	"META"	})
+		{ BTRFS_QGROUP_RSV_DATA,	  "DATA"	},	\
+		{ BTRFS_QGROUP_RSV_META_PERTRANS, "META_PERTRANS" },	\
+		{ BTRFS_QGROUP_RSV_META_PREALLOC, "META_PREALLOC" })
 
 #define BTRFS_GROUP_FLAGS	\
 	{ BTRFS_BLOCK_GROUP_DATA,	"DATA"},	\
-- 
2.15.1

