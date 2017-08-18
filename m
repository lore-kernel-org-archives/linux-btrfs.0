Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39336 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751807AbdHRWRN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:17:13 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 1/7] Btrfs: add a helper to retrive extent inline ref type
Date: Fri, 18 Aug 2017 15:15:18 -0600
Message-Id: <20170818211524.31325-2-bo.li.liu@oracle.com>
In-Reply-To: <20170818211524.31325-1-bo.li.liu@oracle.com>
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An invalid value of extent inline ref type may be read from a
malicious image which may force btrfs to crash.

This adds a helper which does sanity check for the ref type, so we can
know if it's sane, return type if so, otherwise return an error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       | 11 +++++++++++
 fs/btrfs/extent-tree.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f3eb7b..714e779 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2561,6 +2561,17 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 
 /* extent-tree.c */
 
+enum btrfs_inline_ref_type {
+	BTRFS_REF_TYPE_INVALID =	 0,
+	BTRFS_REF_TYPE_BLOCK =		 1,
+	BTRFS_REF_TYPE_DATA =		 2,
+	BTRFS_REF_TYPE_ANY =		 3,
+};
+
+int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
+				     struct btrfs_extent_inline_ref *iref,
+				     enum btrfs_inline_ref_type is_data);
+
 u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes);
 
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e3b0b41..c540578 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1148,6 +1148,43 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 }
 #endif
 
+/*
+ * is_data == BTRFS_REF_TYPE_BLOCK, tree block type is required,
+ * is_data == BTRFS_REF_TYPE_DATA, data type is requried,
+ * is_data == BTRFS_REF_TYPE_ANY, either type is OK.
+ */
+int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
+				     struct btrfs_extent_inline_ref *iref,
+				     enum btrfs_inline_ref_type is_data)
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
+	btrfs_err(eb->fs_info, "eb %llu invalid extent inline ref type %d",
+		  eb->start, type);
+	WARN_ON(1);
+
+	return BTRFS_REF_TYPE_INVALID;
+}
+
 static u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset)
 {
 	u32 high_crc = ~(u32)0;
-- 
2.9.4

