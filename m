Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from peace.netnation.com ([204.174.223.2]:56940 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625Ab3CSWlY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 18:41:24 -0400
Received: from sim by peace.netnation.com with local (Exim 4.80)
	(envelope-from <sim@netnation.com>)
	id 1UI5Df-0001Wq-N1
	for linux-btrfs@vger.kernel.org; Tue, 19 Mar 2013 15:41:23 -0700
Date: Tue, 19 Mar 2013 15:41:23 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: Include the device in most error printk()s
Message-ID: <20130319224123.GA4779@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With more than one btrfs volume mounted, it can be very difficult to find
out which volume is hitting an error. btrfs_error() will print this, but
it is currently rigged as more of a fatal error handler, while many of
the printk()s are currently for debugging and yet-unhandled cases.

This patch just changes the functions where the device information is
already available. Some cases remain where the root or fs_info is not
passed to the function emitting the error.

This may introduce some confusion with volumes backed by multiple devices
emitting errors referring to the primary device in the set instead of the
one on which the error occurred.

Use btrfs_printk(fs_info, format, ...) rather than writing the device
string every time, and introduce macro wrappers ala XFS for brevity.
Since the function already cannot be used for continuations, print a
newline as part of the btrfs_printk() message rather than at each caller.

Signed-off-by: Simon Kirby <sim@hostway.ca>
Reviewed-by: David Sterba <dsterba@suse.cz>
---

v2:
- Ported to btrfs-next
- unsplit strings to improve searchability
- Change "auto deleting" messages to btrfs_debug
- Fix a typo

 fs/btrfs/ctree.h            |   21 +++++++++++--
 fs/btrfs/extent-tree.c      |   67 +++++++++++++++++++++--------------------
 fs/btrfs/free-space-cache.c |   43 +++++++++++++++------------
 fs/btrfs/inode.c            |   69 ++++++++++++++++++++++---------------------
 fs/btrfs/print-tree.c       |    9 +++---
 fs/btrfs/super.c            |   12 ++++----
 fs/btrfs/transaction.c      |    2 +-
 fs/btrfs/volumes.c          |   18 +++++------
 8 files changed, 132 insertions(+), 109 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 14d8f8d..6e81860 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3645,14 +3645,31 @@ int btrfs_sync_fs(struct super_block *sb, int wait);
 
 #ifdef CONFIG_PRINTK
 __printf(2, 3)
-void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...);
+void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
 #else
 static inline __printf(2, 3)
-void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
+void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 }
 #endif
 
+#define btrfs_emerg(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_EMERG fmt, ##args)
+#define btrfs_alert(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_ALERT fmt, ##args)
+#define btrfs_crit(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_CRIT fmt, ##args)
+#define btrfs_err(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_ERR fmt, ##args)
+#define btrfs_warn(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_WARNING fmt, ##args)
+#define btrfs_notice(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_NOTICE fmt, ##args)
+#define btrfs_info(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_INFO fmt, ##args)
+#define btrfs_debug(fs_info, fmt, args...) \
+	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
+
 __printf(5, 6)
 void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 		     unsigned int line, int errno, const char *fmt, ...);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a08d0fe..a03379a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2398,9 +2398,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 				btrfs_free_delayed_extent_op(extent_op);
 
 				if (ret) {
-					printk(KERN_DEBUG
-					       "btrfs: run_delayed_extent_op "
-					       "returned %d\n", ret);
+					btrfs_debug(fs_info, "run_delayed_extent_op returned %d", ret);
 					spin_lock(&delayed_refs->lock);
 					btrfs_delayed_ref_unlock(locked_ref);
 					return ret;
@@ -2439,8 +2437,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		if (ret) {
 			btrfs_delayed_ref_unlock(locked_ref);
 			btrfs_put_delayed_ref(ref);
-			printk(KERN_DEBUG
-			       "btrfs: run_one_delayed_ref returned %d\n", ret);
+			btrfs_debug(fs_info, "run_one_delayed_ref returned %d", ret);
 			spin_lock(&delayed_refs->lock);
 			return ret;
 		}
@@ -2517,7 +2514,8 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 	if (list_empty(&trans->qgroup_ref_list) !=
 	    !trans->delayed_ref_elem.seq) {
 		/* list without seq or seq without list */
-		printk(KERN_ERR "btrfs: qgroup accounting update error, list is%s empty, seq is %llu\n",
+		btrfs_err(fs_info,
+			"qgroup accounting update error, list is%s empty, seq is %llu",
 			list_empty(&trans->qgroup_ref_list) ? "" : " not",
 			trans->delayed_ref_elem.seq);
 		BUG();
@@ -3718,8 +3716,8 @@ static void check_system_chunk(struct btrfs_trans_handle *trans,
 
 	thresh = get_system_chunk_thresh(root, type);
 	if (left < thresh && btrfs_test_opt(root, ENOSPC_DEBUG)) {
-		printk(KERN_INFO "left=%llu, need=%llu, flags=%llu\n",
-		       left, thresh, type);
+		btrfs_info(root->fs_info, "left=%llu, need=%llu, flags=%llu",
+			left, thresh, type);
 		dump_space_info(info, 0, 0);
 	}
 
@@ -5478,9 +5476,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 
 			if (ret) {
-				printk(KERN_ERR "umm, got %d back from search"
-				       ", was looking for %llu\n", ret,
-				       (unsigned long long)bytenr);
+				btrfs_err(info, "umm, got %d back from search, was looking for %llu",
+					ret, (unsigned long long)bytenr);
 				if (ret > 0)
 					btrfs_print_leaf(extent_root,
 							 path->nodes[0]);
@@ -5494,13 +5491,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	} else if (ret == -ENOENT) {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
-		printk(KERN_ERR "btrfs unable to find ref byte nr %llu "
-		       "parent %llu root %llu  owner %llu offset %llu\n",
-		       (unsigned long long)bytenr,
-		       (unsigned long long)parent,
-		       (unsigned long long)root_objectid,
-		       (unsigned long long)owner_objectid,
-		       (unsigned long long)owner_offset);
+		btrfs_err(info,
+			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
+			(unsigned long long)bytenr,
+			(unsigned long long)parent,
+			(unsigned long long)root_objectid,
+			(unsigned long long)owner_objectid,
+			(unsigned long long)owner_offset);
 	} else {
 		btrfs_abort_transaction(trans, extent_root, ret);
 		goto out;
@@ -5528,9 +5525,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_search_slot(trans, extent_root, &key, path,
 					-1, 1);
 		if (ret) {
-			printk(KERN_ERR "umm, got %d back from search"
-			       ", was looking for %llu\n", ret,
-			       (unsigned long long)bytenr);
+			btrfs_err(info, "umm, got %d back from search, was looking for %llu",
+				ret, (unsigned long long)bytenr);
 			btrfs_print_leaf(extent_root, path->nodes[0]);
 		}
 		if (ret < 0) {
@@ -5899,7 +5895,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 
 	space_info = __find_space_info(root->fs_info, data);
 	if (!space_info) {
-		printk(KERN_ERR "No space info for %llu\n", data);
+		btrfs_err(root->fs_info, "No space info for %llu", data);
 		return -ENOSPC;
 	}
 
@@ -6323,9 +6319,9 @@ again:
 			struct btrfs_space_info *sinfo;
 
 			sinfo = __find_space_info(root->fs_info, data);
-			printk(KERN_ERR "btrfs allocation failed flags %llu, "
-			       "wanted %llu\n", (unsigned long long)data,
-			       (unsigned long long)num_bytes);
+			btrfs_err(root->fs_info, "allocation failed flags %llu, wanted %llu",
+				(unsigned long long)data,
+				(unsigned long long)num_bytes);
 			if (sinfo)
 				dump_space_info(sinfo, num_bytes, 1);
 		}
@@ -6344,8 +6340,8 @@ static int __btrfs_free_reserved_extent(struct btrfs_root *root,
 
 	cache = btrfs_lookup_block_group(root->fs_info, start);
 	if (!cache) {
-		printk(KERN_ERR "Unable to find block group for %llu\n",
-		       (unsigned long long)start);
+		btrfs_err(root->fs_info, "Unable to find block group for %llu",
+			(unsigned long long)start);
 		return -ENOSPC;
 	}
 
@@ -6440,9 +6436,9 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	ret = update_block_group(root, ins->objectid, ins->offset, 1);
 	if (ret) { /* -ENOENT, logic error */
-		printk(KERN_ERR "btrfs update block group failed for %llu "
-		       "%llu\n", (unsigned long long)ins->objectid,
-		       (unsigned long long)ins->offset);
+		btrfs_err(fs_info, "update block group failed for %llu %llu",
+			(unsigned long long)ins->objectid,
+			(unsigned long long)ins->offset);
 		BUG();
 	}
 	return ret;
@@ -6513,9 +6509,9 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 
 	ret = update_block_group(root, ins->objectid, root->leafsize, 1);
 	if (ret) { /* -ENOENT, logic error */
-		printk(KERN_ERR "btrfs update block group failed for %llu "
-		       "%llu\n", (unsigned long long)ins->objectid,
-		       (unsigned long long)ins->offset);
+		btrfs_err(fs_info, "update block group failed for %llu %llu",
+			(unsigned long long)ins->objectid,
+			(unsigned long long)ins->offset);
 		BUG();
 	}
 	return ret;
@@ -7004,7 +7000,10 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	BUG_ON(wc->refs[level - 1] == 0);
+	if (unlikely(wc->refs[level - 1] == 0)) {
+		btrfs_err(root->fs_info, "Missing references.");
+		BUG();
+	}
 	*lookup_info = 0;
 
 	if (wc->stage == DROP_REFERENCE) {
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 23012ac..153884e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -104,7 +104,8 @@ struct inode *lookup_free_space_inode(struct btrfs_root *root,
 
 	spin_lock(&block_group->lock);
 	if (!((BTRFS_I(inode)->flags & flags) == flags)) {
-		printk(KERN_INFO "Old style space inode found, converting.\n");
+		btrfs_info(root->fs_info,
+			"Old style space inode found, converting.");
 		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM |
 			BTRFS_INODE_NODATACOW;
 		block_group->disk_cache_state = BTRFS_DC_CLEAR;
@@ -669,10 +670,11 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	btrfs_release_path(path);
 
 	if (BTRFS_I(inode)->generation != generation) {
-		printk(KERN_ERR "btrfs: free space inode generation (%llu) did"
-		       " not match free space cache generation (%llu)\n",
-		       (unsigned long long)BTRFS_I(inode)->generation,
-		       (unsigned long long)generation);
+		btrfs_err(root->fs_info,
+			"free space inode generation (%llu) "
+			"did not match free space cache generation (%llu)",
+			(unsigned long long)BTRFS_I(inode)->generation,
+			(unsigned long long)generation);
 		return 0;
 	}
 
@@ -721,8 +723,8 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			ret = link_free_space(ctl, e);
 			spin_unlock(&ctl->tree_lock);
 			if (ret) {
-				printk(KERN_ERR "Duplicate entries in "
-				       "free space cache, dumping\n");
+				btrfs_err(root->fs_info,
+					"Duplicate entries in free space cache, dumping");
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
@@ -741,8 +743,8 @@ int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			ctl->op->recalc_thresholds(ctl);
 			spin_unlock(&ctl->tree_lock);
 			if (ret) {
-				printk(KERN_ERR "Duplicate entries in "
-				       "free space cache, dumping\n");
+				btrfs_err(root->fs_info,
+					"Duplicate entries in free space cache, dumping");
 				kmem_cache_free(btrfs_free_space_cachep, e);
 				goto free_cache;
 			}
@@ -833,8 +835,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 
 	if (!matched) {
 		__btrfs_remove_free_space_cache(ctl);
-		printk(KERN_ERR "block group %llu has an wrong amount of free "
-		       "space\n", block_group->key.objectid);
+		btrfs_err(fs_info, "block group %llu has wrong amount of free space",
+			block_group->key.objectid);
 		ret = -1;
 	}
 out:
@@ -845,8 +847,8 @@ out:
 		spin_unlock(&block_group->lock);
 		ret = 0;
 
-		printk(KERN_ERR "btrfs: failed to load free space cache "
-		       "for block group %llu\n", block_group->key.objectid);
+		btrfs_err(fs_info, "failed to load free space cache for block group %llu",
+			block_group->key.objectid);
 	}
 
 	iput(inode);
@@ -1104,8 +1106,9 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		spin_unlock(&block_group->lock);
 		ret = 0;
 #ifdef DEBUG
-		printk(KERN_ERR "btrfs: failed to write free space cache "
-		       "for block group %llu\n", block_group->key.objectid);
+		btrfs_err(root->fs_info,
+			"failed to write free space cache for block group %llu",
+			block_group->key.objectid);
 #endif
 	}
 
@@ -2931,8 +2934,9 @@ int load_free_ino_cache(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 	ret = __load_free_space_cache(root, inode, ctl, path, 0);
 
 	if (ret < 0)
-		printk(KERN_ERR "btrfs: failed to load free ino cache for "
-		       "root %llu\n", root->root_key.objectid);
+		btrfs_err(fs_info,
+			"failed to load free ino cache for root %llu",
+			root->root_key.objectid);
 out_put:
 	iput(inode);
 out:
@@ -2959,8 +2963,9 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	if (ret) {
 		btrfs_delalloc_release_metadata(inode, inode->i_size);
 #ifdef DEBUG
-		printk(KERN_ERR "btrfs: failed to write free ino cache "
-		       "for root %llu\n", root->root_key.objectid);
+		btrfs_err(root->fs_info,
+			"failed to write free ino cache for root %llu",
+			root->root_key.objectid);
 #endif
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 315a515..1ad2cc1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2777,6 +2777,8 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u32 csum = ~(u32)0;
+	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
+	                              DEFAULT_RATELIMIT_BURST);
 
 	if (PageChecked(page)) {
 		ClearPageChecked(page);
@@ -2813,11 +2815,11 @@ good:
 	return 0;
 
 zeroit:
-	printk_ratelimited(KERN_INFO "btrfs csum failed ino %llu off %llu csum %u "
-		       "private %llu\n",
-		       (unsigned long long)btrfs_ino(page->mapping->host),
-		       (unsigned long long)start, csum,
-		       (unsigned long long)private);
+	if (__ratelimit(&_rs))
+		btrfs_info(root->fs_info, "csum failed ino %llu off %llu csum %u private %llu",
+			(unsigned long long)btrfs_ino(page->mapping->host),
+			(unsigned long long)start, csum,
+			(unsigned long long)private);
 	memset(kaddr + offset, 1, end - start + 1);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr);
@@ -3098,8 +3100,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		 */
 
 		if (found_key.offset == last_objectid) {
-			printk(KERN_ERR "btrfs: Error removing orphan entry, "
-			       "stopping orphan cleanup\n");
+			btrfs_err(root->fs_info,
+				"Error removing orphan entry, stopping orphan cleanup");
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3156,8 +3158,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				ret = PTR_ERR(trans);
 				goto out;
 			}
-			printk(KERN_ERR "auto deleting %Lu\n",
-			       found_key.objectid);
+			btrfs_debug(root->fs_info, "auto deleting %Lu",
+				found_key.objectid);
 			ret = btrfs_del_orphan_item(trans, root,
 						    found_key.objectid);
 			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
@@ -3221,13 +3223,14 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 	}
 
 	if (nr_unlink)
-		printk(KERN_INFO "btrfs: unlinked %d orphans\n", nr_unlink);
+		btrfs_info(root->fs_info, "unlinked %d orphans", nr_unlink);
 	if (nr_truncate)
-		printk(KERN_INFO "btrfs: truncated %d orphans\n", nr_truncate);
+		btrfs_info(root->fs_info, "truncated %d orphans", nr_truncate);
 
 out:
 	if (ret)
-		printk(KERN_CRIT "btrfs: could not do orphan cleanup %d\n", ret);
+		btrfs_crit(root->fs_info,
+			"could not do orphan cleanup %d", ret);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -3575,9 +3578,10 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_inode_ref(trans, root, name, name_len, ino,
 				  dir_ino, &index);
 	if (ret) {
-		printk(KERN_INFO "btrfs failed to delete reference to %.*s, "
-		       "inode %llu parent %llu\n", name_len, name,
-		       (unsigned long long)ino, (unsigned long long)dir_ino);
+		btrfs_info(root->fs_info,
+			"failed to delete reference to %.*s, inode %llu parent %llu",
+			name_len, name,
+			(unsigned long long)ino, (unsigned long long)dir_ino);
 		btrfs_abort_transaction(trans, root, ret);
 		goto err;
 	}
@@ -4656,8 +4660,9 @@ void btrfs_evict_inode(struct inode *inode)
 			ret = btrfs_block_rsv_migrate(global_rsv, rsv, min_size);
 
 		if (ret) {
-			printk(KERN_WARNING "Could not get space for a "
-			       "delete, will truncate on mount %d\n", ret);
+			btrfs_warn(root->fs_info,
+				"Could not get space for a delete, will truncate on mount %d",
+				ret);
 			btrfs_orphan_del(NULL, inode);
 			btrfs_free_block_rsv(root, rsv);
 			goto no_delete;
@@ -6245,11 +6250,11 @@ not_found_em:
 insert:
 	btrfs_release_path(path);
 	if (em->start > start || extent_map_end(em) <= start) {
-		printk(KERN_ERR "Btrfs: bad extent! em: [%llu %llu] passed "
-		       "[%llu %llu]\n", (unsigned long long)em->start,
-		       (unsigned long long)em->len,
-		       (unsigned long long)start,
-		       (unsigned long long)len);
+		btrfs_err(root->fs_info, "bad extent! em: [%llu %llu] passed [%llu %llu]",
+			(unsigned long long)em->start,
+			(unsigned long long)em->len,
+			(unsigned long long)start,
+			(unsigned long long)len);
 		err = -EIO;
 		goto out;
 	}
@@ -6930,11 +6935,10 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			flush_dcache_page(bvec->bv_page);
 			if (csum != private) {
 failed:
-				printk(KERN_ERR "btrfs csum failed ino %llu off"
-				      " %llu csum %u private %u\n",
-				      (unsigned long long)btrfs_ino(inode),
-				      (unsigned long long)start,
-				      csum, (unsigned)private);
+				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u private %u",
+					(unsigned long long)btrfs_ino(inode),
+					(unsigned long long)start,
+					csum, (unsigned)private);
 				err = -EIO;
 			}
 		}
@@ -7926,8 +7930,8 @@ void btrfs_destroy_inode(struct inode *inode)
 
 	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 		     &BTRFS_I(inode)->runtime_flags)) {
-		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
-		       (unsigned long long)btrfs_ino(inode));
+		btrfs_info(root->fs_info, "inode %llu still on the orphan list",
+			(unsigned long long)btrfs_ino(inode));
 		atomic_dec(&root->orphan_inodes);
 	}
 
@@ -7936,10 +7940,9 @@ void btrfs_destroy_inode(struct inode *inode)
 		if (!ordered)
 			break;
 		else {
-			printk(KERN_ERR "btrfs found ordered "
-			       "extent %llu %llu on inode cleanup\n",
-			       (unsigned long long)ordered->file_offset,
-			       (unsigned long long)ordered->len);
+			btrfs_err(root->fs_info, "found ordered extent %llu %llu on inode cleanup",
+				(unsigned long long)ordered->file_offset,
+				(unsigned long long)ordered->len);
 			btrfs_remove_ordered_extent(inode, ordered);
 			btrfs_put_ordered_extent(ordered);
 			btrfs_put_ordered_extent(ordered);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 920957e..dc0024f 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -176,7 +176,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 
 	nr = btrfs_header_nritems(l);
 
-	printk(KERN_INFO "leaf %llu total ptrs %d free space %d\n",
+	btrfs_info(root->fs_info, "leaf %llu total ptrs %d free space %d",
 		(unsigned long long)btrfs_header_bytenr(l), nr,
 		btrfs_leaf_free_space(root, l));
 	for (i = 0 ; i < nr ; i++) {
@@ -319,10 +319,9 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *c)
 		btrfs_print_leaf(root, c);
 		return;
 	}
-	printk(KERN_INFO "node %llu level %d total ptrs %d free spc %u\n",
-	       (unsigned long long)btrfs_header_bytenr(c),
-	      level, nr,
-	       (u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
+	btrfs_info(root->fs_info, "node %llu level %d total ptrs %d free spc %u",
+		(unsigned long long)btrfs_header_bytenr(c),
+		level, nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr);
 	for (i = 0; i < nr; i++) {
 		btrfs_node_key_to_cpu(c, &key, i);
 		printk(KERN_INFO "\tkey %d (%llu %u %llu) block %llu\n",
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5f21797..4ba5a1d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -105,7 +105,7 @@ static void btrfs_handle_error(struct btrfs_fs_info *fs_info)
 
 	if (test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
 		sb->s_flags |= MS_RDONLY;
-		printk(KERN_INFO "btrfs is forced readonly\n");
+		btrfs_info(fs_info, "forced readonly");
 		/*
 		 * Note that a running device replace operation is not
 		 * canceled here although there is no way to update
@@ -172,7 +172,7 @@ static const char * const logtypes[] = {
 	"debug",
 };
 
-void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
+void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
 	char lvl[4];
@@ -196,7 +196,7 @@ void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...)
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	printk("%sBTRFS %s (device %s): %pV", lvl, type, sb->s_id, &vaf);
+	printk("%sBTRFS %s (device %s): %pV\n", lvl, type, sb->s_id, &vaf);
 
 	va_end(args);
 }
@@ -255,9 +255,9 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 		const char *errstr;
 
 		errstr = btrfs_decode_error(errno);
-		btrfs_printk(root->fs_info,
-			     "%s:%d: Aborting unused transaction (%s)\n",
-			     function, line, errstr);
+		btrfs_warn(root->fs_info,
+		           "%s:%d: Aborting unused transaction(%s).",
+		           function, line, errstr);
 		return;
 	}
 	ACCESS_ONCE(trans->transaction->aborted) = errno;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 74cf8b0..37f509f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1865,7 +1865,7 @@ cleanup_transaction:
 		btrfs_qgroup_free(root, trans->qgroup_reserved);
 		trans->qgroup_reserved = 0;
 	}
-	btrfs_printk(root->fs_info, "Skipping commit of aborted transaction\n");
+	btrfs_warn(root->fs_info, "Skipping commit of aborted transaction.");
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 	cleanup_transaction(trans, root, ret);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5989a92..3705b90 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4411,9 +4411,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	read_unlock(&em_tree->lock);
 
 	if (!em) {
-		printk(KERN_CRIT "btrfs: unable to find logical %llu len %llu\n",
-		       (unsigned long long)logical,
-		       (unsigned long long)*length);
+		btrfs_crit(fs_info, "unable to find logical %llu len %llu",
+			(unsigned long long)logical,
+			(unsigned long long)*length);
 		BUG();
 	}
 
@@ -5297,10 +5297,10 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	}
 
 	if (map_length < length) {
-		printk(KERN_CRIT "btrfs: mapping failed logical %llu bio len %llu "
-		       "len %llu\n", (unsigned long long)logical,
-		       (unsigned long long)length,
-		       (unsigned long long)map_length);
+		btrfs_crit(root->fs_info, "mapping failed logical %llu bio len %llu len %llu",
+			(unsigned long long)logical,
+			(unsigned long long)length,
+			(unsigned long long)map_length);
 		BUG();
 	}
 
@@ -5572,8 +5572,8 @@ static int read_one_dev(struct btrfs_root *root,
 			return -EIO;
 
 		if (!device) {
-			printk(KERN_WARNING "warning devid %llu missing\n",
-			       (unsigned long long)devid);
+			btrfs_warn(root->fs_info, "devid %llu missing",
+				(unsigned long long)devid);
 			device = add_missing_dev(root, devid, dev_uuid);
 			if (!device)
 				return -ENOMEM;
-- 
1.7.10.4
