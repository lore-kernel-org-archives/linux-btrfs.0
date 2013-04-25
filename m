Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48479 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3DYUZE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 16:25:04 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 855F79A0699
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 14:25:03 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id EIXn5x1Su9xrcs1I (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 14:25:02 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove almost all of the BUG()'s from tree-log.c
Date: Thu, 25 Apr 2013 16:24:57 -0400
Message-ID: <1366921497-3762-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There were a whole bunch and I was doing it for other things.  I haven't tested
these error paths but at the very least this is better than panicing.  I've only
left 2 BUG_ON()'s since they are logic errors and I want to replace them with a
ASSERT framework that we can compile out for production users.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |  151 +++++++++++++++++++++++++++++++++------------------
 1 files changed, 98 insertions(+), 53 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index aebfb2d..705aee6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -589,7 +589,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, root, inode, start, extent_end, 1);
-	BUG_ON(ret);
+	if (ret)
+		goto out;
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
@@ -599,7 +600,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 
 		ret = btrfs_insert_empty_item(trans, root, path, key,
 					      sizeof(*item));
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 		dest_offset = btrfs_item_ptr_offset(path->nodes[0],
 						    path->slots[0]);
 		copy_extent_buffer(path->nodes[0], eb, dest_offset,
@@ -653,26 +655,30 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			ret = btrfs_lookup_csums_range(root->log_root,
 						csum_start, csum_end - 1,
 						&ordered_sums, 0);
-			BUG_ON(ret);
+			if (ret)
+				goto out;
 			while (!list_empty(&ordered_sums)) {
 				struct btrfs_ordered_sum *sums;
 				sums = list_entry(ordered_sums.next,
 						struct btrfs_ordered_sum,
 						list);
-				ret = btrfs_csum_file_blocks(trans,
+				if (!ret)
+					ret = btrfs_csum_file_blocks(trans,
 						root->fs_info->csum_root,
 						sums);
-				BUG_ON(ret);
 				list_del(&sums->list);
 				kfree(sums);
 			}
+			if (ret)
+				goto out;
 		} else {
 			btrfs_release_path(path);
 		}
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		/* inline extents are easy, we just overwrite them */
 		ret = overwrite_item(trans, root, path, eb, slot, key);
-		BUG_ON(ret);
+		if (ret)
+			goto out;
 	}
 
 	inode_add_bytes(inode, nbytes);
@@ -717,20 +723,21 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 
 	inode = read_one_inode(root, location.objectid);
 	if (!inode) {
-		kfree(name);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	ret = link_to_fixup_dir(trans, root, path, location.objectid);
-	BUG_ON(ret);
+	if (ret)
+		goto out;
 
 	ret = btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
-	BUG_ON(ret);
+	if (ret)
+		goto out;
+	btrfs_run_delayed_items(trans, root);
+out:
 	kfree(name);
-
 	iput(inode);
-
-	btrfs_run_delayed_items(trans, root);
 	return ret;
 }
 
@@ -883,7 +890,8 @@ again:
 			victim_name_len = btrfs_inode_ref_name_len(leaf,
 								   victim_ref);
 			victim_name = kmalloc(victim_name_len, GFP_NOFS);
-			BUG_ON(!victim_name);
+			if (!victim_name)
+				return -ENOMEM;
 
 			read_extent_buffer(leaf, victim_name,
 					   (unsigned long)(victim_ref + 1),
@@ -899,9 +907,10 @@ again:
 				ret = btrfs_unlink_inode(trans, root, dir,
 							 inode, victim_name,
 							 victim_name_len);
-				BUG_ON(ret);
-				btrfs_run_delayed_items(trans, root);
 				kfree(victim_name);
+				if (ret)
+					return ret;
+				btrfs_run_delayed_items(trans, root);
 				*search_done = 1;
 				goto again;
 			}
@@ -909,7 +918,6 @@ again:
 
 			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
 		}
-		BUG_ON(ret);
 
 		/*
 		 * NOTE: we have searched root tree and checked the
@@ -943,6 +951,8 @@ again:
 				goto next;
 
 			victim_name = kmalloc(victim_name_len, GFP_NOFS);
+			if (!victim_name)
+				return -ENOMEM;
 			read_extent_buffer(leaf, victim_name, (unsigned long)&extref->name,
 					   victim_name_len);
 
@@ -969,14 +979,16 @@ again:
 								 victim_name_len);
 					btrfs_run_delayed_items(trans, root);
 				}
-				BUG_ON(ret);
 				iput(victim_parent);
 				kfree(victim_name);
+				if (ret)
+					return ret;
 				*search_done = 1;
 				goto again;
 			}
 			kfree(victim_name);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 next:
 			cur_offset += victim_name_len + sizeof(*extref);
 		}
@@ -989,7 +1001,8 @@ next:
 					 ref_index, name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 	btrfs_release_path(path);
 
@@ -998,7 +1011,8 @@ next:
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 	}
 	btrfs_release_path(path);
 
@@ -1143,15 +1157,19 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 						      parent_objectid,
 						      ref_index, name, namelen,
 						      &search_done);
-				if (ret == 1)
+				if (ret == 1) {
+					ret = 0;
+					goto out;
+				}
+				if (ret)
 					goto out;
-				BUG_ON(ret);
 			}
 
 			/* insert our name */
 			ret = btrfs_add_link(trans, dir, inode, name, namelen,
 					     0, ref_index);
-			BUG_ON(ret);
+			if (ret)
+				goto out;
 
 			btrfs_update_inode(trans, root, inode);
 		}
@@ -1166,13 +1184,11 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 
 	/* finally write the back reference in the inode */
 	ret = overwrite_item(trans, root, path, eb, slot, key);
-	BUG_ON(ret);
-
 out:
 	btrfs_release_path(path);
 	iput(dir);
 	iput(inode);
-	return 0;
+	return ret;
 }
 
 static int insert_orphan_item(struct btrfs_trans_handle *trans,
@@ -1330,10 +1346,10 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 		if (S_ISDIR(inode->i_mode)) {
 			ret = replay_dir_deletes(trans, root, NULL, path,
 						 ino, 1);
-			BUG_ON(ret);
+			if (ret)
+				goto out;
 		}
 		ret = insert_orphan_item(trans, root, ino);
-		BUG_ON(ret);
 	}
 
 out:
@@ -1378,9 +1394,9 @@ static noinline int fixup_inode_link_counts(struct btrfs_trans_handle *trans,
 			return -EIO;
 
 		ret = fixup_inode_link_count(trans, root, inode);
-		BUG_ON(ret);
-
 		iput(inode);
+		if (ret)
+			goto out;
 
 		/*
 		 * fixup on a directory may create new entries,
@@ -1430,7 +1446,7 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 	} else if (ret == -EEXIST) {
 		ret = 0;
 	} else {
-		BUG();
+		BUG(); /* Logic Error */
 	}
 	iput(inode);
 
@@ -1499,7 +1515,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	struct inode *dir;
 	u8 log_type;
 	int exists;
-	int ret;
+	int ret = 0;
 
 	dir = read_one_inode(root, key->objectid);
 	if (!dir)
@@ -1531,7 +1547,9 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 						     key->offset, name,
 						     name_len, 1);
 	} else {
-		BUG();
+		/* Corruption */
+		ret = -EINVAL;
+		goto out;
 	}
 	if (IS_ERR_OR_NULL(dst_di)) {
 		/* we need a sequence number to insert, so we only
@@ -1559,7 +1577,8 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		goto out;
 
 	ret = drop_one_dir_item(trans, root, path, dir, dst_di);
-	BUG_ON(ret);
+	if (ret)
+		goto out;
 
 	if (key->type == BTRFS_DIR_INDEX_KEY)
 		goto insert;
@@ -1567,14 +1586,15 @@ out:
 	btrfs_release_path(path);
 	kfree(name);
 	iput(dir);
-	return 0;
+	return ret;
 
 insert:
 	btrfs_release_path(path);
 	ret = insert_one_name(trans, root, path, key->objectid, key->offset,
 			      name, name_len, log_type, &log_key);
-
-	BUG_ON(ret && ret != -ENOENT);
+	if (ret && ret != -ENOENT)
+		goto out;
+	ret = 0;
 	goto out;
 }
 
@@ -1605,7 +1625,8 @@ static noinline int replay_one_dir_item(struct btrfs_trans_handle *trans,
 			return -EIO;
 		name_len = btrfs_dir_name_len(eb, di);
 		ret = replay_one_name(trans, root, path, eb, di, key);
-		BUG_ON(ret);
+		if (ret)
+			return ret;
 		ptr = (unsigned long)(di + 1);
 		ptr += name_len;
 	}
@@ -1766,16 +1787,21 @@ again:
 
 			ret = link_to_fixup_dir(trans, root,
 						path, location.objectid);
-			BUG_ON(ret);
+			if (ret) {
+				kfree(name);
+				iput(inode);
+				goto out;
+			}
+
 			btrfs_inc_nlink(inode);
 			ret = btrfs_unlink_inode(trans, root, dir, inode,
 						 name, name_len);
-			BUG_ON(ret);
-
-			btrfs_run_delayed_items(trans, root);
-
+			if (!ret)
+				btrfs_run_delayed_items(trans, root);
 			kfree(name);
 			iput(inode);
+			if (ret)
+				goto out;
 
 			/* there might still be more names under this key
 			 * check and repeat if required
@@ -1879,7 +1905,8 @@ again:
 			ret = check_item_in_log(trans, root, log, path,
 						log_path, dir,
 						&found_key);
-			BUG_ON(ret);
+			if (ret)
+				goto out;
 			if (found_key.offset == (u64)-1)
 				break;
 			dir_key.offset = found_key.offset + 1;
@@ -2083,7 +2110,10 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 					BTRFS_TREE_LOG_OBJECTID);
 				ret = btrfs_free_and_pin_reserved_extent(root,
 							 bytenr, blocksize);
-				BUG_ON(ret); /* -ENOMEM or logic errors */
+				if (ret) {
+					free_extent_buffer(next);
+					return ret;
+				}
 			}
 			free_extent_buffer(next);
 			continue;
@@ -2156,7 +2186,8 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 				ret = btrfs_free_and_pin_reserved_extent(root,
 						path->nodes[*level]->start,
 						path->nodes[*level]->len);
-				BUG_ON(ret);
+				if (ret)
+					return ret;
 			}
 			free_extent_buffer(path->nodes[*level]);
 			path->nodes[*level] = NULL;
@@ -2229,7 +2260,8 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 				BTRFS_TREE_LOG_OBJECTID);
 			ret = btrfs_free_and_pin_reserved_extent(log, next->start,
 							 next->len);
-			BUG_ON(ret); /* -ENOMEM or logic errors */
+			if (ret)
+				goto out;
 		}
 	}
 
@@ -2517,7 +2549,10 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 
 	if (trans) {
 		ret = walk_log_tree(trans, log, &wc);
-		BUG_ON(ret);
+
+		/* I don't think this can happen but just in case */
+		if (ret)
+			btrfs_abort_transaction(trans, log, ret);
 	}
 
 	while (1) {
@@ -2625,7 +2660,10 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (di) {
 		ret = btrfs_delete_one_dir_name(trans, log, path, di);
 		bytes_del += name_len;
-		BUG_ON(ret);
+		if (ret) {
+			err = ret;
+			goto fail;
+		}
 	}
 	btrfs_release_path(path);
 	di = btrfs_lookup_dir_index_item(trans, log, path, dir_ino,
@@ -2637,7 +2675,10 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	if (di) {
 		ret = btrfs_delete_one_dir_name(trans, log, path, di);
 		bytes_del += name_len;
-		BUG_ON(ret);
+		if (ret) {
+			err = ret;
+			goto fail;
+		}
 	}
 
 	/* update the directory size in the log to reflect the names
@@ -2976,7 +3017,7 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		ret = btrfs_search_slot(trans, log, &key, path, -1, 1);
-		BUG_ON(ret == 0);
+		BUG_ON(ret == 0); /* Logic error */
 		if (ret < 0)
 			break;
 
@@ -3179,7 +3220,11 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						log->fs_info->csum_root,
 						ds + cs, ds + cs + cl - 1,
 						&ordered_sums, 0);
-				BUG_ON(ret);
+				if (ret) {
+					btrfs_release_path(dst_path);
+					kfree(ins_data);
+					return ret;
+				}
 			}
 		}
 	}
-- 
1.7.7.6

