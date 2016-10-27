Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57919 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935249AbcJ0SFW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 14:05:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 68D1EAC92
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Oct 2016 18:05:20 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] btrfs-progs: repair: Trickle down EEXISTS while freeing
Date: Thu, 27 Oct 2016 13:05:08 -0500
Message-Id: <20161027180508.8721-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While deleting pending extents, we insert extents to the
extent_tree. However, because of corruption, this might already
be freed. We trickle the EEXISTS error and let the caller
decide what needs to be done with it. In this case, ignore, so
the repair may proceed.

The primary motivation of this is to resolve this BUG_ON:
extent-tree.c:2731: alloc_reserved_tree_block: Assertion `ret` failed, value 0

#2  assert_trace (val=0, line=2728, func=0x489510 <__func__.11558> "alloc_reserved_tree_block", 
	filename=0x489065 "extent-tree.c", assertion=0x48cfb5 "ret") at kerncompat.h:102
#3  alloc_reserved_tree_block (trans=trans@entry=0x7e7240, root=root@entry=0x6a88a0, root_objectid=2, 
	generation=175654, flags=0, key=key@entry=0x2bc5c70, level=0, ins=ins@entry=0x7fffffffcf30) at extent-tree.c:2728
#4  finish_current_insert (trans=trans@entry=0x7e7240, extent_root=extent_root@entry=0x6a88a0)
    at extent-tree.c:2108
#5  __free_extent (trans=trans@entry=0x7e7240, root=root@entry=0x6a88a0, bytenr=57127387136, 
	num_bytes=<optimized out>, parent=parent@entry=0, root_objectid=<optimized out>, owner_objectid=0, 
	owner_offset=owner_offset@entry=0, refs_to_drop=refs_to_drop@entry=1) at extent-tree.c:2410
#6  del_pending_extents (trans=trans@entry=0x7e7240, extent_root=0x6a88a0) at extent-tree.c:2448

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

diff --git a/extent-tree.c b/extent-tree.c
index 3b1577e..a21e369 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2077,7 +2077,7 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *info = extent_root->fs_info;
 	struct pending_extent_op *extent_op;
 	struct btrfs_key key;
-	int ret;
+	int ret, err = 0;
 	int skinny_metadata =
 		btrfs_fs_incompat(extent_root->fs_info,
 				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
@@ -2107,7 +2107,10 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 						extent_op->flags,
 						&extent_op->key,
 						extent_op->level, &key);
-			BUG_ON(ret);
+			if (ret == -EEXIST)
+				err = ret;
+			else
+				BUG_ON(ret);
 		} else {
 			BUG_ON(1);
 		}
@@ -2116,7 +2119,7 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 				  GFP_NOFS);
 		kfree(extent_op);
 	}
-	return 0;
+	return err;
 }
 
 static int pin_down_bytes(struct btrfs_trans_handle *trans,
@@ -2185,7 +2188,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
-	int ret;
+	int ret, err;
 	int is_data;
 	int extent_slot = 0;
 	int found_extent = 0;
@@ -2403,8 +2406,10 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 	}
 fail:
 	btrfs_free_path(path);
-	finish_current_insert(trans, extent_root);
-	return ret;
+	err = finish_current_insert(trans, extent_root);
+	if (ret)
+		return ret;
+	return err;
 }
 
 /*
@@ -2445,7 +2450,12 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 					    start, end + 1 - start, 0,
 					    extent_root->root_key.objectid,
 					    extent_op->level, 0, 1);
-			kfree(extent_op);
+			if (ret == -EEXIST) {
+				fprintf(stderr, "While freeing extent [%llu-%llu]: already free. Ignoring\n",
+						(unsigned long long) start,
+						(unsigned long long) end);
+				ret = 0;
+			}
 		} else {
 			kfree(extent_op);
 			ret = get_state_private(extent_ins, start, &priv);
@@ -2459,8 +2469,8 @@ static int del_pending_extents(struct btrfs_trans_handle *trans, struct
 			if (extent_op->type == PENDING_BACKREF_UPDATE)
 				BUG_ON(1);
 
-			kfree(extent_op);
 		}
+		kfree(extent_op);
 		if (ret)
 			err = ret;
 	}
@@ -2728,7 +2738,10 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
-	BUG_ON(ret);
+	if (ret == -EEXIST)
+		return ret;
+	else
+		BUG_ON(ret);
 
 	leaf = path->nodes[0];
 	extent_item = btrfs_item_ptr(leaf, path->slots[0],
