Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3F0C46475
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FA52081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6FA52081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbeKFQFU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:20 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:31748 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387527AbeKFQFT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:19 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417655"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:41:32 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 6644B4B71EA0;
        Tue,  6 Nov 2018 14:41:33 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:41:36 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15.1 05/13] btrfs: delayed-ref: Add support for increasing data ref under spinlock
Date:   Tue, 6 Nov 2018 14:41:14 +0800
Message-ID: <20181106064122.6154-6-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 6644B4B71EA0.A8E0F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

For in-band dedupe, btrfs needs to increase data ref with delayed_ref
locked, so add a new function btrfs_add_delayed_data_ref_lock() to
increase extent ref with delayed_refs already locked. Export
init_delayed_ref_head and init_delayed_ref_common for inband dedupe.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-ref.c | 53 +++++++++++++++++++++++++++++-------------
 fs/btrfs/delayed-ref.h | 15 ++++++++++++
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 9301b3ad9217..ae8968f10ce0 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -533,7 +533,7 @@ update_existing_head_ref(struct btrfs_delayed_ref_root *delayed_refs,
 	spin_unlock(&existing->lock);
 }
 
-static void init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
+void btrfs_init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
 				  struct btrfs_qgroup_extent_record *qrecord,
 				  u64 bytenr, u64 num_bytes, u64 ref_root,
 				  u64 reserved, int action, bool is_data,
@@ -661,7 +661,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 }
 
 /*
- * init_delayed_ref_common - Initialize the structure which represents a
+ * btrfs_init_delayed_ref_common - Initialize the structure which represents a
  *			     modification to a an extent.
  *
  * @fs_info:    Internal to the mounted filesystem mount structure.
@@ -685,7 +685,7 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
  *		when recording a metadata extent or BTRFS_SHARED_DATA_REF_KEY/
  *		BTRFS_EXTENT_DATA_REF_KEY when recording data extent
  */
-static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
+void btrfs_init_delayed_ref_common(struct btrfs_fs_info *fs_info,
 				    struct btrfs_delayed_ref_node *ref,
 				    u64 bytenr, u64 num_bytes, u64 ref_root,
 				    int action, u8 ref_type)
@@ -758,14 +758,14 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	else
 		ref_type = BTRFS_TREE_BLOCK_REF_KEY;
 
-	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
-				ref_root, action, ref_type);
+	btrfs_init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+				      ref_root, action, ref_type);
 	ref->root = ref_root;
 	ref->parent = parent;
 	ref->level = level;
 
-	init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
-			      ref_root, 0, action, false, is_system);
+	btrfs_init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
+				    ref_root, 0, action, false, is_system);
 	head_ref->extent_op = extent_op;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -794,6 +794,29 @@ int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
+ * Do real delayed data ref insert.
+ * Caller must hold delayed_refs->lock and allocation memory
+ * for dref,head_ref and record.
+ */
+int btrfs_add_delayed_data_ref_locked(struct btrfs_trans_handle *trans,
+			struct btrfs_delayed_ref_head *head_ref,
+			struct btrfs_qgroup_extent_record *qrecord,
+			struct btrfs_delayed_data_ref *ref, int action,
+			int *qrecord_inserted_ret, int *old_ref_mod,
+			int *new_ref_mod)
+{
+	struct btrfs_delayed_ref_root *delayed_refs;
+
+	head_ref = add_delayed_ref_head(trans, head_ref, qrecord,
+					action, qrecord_inserted_ret,
+					old_ref_mod, new_ref_mod);
+
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	return insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
+}
+
 /*
  * add a delayed data ref. it's similar to btrfs_add_delayed_tree_ref.
  */
@@ -820,7 +843,7 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	        ref_type = BTRFS_SHARED_DATA_REF_KEY;
 	else
 	        ref_type = BTRFS_EXTENT_DATA_REF_KEY;
-	init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
+	btrfs_init_delayed_ref_common(fs_info, &ref->node, bytenr, num_bytes,
 				ref_root, action, ref_type);
 	ref->root = ref_root;
 	ref->parent = parent;
@@ -845,8 +868,8 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	init_delayed_ref_head(head_ref, record, bytenr, num_bytes, ref_root,
-			      reserved, action, true, false);
+	btrfs_init_delayed_ref_head(head_ref, record, bytenr, num_bytes,
+			      ref_root, reserved, action, true, false);
 	head_ref->extent_op = NULL;
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -856,11 +879,9 @@ int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 	 * insert both the head node and the new ref without dropping
 	 * the spin lock
 	 */
-	head_ref = add_delayed_ref_head(trans, head_ref, record,
-					action, &qrecord_inserted,
-					old_ref_mod, new_ref_mod);
-
-	ret = insert_delayed_ref(trans, delayed_refs, head_ref, &ref->node);
+	ret = btrfs_add_delayed_data_ref_locked(trans, head_ref,
+			record, ref, action, &qrecord_inserted, old_ref_mod,
+			new_ref_mod);
 	spin_unlock(&delayed_refs->lock);
 
 	trace_add_delayed_data_ref(trans->fs_info, &ref->node, ref,
@@ -887,7 +908,7 @@ int btrfs_add_delayed_extent_op(struct btrfs_fs_info *fs_info,
 	if (!head_ref)
 		return -ENOMEM;
 
-	init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes, 0, 0,
+	btrfs_init_delayed_ref_head(head_ref, NULL, bytenr, num_bytes, 0, 0,
 			      BTRFS_UPDATE_DELAYED_HEAD, extent_op->is_data,
 			      false);
 	head_ref->extent_op = extent_op;
diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index 8e20c5cb5404..208941e3cca0 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -234,11 +234,26 @@ static inline void btrfs_put_delayed_ref_head(struct btrfs_delayed_ref_head *hea
 		kmem_cache_free(btrfs_delayed_ref_head_cachep, head);
 }
 
+void btrfs_init_delayed_ref_head(struct btrfs_delayed_ref_head *head_ref,
+				  struct btrfs_qgroup_extent_record *qrecord,
+				  u64 bytenr, u64 num_bytes, u64 ref_root,
+				  u64 reserved, int action, bool is_data,
+				  bool is_system);
+void btrfs_init_delayed_ref_common(struct btrfs_fs_info *fs_info,
+				    struct btrfs_delayed_ref_node *ref,
+				    u64 bytenr, u64 num_bytes, u64 ref_root,
+				    int action, u8 ref_type);
 int btrfs_add_delayed_tree_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes, u64 parent,
 			       u64 ref_root, int level, int action,
 			       struct btrfs_delayed_extent_op *extent_op,
 			       int *old_ref_mod, int *new_ref_mod);
+int btrfs_add_delayed_data_ref_locked(struct btrfs_trans_handle *trans,
+			struct btrfs_delayed_ref_head *head_ref,
+			struct btrfs_qgroup_extent_record *qrecord,
+			struct btrfs_delayed_data_ref *ref, int action,
+			int *qrecord_inserted_ret, int *old_ref_mod,
+			int *new_ref_mod);
 int btrfs_add_delayed_data_ref(struct btrfs_trans_handle *trans,
 			       u64 bytenr, u64 num_bytes,
 			       u64 parent, u64 ref_root,
-- 
2.19.1



