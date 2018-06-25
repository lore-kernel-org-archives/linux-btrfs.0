Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52974 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752230AbeFYIYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 04:24:55 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 39ED7ADA2
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 08:24:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Add graceful handling of V0 extents
Date: Mon, 25 Jun 2018 11:24:50 +0300
Message-Id: <1529915090-11095-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1529915090-11095-1-git-send-email-nborisov@suse.com>
References: <1529915090-11095-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Following the removal of the v0 handling code let's be courteous and
print an error message when such extents are handled. In the cases
where we have a transaction just abort it, otherwise just call
btrfs_handle_fs_error. Both cases result in the FS being re-mounted RO.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/print-tree.c  | 11 ++++++++---
 fs/btrfs/relocation.c  | 36 +++++++++++++++++++++++++++++++-----
 3 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4129831523a2..131773528683 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -870,8 +870,17 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			num_refs = btrfs_extent_refs(leaf, ei);
 			extent_flags = btrfs_extent_flags(leaf, ei);
 		} else {
-			BUG();
+			ret = -EINVAL;
+			btrfs_err(fs_info,
+		"Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");
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
@@ -1302,6 +1311,11 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 		ref2 = btrfs_item_ptr(leaf, path->slots[0],
 				      struct btrfs_shared_data_ref);
 		num_refs = btrfs_shared_data_ref_count(leaf, ref2);
+	} else if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+		btrfs_err(fs_info,
+			  "Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");
+		btrfs_abort_transaction(trans, -EINVAL);
+		return -EINVAL;
 	} else {
 		BUG();
 	}
@@ -1334,6 +1348,8 @@ static noinline u32 extent_data_ref_count(struct btrfs_path *path,
 
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+	BUG_ON(key.type == BTRFS_EXTENT_REF_V0_KEY);
 	if (iref) {
 		/*
 		 * If type is invalid, we should have bailed out earlier than
@@ -1549,7 +1565,13 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-	BUG_ON(item_size < sizeof(*ei));
+	if (item_size < sizeof(*ei)) {
+		err = -EINVAL;
+		btrfs_err(fs_info,
+		"Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");
+		btrfs_abort_transaction(trans, err);
+		goto out;
+	}
 
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	flags = btrfs_extent_flags(leaf, ei);
@@ -2282,7 +2304,15 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-	BUG_ON(item_size < sizeof(*ei));
+
+	if (item_size < sizeof(*ei)) {
+		err = -EINVAL;
+		btrfs_err(fs_info,
+		"Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");
+		btrfs_abort_transaction(trans, err);
+		goto out;
+	}
+
 	ei = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_extent_item);
 	__run_delayed_extent_op(extent_op, leaf, ei);
 
@@ -6815,7 +6845,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	item_size = btrfs_item_size_nr(leaf, extent_slot);
-	BUG_ON(item_size < sizeof(*ei));
+	if (item_size < sizeof(*ei)) {
+		ret = -EINVAL;
+		btrfs_err(info,
+		"Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");
+		btrfs_abort_transaction(trans, ret);
+		goto out;
+	}
 	ei = btrfs_item_ptr(leaf, extent_slot,
 			    struct btrfs_extent_item);
 	if (owner_objectid < BTRFS_FIRST_FREE_OBJECTID &&
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index b03040b84fe9..cd4387fc766c 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -52,8 +52,11 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int type)
 	u64 offset;
 	int ref_index = 0;
 
-	if (item_size < sizeof(*ei))
-		BUG();
+	if (item_size < sizeof(*ei)) {
+		btrfs_err(eb->fs_info,
+	"Unsupported V0 extent detected! Please recreate the filesystem on newer kernel\n");
+		btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
+	}
 
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(eb, ei);
@@ -256,7 +259,9 @@ void btrfs_print_leaf(struct extent_buffer *l)
 			       btrfs_file_extent_ram_bytes(l, fi));
 			break;
 		case BTRFS_EXTENT_REF_V0_KEY:
-			BUG();
+			btrfs_err(fs_info,
+		"Unsupported V0 extent detected! Please recreate the filesystem on newer kernel\n");
+			btrfs_handle_fs_error(fs_info, -EINVAL, NULL);
 			break;
 		case BTRFS_BLOCK_GROUP_ITEM_KEY:
 			bi = btrfs_item_ptr(l, i,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 52c1e3e6802d..0491aec58bcc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -598,6 +598,12 @@ int find_inline_backref(struct extent_buffer *leaf, int slot,
 	btrfs_item_key_to_cpu(leaf, &key, slot);
 
 	item_size = btrfs_item_size_nr(leaf, slot);
+	if (item_size < sizeof(*ei)) {
+		btrfs_err(leaf->fs_info,
+	"Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");
+		btrfs_handle_fs_error(leaf->fs_info, -EINVAL, NULL);
+		return 1;
+	}
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 	WARN_ON(!(btrfs_extent_flags(leaf, ei) &
 		  BTRFS_EXTENT_FLAG_TREE_BLOCK));
@@ -782,8 +788,14 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 			goto next;
 		}
 
-		ASSERT(key.type != BTRFS_EXTENT_REF_V0_KEY);
-		if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
+		if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+			err = -EINVAL;
+			btrfs_err(rc->extent_root->fs_info,
+			"Unsupported V0 extent detected! Please recreate the filesystem on newer kernel\n");
+			btrfs_handle_fs_error(rc->extent_root->fs_info, err,
+					      NULL);
+			goto out;
+		} else if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
 			if (key.objectid == key.offset) {
 				/*
 				 * only root blocks of reloc trees use
@@ -3315,6 +3327,11 @@ static int add_tree_block(struct reloc_control *rc,
 			level = (int)extent_key->offset;
 		}
 		generation = btrfs_extent_generation(eb, ei);
+	} else if (item_size == sizeof(struct btrfs_extent_item_v0)) {
+		btrfs_err(eb->fs_info,
+		"Unsupported V0 extent detected! Please recreate the filesystem on newer kernel\n");
+		btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
+		return -EINVAL;
 	} else {
 		BUG();
 	}
@@ -3720,8 +3737,12 @@ int add_data_references(struct reloc_control *rc,
 		if (key.objectid != extent_key->objectid)
 			break;
 
-		BUG_ON(key.type == BTRFS_EXTENT_REF_V0_KEY);
-		if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
+		if (key.type == BTRFS_EXTENT_REF_V0_KEY) {
+			btrfs_err(eb->fs_info,
+			"Unsupported V0 extent detected! Please recreate the filesystem on newer kernel\n");
+			btrfs_handle_fs_error(eb->fs_info, -EINVAL, NULL);
+			ret = -EINVAL;
+		} else if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
 			ret = __add_tree_block(rc, key.offset, blocksize,
 					       blocks);
 		} else if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
@@ -3967,7 +3988,12 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 			flags = btrfs_extent_flags(path->nodes[0], ei);
 			ret = check_extent_flags(flags);
 			BUG_ON(ret);
-
+		} else if (item_size == sizeof(struct btrfs_extent_item_v0)) {
+			err = -EINVAL;
+		btrfs_err(trans->fs_info,
+		"Unsupported V0 extent detected! Please recreate the filesystem on newer kernel\n");
+			btrfs_abort_transaction(trans, err);
+			break;
 		} else {
 			BUG();
 		}
-- 
2.7.4

