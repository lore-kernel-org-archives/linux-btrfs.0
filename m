Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab2IRN5y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 09:57:54 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id C4082A3EBF
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 15:57:52 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: move transaction aborts to the point of failure
Date: Tue, 18 Sep 2012 15:52:32 +0200
Message-Id: <1347976352-13939-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Call btrfs_abort_transaction as early as possible when an error
condition is detected, that way the line number reported is useful
and we're not clueless anymore which error path led to the abort.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.h       |    5 ++++
 fs/btrfs/extent-tree.c |   56 ++++++++++++++++++++++++++++++------------------
 fs/btrfs/root-tree.c   |   29 ++++++++++++++----------
 fs/btrfs/volumes.c     |   37 +++++++++++++++++++------------
 4 files changed, 80 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1372057..399521a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3400,6 +3400,11 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
 	}
 }
 
+/*
+ * Call btrfs_abort_transaction as early as possible when an error condition is
+ * detected, that way the exact line number is reported.
+ */
+
 #define btrfs_abort_transaction(trans, root, errno)		\
 do {								\
 	__btrfs_abort_transaction(trans, root, __func__,	\
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ee88d7a..a0377f0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5106,8 +5106,10 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			ret = remove_extent_backref(trans, extent_root, path,
 						    NULL, refs_to_drop,
 						    is_data);
-			if (ret)
-				goto abort;
+			if (ret) {
+				btrfs_abort_transaction(trans, extent_root, ret);
+				goto out;
+			}
 			btrfs_release_path(path);
 			path->leave_spinning = 1;
 
@@ -5125,8 +5127,10 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 					btrfs_print_leaf(extent_root,
 							 path->nodes[0]);
 			}
-			if (ret < 0)
-				goto abort;
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, extent_root, ret);
+				goto out;
+			}
 			extent_slot = path->slots[0];
 		}
 	} else if (ret == -ENOENT) {
@@ -5140,7 +5144,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		       (unsigned long long)owner_objectid,
 		       (unsigned long long)owner_offset);
 	} else {
-		goto abort;
+		btrfs_abort_transaction(trans, extent_root, ret);
+		goto out;
 	}
 
 	leaf = path->nodes[0];
@@ -5150,8 +5155,10 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		BUG_ON(found_extent || extent_slot != path->slots[0]);
 		ret = convert_extent_item_v0(trans, extent_root, path,
 					     owner_objectid, 0);
-		if (ret < 0)
-			goto abort;
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, extent_root, ret);
+			goto out;
+		}
 
 		btrfs_release_path(path);
 		path->leave_spinning = 1;
@@ -5168,8 +5175,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			       (unsigned long long)bytenr);
 			btrfs_print_leaf(extent_root, path->nodes[0]);
 		}
-		if (ret < 0)
-			goto abort;
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, extent_root, ret);
+			goto out;
+		}
+
 		extent_slot = path->slots[0];
 		leaf = path->nodes[0];
 		item_size = btrfs_item_size_nr(leaf, extent_slot);
@@ -5206,8 +5216,10 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			ret = remove_extent_backref(trans, extent_root, path,
 						    iref, refs_to_drop,
 						    is_data);
-			if (ret)
-				goto abort;
+			if (ret) {
+				btrfs_abort_transaction(trans, extent_root, ret);
+				goto out;
+			}
 		}
 	} else {
 		if (found_extent) {
@@ -5224,27 +5236,29 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
-		if (ret)
-			goto abort;
+		if (ret) {
+			btrfs_abort_transaction(trans, extent_root, ret);
+			goto out;
+		}
 		btrfs_release_path(path);
 
 		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
-			if (ret)
-				goto abort;
+			if (ret) {
+				btrfs_abort_transaction(trans, extent_root, ret);
+				goto out;
+			}
 		}
 
 		ret = update_block_group(trans, root, bytenr, num_bytes, 0);
-		if (ret)
-			goto abort;
+		if (ret) {
+			btrfs_abort_transaction(trans, extent_root, ret);
+			goto out;
+		}
 	}
 out:
 	btrfs_free_path(path);
 	return ret;
-
-abort:
-	btrfs_abort_transaction(trans, extent_root, ret);
-	goto out;
 }
 
 /*
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 10d8e4d..eb923d0 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -141,8 +141,10 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		return -ENOMEM;
 
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
-	if (ret < 0)
-		goto out_abort;
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out;
+	}
 
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
@@ -166,16 +168,23 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		btrfs_release_path(path);
 		ret = btrfs_search_slot(trans, root, key, path,
 				-1, 1);
-		if (ret < 0)
-			goto out_abort;
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, root, ret);
+			goto out;
+		}
+
 		ret = btrfs_del_item(trans, root, path);
-		if (ret < 0)
-			goto out_abort;
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, root, ret);
+			goto out;
+		}
 		btrfs_release_path(path);
 		ret = btrfs_insert_empty_item(trans, root, path,
 				key, sizeof(*item));
-		if (ret < 0)
-			goto out_abort;
+		if (ret < 0) {
+			btrfs_abort_transaction(trans, root, ret);
+			goto out;
+		}
 		l = path->nodes[0];
 		slot = path->slots[0];
 		ptr = btrfs_item_ptr_offset(l, slot);
@@ -192,10 +201,6 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 out:
 	btrfs_free_path(path);
 	return ret;
-
-out_abort:
-	btrfs_abort_transaction(trans, root, ret);
-	goto out;
 }
 
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 11d0b2b..ed1ff1c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1775,15 +1775,21 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 	if (seeding_dev) {
 		ret = init_first_rw_device(trans, root, device);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
 			goto error_trans;
+		}
 		ret = btrfs_finish_sprout(trans, root);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
 			goto error_trans;
+		}
 	} else {
 		ret = btrfs_add_device(trans, root, device);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, root, ret);
 			goto error_trans;
+		}
 	}
 
 	/*
@@ -1814,7 +1820,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 
 error_trans:
 	unlock_chunks(root);
-	btrfs_abort_transaction(trans, root, ret);
 	btrfs_end_transaction(trans, root);
 	rcu_string_free(device->name);
 	kfree(device);
@@ -3587,12 +3592,16 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	ret = __btrfs_alloc_chunk(trans, extent_root, &sys_map,
 				  &sys_chunk_size, &sys_stripe_size,
 				  sys_chunk_offset, alloc_profile);
-	if (ret)
-		goto abort;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out;
+	}
 
 	ret = btrfs_add_device(trans, fs_info->chunk_root, device);
-	if (ret)
-		goto abort;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out;
+	}
 
 	/*
 	 * Modifying chunk tree needs allocating new blocks from both
@@ -3602,19 +3611,19 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	 */
 	ret = __finish_chunk_alloc(trans, extent_root, map, chunk_offset,
 				   chunk_size, stripe_size);
-	if (ret)
-		goto abort;
+	if (ret) {
+		btrfs_abort_transaction(trans, root, ret);
+		goto out;
+	}
 
 	ret = __finish_chunk_alloc(trans, extent_root, sys_map,
 				   sys_chunk_offset, sys_chunk_size,
 				   sys_stripe_size);
 	if (ret)
-		goto abort;
+		btrfs_abort_transaction(trans, root, ret);
 
-	return 0;
+out:
 
-abort:
-	btrfs_abort_transaction(trans, root, ret);
 	return ret;
 }
 
-- 
1.7.9

