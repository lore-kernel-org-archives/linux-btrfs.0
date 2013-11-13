Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f44.google.com ([209.85.128.44]:53762 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab3KMAXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 19:23:35 -0500
Received: by mail-qe0-f44.google.com with SMTP id 6so6180462qeb.17
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 16:23:34 -0800 (PST)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [PATCH v2 1/2] Btrfs: convert printk and pr_ to btrfs_* and fix btrfs: prefix
Date: Tue, 12 Nov 2013 19:22:52 -0500
Message-Id: <1384302173-32075-2-git-send-email-fholton@gmail.com>
In-Reply-To: <1384302173-32075-1-git-send-email-fholton@gmail.com>
References: <1384302173-32075-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert all applicable cases of printk and pr_ macros to the btrfs_* macro.
Fix btrfs: prefix in remaining cases.

Signed-off-by: Frank Holton <fholton@gmail.com>
---
v2: changed pr_ and printk to btrfs_ output macro

 fs/btrfs/backref.c               |   21 ++++----
 fs/btrfs/compression.c           |   11 ++--
 fs/btrfs/ctree.c                 |   14 ++---
 fs/btrfs/ctree.h                 |    4 +-
 fs/btrfs/delayed-inode.c         |   10 ++--
 fs/btrfs/delayed-ref.c           |    3 +-
 fs/btrfs/dev-replace.c           |   28 +++++-----
 fs/btrfs/dir-item.c              |    6 +--
 fs/btrfs/disk-io.c               |   45 ++++++++--------
 fs/btrfs/extent-tree.c           |   12 ++---
 fs/btrfs/extent_io.c             |   83 ++++++++++++++++++------------
 fs/btrfs/file-item.c             |    4 +-
 fs/btrfs/free-space-cache.c      |   14 ++---
 fs/btrfs/inode.c                 |   12 ++---
 fs/btrfs/ioctl.c                 |   28 +++++-----
 fs/btrfs/lzo.c                   |    6 +--
 fs/btrfs/ordered-data.c          |    9 ++--
 fs/btrfs/qgroup.c                |   29 ++++++-----
 fs/btrfs/reada.c                 |   14 ++---
 fs/btrfs/relocation.c            |    4 +-
 fs/btrfs/root-tree.c             |    3 +-
 fs/btrfs/scrub.c                 |   27 +++++-----
 fs/btrfs/super.c                 |  105 ++++++++++++++++++--------------------
 fs/btrfs/tests/extent-io-tests.c |    3 +-
 fs/btrfs/transaction.c           |    4 +-
 fs/btrfs/uuid-tree.c             |   12 ++---
 fs/btrfs/volumes.c               |   70 ++++++++++++-------------
 27 files changed, 301 insertions(+), 280 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 3775947..0bab8a9 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -316,8 +316,8 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 
 	path->lowest_level = level;
 	ret = btrfs_search_old_slot(root, &ref->key_for_search, path, time_seq);
-	pr_debug("search slot in root %llu (level %d, ref count %d) returned "
-		 "%d for key (%llu %u %llu)\n",
+	btrfs_debug(fs_info, "search slot in root %llu (level %d, ref count %d) "
+		 "returned %d for key (%llu %u %llu)",
 		 ref->root_id, level, ref->count, ret,
 		 ref->key_for_search.objectid, ref->key_for_search.type,
 		 ref->key_for_search.offset);
@@ -1350,7 +1350,8 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	     found_key->type != BTRFS_METADATA_ITEM_KEY) ||
 	    found_key->objectid > logical ||
 	    found_key->objectid + size <= logical) {
-		pr_debug("logical %llu is not within any extent\n", logical);
+		btrfs_debug(fs_info, "logical %llu is not within any extent",
+				logical);
 		return -ENOENT;
 	}
 
@@ -1361,8 +1362,8 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
 	flags = btrfs_extent_flags(eb, ei);
 
-	pr_debug("logical %llu is at position %llu within the extent (%llu "
-		 "EXTENT_ITEM %llu) flags %#llx size %u\n",
+	btrfs_debug(fs_info, "logical %llu is at position %llu within the extent"
+		 "(%llu EXTENT_ITEM %llu) flags %#llx size %u",
 		 logical, logical - found_key->objectid, found_key->objectid,
 		 found_key->offset, flags, item_size);
 
@@ -1510,7 +1511,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	struct ulist_iterator ref_uiter;
 	struct ulist_iterator root_uiter;
 
-	pr_debug("resolving all inodes for extent %llu\n",
+	btrfs_debug(fs_info, "resolving all inodes for extent %llu",
 			extent_item_objectid);
 
 	if (!search_commit_root) {
@@ -1534,8 +1535,8 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 			break;
 		ULIST_ITER_INIT(&root_uiter);
 		while (!ret && (root_node = ulist_next(roots, &root_uiter))) {
-			pr_debug("root %llu references leaf %llu, data list "
-				 "%#llx\n", root_node->val, ref_node->val,
+			btrfs_debug(fs_info, "root %llu references leaf %llu, data list "
+				 "%#llx", root_node->val, ref_node->val,
 				 ref_node->aux);
 			ret = iterate_leaf_refs((struct extent_inode_elem *)
 						(uintptr_t)ref_node->aux,
@@ -1627,8 +1628,8 @@ static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
 		for (cur = 0; cur < btrfs_item_size(eb, item); cur += len) {
 			name_len = btrfs_inode_ref_name_len(eb, iref);
 			/* path must be released before calling iterate()! */
-			pr_debug("following ref at offset %u for inode %llu in "
-				 "tree %llu\n", cur, found_key.objectid,
+			btrfs_debug(fs_root->fs_info, "following ref at offset %u for "
+				 "inode %llu in tree %llu", cur, found_key.objectid,
 				 fs_root->objectid);
 			ret = iterate(parent, name_len,
 				      (unsigned long)(iref + 1), eb, ctx);
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1499b27..452e94a 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -128,10 +128,10 @@ static int check_compressed_csum(struct inode *inode,
 		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
-			printk(KERN_INFO "btrfs csum failed ino %llu "
-			       "extent %llu csum %u "
-			       "wanted %u mirror %d\n",
-			       btrfs_ino(inode), disk_start, csum, *cb_sum,
+			btrfs_info(BTRFS_I(inode)->root->fs_info, "csum failed "
+				   "ino %llu extent %llu csum %u "
+				   "wanted %u mirror %d",
+				   btrfs_ino(inode), disk_start, csum, *cb_sum,
 			       cb->mirror_num);
 			ret = -EIO;
 			goto fail;
@@ -412,7 +412,8 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
 		}
 		if (bytes_left < PAGE_CACHE_SIZE) {
-			printk("bytes left %lu compress len %lu nr %lu\n",
+			btrfs_info(BTRFS_I(inode)->root->fs_info, "bytes left %lu compress"
+				   "len %lu nr %lu",
 			       bytes_left, cb->compressed_len, cb->nr_pages);
 		}
 		bytes_left -= PAGE_CACHE_SIZE;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 316136b..fe1dc0e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1287,8 +1287,8 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		old = read_tree_block(root, logical, blocksize, 0);
 		if (WARN_ON(!old || !extent_buffer_uptodate(old))) {
 			free_extent_buffer(old);
-			pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
-				logical);
+			btrfs_warn(root->fs_info, "failed to read tree block %llu from "
+				 "get_old_root", logical);
 		} else {
 			eb = btrfs_clone_extent_buffer(old);
 			free_extent_buffer(old);
@@ -3362,8 +3362,8 @@ noinline int btrfs_leaf_free_space(struct btrfs_root *root,
 	int ret;
 	ret = BTRFS_LEAF_DATA_SIZE(root) - leaf_space_used(leaf, 0, nritems);
 	if (ret < 0) {
-		printk(KERN_CRIT "leaf free space ret %d, leaf data size %lu, "
-		       "used %d nritems %d\n",
+		btrfs_crit(root->fs_info, "leaf free space ret %d, leaf data size %lu, "
+			   "used %d nritems %d",
 		       ret, (unsigned long) BTRFS_LEAF_DATA_SIZE(root),
 		       leaf_space_used(leaf, 0, nritems), nritems);
 	}
@@ -4432,7 +4432,7 @@ void btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	BUG_ON(slot < 0);
 	if (slot >= nritems) {
 		btrfs_print_leaf(root, leaf);
-		printk(KERN_CRIT "slot %d too large, nritems %d\n",
+		btrfs_crit(root->fs_info, "slot %d too large, nritems %d",
 		       slot, nritems);
 		BUG_ON(1);
 	}
@@ -4495,7 +4495,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 	if (btrfs_leaf_free_space(root, leaf) < total_size) {
 		btrfs_print_leaf(root, leaf);
-		printk(KERN_CRIT "not enough freespace need %u have %d\n",
+		btrfs_crit(root->fs_info, "not enough freespace need %u have %d",
 		       total_size, btrfs_leaf_free_space(root, leaf));
 		BUG();
 	}
@@ -4505,7 +4505,7 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 
 		if (old_data < data_end) {
 			btrfs_print_leaf(root, leaf);
-			printk(KERN_CRIT "slot %d old_data %d data_end %d\n",
+			btrfs_crit(root->fs_info, "slot %d old_data %d data_end %d",
 			       slot, old_data, data_end);
 			BUG_ON(1);
 		}
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f013a31..e319d25 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3816,7 +3816,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 
 static inline void assfail(char *expr, char *file, int line)
 {
-	printk(KERN_ERR "BTRFS assertion failed: %s, file: %s, line: %d",
+	pr_err("btrfs: assertion failed: %s, file: %s, line: %d",
 	       expr, file, line);
 	BUG();
 }
@@ -3854,7 +3854,7 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
 		if (!(features & flag)) {
 			features |= flag;
 			btrfs_set_super_incompat_flags(disk_super, features);
-			printk(KERN_INFO "btrfs: setting %llu feature flag\n",
+			btrfs_info(fs_info, "setting %llu feature flag",
 					 flag);
 		}
 		spin_unlock(&fs_info->super_lock);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 8d292fb..cea715f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1472,9 +1472,9 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&delayed_node->mutex);
 	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "err add delayed dir index item(name: %.*s) "
+		btrfs_err(root->fs_info, "err add delayed dir index item(name: %.*s) "
 				"into the insertion tree of the delayed node"
-				"(root id: %llu, inode id: %llu, errno: %d)\n",
+				"(root id: %llu, inode id: %llu, errno: %d)",
 				name_len, name, delayed_node->root->objectid,
 				delayed_node->inode_id, ret);
 		BUG();
@@ -1544,9 +1544,9 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&node->mutex);
 	ret = __btrfs_add_delayed_deletion_item(node, item);
 	if (unlikely(ret)) {
-		printk(KERN_ERR "err add delayed dir index item(index: %llu) "
-				"into the deletion tree of the delayed node"
-				"(root id: %llu, inode id: %llu, errno: %d)\n",
+		btrfs_crit(root->fs_info, "err add delayed dir index item(index: %llu)"
+				" into the deletion tree of the delayed node"
+				"(root id: %llu, inode id: %llu, errno: %d)",
 				index, node->root->objectid, node->inode_id,
 				ret);
 		BUG();
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e4d467b..fd26823 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -361,7 +361,8 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 		elem = list_first_entry(&fs_info->tree_mod_seq_list,
 					struct seq_list, list);
 		if (seq >= elem->seq) {
-			pr_debug("holding back delayed_ref %#x.%x, lowest is %#x.%x (%p)\n",
+			btrfs_debug(fs_info, "holding back delayed_ref %#x.%x, "
+				 "lowest is %#x.%x (%p)",
 				 (u32)(seq >> 32), (u32)seq,
 				 (u32)(elem->seq >> 32), (u32)elem->seq,
 				 delayed_refs);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 3e41097..f6f50d2 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -102,7 +102,7 @@ no_valid_dev_replace_entry_found:
 	ptr = btrfs_item_ptr(eb, slot, struct btrfs_dev_replace_item);
 
 	if (item_size != sizeof(struct btrfs_dev_replace_item)) {
-		pr_warn("btrfs: dev_replace entry found has unexpected size, ignore entry\n");
+		btrfs_warn(fs_info, "dev_replace entry found has unexpected size, ignore entry");
 		goto no_valid_dev_replace_entry_found;
 	}
 
@@ -145,13 +145,17 @@ no_valid_dev_replace_entry_found:
 		if (!dev_replace->srcdev &&
 		    !btrfs_test_opt(dev_root, DEGRADED)) {
 			ret = -EIO;
-			pr_warn("btrfs: cannot mount because device replace operation is ongoing and\n" "srcdev (devid %llu) is missing, need to run 'btrfs dev scan'?\n",
+			btrfs_warn(fs_info, "cannot mount because device replace operation"
+				 " is ongoing and\n" "srcdev (devid %llu) is missing, need to "
+				 "run 'btrfs dev scan'?",
 				src_devid);
 		}
 		if (!dev_replace->tgtdev &&
 		    !btrfs_test_opt(dev_root, DEGRADED)) {
 			ret = -EIO;
-			pr_warn("btrfs: cannot mount because device replace operation is ongoing and\n" "tgtdev (devid %llu) is missing, need to run btrfs dev scan?\n",
+			btrfs_warn(fs_info, "cannot mount because device replace operation "
+				 "is ongoing and\n" "tgtdev (devid %llu) is missing, need to "
+				 "run btrfs dev scan?",
 				BTRFS_DEV_REPLACE_DEVID);
 		}
 		if (dev_replace->tgtdev) {
@@ -210,7 +214,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 	}
 	ret = btrfs_search_slot(trans, dev_root, &key, path, -1, 1);
 	if (ret < 0) {
-		pr_warn("btrfs: error %d while searching for dev_replace item!\n",
+		btrfs_warn(fs_info, "error %d while searching for dev_replace item!",
 			ret);
 		goto out;
 	}
@@ -230,7 +234,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 		 */
 		ret = btrfs_del_item(trans, dev_root, path);
 		if (ret != 0) {
-			pr_warn("btrfs: delete too small dev_replace item failed %d!\n",
+			btrfs_warn(fs_info, "delete too small dev_replace item failed %d!",
 				ret);
 			goto out;
 		}
@@ -243,7 +247,7 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 		ret = btrfs_insert_empty_item(trans, dev_root, path,
 					      &key, sizeof(*ptr));
 		if (ret < 0) {
-			pr_warn("btrfs: insert dev_replace item failed %d!\n",
+			btrfs_warn(fs_info, "insert dev_replace item failed %d!",
 				ret);
 			goto out;
 		}
@@ -305,7 +309,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	struct btrfs_device *src_device = NULL;
 
 	if (btrfs_fs_incompat(fs_info, RAID56)) {
-		pr_warn("btrfs: dev_replace cannot yet handle RAID5/RAID6\n");
+		btrfs_warn(fs_info, "dev_replace cannot yet handle RAID5/RAID6");
 		return -EINVAL;
 	}
 
@@ -325,7 +329,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	ret = btrfs_init_dev_replace_tgtdev(root, args->start.tgtdev_name,
 					    &tgt_device);
 	if (ret) {
-		pr_err("btrfs: target device %s is invalid!\n",
+		btrfs_err(fs_info, "target device %s is invalid!",
 		       args->start.tgtdev_name);
 		mutex_unlock(&fs_info->volume_mutex);
 		return -EINVAL;
@@ -341,7 +345,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	}
 
 	if (tgt_device->total_bytes < src_device->total_bytes) {
-		pr_err("btrfs: target device is smaller than source device!\n");
+		btrfs_err(fs_info, "target device is smaller than source device!");
 		ret = -EINVAL;
 		goto leave_no_lock;
 	}
@@ -699,7 +703,7 @@ void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info)
 			BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
 		dev_replace->time_stopped = get_seconds();
 		dev_replace->item_needs_writeback = 1;
-		pr_info("btrfs: suspending dev_replace for unmount\n");
+		btrfs_info(fs_info, "suspending dev_replace for unmount");
 		break;
 	}
 
@@ -728,8 +732,8 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 		break;
 	}
 	if (!dev_replace->tgtdev || !dev_replace->tgtdev->bdev) {
-		pr_info("btrfs: cannot continue dev_replace, tgtdev is missing\n"
-			"btrfs: you may cancel the operation after 'mount -o degraded'\n");
+		btrfs_info(fs_info, "cannot continue dev_replace, tgtdev is missing"
+			"btrfs: you may cancel the operation after 'mount -o degraded'");
 		btrfs_dev_replace_unlock(dev_replace);
 		return 0;
 	}
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c031ea3..9cc2be0 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -459,7 +459,7 @@ int verify_dir_item(struct btrfs_root *root,
 	u8 type = btrfs_dir_type(leaf, dir_item);
 
 	if (type >= BTRFS_FT_MAX) {
-		printk(KERN_CRIT "btrfs: invalid dir item type: %d\n",
+		btrfs_crit(root->fs_info, "invalid dir item type: %d",
 		       (int)type);
 		return 1;
 	}
@@ -468,7 +468,7 @@ int verify_dir_item(struct btrfs_root *root,
 		namelen = XATTR_NAME_MAX;
 
 	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
-		printk(KERN_CRIT "btrfs: invalid dir item name len: %u\n",
+		btrfs_crit(root->fs_info, "invalid dir item name len: %u",
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
@@ -476,7 +476,7 @@ int verify_dir_item(struct btrfs_root *root,
 	/* BTRFS_MAX_XATTR_SIZE is the same for all dir items */
 	if ((btrfs_dir_data_len(leaf, dir_item) +
 	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)) {
-		printk(KERN_CRIT "btrfs: invalid dir item name + data len: %u + %u\n",
+		btrfs_crit(root->fs_info, "invalid dir item name + data len: %u + %u",
 		       (unsigned)btrfs_dir_name_len(leaf, dir_item),
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4c4ed0b..81ca09a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -500,8 +500,8 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 }
 
 #define CORRUPT(reason, eb, root, slot)				\
-	printk(KERN_CRIT "btrfs: corrupt leaf, %s: block=%llu,"	\
-	       "root=%llu, slot=%d\n", reason,			\
+	btrfs_crit(root->fs_info, "btrfs: corrupt leaf, %s: block=%llu,"	\
+		   "root=%llu, slot=%d", reason,			\
 	       btrfs_header_bytenr(eb),	root->objectid, slot)
 
 static noinline int check_leaf(struct btrfs_root *root,
@@ -600,21 +600,21 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		printk_ratelimited(KERN_INFO "btrfs bad tree block start "
+		printk_ratelimited(KERN_INFO "btrfs: bad tree block start "
 			       "%llu %llu\n",
 			       found_start, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
-		printk_ratelimited(KERN_INFO "btrfs bad fsid on block %llu\n",
+		printk_ratelimited(KERN_INFO "btrfs: bad fsid on block %llu\n",
 			       eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	found_level = btrfs_header_level(eb);
 	if (found_level >= BTRFS_MAX_LEVEL) {
-		btrfs_info(root->fs_info, "bad tree block level %d\n",
+		btrfs_info(root->fs_info, "bad tree block level %d",
 			   (int)btrfs_header_level(eb));
 		ret = -EIO;
 		goto err;
@@ -1010,8 +1010,9 @@ static void btree_invalidatepage(struct page *page, unsigned int offset,
 	extent_invalidatepage(tree, page, offset);
 	btree_releasepage(page, GFP_NOFS);
 	if (PagePrivate(page)) {
-		printk(KERN_WARNING "btrfs warning page private not zero "
-		       "on page %llu\n", (unsigned long long)page_offset(page));
+		btrfs_warn(BTRFS_I(page->mapping->host)->root->fs_info, "btrfs warning"
+			   " page private not zero "
+			   "on page %llu", (unsigned long long)page_offset(page));
 		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		page_cache_release(page);
@@ -2391,7 +2392,7 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_incompat_flags(disk_super) &
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
-		printk(KERN_ERR "BTRFS: couldn't mount because of "
+		printk(KERN_ERR "btrfs: couldn't mount because of "
 		       "unsupported optional features (%Lx).\n",
 		       features);
 		err = -EINVAL;
@@ -2400,7 +2401,7 @@ int open_ctree(struct super_block *sb,
 
 	if (btrfs_super_leafsize(disk_super) !=
 	    btrfs_super_nodesize(disk_super)) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		printk(KERN_ERR "btrfs: couldn't mount because metadata "
 		       "blocksizes don't match.  node %d leaf %d\n",
 		       btrfs_super_nodesize(disk_super),
 		       btrfs_super_leafsize(disk_super));
@@ -2408,7 +2409,7 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 	if (btrfs_super_leafsize(disk_super) > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		printk(KERN_ERR "BTRFS: couldn't mount because metadata "
+		printk(KERN_ERR "btrfs: couldn't mount because metadata "
 		       "blocksize (%d) was too large\n",
 		       btrfs_super_leafsize(disk_super));
 		err = -EINVAL;
@@ -2429,7 +2430,7 @@ int open_ctree(struct super_block *sb,
 	 */
 	if (btrfs_super_leafsize(disk_super) > PAGE_CACHE_SIZE) {
 		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			printk(KERN_INFO "btrfs flagging fs with big metadata feature\n");
+			printk(KERN_INFO "btrfs: flagging fs with big metadata feature\n");
 		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
 	}
 
@@ -2461,7 +2462,7 @@ int open_ctree(struct super_block *sb,
 	features = btrfs_super_compat_ro_flags(disk_super) &
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
+		printk(KERN_ERR "btrfs: couldn't mount RDWR because of "
 		       "unsupported option features (%Lx).\n",
 		       features);
 		err = -EINVAL;
@@ -2745,13 +2746,13 @@ retry_root_backup:
 
 	ret = btrfs_init_space_info(fs_info);
 	if (ret) {
-		printk(KERN_ERR "Failed to initial space info: %d\n", ret);
+		printk(KERN_ERR "btrfs: Failed to initial space info: %d\n", ret);
 		goto fail_block_groups;
 	}
 
 	ret = btrfs_read_block_groups(extent_root);
 	if (ret) {
-		printk(KERN_ERR "Failed to read block groups: %d\n", ret);
+		printk(KERN_ERR "btrfs: Failed to read block groups: %d\n", ret);
 		goto fail_block_groups;
 	}
 	fs_info->num_tolerated_disk_barrier_failures =
@@ -2760,7 +2761,7 @@ retry_root_backup:
 	     fs_info->num_tolerated_disk_barrier_failures &&
 	    !(sb->s_flags & MS_RDONLY)) {
 		printk(KERN_WARNING
-		       "Btrfs: too many missing devices, writeable mount is not allowed\n");
+			   "btrfs: too many missing devices, writeable mount is not allowed\n");
 		goto fail_block_groups;
 	}
 
@@ -2778,7 +2779,7 @@ retry_root_backup:
 	if (!btrfs_test_opt(tree_root, SSD) &&
 	    !btrfs_test_opt(tree_root, NOSSD) &&
 	    !fs_info->fs_devices->rotating) {
-		printk(KERN_INFO "Btrfs detected SSD devices, enabling SSD "
+		printk(KERN_INFO "btrfs: detected SSD devices, enabling SSD "
 		       "mode\n");
 		btrfs_set_opt(fs_info->mount_opt, SSD);
 	}
@@ -2804,7 +2805,7 @@ retry_root_backup:
 		u64 bytenr = btrfs_super_log_root(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
-			printk(KERN_WARNING "Btrfs log replay required "
+			printk(KERN_WARNING "btrfs: log replay required "
 			       "on RO media\n");
 			err = -EIO;
 			goto fail_qgroup;
@@ -3000,7 +3001,7 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 		struct btrfs_device *device = (struct btrfs_device *)
 			bh->b_private;
 
-		printk_ratelimited_in_rcu(KERN_WARNING "lost page write due to "
+		printk_ratelimited_in_rcu(KERN_WARNING "btrfs: lost page write due to "
 					  "I/O error on %s\n",
 					  rcu_str_deref(device->name));
 		/* note, we dont' set_buffer_write_io_error because we have
@@ -3407,7 +3408,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 			total_errors++;
 	}
 	if (total_errors > max_errors) {
-		printk(KERN_ERR "btrfs: %d errors while writing supers\n",
+		btrfs_err(root->fs_info, "btrfs: %d errors while writing supers",
 		       total_errors);
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
@@ -3582,7 +3583,7 @@ int close_ctree(struct btrfs_root *root)
 	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_commit_super(root);
 		if (ret)
-			printk(KERN_ERR "btrfs: commit super ret %d\n", ret);
+			btrfs_err(root->fs_info, "btrfs: commit super ret %d", ret);
 	}
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
@@ -3599,7 +3600,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_free_qgroup_config(root->fs_info);
 
 	if (percpu_counter_sum(&fs_info->delalloc_bytes)) {
-		printk(KERN_INFO "btrfs: at unmount delalloc count %lld\n",
+		btrfs_info(root->fs_info, "btrfs: at unmount delalloc count %lld",
 		       percpu_counter_sum(&fs_info->delalloc_bytes));
 	}
 
@@ -3824,7 +3825,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	spin_lock(&delayed_refs->lock);
 	if (delayed_refs->num_entries == 0) {
 		spin_unlock(&delayed_refs->lock);
-		printk(KERN_INFO "delayed_refs has NO entry\n");
+		btrfs_info(root->fs_info, "delayed_refs has NO entry");
 		return ret;
 	}
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 42f1c8e..1efda46 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5840,8 +5840,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 
 	refs = btrfs_extent_refs(leaf, ei);
 	if (refs < refs_to_drop) {
-		btrfs_err(info, "trying to drop %d refs but we only have %Lu "
-			  "for bytenr %Lu\n", refs_to_drop, refs, bytenr);
+		btrfs_err(info, "trying to drop %d refs but we only have %llu "
+			  "for bytenr %llu", refs_to_drop, refs, bytenr);
 		ret = -EINVAL;
 		btrfs_abort_transaction(trans, extent_root, ret);
 		goto out;
@@ -6591,12 +6591,12 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 	int index = 0;
 
 	spin_lock(&info->lock);
-	printk(KERN_INFO "space_info %llu has %llu free, is %sfull\n",
+	printk(KERN_INFO "btrfs: space_info %llu has %llu free, is %sfull\n",
 	       info->flags,
 	       info->total_bytes - info->bytes_used - info->bytes_pinned -
 	       info->bytes_reserved - info->bytes_readonly,
 	       (info->full) ? "" : "not ");
-	printk(KERN_INFO "space_info total=%llu, used=%llu, pinned=%llu, "
+	printk(KERN_INFO "btrfs: space_info total=%llu, used=%llu, pinned=%llu, "
 	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
 	       info->total_bytes, info->bytes_used, info->bytes_pinned,
 	       info->bytes_reserved, info->bytes_may_use,
@@ -6610,7 +6610,7 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 again:
 	list_for_each_entry(cache, &info->block_groups[index], list) {
 		spin_lock(&cache->lock);
-		printk(KERN_INFO "block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
+		printk(KERN_INFO "btrfs: block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
 		       cache->key.objectid, cache->key.offset,
 		       btrfs_block_group_used(&cache->item), cache->pinned,
 		       cache->reserved, cache->ro ? "[readonly]" : "");
@@ -7721,7 +7721,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 
 			btrfs_end_transaction_throttle(trans, tree_root);
 			if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
-				pr_debug("btrfs: drop snapshot early exit\n");
+				btrfs_debug(root->fs_info, "drop snapshot early exit");
 				err = -EAGAIN;
 				goto out_free;
 			}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 856bc2b..227cdd5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -59,7 +59,7 @@ void btrfs_leak_debug_check(void)
 
 	while (!list_empty(&states)) {
 		state = list_entry(states.next, struct extent_state, leak_list);
-		printk(KERN_ERR "btrfs state leak: start %llu end %llu "
+		printk(KERN_ERR "btrfs: state leak: start %llu end %llu "
 		       "state %lu in tree %p refs %d\n",
 		       state->start, state->end, state->state, state->tree,
 		       atomic_read(&state->refs));
@@ -69,7 +69,7 @@ void btrfs_leak_debug_check(void)
 
 	while (!list_empty(&buffers)) {
 		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
-		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
+		printk(KERN_ERR "btrfs: buffer leak start %llu len %lu "
 		       "refs %d\n",
 		       eb->start, eb->len, atomic_read(&eb->refs));
 		list_del(&eb->leak_list);
@@ -390,7 +390,7 @@ static int insert_state(struct extent_io_tree *tree,
 	struct rb_node *node;
 
 	if (end < start)
-		WARN(1, KERN_ERR "btrfs end < start %llu %llu\n",
+		WARN(1, KERN_ERR "btrfs: end < start %llu %llu\n",
 		       end, start);
 	state->start = start;
 	state->end = end;
@@ -401,7 +401,7 @@ static int insert_state(struct extent_io_tree *tree,
 	if (node) {
 		struct extent_state *found;
 		found = rb_entry(node, struct extent_state, rb_node);
-		printk(KERN_ERR "btrfs found node %llu %llu on insert of "
+		printk(KERN_ERR "btrfs: found node %llu %llu on insert of "
 		       "%llu %llu\n",
 		       found->start, found->end, start, end);
 		return -EEXIST;
@@ -2021,7 +2021,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 		return -EIO;
 	}
 
-	printk_ratelimited_in_rcu(KERN_INFO "btrfs read error corrected: ino %lu off %llu "
+	printk_ratelimited_in_rcu(KERN_INFO "btrfs: read error corrected: ino %lu off %llu "
 		      "(dev %s sector %llu)\n", page->mapping->host->i_ino,
 		      start, rcu_str_deref(dev->name), sector);
 
@@ -2080,8 +2080,8 @@ static int clean_io_failure(u64 start, struct page *page)
 
 	if (failrec->in_validation) {
 		/* there was no real error, just free the record */
-		pr_debug("clean_io_failure: freeing dummy error at %llu\n",
-			 failrec->start);
+		btrfs_debug(BTRFS_I(inode)->root->fs_info, "clean_io_failure: freeing "
+			 "dummy error at %llu", failrec->start);
 		did_repair = 1;
 		goto out;
 	}
@@ -2179,8 +2179,9 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 			extent_set_compress_type(&failrec->bio_flags,
 						 em->compress_type);
 		}
-		pr_debug("bio_readpage_error: (new) logical=%llu, start=%llu, "
-			 "len=%llu\n", logical, start, failrec->len);
+		btrfs_debug(BTRFS_I(inode)->root->fs_info, "bio_readpage_error: (new) "
+			 "logical=%llu, start=%llu, len=%llu", logical, start,
+			 failrec->len);
 		failrec->logical = logical;
 		free_extent_map(em);
 
@@ -2200,8 +2201,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		}
 	} else {
 		failrec = (struct io_failure_record *)(unsigned long)private;
-		pr_debug("bio_readpage_error: (found) logical=%llu, "
-			 "start=%llu, len=%llu, validation=%d\n",
+		btrfs_debug(BTRFS_I(inode)->root->fs_info, "bio_readpage_error: "
+			 "(found) logical=%llu, start=%llu, len=%llu, validation=%d",
 			 failrec->logical, failrec->start, failrec->len,
 			 failrec->in_validation);
 		/*
@@ -2218,7 +2219,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		 * all the retry and error correction code that follows. no
 		 * matter what the error is, it is very likely to persist.
 		 */
-		pr_debug("bio_readpage_error: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
+		btrfs_debug(BTRFS_I(inode)->root->fs_info, "bio_readpage_error: cannot "
+			 "repair, num_copies=%d, next_mirror %d, failed_mirror %d",
 			 num_copies, failrec->this_mirror, failed_mirror);
 		free_io_failure(inode, failrec, 0);
 		return -EIO;
@@ -2261,7 +2263,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	}
 
 	if (failrec->this_mirror > num_copies) {
-		pr_debug("bio_readpage_error: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
+		btrfs_debug(BTRFS_I(inode)->root->fs_info, "bio_readpage_error: (fail)"
+			 " num_copies=%d, next_mirror %d, failed_mirror %d",
 			 num_copies, failrec->this_mirror, failed_mirror);
 		free_io_failure(inode, failrec, 0);
 		return -EIO;
@@ -2292,9 +2295,9 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 
 	bio_add_page(bio, page, failrec->len, start - page_offset(page));
 
-	pr_debug("bio_readpage_error: submitting new read[%#x] to "
-		 "this_mirror=%d, num_copies=%d, in_validation=%d\n", read_mode,
-		 failrec->this_mirror, num_copies, failrec->in_validation);
+	btrfs_debug(BTRFS_I(inode)->root->fs_info, "bio_readpage_error: submitting"
+		 "new read[%#x] to this_mirror=%d, num_copies=%d, in_validation=%d",
+		 read_mode, failrec->this_mirror, num_copies, failrec->in_validation);
 
 	ret = tree->ops->submit_bio_hook(inode, read_mode, bio,
 					 failrec->this_mirror,
@@ -2351,11 +2354,17 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		 * advance bv_offset and adjust bv_len to compensate.
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
-			printk("%s page write in btrfs with offset %u and length %u\n",
-			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
-			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
-			       bvec->bv_offset, bvec->bv_len);
+		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
+			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
+				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
+				   "partial page write in btrfs with offset %u and length %u",
+					bvec->bv_offset, bvec->bv_len);
+			else
+				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
+				   "incomplete page write in btrfs with offset %u and "
+				   "length %u",
+					bvec->bv_offset, bvec->bv_len);
+		}
 
 		start = page_offset(page);
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
@@ -2418,8 +2427,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
 
-		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
-			 "mirror=%lu\n", (u64)bio->bi_sector, err,
+		btrfs_debug(BTRFS_I(inode)->root->fs_info, "end_bio_extent_readpage:"
+			 "bi_sector=%llu, err=%d, irror=%lu", (u64)bio->bi_sector, err,
 			 io_bio->mirror_num);
 		tree = &BTRFS_I(inode)->io_tree;
 
@@ -2428,11 +2437,17 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		 * advance bv_offset and adjust bv_len to compensate.
 		 * Print a warning for nonzero offsets, and an error
 		 * if they don't add up to a full page.  */
-		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE)
-			printk("%s page read in btrfs with offset %u and length %u\n",
-			       bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE
-			       ? KERN_ERR "partial" : KERN_INFO "incomplete",
-			       bvec->bv_offset, bvec->bv_len);
+		if (bvec->bv_offset || bvec->bv_len != PAGE_CACHE_SIZE) {
+			if (bvec->bv_offset + bvec->bv_len != PAGE_CACHE_SIZE)
+				btrfs_err(BTRFS_I(page->mapping->host)->root->fs_info,
+				   "partial page read in btrfs with offset %u and length %u",
+					bvec->bv_offset, bvec->bv_len);
+			else
+				btrfs_info(BTRFS_I(page->mapping->host)->root->fs_info,
+				   "incomplete page read in btrfs with offset %u and "
+				   "length %u",
+					bvec->bv_offset, bvec->bv_len);
+		}
 
 		start = page_offset(page);
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
@@ -3292,8 +3307,8 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 
 			set_range_writeback(tree, cur, cur + iosize - 1);
 			if (!PageWriteback(page)) {
-				printk(KERN_ERR "btrfs warning page %lu not "
-				       "writeback, cur %llu end %llu\n",
+				btrfs_err(BTRFS_I(inode)->root->fs_info, "page %lu not "
+					   "writeback, cur %llu end %llu",
 				       page->index, cur, end);
 			}
 
@@ -5117,12 +5132,12 @@ void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus src_offset %lu move "
 		       "len %lu dst len %lu\n", src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus dst_offset %lu move "
 		       "len %lu dst len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
@@ -5164,12 +5179,12 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 	unsigned long src_i;
 
 	if (src_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus src_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus src_offset %lu move "
 		       "len %lu len %lu\n", src_offset, len, dst->len);
 		BUG_ON(1);
 	}
 	if (dst_offset + len > dst->len) {
-		printk(KERN_ERR "btrfs memmove bogus dst_offset %lu move "
+		printk(KERN_ERR "btrfs: memmove bogus dst_offset %lu move "
 		       "len %lu len %lu\n", dst_offset, len, dst->len);
 		BUG_ON(1);
 	}
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 6f38488..b3a2b4d 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -246,8 +246,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 						offset + bvec->bv_len - 1,
 						EXTENT_NODATASUM, GFP_NOFS);
 				} else {
-					printk(KERN_INFO "btrfs no csum found "
-					       "for inode %llu start %llu\n",
+					btrfs_info(BTRFS_I(inode)->root->fs_info, "no csum found "
+						   "for inode %llu start %llu",
 					       btrfs_ino(inode), offset);
 				}
 				item = NULL;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7008868..0f13a6e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -349,8 +349,8 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct inode *inode,
 			btrfs_readpage(NULL, page);
 			lock_page(page);
 			if (!PageUptodate(page)) {
-				printk(KERN_ERR "btrfs: error reading free "
-				       "space cache\n");
+				btrfs_err(BTRFS_I(inode)->root->fs_info, "error reading free "
+					   "space cache");
 				io_ctl_drop_pages(io_ctl);
 				return -EIO;
 			}
@@ -2013,14 +2013,14 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes && !block_group->ro)
 			count++;
-		printk(KERN_CRIT "entry offset %llu, bytes %llu, bitmap %s\n",
-		       info->offset, info->bytes,
+		btrfs_crit(block_group->fs_info, "entry offset %llu, bytes %llu, "
+			   "bitmap %s", info->offset, info->bytes,
 		       (info->bitmap) ? "yes" : "no");
 	}
-	printk(KERN_INFO "block group has cluster?: %s\n",
+	btrfs_info(block_group->fs_info, "block group has cluster?: %s",
 	       list_empty(&block_group->cluster_list) ? "no" : "yes");
-	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
-	       "\n", count);
+	btrfs_info(block_group->fs_info, "%d blocks of free space at or bigger "
+		   "than bytes is", count);
 }
 
 void btrfs_init_free_space_ctl(struct btrfs_block_group_cache *block_group)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f167ced..d9e55c3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2026,7 +2026,7 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 		if (PTR_ERR(root) == -ENOENT)
 			return 0;
 		WARN_ON(1);
-		pr_debug("inum=%llu, offset=%llu, root_id=%llu\n",
+		btrfs_debug(fs_info, "inum=%llu, offset=%llu, root_id=%llu",
 			 inum, offset, root_id);
 		return PTR_ERR(root);
 	}
@@ -6912,8 +6912,8 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 	struct btrfs_dio_private *dip = bio->bi_private;
 
 	if (err) {
-		printk(KERN_ERR "btrfs direct IO failed ino %llu rw %lu "
-		      "sector %#Lx len %u err no %d\n",
+		btrfs_err(BTRFS_I(dip->inode)->root->fs_info, "direct IO failed "
+				  "ino %llu rw %lu sector %#Lx len %u err no %d",
 		      btrfs_ino(dip->inode), bio->bi_rw,
 		      (unsigned long long)bio->bi_sector, bio->bi_size, err);
 		dip->errors = 1;
@@ -8070,9 +8070,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 */
 	trans = btrfs_start_transaction(root, 11);
 	if (IS_ERR(trans)) {
-                ret = PTR_ERR(trans);
-                goto out_notrans;
-        }
+				ret = PTR_ERR(trans);
+				goto out_notrans;
+		}
 
 	if (dest != root)
 		btrfs_record_root_in_trans(trans, dest);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1d04b55..c384809 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1249,7 +1249,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			break;
 
 		if (btrfs_defrag_cancelled(root->fs_info)) {
-			printk(KERN_DEBUG "btrfs: defrag_file cancelled\n");
+			btrfs_debug(root->fs_info, "defrag_file cancelled");
 			ret = -EAGAIN;
 			break;
 		}
@@ -1411,20 +1411,20 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			ret = -EINVAL;
 			goto out_free;
 		}
-		printk(KERN_INFO "btrfs: resizing devid %llu\n", devid);
+		btrfs_info(root->fs_info, "resizing devid %llu", devid);
 	}
 
 	device = btrfs_find_device(root->fs_info, devid, NULL, NULL);
 	if (!device) {
-		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
+		btrfs_info(root->fs_info, "resizer unable to find device %llu",
 		       devid);
 		ret = -ENODEV;
 		goto out_free;
 	}
 
 	if (!device->writeable) {
-		printk(KERN_INFO "btrfs: resizer unable to apply on "
-		       "readonly device %llu\n",
+		btrfs_info(root->fs_info, "resizer unable to apply on "
+			   "readonly device %llu",
 		       devid);
 		ret = -EPERM;
 		goto out_free;
@@ -1537,8 +1537,8 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 
 		src_inode = file_inode(src.file);
 		if (src_inode->i_sb != file_inode(file)->i_sb) {
-			printk(KERN_INFO "btrfs: Snapshot src from "
-			       "another FS\n");
+			btrfs_info(BTRFS_I(src_inode)->root->fs_info, "Snapshot src from "
+				   "another FS");
 			ret = -EINVAL;
 		} else {
 			ret = btrfs_mksubvol(&file->f_path, name, namelen,
@@ -1905,7 +1905,7 @@ static noinline int search_ioctl(struct inode *inode,
 		key.offset = (u64)-1;
 		root = btrfs_read_fs_root_no_name(info, &key);
 		if (IS_ERR(root)) {
-			printk(KERN_ERR "could not find root %llu\n",
+			printk(KERN_ERR "btrfs: could not find root %llu\n",
 			       sk->tree_id);
 			btrfs_free_path(path);
 			return -ENOENT;
@@ -1995,7 +1995,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	key.offset = (u64)-1;
 	root = btrfs_read_fs_root_no_name(info, &key);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "could not find root %llu\n", tree_id);
+		printk(KERN_ERR "btrfs: could not find root %llu\n", tree_id);
 		ret = -ENOENT;
 		goto out;
 	}
@@ -3337,8 +3337,8 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
 		btrfs_end_transaction(trans, root);
-		printk(KERN_ERR "Umm, you don't have the default dir item, "
-		       "this isn't going to work\n");
+		btrfs_err(new_root->fs_info, "Umm, you don't have the default dir"
+			   "item, this isn't going to work");
 		ret = -ENOENT;
 		goto out;
 	}
@@ -4425,8 +4425,8 @@ static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
 	len = strnlen(label, BTRFS_LABEL_SIZE);
 
 	if (len == BTRFS_LABEL_SIZE) {
-		pr_warn("btrfs: label is too long, return the first %zu bytes\n",
-			--len);
+		btrfs_warn(root->fs_info, "label is too long, return the first %zu "
+			"bytes", --len);
 	}
 
 	ret = copy_to_user(arg, label, len);
@@ -4449,7 +4449,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 		return -EFAULT;
 
 	if (strnlen(label, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE) {
-		pr_err("btrfs: unable to set label with more than %d bytes\n",
+		btrfs_err(root->fs_info, "unable to set label with more than %d bytes",
 		       BTRFS_LABEL_SIZE - 1);
 		return -EINVAL;
 	}
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index b6a6f07..6596b0a 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -141,7 +141,7 @@ static int lzo_compress_pages(struct list_head *ws,
 		ret = lzo1x_1_compress(data_in, in_len, workspace->cbuf,
 				       &out_len, workspace->mem);
 		if (ret != LZO_E_OK) {
-			printk(KERN_DEBUG "btrfs deflate in loop returned %d\n",
+			printk(KERN_DEBUG "btrfs: deflate in loop returned %d\n",
 			       ret);
 			ret = -1;
 			goto out;
@@ -357,7 +357,7 @@ cont:
 		if (need_unmap)
 			kunmap(pages_in[page_in_index - 1]);
 		if (ret != LZO_E_OK) {
-			printk(KERN_WARNING "btrfs decompress failed\n");
+			printk(KERN_WARNING "btrfs: decompress failed\n");
 			ret = -1;
 			break;
 		}
@@ -401,7 +401,7 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	out_len = PAGE_CACHE_SIZE;
 	ret = lzo1x_decompress_safe(data_in, in_len, workspace->buf, &out_len);
 	if (ret != LZO_E_OK) {
-		printk(KERN_WARNING "btrfs decompress failed!\n");
+		printk(KERN_WARNING "btrfs: decompress failed!\n");
 		ret = -1;
 		goto out;
 	}
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 25a8f38..5613186 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -336,12 +336,13 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 		      entry->len);
 	*file_offset = dec_end;
 	if (dec_start > dec_end) {
-		printk(KERN_CRIT "bad ordering dec_start %llu end %llu\n",
-		       dec_start, dec_end);
+		btrfs_crit(BTRFS_I(inode)->root->fs_info, "bad ordering dec_start %llu"
+			   "end %llu", dec_start, dec_end);
 	}
 	to_dec = dec_end - dec_start;
 	if (to_dec > entry->bytes_left) {
-		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
+		btrfs_crit(BTRFS_I(inode)->root->fs_info, "bad ordered accounting "
+			   "left %llu size %llu",
 		       entry->bytes_left, to_dec);
 	}
 	entry->bytes_left -= to_dec;
@@ -401,7 +402,7 @@ have_entry:
 	}
 
 	if (io_size > entry->bytes_left) {
-		printk(KERN_CRIT "bad ordered accounting left %llu size %llu\n",
+		btrfs_crit(BTRFS_I(inode)->root->fs_info, "bad ordered accounting left %llu size %llu",
 		       entry->bytes_left, io_size);
 	}
 	entry->bytes_left -= io_size;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4e6ef49..8093103 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -301,16 +301,16 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 
 			if (btrfs_qgroup_status_version(l, ptr) !=
 			    BTRFS_QGROUP_STATUS_VERSION) {
-				printk(KERN_ERR
-				 "btrfs: old qgroup version, quota disabled\n");
+				btrfs_err(fs_info,
+				 "old qgroup version, quota disabled");
 				goto out;
 			}
 			if (btrfs_qgroup_status_generation(l, ptr) !=
 			    fs_info->generation) {
 				flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-				printk(KERN_ERR
-					"btrfs: qgroup generation mismatch, "
-					"marked as inconsistent\n");
+				btrfs_err(fs_info,
+					"qgroup generation mismatch, "
+					"marked as inconsistent");
 			}
 			fs_info->qgroup_flags = btrfs_qgroup_status_flags(l,
 									  ptr);
@@ -325,7 +325,7 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 		qgroup = find_qgroup_rb(fs_info, found_key.offset);
 		if ((qgroup && found_key.type == BTRFS_QGROUP_INFO_KEY) ||
 		    (!qgroup && found_key.type == BTRFS_QGROUP_LIMIT_KEY)) {
-			printk(KERN_ERR "btrfs: inconsitent qgroup config\n");
+			btrfs_err(fs_info, "inconsitent qgroup config");
 			flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		}
 		if (!qgroup) {
@@ -396,8 +396,8 @@ next1:
 		ret = add_relation_rb(fs_info, found_key.objectid,
 				      found_key.offset);
 		if (ret == -ENOENT) {
-			printk(KERN_WARNING
-				"btrfs: orphan qgroup relation 0x%llx->0x%llx\n",
+			btrfs_warn(fs_info,
+				"orphan qgroup relation 0x%llx->0x%llx",
 				found_key.objectid, found_key.offset);
 			ret = 0;	/* ignore the error */
 		}
@@ -1161,7 +1161,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 				       limit->rsv_excl);
 	if (ret) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-		printk(KERN_INFO "unable to update quota limit for %llu\n",
+		btrfs_info(fs_info, "unable to update quota limit for %llu",
 		       qgroupid);
 	}
 
@@ -1840,7 +1840,8 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
 {
 	if (list_empty(&trans->qgroup_ref_list) && !trans->delayed_ref_elem.seq)
 		return;
-	pr_err("btrfs: qgroups not uptodate in trans handle %p: list is%s empty, seq is %#x.%x\n",
+	btrfs_err(trans->root->fs_info, "qgroups not uptodate in trans handle %p:"
+		" list is%s empty, seq is %#x.%x",
 		trans, list_empty(&trans->qgroup_ref_list) ? "" : " not",
 		(u32)(trans->delayed_ref_elem.seq >> 32),
 		(u32)trans->delayed_ref_elem.seq);
@@ -1871,7 +1872,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 					 &fs_info->qgroup_rescan_progress,
 					 path, 1, 0);
 
-	pr_debug("current progress key (%llu %u %llu), search_slot ret %d\n",
+	btrfs_debug(fs_info, "current progress key (%llu %u %llu), search_slot ret %d",
 		 fs_info->qgroup_rescan_progress.objectid,
 		 fs_info->qgroup_rescan_progress.type,
 		 fs_info->qgroup_rescan_progress.offset, ret);
@@ -2037,10 +2038,10 @@ out:
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	if (err >= 0) {
-		pr_info("btrfs: qgroup scan completed%s\n",
+		btrfs_info(fs_info, "qgroup scan completed%s",
 			err == 2 ? " (inconsistency flag cleared)" : "");
 	} else {
-		pr_err("btrfs: qgroup scan failed with %d\n", err);
+		btrfs_err(fs_info, "qgroup scan failed with %d", err);
 	}
 
 	complete_all(&fs_info->qgroup_rescan_completion);
@@ -2096,7 +2097,7 @@ qgroup_rescan_init(struct btrfs_fs_info *fs_info, u64 progress_objectid,
 
 	if (ret) {
 err:
-		pr_info("btrfs: qgroup_rescan_init failed with %d\n", ret);
+		btrfs_info(fs_info, "qgroup_rescan_init failed with %d", ret);
 		return ret;
 	}
 
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 1031b69..da72999 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -189,8 +189,8 @@ static int __readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
 			 */
 #ifdef DEBUG
 			if (rec->generation != generation) {
-				printk(KERN_DEBUG "generation mismatch for "
-						"(%llu,%d,%llu) %llu != %llu\n",
+				btrfs_debug(root->fs_info "generation mismatch for "
+						"(%llu,%d,%llu) %llu != %llu",
 				       key.objectid, key.type, key.offset,
 				       rec->generation, generation);
 			}
@@ -365,7 +365,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		goto error;
 
 	if (bbio->num_stripes > BTRFS_MAX_MIRRORS) {
-		printk(KERN_ERR "btrfs readahead: more than %d copies not "
+		btrfs_err(root->fs_info, "btrfs readahead: more than %d copies not "
 				"supported", BTRFS_MAX_MIRRORS);
 		goto error;
 	}
@@ -811,7 +811,7 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 
 	spin_lock(&fs_info->reada_lock);
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
-		printk(KERN_DEBUG "dev %lld has %d in flight\n", device->devid,
+		btrfs_debug(fsinfo, "dev %lld has %d in flight", device->devid,
 			atomic_read(&device->reada_in_flight));
 		index = 0;
 		while (1) {
@@ -820,7 +820,7 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 						     (void **)&zone, index, 1);
 			if (ret == 0)
 				break;
-			printk(KERN_DEBUG "  zone %llu-%llu elems %llu locked "
+			btrfs_debug(fsinfo, "  zone %llu-%llu elems %llu locked "
 				"%d devs", zone->start, zone->end, zone->elems,
 				zone->locked);
 			for (j = 0; j < zone->ndevs; ++j) {
@@ -842,7 +842,7 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 						     (void **)&re, index, 1);
 			if (ret == 0)
 				break;
-			printk(KERN_DEBUG
+			btrfs_debug(fsinfo,
 				"  re: logical %llu size %u empty %d for %lld",
 				re->logical, re->blocksize,
 				list_empty(&re->extctl), re->scheduled_for ?
@@ -877,7 +877,7 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 			index = (re->logical >> PAGE_CACHE_SHIFT) + 1;
 			continue;
 		}
-		printk(KERN_DEBUG
+		btrfs_debug(fsinfo,
 			"re: logical %llu size %u list empty %d for %lld",
 			re->logical, re->blocksize, list_empty(&re->extctl),
 			re->scheduled_for ? re->scheduled_for->devid : -1);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ce459a7..c1de9a4 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4219,7 +4219,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		goto out;
 	}
 
-	printk(KERN_INFO "btrfs: relocating block group %llu flags %llu\n",
+	btrfs_debug(extent_root->fs_info, "relocating block group %llu flags %llu",
 	       rc->block_group->key.objectid, rc->block_group->flags);
 
 	ret = btrfs_start_delalloc_roots(fs_info, 0);
@@ -4241,7 +4241,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 		if (rc->extents_found == 0)
 			break;
 
-		printk(KERN_INFO "btrfs: found %llu extents\n",
+		btrfs_info(extent_root->fs_info, "found %llu extents",
 			rc->extents_found);
 
 		if (rc->stage == MOVE_DATA_EXTENTS && rc->found_file_extent) {
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ec71ea4..79d5b0f 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -35,7 +35,6 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 	uuid_le uuid;
 	int len;
 	int need_reset = 0;
-
 	len = btrfs_item_size_nr(eb, slot);
 	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
 			min_t(int, len, (int)sizeof(*item)));
@@ -154,7 +153,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	if (ret != 0) {
 		btrfs_print_leaf(root, path->nodes[0]);
-		printk(KERN_CRIT "unable to update root key %llu %u %llu\n",
+		btrfs_crit(root->fs_info, "unable to update root key %llu %u %llu",
 		       key->objectid, key->type, key->offset);
 		BUG_ON(1);
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2544805..ed8bb82 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2457,9 +2457,9 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 
 			if (key.objectid < logical &&
 			    (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
-				printk(KERN_ERR
-				       "btrfs scrub: tree block %llu spanning "
-				       "stripes, ignored. logical=%llu\n",
+				btrfs_err(fs_info,
+					   "scrub: tree block %llu spanning "
+					   "stripes, ignored. logical=%llu",
 				       key.objectid, logical);
 				goto next;
 			}
@@ -2841,8 +2841,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	 * check some assumptions
 	 */
 	if (fs_info->chunk_root->nodesize != fs_info->chunk_root->leafsize) {
-		printk(KERN_ERR
-		       "btrfs_scrub: size assumption nodesize == leafsize (%d == %d) fails\n",
+		btrfs_err(fs_info,
+			   "scrub: size assumption nodesize == leafsize (%d == %d) fails",
 		       fs_info->chunk_root->nodesize,
 		       fs_info->chunk_root->leafsize);
 		return -EINVAL;
@@ -2854,16 +2854,17 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 * the way scrub is implemented. Do not handle this
 		 * situation at all because it won't ever happen.
 		 */
-		printk(KERN_ERR
-		       "btrfs_scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails\n",
+		btrfs_err(fs_info,
+			   "scrub: size assumption nodesize <= BTRFS_STRIPE_LEN (%d <= %d) fails",
 		       fs_info->chunk_root->nodesize, BTRFS_STRIPE_LEN);
 		return -EINVAL;
 	}
 
 	if (fs_info->chunk_root->sectorsize != PAGE_SIZE) {
 		/* not supported for data w/o checksums */
-		printk(KERN_ERR
-		       "btrfs_scrub: size assumption sectorsize != PAGE_SIZE (%d != %lu) fails\n",
+		btrfs_err(fs_info,
+			   "scrub: size assumption sectorsize != PAGE_SIZE "
+			   "(%d != %lu) fails",
 		       fs_info->chunk_root->sectorsize, PAGE_SIZE);
 		return -EINVAL;
 	}
@@ -2876,7 +2877,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		 * would exhaust the array bounds of pagev member in
 		 * struct scrub_block
 		 */
-		pr_err("btrfs_scrub: size assumption nodesize and sectorsize <= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails\n",
+		btrfs_err(fs_info, "scrub: size assumption nodesize and sectorsize "
+			   "<= SCRUB_MAX_PAGES_PER_BLOCK (%d <= %d && %d <= %d) fails",
 		       fs_info->chunk_root->nodesize,
 		       SCRUB_MAX_PAGES_PER_BLOCK,
 		       fs_info->chunk_root->sectorsize,
@@ -3185,7 +3187,8 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 	ret = iterate_inodes_from_logical(logical, fs_info, path,
 					  record_inode_for_nocow, nocow_ctx);
 	if (ret != 0 && ret != -ENOENT) {
-		pr_warn("iterate_inodes_from_logical() failed: log %llu, phys %llu, len %llu, mir %u, ret %d\n",
+		btrfs_warn(fs_info, "iterate_inodes_from_logical() failed: log %llu, "
+			"phys %llu, len %llu, mir %u, ret %d",
 			logical, physical_for_dev_replace, len, mirror_num,
 			ret);
 		not_written = 1;
@@ -3307,7 +3310,7 @@ static int copy_nocow_pages_for_inode(u64 inum, u64 offset, u64 root,
 again:
 		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
 		if (!page) {
-			pr_err("find_or_create_page() failed\n");
+			btrfs_err(fs_info, "find_or_create_page() failed");
 			ret = -ENOMEM;
 			goto out;
 		}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e87baf6..5d5bb2c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -141,7 +141,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	 * under MS_RDONLY, then it is safe here.
 	 */
 	if (errno == -EROFS && (sb->s_flags & MS_RDONLY))
-  		return;
+		return;
 
 	errstr = btrfs_decode_error(errno);
 	if (fmt) {
@@ -152,11 +152,11 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s (%pV)\n",
+		printk(KERN_CRIT "btrfs: error (device %s) in %s:%d: errno=%d %s (%pV)\n",
 			sb->s_id, function, line, errno, errstr, &vaf);
 		va_end(args);
 	} else {
-		printk(KERN_CRIT "BTRFS error (device %s) in %s:%d: errno=%d %s\n",
+		printk(KERN_CRIT "btrfs: error (device %s) in %s:%d: errno=%d %s\n",
 			sb->s_id, function, line, errno, errstr);
 	}
 
@@ -201,7 +201,7 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
+	printk("%sbtrfs: %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
 
 	va_end(args);
 }
@@ -291,11 +291,11 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 
 	errstr = btrfs_decode_error(errno);
 	if (fs_info && (fs_info->mount_opt & BTRFS_MOUNT_PANIC_ON_FATAL_ERROR))
-		panic(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
+		panic(KERN_CRIT "btrfs: panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
 			s_id, function, line, &vaf, errno, errstr);
 
-	printk(KERN_CRIT "BTRFS panic (device %s) in %s:%d: %pV (errno=%d %s)\n",
-	       s_id, function, line, &vaf, errno, errstr);
+	btrfs_crit(fs_info, "panic in %s:%d: %pV (errno=%d %s)",
+		   function, line, &vaf, errno, errstr);
 	va_end(args);
 	/* Caller calls BUG() */
 }
@@ -409,7 +409,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_degraded:
-			printk(KERN_INFO "btrfs: allowing degraded mounts\n");
+			btrfs_info(root->fs_info, "allowing degraded mounts");
 			btrfs_set_opt(info->mount_opt, DEGRADED);
 			break;
 		case Opt_subvol:
@@ -422,15 +422,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			 */
 			break;
 		case Opt_nodatasum:
-			printk(KERN_INFO "btrfs: setting nodatasum\n");
+			btrfs_info(root->fs_info, "setting nodatasum");
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_nodatacow:
 			if (!btrfs_test_opt(root, COMPRESS) ||
 				!btrfs_test_opt(root, FORCE_COMPRESS)) {
-					printk(KERN_INFO "btrfs: setting nodatacow, compression disabled\n");
+					btrfs_info(root->fs_info, "setting nodatacow, compression disabled");
 			} else {
-				printk(KERN_INFO "btrfs: setting nodatacow\n");
+				btrfs_info(root->fs_info, "setting nodatacow");
 			}
 			info->compress_type = BTRFS_COMPRESS_NONE;
 			btrfs_clear_opt(info->mount_opt, COMPRESS);
@@ -472,31 +472,31 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 
 			if (compress_force) {
 				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
-				pr_info("btrfs: force %s compression\n",
+				btrfs_info(root->fs_info, "force %s compression",
 					compress_type);
 			} else
-				pr_info("btrfs: use %s compression\n",
+				btrfs_info(root->fs_info, "use %s compression",
 					compress_type);
 			break;
 		case Opt_ssd:
-			printk(KERN_INFO "btrfs: use ssd allocation scheme\n");
+			btrfs_info(root->fs_info, "use ssd allocation scheme");
 			btrfs_set_opt(info->mount_opt, SSD);
 			break;
 		case Opt_ssd_spread:
-			printk(KERN_INFO "btrfs: use spread ssd "
-			       "allocation scheme\n");
+			btrfs_info(root->fs_info, "use spread ssd "
+				   "allocation scheme");
 			btrfs_set_opt(info->mount_opt, SSD);
 			btrfs_set_opt(info->mount_opt, SSD_SPREAD);
 			break;
 		case Opt_nossd:
-			printk(KERN_INFO "btrfs: not using ssd allocation "
-			       "scheme\n");
+			btrfs_info(root->fs_info, "not using ssd allocation "
+				   "scheme");
 			btrfs_set_opt(info->mount_opt, NOSSD);
 			btrfs_clear_opt(info->mount_opt, SSD);
 			btrfs_clear_opt(info->mount_opt, SSD_SPREAD);
 			break;
 		case Opt_nobarrier:
-			printk(KERN_INFO "btrfs: turning off barriers\n");
+			btrfs_info(root->fs_info, "turning off barriers");
 			btrfs_set_opt(info->mount_opt, NOBARRIER);
 			break;
 		case Opt_thread_pool:
@@ -521,7 +521,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 						info->max_inline,
 						root->sectorsize);
 				}
-				printk(KERN_INFO "btrfs: max_inline at %llu\n",
+				btrfs_info(root->fs_info, "max_inline at %llu",
 					info->max_inline);
 			} else {
 				ret = -ENOMEM;
@@ -535,8 +535,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				info->alloc_start = memparse(num, NULL);
 				mutex_unlock(&info->chunk_mutex);
 				kfree(num);
-				printk(KERN_INFO
-					"btrfs: allocations start at %llu\n",
+				btrfs_info(root->fs_info, "allocations start at %llu",
 					info->alloc_start);
 			} else {
 				ret = -ENOMEM;
@@ -547,11 +546,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			root->fs_info->sb->s_flags &= ~MS_POSIXACL;
 			break;
 		case Opt_notreelog:
-			printk(KERN_INFO "btrfs: disabling tree log\n");
+			btrfs_info(root->fs_info, "disabling tree log");
 			btrfs_set_opt(info->mount_opt, NOTREELOG);
 			break;
 		case Opt_flushoncommit:
-			printk(KERN_INFO "btrfs: turning on flush-on-commit\n");
+			btrfs_info(root->fs_info, "turning on flush-on-commit");
 			btrfs_set_opt(info->mount_opt, FLUSHONCOMMIT);
 			break;
 		case Opt_ratio:
@@ -560,7 +559,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			} else if (intarg >= 0) {
 				info->metadata_ratio = intarg;
-				printk(KERN_INFO "btrfs: metadata ratio %d\n",
+				btrfs_info(root->fs_info, "metadata ratio %d",
 				       info->metadata_ratio);
 			} else {
 				ret = -EINVAL;
@@ -577,15 +576,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, RESCAN_UUID_TREE);
 			break;
 		case Opt_no_space_cache:
-			printk(KERN_INFO "btrfs: disabling disk space caching\n");
+			btrfs_info(root->fs_info, "disabling disk space caching");
 			btrfs_clear_opt(info->mount_opt, SPACE_CACHE);
 			break;
 		case Opt_inode_cache:
-			printk(KERN_INFO "btrfs: enabling inode map caching\n");
+			btrfs_info(root->fs_info, "enabling inode map caching");
 			btrfs_set_opt(info->mount_opt, INODE_MAP_CACHE);
 			break;
 		case Opt_clear_cache:
-			printk(KERN_INFO "btrfs: force clearing of disk cache\n");
+			btrfs_info(root->fs_info, "force clearing of disk cache");
 			btrfs_set_opt(info->mount_opt, CLEAR_CACHE);
 			break;
 		case Opt_user_subvol_rm_allowed:
@@ -595,11 +594,11 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, ENOSPC_DEBUG);
 			break;
 		case Opt_defrag:
-			printk(KERN_INFO "btrfs: enabling auto defrag\n");
+			btrfs_info(root->fs_info, "enabling auto defrag");
 			btrfs_set_opt(info->mount_opt, AUTO_DEFRAG);
 			break;
 		case Opt_recovery:
-			printk(KERN_INFO "btrfs: enabling auto recovery\n");
+			btrfs_info(root->fs_info, "enabling auto recovery");
 			btrfs_set_opt(info->mount_opt, RECOVERY);
 			break;
 		case Opt_skip_balance:
@@ -607,14 +606,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			break;
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 		case Opt_check_integrity_including_extent_data:
-			printk(KERN_INFO "btrfs: enabling check integrity"
-			       " including extent data\n");
+			btrfs_info(root->fs_info, "enabling check integrity"
+				   " including extent data");
 			btrfs_set_opt(info->mount_opt,
 				      CHECK_INTEGRITY_INCLUDING_EXTENT_DATA);
 			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
 			break;
 		case Opt_check_integrity:
-			printk(KERN_INFO "btrfs: enabling check integrity\n");
+			btrfs_info(root->fs_info, "enabling check integrity");
 			btrfs_set_opt(info->mount_opt, CHECK_INTEGRITY);
 			break;
 		case Opt_check_integrity_print_mask:
@@ -623,8 +622,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			} else if (intarg >= 0) {
 				info->check_integrity_print_mask = intarg;
-				printk(KERN_INFO "btrfs:"
-				       " check_integrity_print_mask 0x%x\n",
+				btrfs_info(root->fs_info, "check_integrity_print_mask 0x%x",
 				       info->check_integrity_print_mask);
 			} else {
 				ret = -EINVAL;
@@ -635,8 +633,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_check_integrity_including_extent_data:
 		case Opt_check_integrity:
 		case Opt_check_integrity_print_mask:
-			printk(KERN_ERR "btrfs: support for check_integrity*"
-			       " not compiled in!\n");
+			btrfs_err(root->fs_info, "support for check_integrity*"
+				   " not compiled in!");
 			ret = -EINVAL;
 			goto out;
 #endif
@@ -656,28 +654,25 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			intarg = 0;
 			ret = match_int(&args[0], &intarg);
 			if (ret < 0) {
-				printk(KERN_ERR
-					"btrfs: invalid commit interval\n");
+				btrfs_err(root->fs_info, "invalid commit interval");
 				ret = -EINVAL;
 				goto out;
 			}
 			if (intarg > 0) {
 				if (intarg > 300) {
-					printk(KERN_WARNING
-					    "btrfs: excessive commit interval %d\n",
+					btrfs_warn(root->fs_info, "excessive commit interval %d",
 							intarg);
 				}
 				info->commit_interval = intarg;
 			} else {
-				printk(KERN_INFO
-				    "btrfs: using default commit interval %ds\n",
+				btrfs_info(root->fs_info, "using default commit interval %ds",
 				    BTRFS_DEFAULT_COMMIT_INTERVAL);
 				info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 			}
 			break;
 		case Opt_err:
-			printk(KERN_INFO "btrfs: unrecognized mount option "
-			       "'%s'\n", p);
+			btrfs_info(root->fs_info, "unrecognized mount option "
+				   "'%s'", p);
 			ret = -EINVAL;
 			goto out;
 		default:
@@ -686,7 +681,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	}
 out:
 	if (!ret && btrfs_test_opt(root, SPACE_CACHE))
-		printk(KERN_INFO "btrfs: disk space caching is enabled\n");
+		btrfs_info(root->fs_info, "disk space caching is enabled");
 	kfree(orig);
 	return ret;
 }
@@ -1241,7 +1236,7 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 
 	fs_info->thread_pool_size = new_pool_size;
 
-	printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n",
+	btrfs_info(fs_info, "resize thread pool %d -> %d",
 	       old_pool_size, new_pool_size);
 
 	btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
@@ -1347,7 +1342,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	} else {
 		if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state)) {
 			btrfs_err(fs_info,
-				"Remounting read-write after error is not allowed\n");
+				"Remounting read-write after error is not allowed");
 			ret = -EINVAL;
 			goto restore;
 		}
@@ -1359,8 +1354,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (fs_info->fs_devices->missing_devices >
 		     fs_info->num_tolerated_disk_barrier_failures &&
 		    !(*flags & MS_RDONLY)) {
-			printk(KERN_WARNING
-			       "Btrfs: too many missing devices, writeable remount is not allowed\n");
+			btrfs_warn(fs_info, "too many missing devices, writeable "
+					"remount is not allowed");
 			ret = -EACCES;
 			goto restore;
 		}
@@ -1385,16 +1380,16 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 
 		ret = btrfs_resume_dev_replace_async(fs_info);
 		if (ret) {
-			pr_warn("btrfs: failed to resume dev_replace\n");
+			btrfs_warn(fs_info, "failed to resume dev_replace");
 			goto restore;
 		}
 
 		if (!fs_info->uuid_root) {
-			pr_info("btrfs: creating UUID tree\n");
+			btrfs_info(fs_info, "creating UUID tree");
 			ret = btrfs_create_uuid_tree(fs_info);
 			if (ret) {
-				pr_warn("btrfs: failed to create the uuid "
-					"tree %d\n", ret);
+				btrfs_warn(fs_info, "failed to create the uuid "
+					"tree %d", ret);
 				goto restore;
 			}
 		}
@@ -1779,7 +1774,7 @@ static void btrfs_interface_exit(void)
 
 static void btrfs_print_info(void)
 {
-	printk(KERN_INFO "Btrfs loaded"
+	printk(KERN_INFO "btrfs: loaded"
 #ifdef CONFIG_BTRFS_DEBUG
 			", debug=on"
 #endif
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 7e99c2f..a228973 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -56,7 +56,8 @@ static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
 		cond_resched();
 		loops++;
 		if (loops > 100000) {
-			printk(KERN_ERR "stuck in a loop, start %Lu, end %Lu, nr_pages %lu, ret %d\n", start, end, nr_pages, ret);
+			btrfs_err(BTRFS_I(inode)->root->fs_info, "stuck in a loop, "
+				"start %llu, end %llu, nr_pages %lu, ret %d", start, end, nr_pages, ret);
 			break;
 		}
 	}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 57c16b4..0ffcc05 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1105,7 +1105,7 @@ int btrfs_defrag_root(struct btrfs_root *root)
 			break;
 
 		if (btrfs_defrag_cancelled(root->fs_info)) {
-			printk(KERN_DEBUG "btrfs: defrag_root cancelled\n");
+			btrfs_debug(root->fs_info, "defrag_root cancelled");
 			ret = -EAGAIN;
 			break;
 		}
@@ -1978,7 +1978,7 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 	list_del_init(&root->root_list);
 	spin_unlock(&fs_info->trans_lock);
 
-	pr_debug("btrfs: cleaner removing %llu\n", root->objectid);
+	btrfs_debug(root->fs_info, "cleaner removing %llu", root->objectid);
 
 	btrfs_kill_all_delayed_nodes(root);
 
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index fbda900..34bf72e 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -69,7 +69,7 @@ static int btrfs_uuid_tree_lookup(struct btrfs_root *uuid_root, u8 *uuid,
 	ret = -ENOENT;
 
 	if (!IS_ALIGNED(item_size, sizeof(u64))) {
-		pr_warn("btrfs: uuid item with illegal size %lu!\n",
+		btrfs_warn(uuid_root->fs_info, "uuid item with illegal size %lu!",
 			(unsigned long)item_size);
 		goto out;
 	}
@@ -137,7 +137,7 @@ int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
 		offset = btrfs_item_ptr_offset(eb, slot);
 		offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
 	} else if (ret < 0) {
-		pr_warn("btrfs: insert uuid item failed %d (0x%016llx, 0x%016llx) type %u!\n",
+		btrfs_warn(uuid_root->fs_info, "insert uuid item failed %d (0x%016llx, 0x%016llx) type %u!",
 			ret, (unsigned long long)key.objectid,
 			(unsigned long long)key.offset, type);
 		goto out;
@@ -183,7 +183,7 @@ int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, uuid_root, &key, path, -1, 1);
 	if (ret < 0) {
-		pr_warn("btrfs: error %d while searching for uuid item!\n",
+		btrfs_warn(uuid_root->fs_info, "error %d while searching for uuid item!",
 			ret);
 		goto out;
 	}
@@ -197,7 +197,7 @@ int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
 	offset = btrfs_item_ptr_offset(eb, slot);
 	item_size = btrfs_item_size_nr(eb, slot);
 	if (!IS_ALIGNED(item_size, sizeof(u64))) {
-		pr_warn("btrfs: uuid item with illegal size %lu!\n",
+		btrfs_warn(uuid_root->fs_info, "uuid item with illegal size %lu!",
 			(unsigned long)item_size);
 		ret = -ENOENT;
 		goto out;
@@ -299,7 +299,7 @@ again_search_slot:
 		offset = btrfs_item_ptr_offset(leaf, slot);
 		item_size = btrfs_item_size_nr(leaf, slot);
 		if (!IS_ALIGNED(item_size, sizeof(u64))) {
-			pr_warn("btrfs: uuid item with illegal size %lu!\n",
+			btrfs_warn(fs_info, "uuid item with illegal size %lu!",
 				(unsigned long)item_size);
 			goto skip;
 		}
@@ -349,6 +349,6 @@ skip:
 out:
 	btrfs_free_path(path);
 	if (ret)
-		pr_warn("btrfs: btrfs_uuid_tree_iterate failed %d\n", ret);
+		btrfs_warn(fs_info, "btrfs_uuid_tree_iterate failed %d", ret);
 	return 0;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1c30328..57be8c2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -125,7 +125,7 @@ static void btrfs_kobject_uevent(struct block_device *bdev,
 
 	ret = kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, action);
 	if (ret)
-		pr_warn("Sending event '%d' to kobject: '%s' (%p): failed\n",
+		pr_warn("btrfs: Sending event '%d' to kobject: '%s' (%p): failed\n",
 			action,
 			kobject_name(&disk_to_dev(bdev->bd_disk)->kobj),
 			&disk_to_dev(bdev->bd_disk)->kobj);
@@ -1813,7 +1813,7 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
 		}
 
 		if (!*device) {
-			pr_err("btrfs: no missing device found\n");
+			btrfs_err(root->fs_info, "no missing device found");
 			return -ENOENT;
 		}
 
@@ -3052,7 +3052,7 @@ loop:
 error:
 	btrfs_free_path(path);
 	if (enospc_errors) {
-		printk(KERN_INFO "btrfs: %d enospc errors during balance\n",
+		btrfs_info(fs_info, "%d enospc errors during balance",
 		       enospc_errors);
 		if (!ret)
 			ret = -ENOSPC;
@@ -3138,8 +3138,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		if (!(bctl->flags & BTRFS_BALANCE_DATA) ||
 		    !(bctl->flags & BTRFS_BALANCE_METADATA) ||
 		    memcmp(&bctl->data, &bctl->meta, sizeof(bctl->data))) {
-			printk(KERN_ERR "btrfs: with mixed groups data and "
-			       "metadata balance options must be the same\n");
+			btrfs_err(fs_info, "with mixed groups data and "
+				   "metadata balance options must be the same");
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3165,8 +3165,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->data.target, 1) ||
 	     (bctl->data.target & ~allowed))) {
-		printk(KERN_ERR "btrfs: unable to start balance with target "
-		       "data profile %llu\n",
+		btrfs_err(fs_info, "unable to start balance with target "
+			   "data profile %llu",
 		       bctl->data.target);
 		ret = -EINVAL;
 		goto out;
@@ -3174,8 +3174,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->meta.target, 1) ||
 	     (bctl->meta.target & ~allowed))) {
-		printk(KERN_ERR "btrfs: unable to start balance with target "
-		       "metadata profile %llu\n",
+		btrfs_err(fs_info, "unable to start balance with target "
+			   "metadata profile %llu",
 		       bctl->meta.target);
 		ret = -EINVAL;
 		goto out;
@@ -3183,8 +3183,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	if ((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->sys.target, 1) ||
 	     (bctl->sys.target & ~allowed))) {
-		printk(KERN_ERR "btrfs: unable to start balance with target "
-		       "system profile %llu\n",
+		btrfs_err(fs_info, "unable to start balance with target "
+			   "system profile %llu",
 		       bctl->sys.target);
 		ret = -EINVAL;
 		goto out;
@@ -3193,7 +3193,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	/* allow dup'ed data chunks only in mixed mode */
 	if (!mixed && (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (bctl->data.target & BTRFS_BLOCK_GROUP_DUP)) {
-		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
+		btrfs_err(fs_info, "dup for data is not allowed");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3213,11 +3213,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		     (fs_info->avail_metadata_alloc_bits & allowed) &&
 		     !(bctl->meta.target & allowed))) {
 			if (bctl->flags & BTRFS_BALANCE_FORCE) {
-				printk(KERN_INFO "btrfs: force reducing metadata "
-				       "integrity\n");
+				btrfs_info(fs_info, "force reducing metadata "
+					   "integrity");
 			} else {
-				printk(KERN_ERR "btrfs: balance will reduce metadata "
-				       "integrity, use force if you want this\n");
+				btrfs_err(fs_info, "balance will reduce metadata "
+					   "integrity, use force if you want this");
 				ret = -EINVAL;
 				goto out;
 			}
@@ -3303,7 +3303,7 @@ static int balance_kthread(void *data)
 	mutex_lock(&fs_info->balance_mutex);
 
 	if (fs_info->balance_ctl) {
-		printk(KERN_INFO "btrfs: continuing balance\n");
+		btrfs_info(fs_info, "continuing balance");
 		ret = btrfs_balance(fs_info->balance_ctl, NULL);
 	}
 
@@ -3325,7 +3325,7 @@ int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info)
 	spin_unlock(&fs_info->balance_lock);
 
 	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
-		printk(KERN_INFO "btrfs: force skipping balance\n");
+		btrfs_info(fs_info, "force skipping balance");
 		return 0;
 	}
 
@@ -3543,7 +3543,7 @@ update_tree:
 						  BTRFS_UUID_KEY_SUBVOL,
 						  key.objectid);
 			if (ret < 0) {
-				pr_warn("btrfs: uuid_tree_add failed %d\n",
+				btrfs_warn(fs_info, "uuid_tree_add failed %d",
 					ret);
 				break;
 			}
@@ -3555,7 +3555,7 @@ update_tree:
 						 BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 						  key.objectid);
 			if (ret < 0) {
-				pr_warn("btrfs: uuid_tree_add failed %d\n",
+				btrfs_warn(fs_info, "uuid_tree_add failed %d",
 					ret);
 				break;
 			}
@@ -3590,7 +3590,7 @@ out:
 	if (trans && !IS_ERR(trans))
 		btrfs_end_transaction(trans, fs_info->uuid_root);
 	if (ret)
-		pr_warn("btrfs: btrfs_uuid_scan_kthread failed %d\n", ret);
+		btrfs_warn(fs_info, "btrfs_uuid_scan_kthread failed %d", ret);
 	else
 		fs_info->update_uuid_tree_gen = 1;
 	up(&fs_info->uuid_tree_rescan_sem);
@@ -3654,7 +3654,7 @@ static int btrfs_uuid_rescan_kthread(void *data)
 	 */
 	ret = btrfs_uuid_tree_iterate(fs_info, btrfs_check_uuid_tree_entry);
 	if (ret < 0) {
-		pr_warn("btrfs: iterating uuid_tree failed %d\n", ret);
+		btrfs_warn(fs_info, "iterating uuid_tree failed %d", ret);
 		up(&fs_info->uuid_tree_rescan_sem);
 		return ret;
 	}
@@ -3695,7 +3695,7 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	task = kthread_run(btrfs_uuid_scan_kthread, fs_info, "btrfs-uuid");
 	if (IS_ERR(task)) {
 		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
-		pr_warn("btrfs: failed to start uuid_scan task\n");
+		btrfs_warn(fs_info, "failed to start uuid_scan task");
 		up(&fs_info->uuid_tree_rescan_sem);
 		return PTR_ERR(task);
 	}
@@ -3711,7 +3711,7 @@ int btrfs_check_uuid_tree(struct btrfs_fs_info *fs_info)
 	task = kthread_run(btrfs_uuid_rescan_kthread, fs_info, "btrfs-uuid");
 	if (IS_ERR(task)) {
 		/* fs_info->update_uuid_tree_gen remains 0 in all error case */
-		pr_warn("btrfs: failed to start uuid_rescan task\n");
+		btrfs_warn(fs_info, "failed to start uuid_rescan task");
 		up(&fs_info->uuid_tree_rescan_sem);
 		return PTR_ERR(task);
 	}
@@ -4281,7 +4281,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 
 	if (em->start != chunk_offset || em->len != chunk_size) {
 		btrfs_crit(extent_root->fs_info, "found a bad mapping, wanted"
-			  " %Lu-%Lu, found %Lu-%Lu\n", chunk_offset,
+			  " %llu-%llu, found %llu-%llu", chunk_offset,
 			  chunk_size, em->start, em->len);
 		free_extent_map(em);
 		return -EINVAL;
@@ -4483,14 +4483,14 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	 * and exit, so return 1 so the callers don't try to use other copies.
 	 */
 	if (!em) {
-		btrfs_crit(fs_info, "No mapping for %Lu-%Lu\n", logical,
+		btrfs_crit(fs_info, "No mapping for %llu-%llu", logical,
 			    logical+len);
 		return 1;
 	}
 
 	if (em->start > logical || em->start + em->len < logical) {
-		btrfs_crit(fs_info, "Invalid mapping for %Lu-%Lu, got "
-			    "%Lu-%Lu\n", logical, logical+len, em->start,
+		btrfs_crit(fs_info, "Invalid mapping for %llu-%llu, got "
+				"%llu-%llu", logical, logical+len, em->start,
 			    em->start + em->len);
 		free_extent_map(em);
 		return 1;
@@ -4670,8 +4670,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	}
 
 	if (em->start > logical || em->start + em->len < logical) {
-		btrfs_crit(fs_info, "found a bad mapping, wanted %Lu, "
-			   "found %Lu-%Lu\n", logical, em->start,
+		btrfs_crit(fs_info, "found a bad mapping, wanted %llu, "
+			   "found %llu-%llu", logical, em->start,
 			   em->start + em->len);
 		free_extent_map(em);
 		return -EINVAL;
@@ -5433,8 +5433,8 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 
 		rcu_read_lock();
 		name = rcu_dereference(dev->name);
-		pr_debug("btrfs_map_bio: rw %d, sector=%llu, dev=%lu "
-			 "(%s id %llu), size=%u\n", rw,
+		btrfs_debug(root->fs_info, "btrfs_map_bio: rw %d, sector=%llu, dev=%lu "
+			 "(%s id %llu), size=%u", rw,
 			 (u64)bio->bi_sector, (u_long)dev->bdev->bd_dev,
 			 name->str, dev->devid, bio->bi_size);
 		rcu_read_unlock();
@@ -6242,12 +6242,10 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
-		printk(KERN_WARNING
-		       "btrfs: get dev_stats failed, device not found\n");
+		btrfs_warn(root->fs_info, "get dev_stats failed, device not found");
 		return -ENODEV;
 	} else if (!dev->dev_stats_valid) {
-		printk(KERN_WARNING
-		       "btrfs: get dev_stats failed, not yet valid\n");
+		btrfs_warn(root->fs_info, "get dev_stats failed, not yet valid");
 		return -ENODEV;
 	} else if (stats->flags & BTRFS_DEV_STATS_RESET) {
 		for (i = 0; i < BTRFS_DEV_STAT_VALUES_MAX; i++) {
-- 
1.7.9.5

