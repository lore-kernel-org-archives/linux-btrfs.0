Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56600 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758365AbeDXOSa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 10:18:30 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 76701AF25
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 14:18:29 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 1/8] btrfs: Factor out common delayed refs init code
Date: Tue, 24 Apr 2018 17:18:17 +0300
Message-Id: <1524579504-30304-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1524579504-30304-1-git-send-email-nborisov@suse.com>
References: <1524579504-30304-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

THe majority of the init code for struct btrfs_delayed_ref_node is
duplicated in add_delayed_data_ref and add_delayed_tree_ref. Factor
out the common bits in init_delayed_ref_common. This function is
going to be used in future patches to clean that up. No functional
changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-ref.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 4fb041e14742..a0dc255792c7 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -645,6 +645,57 @@ add_delayed_ref_head(struct btrfs_trans_handle *trans,
 }
 
 /*
+ * init_delayed_ref_common - Initialize the structure which represents a
+ *			     modification to a an extent.
+ *
+ * @fs_info:    Internal to the mounted filesystem mount structure.
+ *
+ * @ref:	The structure which is going to be initialized.
+ *
+ * @bytenr:	The logical address of the extent for which a modification is
+ *		going to be recorded.
+ *
+ * @num_bytes:  Size of the extent whose modification is being recorded.
+ *
+ * @ref_root:	The id of the root where this modification has originated, this
+ *		can be either one of the well-known metadata trees or the
+ *		subvolume id which references this extent.
+ *
+ * @action:	Can be one of BTRFS_ADD_DELAYED_REF/BTRFS_DROP_DELAYED_REF or
+ *		BTRFS_ADD_DELAYED_EXTENT
+ *
+ * @ref_type:	Holds the type of the extent which is being recorded, can be
+ *		one of BTRFS_SHARED_BLOCK_REF_KEY/BTRFS_TREE_BLOCK_REF_KEY
+ *		when recording a metadata extent or BTRFS_SHARED_DATA_REF_KEY/
+ *		BTRFS_EXTENT_DATA_REF_KEY when recording data extent
+ */
+static void init_delayed_ref_common(struct btrfs_fs_info *fs_info,
+				    struct btrfs_delayed_ref_node *ref,
+				    u64 bytenr, u64 num_bytes, u64 ref_root,
+				    int action, u8 ref_type)
+{
+	u64 seq = 0;
+
+	if (action == BTRFS_ADD_DELAYED_EXTENT)
+		action = BTRFS_ADD_DELAYED_REF;
+
+	if (is_fstree(ref_root))
+		seq = atomic64_read(&fs_info->tree_mod_seq);
+
+	refcount_set(&ref->refs, 1);
+	ref->bytenr = bytenr;
+	ref->num_bytes = num_bytes;
+	ref->ref_mod = 1;
+	ref->action = action;
+	ref->is_head = 0;
+	ref->in_tree = 1;
+	ref->seq = seq;
+	ref->type = ref_type;
+	RB_CLEAR_NODE(&ref->ref_node);
+	INIT_LIST_HEAD(&ref->add_list);
+}
+
+/*
  * helper to insert a delayed tree ref into the rbtree.
  */
 static noinline void
-- 
2.7.4

