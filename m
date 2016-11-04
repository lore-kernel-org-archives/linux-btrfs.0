Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32612 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933271AbcKDBdr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 21:33:47 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 3284841B4BC6
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Nov 2016 09:33:17 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v14 07/15] btrfs: delayed-ref: Add support for increasing data ref under spinlock
Date: Fri,  4 Nov 2016 09:32:56 +0800
Message-Id: <20161104013304.11365-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161104013304.11365-1-quwenruo@cn.fujitsu.com>
References: <20161104013304.11365-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For in-band dedupe, btrfs needs to increase data ref with delayed_ref
locked, so add a new function btrfs_add_delayed_data_ref_lock() to
increase extent ref with delayed_refs already locked.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 30 +++++++++++++++++++++++-------
 fs/btrfs/delayed-ref.h |  8 ++++++++
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 8d93854..dccce10 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -805,6 +805,26 @@ free_ref:
 }
 
 /*
+ * Do real delayed data ref insert.
+ * Caller must hold delayed_refs->lock and allocation memory
+ * for dref,head_ref and record.
+ */
+void btrfs_add_delayed_data_ref_locked(struct btrfs_fs_info *fs_info,
+			struct btrfs_trans_handle *trans,
+			struct btrfs_delayed_data_ref *dref,
+			struct btrfs_delayed_ref_head *head_ref,
+			struct btrfs_qgroup_extent_record *qrecord,
+			u64 bytenr, u64 num_bytes, u64 parent, u64 ref_root,
+			u64 owner, u64 offset, u64 reserved, int action)
+{
+	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node,
+			qrecord, bytenr, num_bytes, ref_root, reserved,
+			action, 1);
+	add_delayed_data_ref(fs_info, trans, head_ref, &dref->node, bytenr,
+			num_bytes, parent, ref_root, owner, offset, action);
+}
+
+/*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
@@ -850,13 +870,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
-					bytenr, num_bytes, ref_root, reserved,
-					action, 1);
-
-	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
-				   num_bytes, parent, ref_root, owner, offset,
-				   action);
+	btrfs_add_delayed_data_ref_locked(fs_info, trans, ref, head_ref, record,
+			bytenr, num_bytes, parent, ref_root, owner, offset,
+			reserved, action);
 	spin_unlock(&delayed_refs->lock);
 
 	return 0;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 43f3629..d3a4369 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -239,11 +239,19 @@ static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
 	}
 }
 
+struct btrfs_qgroup_extent_record;
 int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op);
+void btrfs_add_delayed_data_ref_locked(struct btrfs_fs_info *fs_info,
+			struct btrfs_trans_handle *trans,
+			struct btrfs_delayed_data_ref *dref,
+			struct btrfs_delayed_ref_head *head_ref,
+			struct btrfs_qgroup_extent_record *qrecord,
+			u64 bytenr, u64 num_bytes, u64 parent, u64 ref_root,
+			u64 owner, u64 offset, u64 reserved, int action);
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
-- 
2.10.1



