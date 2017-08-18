Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39341 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752272AbdHRWRO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:17:14 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v3 7/7] Btrfs: add one more sanity check for shared ref type
Date: Fri, 18 Aug 2017 15:15:24 -0600
Message-Id: <20170818211524.31325-8-bo.li.liu@oracle.com>
In-Reply-To: <20170818211524.31325-1-bo.li.liu@oracle.com>
References: <20170818211524.31325-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Every shared ref has a parent tree block, which can be get from
btrfs_extent_inline_ref_offset().  And the tree block must be aligned
to the nodesize, so we'd know this inline ref is not valid if this
block's bytenr is not aligned to the nodesize, in which case, most
likely the ref type has been misused.

This adds the above mentioned check and also updates
print_extent_item() called by btrfs_print_leaf() to point out the
invalid ref while printing the tree structure.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c | 29 +++++++++++++++++++++++++----
 fs/btrfs/print-tree.c  | 27 +++++++++++++++++++++------
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d75129a..13264cd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1158,19 +1158,40 @@ int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
 				     enum btrfs_inline_ref_type is_data)
 {
 	int type = btrfs_extent_inline_ref_type(eb, iref);
+	u64 offset = btrfs_extent_inline_ref_offset(eb, iref);
 
 	if (type == BTRFS_TREE_BLOCK_REF_KEY ||
 	    type == BTRFS_SHARED_BLOCK_REF_KEY ||
 	    type == BTRFS_SHARED_DATA_REF_KEY ||
 	    type == BTRFS_EXTENT_DATA_REF_KEY) {
 		if (is_data == BTRFS_REF_TYPE_BLOCK) {
-			if (type == BTRFS_TREE_BLOCK_REF_KEY ||
-			    type == BTRFS_SHARED_BLOCK_REF_KEY)
+			if (type == BTRFS_TREE_BLOCK_REF_KEY)
 				return type;
+			if (type == BTRFS_SHARED_BLOCK_REF_KEY) {
+				ASSERT(eb->fs_info);
+				/*
+				 * Every shared one has parent tree
+				 * block, which must be aligned to
+				 * nodesize.
+				 */
+				if (offset &&
+				    IS_ALIGNED(offset, eb->fs_info->nodesize))
+					return type;
+			}
 		} else if (is_data == BTRFS_REF_TYPE_DATA) {
-			if (type == BTRFS_EXTENT_DATA_REF_KEY ||
-			    type == BTRFS_SHARED_DATA_REF_KEY)
+			if (type == BTRFS_EXTENT_DATA_REF_KEY)
 				return type;
+			if (type == BTRFS_SHARED_DATA_REF_KEY) {
+				ASSERT(eb->fs_info);
+				/*
+				 * Every shared one has parent tree
+				 * block, which must be aligned to
+				 * nodesize.
+				 */
+				if (offset &&
+				    IS_ALIGNED(offset, eb->fs_info->nodesize))
+					return type;
+			}
 		} else {
 			ASSERT(is_data == BTRFS_REF_TYPE_ANY);
 			return type;
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 0e52e47..9f8c5ee 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -44,7 +44,7 @@ static void print_dev_item(struct extent_buffer *eb,
 static void print_extent_data_ref(struct extent_buffer *eb,
 				  struct btrfs_extent_data_ref *ref)
 {
-	pr_info("\t\textent data backref root %llu objectid %llu offset %llu count %u\n",
+	pr_cont("extent data backref root %llu objectid %llu offset %llu count %u\n",
 	       btrfs_extent_data_ref_root(eb, ref),
 	       btrfs_extent_data_ref_objectid(eb, ref),
 	       btrfs_extent_data_ref_offset(eb, ref),
@@ -63,6 +63,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 flags;
 	u64 offset;
+	int ref_index = 0;
 
 	if (item_size < sizeof(*ei)) {
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
@@ -104,12 +105,20 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 		iref = (struct btrfs_extent_inline_ref *)ptr;
 		type = btrfs_extent_inline_ref_type(eb, iref);
 		offset = btrfs_extent_inline_ref_offset(eb, iref);
+		pr_info("\t\tref#%d: ", ref_index++);
 		switch (type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			pr_info("\t\ttree block backref root %llu\n", offset);
+			pr_cont("tree block backref root %llu\n", offset);
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			pr_info("\t\tshared block backref parent %llu\n", offset);
+			pr_cont("shared block backref parent %llu\n", offset);
+			/*
+			 * offset is supposed to be a tree block which
+			 * must be aligned to nodesize.
+			 */
+			if (!IS_ALIGNED(offset, eb->fs_info->nodesize))
+				pr_info("\t\t\t(parent %llu is NOT ALIGNED to nodesize %llu)\n",
+					offset, (unsigned long long)eb->fs_info->nodesize);
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -117,12 +126,18 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 			break;
 		case BTRFS_SHARED_DATA_REF_KEY:
 			sref = (struct btrfs_shared_data_ref *)(iref + 1);
-			pr_info("\t\tshared data backref parent %llu count %u\n",
+			pr_cont("shared data backref parent %llu count %u\n",
 			       offset, btrfs_shared_data_ref_count(eb, sref));
+			/*
+			 * offset is supposed to be a tree block which
+			 * must be aligned to nodesize.
+			 */
+			if (!IS_ALIGNED(offset, eb->fs_info->nodesize))
+				pr_info("\t\t\t(parent %llu is NOT ALIGNED to nodesize %llu)\n",
+				     offset, (unsigned long long)eb->fs_info->nodesize);
 			break;
 		default:
-			btrfs_err(eb->fs_info,
-				  "extent %llu has invalid ref type %d\n",
+			pr_cont("(extent %llu has INVALID ref type %d)\n",
 				  eb->start, type);
 			return;
 		}
-- 
2.9.4

