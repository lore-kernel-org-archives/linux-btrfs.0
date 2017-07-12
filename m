Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42656 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755882AbdGLIul (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 04:50:41 -0400
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v14.4 08/15] btrfs: delayed-ref: Add support for increasing data ref under spinlock
Date: Wed, 12 Jul 2017 16:49:55 +0800
Message-ID: <20170712085002.23241-9-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170712085002.23241-1-lufq.fnst@cn.fujitsu.com>
References: <20170712085002.23241-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

For in-band dedupe, btrfs needs to increase data ref with delayed_ref
locked, so add a new function btrfs_add_delayed_data_ref_lock() to
increase extent ref with delayed_refs already locked.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 35 +++++++++++++++++++++++++++--------
 fs/btrfs/delayed-ref.h | 10 ++++++++++
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 93ffa898df6d..19110dd19ac9 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -843,6 +843,29 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
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
+			u64 owner, u64 offset, u64 reserved, int action,
+			int *qrecord_inserted_ret, int *old_ref_mod,
+			int *new_ref_mod)
+{
+	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node,
+			qrecord, bytenr, num_bytes, ref_root, reserved,
+			action, 1, qrecord_inserted_ret, old_ref_mod,
+			new_ref_mod);
+	add_delayed_data_ref(fs_info, trans, head_ref, &dref->node, bytenr,
+			num_bytes, parent, ref_root, owner, offset, action);
+}
+
+/*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
@@ -888,14 +911,10 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
-					bytenr, num_bytes, ref_root, reserved,
-					action, 1, &qrecord_inserted,
-					old_ref_mod, new_ref_mod);
-
-	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
-				   num_bytes, parent, ref_root, owner, offset,
-				   action);
+	btrfs_add_delayed_data_ref_locked(fs_info, trans, ref, head_ref, record,
+			bytenr, num_bytes, parent, ref_root, owner, offset,
+			reserved, action, &qrecord_inserted, old_ref_mod,
+			new_ref_mod);
 	spin_unlock(&delayed_refs->lock);
 
 	if (qrecord_inserted)
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index ce88e4ac5276..dc9761ec139a 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -243,12 +243,22 @@ static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
 	}
 }
 
+struct btrfs_qgroup_extent_record;
 int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
+void btrfs_add_delayed_data_ref_locked(struct btrfs_fs_info *fs_info,
+			struct btrfs_trans_handle *trans,
+			struct btrfs_delayed_data_ref *dref,
+			struct btrfs_delayed_ref_head *head_ref,
+			struct btrfs_qgroup_extent_record *qrecord,
+			u64 bytenr, u64 num_bytes, u64 parent, u64 ref_root,
+			u64 owner, u64 offset, u64 reserved, int action,
+			int *qrecord_inserted_ret, int *old_ref_mod,
+			int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
-- 
2.13.2



