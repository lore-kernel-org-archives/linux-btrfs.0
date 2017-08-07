Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31845 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdHGW4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:56:49 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77MumkK019803
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v77MulYl027532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v77MulGU000365
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:47 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/7] Btrfs: add a helper to retrive extent inline ref type
Date: Mon,  7 Aug 2017 15:55:25 -0600
Message-Id: <20170807215531.12423-2-bo.li.liu@oracle.com>
In-Reply-To: <20170807215531.12423-1-bo.li.liu@oracle.com>
References: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An invalid value of extent inline ref type may be read from a
malicious image which may force btrfs to crash.

This adds a helper which does sanity check for the ref type, so we can
know if it's sane, return type if so, otherwise return an error.

v2: add enum type and return BTRFS_REF_TYPE_INVALID instead of -EINVAL

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       | 11 +++++++++++
 fs/btrfs/extent-tree.c | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f3eb7b..9866420 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2561,6 +2561,17 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 
 /* extent-tree.c */
 
+enum btrfs_inline_ref_types {
+	BTRFS_REF_TYPE_INVALID =	 0,
+	BTRFS_REF_TYPE_BLOCK =		 1,
+	BTRFS_REF_TYPE_DATA =		 2,
+	BTRFS_REF_TYPE_ANY =		 3,
+};
+
+int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
+				     struct btrfs_extent_inline_ref *iref,
+				     enum btrfs_inline_ref_types is_data);
+
 u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes);
 
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e3b0b41..83a3cdc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1148,6 +1148,42 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 }
 #endif
 
+/*
+ * is_data == BTRFS_REF_TYPE_BLOCK, tree block type is required,
+ * is_data == BTRFS_REF_TYPE_DATA, data type is requried,
+ * is_data == BTRFS_REF_TYPE_ANY, either type is OK.
+ */
+int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
+				     struct btrfs_extent_inline_ref *iref,
+				     enum btrfs_inline_ref_types is_data)
+{
+	int type = btrfs_extent_inline_ref_type(eb, iref);
+
+	if (type == BTRFS_TREE_BLOCK_REF_KEY ||
+	    type == BTRFS_SHARED_BLOCK_REF_KEY ||
+	    type == BTRFS_SHARED_DATA_REF_KEY ||
+	    type == BTRFS_EXTENT_DATA_REF_KEY) {
+		if (is_data == BTRFS_REF_TYPE_BLOCK) {
+			if (type == BTRFS_TREE_BLOCK_REF_KEY ||
+			    type == BTRFS_SHARED_BLOCK_REF_KEY)
+				return type;
+		} else if (is_data == BTRFS_REF_TYPE_DATA) {
+			if (type == BTRFS_EXTENT_DATA_REF_KEY ||
+			    type == BTRFS_SHARED_DATA_REF_KEY)
+				return type;
+		} else {
+			ASSERT(is_data == BTRFS_REF_TYPE_ANY);
+			return type;
+		}
+	}
+
+	btrfs_print_leaf(eb->fs_info, eb);
+	WARN(1, "eb %llu invalid extent inline ref type %d\n",
+	     eb->start, type);
+
+	return BTRFS_REF_TYPE_INVALID;
+}
+
 static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
 {
 	u32 high_crc = ~(u32)0;
-- 
2.9.4

