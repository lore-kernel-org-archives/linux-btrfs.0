Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27529 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946506AbdEZB1N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:27:13 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q1RCAP010322
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1RCdH025276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:12 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1RBaE013225
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:11 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] Btrfs: add a helper to retrive extent inline ref type
Date: Thu, 25 May 2017 18:26:26 -0600
Message-Id: <20170526002631.8546-2-bo.li.liu@oracle.com>
In-Reply-To: <20170526002631.8546-1-bo.li.liu@oracle.com>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An invalid value of extent inline ref type may be read from a
malicious image which may force btrfs to crash.

This adds a helper which does sanity check for the ref type, so we can
know if it's sane, return type if so, otherwise return an error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       |  4 ++++
 fs/btrfs/extent-tree.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c411590..206ae8c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2542,6 +2542,10 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 
 /* extent-tree.c */
 
+int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
+				     struct btrfs_extent_inline_ref *iref,
+				     int is_data);
+
 u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes);
 
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index be54776..fba8ca0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1117,6 +1117,41 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 }
 #endif
 
+/*
+ * is_data == 0, tree block type is required,
+ * is_data == 1, data type is requried,
+ * is_data == 2, either type is OK.
+ */
+int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
+				     struct btrfs_extent_inline_ref *iref,
+				     int is_data)
+{
+	int type = btrfs_extent_inline_ref_type(eb, iref);
+
+	if (type == BTRFS_TREE_BLOCK_REF_KEY ||
+	    type == BTRFS_SHARED_BLOCK_REF_KEY ||
+	    type == BTRFS_SHARED_DATA_REF_KEY ||
+	    type == BTRFS_EXTENT_DATA_REF_KEY) {
+		if (is_data == 2) {
+			return type;
+		} else if (is_data == 1) {
+			if (type == BTRFS_EXTENT_DATA_REF_KEY ||
+			    type == BTRFS_SHARED_DATA_REF_KEY)
+				return type;
+		} else {
+			if (type == BTRFS_TREE_BLOCK_REF_KEY ||
+			    type == BTRFS_SHARED_BLOCK_REF_KEY)
+				return type;
+		}
+	}
+
+	btrfs_print_leaf(eb->fs_info, eb);
+	WARN(1, "eb %llu(%s block) invalid extent inline ref type %d\n",
+	     eb->start, (is_data) ? "data" : "tree", type);
+
+	return -EINVAL;
+}
+
 static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
 {
 	u32 high_crc = ~(u32)0;
-- 
2.9.4

