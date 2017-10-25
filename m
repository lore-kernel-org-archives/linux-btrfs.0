Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:49148 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdJYCzG (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 24 Oct 2017 22:55:06 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 1/6] btrfs: qgroup: Skeleton to support separate qgroup reservation type
Date: Wed, 25 Oct 2017 10:54:40 +0800
Message-Id: <20171025025445.16617-2-wqu@suse.com>
In-Reply-To: <20171025025445.16617-1-wqu@suse.com>
References: <20171025025445.16617-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of single qgroup->reserved, use a new structure btrfs_qgroup_rsv
to restore different types of reservation.

This patch only updates the header and needed modification to pass
compile.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 16 ++++++++++------
 fs/btrfs/qgroup.h | 27 +++++++++++++++++++++++++--
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index e172d4843eae..fe3adb996883 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2444,7 +2444,8 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
 }
 
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
-			       u64 ref_root, u64 num_bytes)
+			       u64 ref_root, u64 num_bytes,
+			       enum btrfs_qgroup_rsv_type type)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -2936,7 +2937,8 @@ static int qgroup_free_reserved_data(struct inode *inode,
 			goto out;
 		freed += changeset.bytes_changed;
 	}
-	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed);
+	btrfs_qgroup_free_refroot(root->fs_info, root->objectid, freed,
+				  BTRFS_QGROUP_RSV_DATA);
 	ret = freed;
 out:
 	extent_changeset_release(&changeset);
@@ -2968,7 +2970,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
 	if (free)
 		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
 				BTRFS_I(inode)->root->objectid,
-				changeset.bytes_changed);
+				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
 	ret = changeset.bytes_changed;
 out:
 	extent_changeset_release(&changeset);
@@ -3045,7 +3047,8 @@ void btrfs_qgroup_free_meta_all(struct btrfs_root *root)
 	if (reserved == 0)
 		return;
 	trace_qgroup_meta_reserve(root, -(s64)reserved);
-	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved);
+	btrfs_qgroup_free_refroot(fs_info, root->objectid, reserved,
+				  BTRFS_QGROUP_RSV_META);
 }
 
 void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
@@ -3060,7 +3063,8 @@ void btrfs_qgroup_free_meta(struct btrfs_root *root, int num_bytes)
 	WARN_ON(atomic64_read(&root->qgroup_meta_rsv) < num_bytes);
 	atomic64_sub(num_bytes, &root->qgroup_meta_rsv);
 	trace_qgroup_meta_reserve(root, -(s64)num_bytes);
-	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes);
+	btrfs_qgroup_free_refroot(fs_info, root->objectid, num_bytes,
+				  BTRFS_QGROUP_RSV_META);
 }
 
 /*
@@ -3088,7 +3092,7 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
 		}
 		btrfs_qgroup_free_refroot(BTRFS_I(inode)->root->fs_info,
 				BTRFS_I(inode)->root->objectid,
-				changeset.bytes_changed);
+				changeset.bytes_changed, BTRFS_QGROUP_RSV_DATA);
 
 	}
 	extent_changeset_release(&changeset);
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index d9984e87cddf..fead9955af72 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -61,6 +61,26 @@ struct btrfs_qgroup_extent_record {
 	struct ulist *old_roots;
 };
 
+enum btrfs_qgroup_rsv_type {
+	BTRFS_QGROUP_RSV_DATA = 0,
+	BTRFS_QGROUP_RSV_META,
+	BTRFS_QGROUP_RSV_LAST,
+};
+
+/*
+ * Represents how many bytes we have reserved for this qgroup.
+ *
+ * Each type should have different reservation behavior.
+ * E.g, data follows its io_tree flag modification, while
+ * *currently* meta is just reserve-and-clear during transcation.
+ *
+ * TODO: Add new type for reservation which can survive transaction commit.
+ * Currect metadata reservation behavior is not suitable for such case.
+ */
+struct btrfs_qgroup_rsv {
+	u64 values[BTRFS_QGROUP_RSV_LAST];
+};
+
 /*
  * one struct for each qgroup, organized in fs_info->qgroup_tree.
  */
@@ -88,6 +108,7 @@ struct btrfs_qgroup {
 	 * reservation tracking
 	 */
 	u64 reserved;
+	struct btrfs_qgroup_rsv rsv;
 
 	/*
 	 * lists
@@ -228,12 +249,14 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
-			       u64 ref_root, u64 num_bytes);
+			       u64 ref_root, u64 num_bytes,
+			       enum btrfs_qgroup_rsv_type type);
 static inline void btrfs_qgroup_free_delayed_ref(struct btrfs_fs_info *fs_info,
 						 u64 ref_root, u64 num_bytes)
 {
 	trace_btrfs_qgroup_free_delayed_ref(fs_info, ref_root, num_bytes);
-	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes);
+	btrfs_qgroup_free_refroot(fs_info, ref_root, num_bytes,
+				  BTRFS_QGROUP_RSV_DATA);
 }
 
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-- 
2.14.2

