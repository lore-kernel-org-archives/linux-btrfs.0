Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17474 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751459AbdCPH7d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 03:59:33 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id F0A7349F9A79
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Mar 2017 15:59:12 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v14.2 08/16] btrfs: delayed-ref: Add support for increasing data ref under spinlock
Date: Thu, 16 Mar 2017 15:58:46 +0800
Message-ID: <20170316075854.15788-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
References: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For in-band dedupe, btrfs needs to increase data ref with delayed_ref
locked, so add a new function btrfs_add_delayed_data_ref_lock() to
increase extent ref with delayed_refs already locked.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/delayed-ref.c | 31 ++++++++++++++++++++++++-------
 fs/btrfs/delayed-ref.h |  9 +++++++++
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 6eb80952efb3..18111563eef1 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -832,6 +832,27 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
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
+			int *qrecord_inserted_ret)
+{
+	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node,
+			qrecord, bytenr, num_bytes, ref_root, reserved,
+			action, 1, qrecord_inserted_ret);
+	add_delayed_data_ref(fs_info, trans, head_ref, &dref->node, bytenr,
+			num_bytes, parent, ref_root, owner, offset, action);
+}
+
+/*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
@@ -876,13 +897,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(fs_info, trans, &head_ref->node, record,
-					bytenr, num_bytes, ref_root, reserved,
-					action, 1, &qrecord_inserted);
-
-	add_delayed_data_ref(fs_info, trans, head_ref, &ref->node, bytenr,
-				   num_bytes, parent, ref_root, owner, offset,
-				   action);
+	btrfs_add_delayed_data_ref_locked(fs_info, trans, ref, head_ref, record,
+			bytenr, num_bytes, parent, ref_root, owner, offset,
+			reserved, action, &qrecord_inserted);
 	spin_unlock(&delayed_refs->lock);
 
 	if (qrecord_inserted)
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 0e537f98f1a1..94ee33a4d618 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -241,11 +241,20 @@ static inline void btrfs_put_delayed_ref(struct btrfs_delayed_ref_node *ref)
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
+			u64 owner, u64 offset, u64 reserved, int action,
+			int *qrecord_inserted_ret);
 int btrfs_add_delayed_data_ref(struct btrfs_fs_info *fs_info,
 			       struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
-- 
2.12.0



