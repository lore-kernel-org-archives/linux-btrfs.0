Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52211 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751841AbeAZH0T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 02:26:19 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v2 1/7] btrfs-progs: Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE
Date: Fri, 26 Jan 2018 15:26:00 +0800
Message-ID: <1516951566-21777-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup. Also make it consistent with kernel.
Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE, since
maybe in some situation we do not know root, but just know fs_info.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c              |  6 +++---
 convert/source-ext2.c     |  2 +-
 convert/source-reiserfs.c |  4 ++--
 ctree.c                   | 49 +++++++++++++++++++++++++++--------------------
 ctree.h                   | 10 ++++++----
 file-item.c               |  2 +-
 volumes.c                 |  2 +-
 7 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 7d6bbb07..b118ea71 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7255,9 +7255,9 @@ again:
 		unsigned int shift = 0, offset;
 
 		if (i == 0 && btrfs_item_end_nr(buf, i) !=
-		    BTRFS_LEAF_DATA_SIZE(root)) {
+		    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 			if (btrfs_item_end_nr(buf, i) >
-			    BTRFS_LEAF_DATA_SIZE(root)) {
+			    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 				ret = delete_bogus_item(root, path, buf, i);
 				if (!ret)
 					goto again;
@@ -7266,7 +7266,7 @@ again:
 				ret = -EIO;
 				break;
 			}
-			shift = BTRFS_LEAF_DATA_SIZE(root) -
+			shift = BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 				btrfs_item_end_nr(buf, i);
 		} else if (i > 0 && btrfs_item_end_nr(buf, i) !=
 			   btrfs_item_offset_nr(buf, i - 1)) {
diff --git a/convert/source-ext2.c b/convert/source-ext2.c
index e9277213..e5c2a943 100644
--- a/convert/source-ext2.c
+++ b/convert/source-ext2.c
@@ -520,7 +520,7 @@ static int ext2_copy_single_xattr(struct btrfs_trans_handle *trans,
 	}
 	strncpy(namebuf, xattr_prefix_table[name_index], XATTR_NAME_MAX);
 	strncat(namebuf, EXT2_EXT_ATTR_NAME(entry), entry->e_name_len);
-	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root) -
+	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
 		fprintf(stderr, "skip large xattr on inode %Lu name %.*s\n",
 			objectid - INO_OFFSET, name_len, namebuf);
diff --git a/convert/source-reiserfs.c b/convert/source-reiserfs.c
index be79d8e2..e3582bda 100644
--- a/convert/source-reiserfs.c
+++ b/convert/source-reiserfs.c
@@ -676,7 +676,7 @@ static int reiserfs_xattr_indirect_fn(reiserfs_filsys_t fs, u64 position,
 	size_t alloc = min(position + num_blocks * fs->fs_blocksize, size);
 	char *body;
 
-	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root) -
+	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root->fs_info) -
 	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
 		fprintf(stderr, "skip large xattr on objectid %llu name %.*s\n",
 			xa_data->target_oid, (int)xa_data->namelen,
@@ -714,7 +714,7 @@ static int reiserfs_xattr_direct_fn(reiserfs_filsys_t fs, __u64 position,
 	struct reiserfs_xattr_data *xa_data = data;
 	char *newbody;
 
-	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root) -
+	if (size > BTRFS_LEAF_DATA_SIZE(xa_data->root->fs_info) -
 	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
 		fprintf(stderr, "skip large xattr on objectid %llu name %.*s\n",
 			xa_data->target_oid, (int)xa_data->namelen,
diff --git a/ctree.c b/ctree.c
index f4cf006b..cb16c42c 100644
--- a/ctree.c
+++ b/ctree.c
@@ -415,7 +415,7 @@ static inline unsigned int leaf_data_end(struct btrfs_root *root,
 {
 	u32 nr = btrfs_header_nritems(leaf);
 	if (nr == 0)
-		return BTRFS_LEAF_DATA_SIZE(root);
+		return BTRFS_LEAF_DATA_SIZE(root->fs_info);
 	return btrfs_item_offset_nr(leaf, nr - 1);
 }
 
@@ -517,24 +517,26 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 			goto fail;
 		}
 		if (i == 0 && btrfs_item_end_nr(buf, i) !=
-		    BTRFS_LEAF_DATA_SIZE(root)) {
+		    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 			ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
 			fprintf(stderr, "bad item end %u wanted %u\n",
 				btrfs_item_end_nr(buf, i),
-				(unsigned)BTRFS_LEAF_DATA_SIZE(root));
+				(unsigned)BTRFS_LEAF_DATA_SIZE(root->fs_info));
 			goto fail;
 		}
 	}
 
 	for (i = 0; i < nritems; i++) {
-		if (btrfs_item_end_nr(buf, i) > BTRFS_LEAF_DATA_SIZE(root)) {
+		if (btrfs_item_end_nr(buf, i) >
+				BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 			btrfs_item_key(buf, &key, 0);
 			btrfs_print_key(&key);
 			fflush(stdout);
 			ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
 			fprintf(stderr, "slot end outside of leaf %llu > %llu\n",
 				(unsigned long long)btrfs_item_end_nr(buf, i),
-				(unsigned long long)BTRFS_LEAF_DATA_SIZE(root));
+				(unsigned long long)BTRFS_LEAF_DATA_SIZE(
+					root->fs_info));
 			goto fail;
 		}
 	}
@@ -1621,7 +1623,7 @@ static int leaf_space_used(struct extent_buffer *l, int start, int nr)
  */
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf)
 {
-	u32 nodesize = (root ? BTRFS_LEAF_DATA_SIZE(root) : leaf->len);
+	u32 nodesize = (root ? BTRFS_LEAF_DATA_SIZE(root->fs_info) : leaf->len);
 	int nritems = btrfs_header_nritems(leaf);
 	int ret;
 	ret = nodesize - leaf_space_used(leaf, 0, nritems);
@@ -1742,11 +1744,11 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	memmove_extent_buffer(right,
 			      btrfs_leaf_data(right) + data_end - push_space,
 			      btrfs_leaf_data(right) + data_end,
-			      BTRFS_LEAF_DATA_SIZE(root) - data_end);
+			      BTRFS_LEAF_DATA_SIZE(root->fs_info) - data_end);
 
 	/* copy from the left data area */
 	copy_extent_buffer(right, left, btrfs_leaf_data(right) +
-		     BTRFS_LEAF_DATA_SIZE(root) - push_space,
+		     BTRFS_LEAF_DATA_SIZE(root->fs_info) - push_space,
 		     btrfs_leaf_data(left) + leaf_data_end(root, left),
 		     push_space);
 
@@ -1762,7 +1764,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	/* update the item pointers */
 	right_nritems += push_items;
 	btrfs_set_header_nritems(right, right_nritems);
-	push_space = BTRFS_LEAF_DATA_SIZE(root);
+	push_space = BTRFS_LEAF_DATA_SIZE(root->fs_info);
 	for (i = 0; i < right_nritems; i++) {
 		item = btrfs_item_nr(i);
 		push_space -= btrfs_item_size(right, item);
@@ -1881,7 +1883,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 			   btrfs_item_nr_offset(0),
 			   push_items * sizeof(struct btrfs_item));
 
-	push_space = BTRFS_LEAF_DATA_SIZE(root) -
+	push_space = BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 		     btrfs_item_offset_nr(right, push_items -1);
 
 	copy_extent_buffer(left, right, btrfs_leaf_data(left) +
@@ -1899,7 +1901,8 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		item = btrfs_item_nr(i);
 		ioff = btrfs_item_offset(left, item);
 		btrfs_set_item_offset(left, item,
-		      ioff - (BTRFS_LEAF_DATA_SIZE(root) - old_left_item_size));
+		      ioff - (BTRFS_LEAF_DATA_SIZE(root->fs_info) -
+			      old_left_item_size));
 	}
 	btrfs_set_header_nritems(left, old_left_nritems + push_items);
 
@@ -1913,7 +1916,8 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		push_space = btrfs_item_offset_nr(right, push_items - 1) -
 						  leaf_data_end(root, right);
 		memmove_extent_buffer(right, btrfs_leaf_data(right) +
-				      BTRFS_LEAF_DATA_SIZE(root) - push_space,
+				      BTRFS_LEAF_DATA_SIZE(root->fs_info) -
+				      push_space,
 				      btrfs_leaf_data(right) +
 				      leaf_data_end(root, right), push_space);
 
@@ -1924,7 +1928,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 	right_nritems -= push_items;
 	btrfs_set_header_nritems(right, right_nritems);
-	push_space = BTRFS_LEAF_DATA_SIZE(root);
+	push_space = BTRFS_LEAF_DATA_SIZE(root->fs_info);
 	for (i = 0; i < right_nritems; i++) {
 		item = btrfs_item_nr(i);
 		push_space = push_space - btrfs_item_size(right, item);
@@ -1981,11 +1985,12 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 			   nritems * sizeof(struct btrfs_item));
 
 	copy_extent_buffer(right, l,
-		     btrfs_leaf_data(right) + BTRFS_LEAF_DATA_SIZE(root) -
+		     btrfs_leaf_data(right) +
+		     BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 		     data_copy_size, btrfs_leaf_data(l) +
 		     leaf_data_end(root, l), data_copy_size);
 
-	rt_data_off = BTRFS_LEAF_DATA_SIZE(root) -
+	rt_data_off = BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 		      btrfs_item_end_nr(l, mid);
 
 	for (i = 0; i < nritems; i++) {
@@ -2046,7 +2051,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	l = path->nodes[0];
 	slot = path->slots[0];
 	if (extend && data_size + btrfs_item_size_nr(l, slot) +
-	    sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root))
+	    sizeof(struct btrfs_item) > BTRFS_LEAF_DATA_SIZE(root->fs_info))
 		return -EOVERFLOW;
 
 	/* first try to make some room by pushing left and right */
@@ -2081,21 +2086,22 @@ again:
 	if (mid <= slot) {
 		if (nritems == 1 ||
 		    leaf_space_used(l, mid, nritems - mid) + data_size >
-			BTRFS_LEAF_DATA_SIZE(root)) {
+			BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 			if (slot >= nritems) {
 				split = 0;
 			} else {
 				mid = slot;
 				if (mid != nritems &&
 				    leaf_space_used(l, mid, nritems - mid) +
-				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
+				    data_size >
+				    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 					split = 2;
 				}
 			}
 		}
 	} else {
 		if (leaf_space_used(l, 0, mid) + data_size >
-			BTRFS_LEAF_DATA_SIZE(root)) {
+			BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 			if (!extend && data_size && slot == 0) {
 				split = 0;
 			} else if ((extend || !data_size) && slot == 0) {
@@ -2104,7 +2110,8 @@ again:
 				mid = slot;
 				if (mid != nritems &&
 				    leaf_space_used(l, mid, nritems - mid) +
-				    data_size > BTRFS_LEAF_DATA_SIZE(root)) {
+				    data_size >
+				    BTRFS_LEAF_DATA_SIZE(root->fs_info)) {
 					split = 2 ;
 				}
 			}
@@ -2729,7 +2736,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		}
 
 		/* delete the leaf if it is mostly empty */
-		if (used < BTRFS_LEAF_DATA_SIZE(root) / 4) {
+		if (used < BTRFS_LEAF_DATA_SIZE(root->fs_info) / 4) {
 			/* push_leaf_left fixes the path.
 			 * make sure the path still points to our leaf
 			 * for possible call to del_ptr below
diff --git a/ctree.h b/ctree.h
index ef422ea6..11913efa 100644
--- a/ctree.h
+++ b/ctree.h
@@ -360,11 +360,12 @@ struct btrfs_header {
 			        sizeof(struct btrfs_header)) / \
 			        sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
-#define BTRFS_LEAF_DATA_SIZE(r) (__BTRFS_LEAF_DATA_SIZE(r->fs_info->nodesize))
-#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r) - \
+#define BTRFS_LEAF_DATA_SIZE(fs_info) \
+				(__BTRFS_LEAF_DATA_SIZE(fs_info->nodesize))
+#define BTRFS_MAX_INLINE_DATA_SIZE(r) (BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
 					sizeof(struct btrfs_item) - \
 					sizeof(struct btrfs_file_extent_item))
-#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r) - \
+#define BTRFS_MAX_XATTR_SIZE(r)	(BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
 				 sizeof(struct btrfs_item) -\
 				 sizeof(struct btrfs_dir_item))
 
@@ -599,7 +600,8 @@ struct btrfs_extent_item_v0 {
 	__le32 refs;
 } __attribute__ ((__packed__));
 
-#define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r) >> 4) - \
+#define BTRFS_MAX_EXTENT_ITEM_SIZE(r) \
+			((BTRFS_LEAF_DATA_SIZE(r->fs_info) >> 4) - \
 					sizeof(struct btrfs_item))
 #define BTRFS_MAX_EXTENT_SIZE		SZ_128M
 
diff --git a/file-item.c b/file-item.c
index 8e169e18..7b0ff358 100644
--- a/file-item.c
+++ b/file-item.c
@@ -27,7 +27,7 @@
 #include "crc32c.h"
 #include "internal.h"
 
-#define MAX_CSUM_ITEMS(r,size) ((((BTRFS_LEAF_DATA_SIZE(r) - \
+#define MAX_CSUM_ITEMS(r, size) ((((BTRFS_LEAF_DATA_SIZE(r->fs_info) - \
 			       sizeof(struct btrfs_item) * 2) / \
 			       size) - 1))
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
diff --git a/volumes.c b/volumes.c
index ce3a5405..034f5d45 100644
--- a/volumes.c
+++ b/volumes.c
@@ -837,7 +837,7 @@ error:
 	return ret;
 }
 
-#define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r)		\
+#define BTRFS_MAX_DEVS(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info)	\
 			- sizeof(struct btrfs_item)		\
 			- sizeof(struct btrfs_chunk))		\
 			/ sizeof(struct btrfs_stripe) + 1)
-- 
2.14.3



