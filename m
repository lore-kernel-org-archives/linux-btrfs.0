Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45036 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935005AbeFZN5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Jun 2018 09:57:39 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C7D2ABD6
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 13:57:38 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Add graceful handling of V0 extents
Date: Tue, 26 Jun 2018 16:57:36 +0300
Message-Id: <1530021456-20749-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20180625152156.GF27958@twin.jikos.cz>
References: <20180625152156.GF27958@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Following the removal of the v0 handling code let's be courteous and
print an error message when such extents are handled. In the cases
where we have a transaction just abort it, otherwise just call
btrfs_handle_fs_error. Both cases result in the FS being re-mounted RO.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2:
 * Replaced open-coded error printing with a helper function for consistency. 

 fs/btrfs/ctree.h       |  7 +++++++
 fs/btrfs/extent-tree.c | 39 +++++++++++++++++++++++++++++++++++----
 fs/btrfs/print-tree.c  |  9 ++++++---
 fs/btrfs/relocation.c  | 31 ++++++++++++++++++++++++++-----
 4 files changed, 74 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bc52bf7ac572..629ae1977d2c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3457,6 +3457,13 @@ static inline void assfail(char *expr, char *file, int line)
 	BUG();
 }
 
+__cold
+static inline void btrfs_print_v0_err(struct btrfs_fs_info *fs_info)
+{
+	btrfs_err(fs_info,
+	"Unsupported V0 extent filesystem detected. Aborting... Please re-create your filesystem with a newer kernel");
+}
+
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 #else
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4129831523a2..dd3ef8699b67 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -870,8 +870,16 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			num_refs = btrfs_extent_refs(leaf, ei);
 			extent_flags = btrfs_extent_flags(leaf, ei);
 		} else {
-			BUG();
+			ret = -EINVAL;
+			btrfs_print_v0_err(fs_info);
+			if (trans)
+				btrfs_abort_transaction(trans, ret);
+			else
+				btrfs_handle_fs_error(fs_info, ret, NULL);
+
+			goto out_free;
 		}
+
 		BUG_ON(num_refs == 0);
 	} else {
 		num_refs = 0;
@@ -1302,6 +1310,10 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 		ref2 = btrfs_item_ptr(leaf, path->slots[0],
 				      struct btrfs_shared_data_ref);
 		num_refs = btrfs_shared_data_ref_count(leaf, ref2);
+	} else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+		btrfs_print_v0_err(fs_info);
+		btrfs_abort_transaction(trans, -EINVAL);
+		return -EINVAL;
 	} else {
 		BUG();
 	}
@@ -1334,6 +1346,8 @@ static noinline u32 extent_data_ref_count(struct btrfs_path *path,
 
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+	BUG_ON(key.type == BTRFS_EXTENT_REF_V0_KEY);
 	if (iref) {
 		/*
 		 * If type is invalid, we should have bailed out earlier than
@@ -1549,7 +1563,12 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-	BUG_ON(item_size < sizeof(*ei));
+	if (item_size < sizeof(*ei)) {
+		err = -EINVAL;
+		btrfs_print_v0_err(fs_info);
+		btrfs_abort_transaction(trans, err);
+		goto out;
+	}
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	flags = btrfs_extent_flags(leaf, ei);
@@ -2282,7 +2301,14 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-	BUG_ON(item_size < sizeof(*ei));
+
+	if (item_size < sizeof(*ei)) {
+		err = -EINVAL;
+		btrfs_print_v0_err(fs_info);
+		btrfs_abort_transaction(trans, err);
+		goto out;
+	}
+
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	__run_delayed_extent_op(extent_op, leaf, ei);
 
@@ -6815,7 +6841,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, extent_slot);
-	BUG_ON(item_size < sizeof(*ei));
+	if (item_size < sizeof(*ei)) {
+		ret = -EINVAL;
+		btrfs_print_v0_err(info);
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 	ei = btrfs_item_ptr(leaf, extent_slot,
 			    struct btrfs_extent_item);
 	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID &&
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index b03040b84fe9..772560eecfa6 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -52,8 +52,10 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 	u64 offset;
 	int ref_index = 0;
 
-	if (item_size < sizeof(*ei))
-		BUG();
+	if (item_size < sizeof(*ei)) {
+		btrfs_print_v0_err(eb->fs_info);
+		btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
+	}
 
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(eb, ei);
@@ -256,7 +258,8 @@ void btrfs_print_leaf(struct extent_buffer *l)
 			       btrfs_file_extent_ram_bytes(l, fi));
 			break;
 		case BTRFS_EXTENT_REF_V0_KEY:
-			BUG();
+			btrfs_print_v0_err(fs_info);
+			btrfs_handle_fs_error(fs_info, -EINVAL, NULL);
 			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 52c1e3e6802d..6fcd88c856d3 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -598,6 +598,11 @@ int find_inline_backref(struct extent_buffer *leaf, int slot,
 	btrfs_item_key_to_cpu(leaf, &key, slot);
 
 	item_size = btrfs_item_size_nr(leaf, slot);
+	if (item_size < sizeof(*ei)) {
+		btrfs_print_v0_err(leaf->fs_info);
+		btrfs_handle_fs_error(leaf->fs_info, -EINVAL, NULL);
+		return 1;
+	}
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 	WARN_ON(!(btrfs_extent_flags(leaf, ei) &
 		  BTRFS_EXTENT_FLAG_TREE_BLOCK));
@@ -782,8 +787,13 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 			goto next;
 		}
 
-		ASSERT(key.type != BTRFS_EXTENT_REF_V0_KEY);
-		if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
+		if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+			err = -EINVAL;
+			btrfs_print_v0_err(rc->extent_root->fs_info);
+			btrfs_handle_fs_error(rc->extent_root->fs_info, err,
+					      NULL);
+			goto out;
+		} else if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
 			if (key.objectid == key.offset) {
 				/*
 				 * only root blocks of reloc trees use
@@ -3315,6 +3325,10 @@ static int add_tree_block(struct reloc_control *rc,
 			level = (int)extent_key->offset;
 		}
 		generation = btrfs_extent_generation(eb, ei);
+	} else if (item_size == sizeof(struct btrfs_extent_item_v0)) {
+		btrfs_print_v0_err(eb->fs_info);
+		btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
+		return -EINVAL;
 	} else {
 		BUG();
 	}
@@ -3720,8 +3734,11 @@ int add_data_references(struct reloc_control *rc,
 		if (key.objectid != extent_key->objectid)
 			break;
 
-		BUG_ON(key.type == BTRFS_EXTENT_REF_V0_KEY);
-		if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
+		if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+			btrfs_print_v0_err(eb->fs_info);
+			btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
+			ret = -EINVAL;
+		} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
 			ret = __add_tree_block(rc, key.offset, blocksize,
 					       blocks);
 		} else if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
@@ -3967,7 +3984,11 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 			flags = btrfs_extent_flags(path->nodes[0], ei);
 			ret = check_extent_flags(flags);
 			BUG_ON(ret);
-
+		} else if (item_size == sizeof(struct btrfs_extent_item_v0)) {
+			err = -EINVAL;
+			btrfs_print_v0_err(trans->fs_info);
+			btrfs_abort_transaction(trans, err);
+			break;
 		} else {
 			BUG();
 		}
-- 
2.7.4

