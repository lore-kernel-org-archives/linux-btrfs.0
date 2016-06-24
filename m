Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbcFXWPd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:33 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 94768ADEA
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 31/31] btrfs: root->fs_info cleanup, btrfs_end_transaction{,_throttle} use trans->fs_info instead of parameter
Date: Fri, 24 Jun 2016 18:15:24 -0400
Message-Id: <1466806524-27508-32-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Without btrfs_commit_transaction accepting a root parameter,
__btrfs_end_transaction doesn't consume one anymore.

In theory, we still accept it to compare that the root we used to start
the transaction is the same one we used to end it.  In practice, the
check doesn't exist.  There was one case where we were passing different
roots but that was fixed in an earlier patch.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/backref.c         |  2 +-
 fs/btrfs/delayed-inode.c   |  4 +--
 fs/btrfs/disk-io.c         |  2 +-
 fs/btrfs/extent-tree.c     | 25 ++++++++---------
 fs/btrfs/file.c            | 18 ++++++------
 fs/btrfs/free-space-tree.c |  4 +--
 fs/btrfs/inode.c           | 68 +++++++++++++++++++++++-----------------------
 fs/btrfs/ioctl.c           | 37 ++++++++++++-------------
 fs/btrfs/qgroup.c          |  4 +--
 fs/btrfs/relocation.c      | 20 +++++++-------
 fs/btrfs/root-tree.c       |  2 +-
 fs/btrfs/scrub.c           |  6 ++--
 fs/btrfs/send.c            |  2 +-
 fs/btrfs/transaction.c     | 30 ++++++++++----------
 fs/btrfs/transaction.h     |  6 ++--
 fs/btrfs/tree-log.c        |  2 +-
 fs/btrfs/uuid-tree.c       |  2 +-
 fs/btrfs/volumes.c         | 16 +++++------
 fs/btrfs/xattr.c           |  2 +-
 19 files changed, 123 insertions(+), 129 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1d2c742..5c9505a0 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1706,7 +1706,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 out:
 	if (!search_commit_root) {
 		btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
-		btrfs_end_transaction(trans, fs_info->extent_root);
+		btrfs_end_transaction(trans);
 	} else {
 		up_read(&fs_info->commit_root_sem);
 	}
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index ca56a8d..9535b5d 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1301,7 +1301,7 @@ int btrfs_commit_inode_delayed_inode(struct inode *inode)
 	btrfs_free_path(path);
 	trans->block_rsv = block_rsv;
 trans_out:
-	btrfs_end_transaction(trans, delayed_node->root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
 out:
 	btrfs_release_delayed_node(delayed_node);
@@ -1366,7 +1366,7 @@ again:
 	__btrfs_commit_inode_delayed_items(trans, path, delayed_node);
 
 	trans->block_rsv = block_rsv;
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty_nodelay(root->fs_info);
 
 release_path:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 153e03e..59e5f1e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1928,7 +1928,7 @@ static int transaction_kthread(void *arg)
 		if (transid == trans->transid) {
 			btrfs_commit_transaction(trans);
 		} else {
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 		}
 sleep:
 		wake_up_process(fs_info->cleaner_kthread);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31478eb..304e46d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2849,7 +2849,7 @@ static void delayed_ref_async_start(struct btrfs_work *work)
 	if (ret)
 		async->error = ret;
 
-	ret = btrfs_end_transaction(trans, async->root);
+	ret = btrfs_end_transaction(trans);
 	if (ret && !async->error)
 		async->error = ret;
 done:
@@ -4159,7 +4159,7 @@ alloc:
 
 			ret = do_chunk_alloc(trans, fs_info, alloc_target,
 					     CHUNK_ALLOC_NO_FORCE);
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 			if (ret < 0) {
 				if (ret != -ENOSPC)
 					return ret;
@@ -4216,7 +4216,7 @@ commit_trans:
 				mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
 				goto again;
 			} else {
-				btrfs_end_transaction(trans, root);
+				btrfs_end_transaction(trans);
 			}
 		}
 
@@ -4820,7 +4820,7 @@ static int flush_space(struct btrfs_root *root,
 			break;
 		}
 		ret = btrfs_run_delayed_items_nr(trans, fs_info, nr);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		break;
 	case FLUSH_DELALLOC:
 	case FLUSH_DELALLOC_WAIT:
@@ -4836,7 +4836,7 @@ static int flush_space(struct btrfs_root *root,
 		ret = do_chunk_alloc(trans, fs_info,
 				     btrfs_get_alloc_profile(root, 0),
 				     CHUNK_ALLOC_NO_FORCE);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		if (ret == -ENOSPC)
 			ret = 0;
 		break;
@@ -7629,7 +7629,7 @@ loop:
 			else
 				ret = 0;
 			if (!exist)
-				btrfs_end_transaction(trans, root);
+				btrfs_end_transaction(trans);
 			if (ret)
 				goto out;
 		}
@@ -9118,7 +9118,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 				goto out_end_trans;
 			}
 
-			btrfs_end_transaction_throttle(trans, tree_root);
+			btrfs_end_transaction_throttle(trans);
 			if (!for_reloc && btrfs_need_cleaner_sleep(fs_info)) {
 				pr_debug("BTRFS: drop snapshot early exit\n");
 				err = -EAGAIN;
@@ -9171,7 +9171,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	}
 	root_dropped = true;
 out_end_trans:
-	btrfs_end_transaction_throttle(trans, tree_root);
+	btrfs_end_transaction_throttle(trans);
 out_free:
 	kfree(wc);
 	btrfs_free_path(path);
@@ -9380,7 +9380,7 @@ again:
 		u64 transid = trans->transid;
 
 		mutex_unlock(&fs_info->ro_block_group_mutex);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 
 		ret = btrfs_wait_for_commit(fs_info, transid);
 		if (ret)
@@ -9425,7 +9425,7 @@ out:
 	}
 	mutex_unlock(&fs_info->ro_block_group_mutex);
 
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
@@ -9644,7 +9644,7 @@ int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 			   "no space to allocate a new chunk for block group %llu",
 			   block_group->key.objectid);
 	mutex_unlock(&fs_info->chunk_mutex);
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 out:
 	btrfs_put_block_group(block_group);
 	return ret;
@@ -10566,7 +10566,6 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_space_info *space_info;
-	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
@@ -10717,7 +10716,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			btrfs_get_block_group(block_group);
 		}
 end_trans:
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 next:
 		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 		btrfs_put_block_group(block_group);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5fa030f..34d54d9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2109,7 +2109,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * which are indicated by ctx.io_err.
 	 */
 	if (ctx.io_err) {
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		ret = ctx.io_err;
 		goto out;
 	}
@@ -2118,20 +2118,20 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		if (!ret) {
 			ret = btrfs_sync_log(trans, root, &ctx);
 			if (!ret) {
-				ret = btrfs_end_transaction(trans, root);
+				ret = btrfs_end_transaction(trans);
 				goto out;
 			}
 		}
 		if (!full_sync) {
 			ret = btrfs_wait_ordered_range(inode, start, len);
 			if (ret) {
-				btrfs_end_transaction(trans, root);
+				btrfs_end_transaction(trans);
 				goto out;
 			}
 		}
 		ret = btrfs_commit_transaction(trans);
 	} else {
-		ret = btrfs_end_transaction(trans, root);
+		ret = btrfs_end_transaction(trans);
 	}
 out:
 	return ret > 0 ? -EIO : ret;
@@ -2524,7 +2524,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
 
 		trans = btrfs_start_transaction(root, rsv_count);
@@ -2590,7 +2590,7 @@ out_trans:
 	trans->block_rsv = &fs_info->trans_block_rsv;
 	ret = btrfs_update_inode(trans, root, inode);
 	updated_inode = true;
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
 out_free:
 	btrfs_free_path(path);
@@ -2612,7 +2612,7 @@ out_only_mutex:
 			err = PTR_ERR(trans);
 		} else {
 			err = btrfs_update_inode(trans, root, inode);
-			ret = btrfs_end_transaction(trans, root);
+			ret = btrfs_end_transaction(trans);
 		}
 	}
 	inode_unlock(inode);
@@ -2843,9 +2843,9 @@ static long btrfs_fallocate(struct file *file, int mode,
 			btrfs_ordered_update_i_size(inode, actual_end, NULL);
 			ret = btrfs_update_inode(trans, root, inode);
 			if (ret)
-				btrfs_end_transaction(trans, root);
+				btrfs_end_transaction(trans);
 			else
-				ret = btrfs_end_transaction(trans, root);
+				ret = btrfs_end_transaction(trans);
 		}
 	}
 out_unlock:
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 671865b..73918e9 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1196,7 +1196,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 abort:
 	fs_info->creating_free_space_tree = 0;
 	btrfs_abort_transaction(trans, ret);
-	btrfs_end_transaction(trans, tree_root);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
@@ -1283,7 +1283,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 
 abort:
 	btrfs_abort_transaction(trans, ret);
-	btrfs_end_transaction(trans, tree_root);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4600e93..c45570e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -325,7 +325,7 @@ out:
 	 */
 	btrfs_qgroup_free_data(inode, 0, PAGE_SIZE);
 	btrfs_free_path(path);
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
@@ -1516,7 +1516,7 @@ out_check:
 	}
 
 error:
-	err = btrfs_end_transaction(trans, root);
+	err = btrfs_end_transaction(trans);
 	if (!ret)
 		ret = err;
 
@@ -2640,7 +2640,7 @@ again:
 out_free_path:
 	btrfs_release_path(path);
 	path->leave_spinning = 0;
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, lock_end,
 			     &cached, GFP_NOFS);
@@ -2986,7 +2986,7 @@ out:
 	if (root != fs_info->tree_root)
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 	if (trans)
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 
 	if (ret || truncated) {
 		u64 start, end;
@@ -3494,7 +3494,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				    found_key.objectid);
 			ret = btrfs_del_orphan_item(trans, root,
 						    found_key.objectid);
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 			if (ret)
 				goto out;
 			continue;
@@ -3524,7 +3524,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 				goto out;
 			}
 			ret = btrfs_orphan_add(trans, inode);
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 			if (ret) {
 				iput(inode);
 				goto out;
@@ -3555,7 +3555,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 	    test_bit(BTRFS_ROOT_ORPHAN_ITEM_INSERTED, &root->state)) {
 		trans = btrfs_join_transaction(root);
 		if (!IS_ERR(trans))
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 	}
 
 	if (nr_unlink)
@@ -4125,7 +4125,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 
 out:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(root->fs_info);
 	return ret;
 }
@@ -4245,7 +4245,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!err)
 		btrfs_i_size_write(inode, 0);
 out:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(root->fs_info);
 
 	return err;
@@ -4806,7 +4806,7 @@ static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
 	ret = btrfs_drop_extents(trans, root, inode, offset, offset + len, 1);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
@@ -4816,7 +4816,7 @@ static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
 		btrfs_abort_transaction(trans, ret);
 	else
 		btrfs_update_inode(trans, root, inode);
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
@@ -4980,7 +4980,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		pagecache_isize_extended(inode, oldsize, newsize);
 		ret = btrfs_update_inode(trans, root, inode);
 		btrfs_end_write_no_snapshoting(root);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 	} else {
 
 		/*
@@ -5011,7 +5011,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 		 * will be consistent.
 		 */
 		ret = btrfs_orphan_add(trans, inode);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		if (ret)
 			return ret;
 
@@ -5042,7 +5042,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 			err = btrfs_orphan_del(trans, inode);
 			if (err)
 				btrfs_abort_transaction(trans, err);
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 		}
 	}
 
@@ -5314,7 +5314,7 @@ void btrfs_evict_inode(struct inode *inode)
 			break;
 
 		trans->block_rsv = &fs_info->trans_block_rsv;
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		trans = NULL;
 		btrfs_btree_balance_dirty(fs_info);
 	}
@@ -5337,7 +5337,7 @@ void btrfs_evict_inode(struct inode *inode)
 	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
 		btrfs_return_ino(root, btrfs_ino(inode));
 
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
 no_delete:
 	btrfs_remove_delayed_node(inode);
@@ -6000,14 +6000,14 @@ static int btrfs_dirty_inode(struct inode *inode)
 	ret = btrfs_update_inode(trans, root, inode);
 	if (ret && ret == -ENOSPC) {
 		/* whoops, lets try again with the full transaction */
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 
 		ret = btrfs_update_inode(trans, root, inode);
 	}
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	if (BTRFS_I(inode)->delayed_node)
 		btrfs_balance_delayed_items(fs_info);
 
@@ -6445,7 +6445,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	}
 
 out_unlock:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_balance_delayed_items(fs_info);
 	btrfs_btree_balance_dirty(fs_info);
 	if (drop_inode) {
@@ -6521,7 +6521,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	d_instantiate(dentry, inode);
 
 out_unlock:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	if (err && drop_inode_on_err) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -6603,7 +6603,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	btrfs_balance_delayed_items(fs_info);
 fail:
 	if (trans)
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -6672,7 +6672,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	drop_on_err = 0;
 
 out_fail:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	if (drop_on_err) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -7060,7 +7060,7 @@ out:
 
 	btrfs_free_path(path);
 	if (trans) {
-		ret = btrfs_end_transaction(trans, root);
+		ret = btrfs_end_transaction(trans);
 		if (!err)
 			err = ret;
 	}
@@ -7384,7 +7384,7 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 
 	ret = btrfs_cross_ref_exist(trans, root, btrfs_ino(inode),
 				    key.offset - backref_offset, disk_bytenr);
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	if (ret) {
 		ret = 0;
 		goto out;
@@ -9180,7 +9180,7 @@ static int btrfs_truncate(struct inode *inode)
 			break;
 		}
 
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
 
 		trans = btrfs_start_transaction(root, 2);
@@ -9209,7 +9209,7 @@ static int btrfs_truncate(struct inode *inode)
 		if (ret && !err)
 			err = ret;
 
-		ret = btrfs_end_transaction(trans, root);
+		ret = btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(fs_info);
 	}
 
@@ -9678,7 +9678,7 @@ out_fail:
 			dest_log_pinned = false;
 		}
 	}
-	ret = btrfs_end_transaction(trans, root);
+	ret = btrfs_end_transaction(trans);
 out_notrans:
 	if (new_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
@@ -9948,7 +9948,7 @@ out_fail:
 		btrfs_end_log_trans(root);
 		log_pinned = false;
 	}
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 out_notrans:
 	if (old_ino == BTRFS_FIRST_FREE_OBJECTID)
 		up_read(&fs_info->subvol_sem);
@@ -10281,7 +10281,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	d_instantiate(dentry, inode);
 
 out_unlock:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -10336,7 +10336,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 					   *alloc_hint, &ins, 1, 0);
 		if (ret) {
 			if (own_trans)
-				btrfs_end_transaction(trans, root);
+				btrfs_end_transaction(trans);
 			break;
 		}
 		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
@@ -10352,7 +10352,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						   ins.offset, 0);
 			btrfs_abort_transaction(trans, ret);
 			if (own_trans)
-				btrfs_end_transaction(trans, root);
+				btrfs_end_transaction(trans);
 			break;
 		}
 
@@ -10412,12 +10412,12 @@ next:
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			if (own_trans)
-				btrfs_end_transaction(trans, root);
+				btrfs_end_transaction(trans);
 			break;
 		}
 
 		if (own_trans)
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 	}
 	return ret;
 }
@@ -10519,7 +10519,7 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	mark_inode_dirty(inode);
 
 out:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	if (ret)
 		iput(inode);
 	btrfs_balance_delayed_items(fs_info);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 04e8061..3d402dd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -353,7 +353,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	inode->i_ctime = current_fs_time(inode->i_sb);
 	ret = btrfs_update_inode(trans, root, inode);
 
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
  out_drop:
 	if (ret) {
 		ip->flags = ip_oldflags;
@@ -2542,7 +2542,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
-	ret = btrfs_end_transaction(trans, root);
+	ret = btrfs_end_transaction(trans);
 	if (ret && !err)
 		err = ret;
 	inode->i_flags |= S_DEAD;
@@ -3302,10 +3302,10 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode(trans, root, inode);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		goto out;
 	}
-	ret = btrfs_end_transaction(trans, root);
+	ret = btrfs_end_transaction(trans);
 out:
 	return ret;
 }
@@ -3706,7 +3706,7 @@ process_slot:
 					if (ret != -EOPNOTSUPP)
 						btrfs_abort_transaction(trans,
 									ret);
-					btrfs_end_transaction(trans, root);
+					btrfs_end_transaction(trans);
 					goto out;
 				}
 
@@ -3714,7 +3714,7 @@ process_slot:
 							      &new_key, size);
 				if (ret) {
 					btrfs_abort_transaction(trans, ret);
-					btrfs_end_transaction(trans, root);
+					btrfs_end_transaction(trans);
 					goto out;
 				}
 
@@ -3747,8 +3747,7 @@ process_slot:
 					if (ret) {
 						btrfs_abort_transaction(trans,
 									ret);
-						btrfs_end_transaction(trans,
-								      root);
+						btrfs_end_transaction(trans);
 						goto out;
 
 					}
@@ -3767,7 +3766,7 @@ process_slot:
 
 				if (comp && (skip || trim)) {
 					ret = -EINVAL;
-					btrfs_end_transaction(trans, root);
+					btrfs_end_transaction(trans);
 					goto out;
 				}
 				size -= skip + trim;
@@ -3783,7 +3782,7 @@ process_slot:
 					if (ret != -EOPNOTSUPP)
 						btrfs_abort_transaction(trans,
 									ret);
-					btrfs_end_transaction(trans, root);
+					btrfs_end_transaction(trans);
 					goto out;
 				}
 				leaf = path->nodes[0];
@@ -3838,7 +3837,7 @@ process_slot:
 		if (ret) {
 			if (ret != -EOPNOTSUPP)
 				btrfs_abort_transaction(trans, ret);
-			btrfs_end_transaction(trans, root);
+			btrfs_end_transaction(trans);
 			goto out;
 		}
 		clone_update_extent_map(inode, trans, NULL, last_dest_end,
@@ -4100,7 +4099,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 				   dir_id, "default", 7, 1);
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_free_path(path);
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		btrfs_err(fs_info,
 			  "Umm, you don't have the default dir item, this isn't going to work");
 		ret = -ENOENT;
@@ -4113,7 +4112,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	btrfs_free_path(path);
 
 	btrfs_set_fs_incompat(fs_info, DEFAULT_SUBVOL);
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 out:
 	mnt_drop_write_file(file);
 	return ret;
@@ -4293,7 +4292,7 @@ long btrfs_ioctl_trans_end(struct file *file)
 		return -EINVAL;
 	file->private_data = NULL;
 
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 
 	atomic_dec(&root->fs_info->open_ioctl_trans);
 
@@ -4320,7 +4319,7 @@ static noinline long btrfs_ioctl_start_sync(struct btrfs_root *root,
 	transid = trans->transid;
 	ret = btrfs_commit_transaction_async(trans, root, 0);
 	if (ret) {
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 out:
@@ -4928,7 +4927,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	if (err < 0)
 		btrfs_handle_fs_error(fs_info, err,
 				      "failed to update qgroup status and info");
-	err = btrfs_end_transaction(trans, root);
+	err = btrfs_end_transaction(trans);
 	if (err && !ret)
 		ret = err;
 
@@ -4980,7 +4979,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid);
 	}
 
-	err = btrfs_end_transaction(trans, root);
+	err = btrfs_end_transaction(trans);
 	if (err && !ret)
 		ret = err;
 
@@ -5030,7 +5029,7 @@ static long btrfs_ioctl_qgroup_limit(struct file *file, void __user *arg)
 	/* FIXME: check if the IDs really exist */
 	ret = btrfs_limit_qgroup(trans, fs_info, qgroupid, &sa->lim);
 
-	err = btrfs_end_transaction(trans, root);
+	err = btrfs_end_transaction(trans);
 	if (err && !ret)
 		ret = err;
 
@@ -5176,7 +5175,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
 	if (ret < 0) {
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		goto out;
 	}
 	if (received_uuid_changed && !btrfs_is_empty_uuid(sa->uuid)) {
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b00c2ea..c9a1ce4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2321,7 +2321,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		if (err > 0)
 			btrfs_commit_transaction(trans);
 		else
-			btrfs_end_transaction(trans, fs_info->fs_root);
+			btrfs_end_transaction(trans);
 	}
 
 out:
@@ -2356,7 +2356,7 @@ out:
 		err = ret;
 		btrfs_err(fs_info, "fail to update qgroup status: %d\n", err);
 	}
-	btrfs_end_transaction(trans, fs_info->quota_root);
+	btrfs_end_transaction(trans);
 
 	if (btrfs_fs_closing(fs_info)) {
 		btrfs_info(fs_info, "qgroup scan paused");
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d64a805..930d09c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2234,7 +2234,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 			       path->slots[level]);
 		root_item->drop_level = level;
 
-		btrfs_end_transaction_throttle(trans, root);
+		btrfs_end_transaction_throttle(trans);
 		trans = NULL;
 
 		btrfs_btree_balance_dirty(fs_info);
@@ -2265,7 +2265,7 @@ out:
 	}
 
 	if (trans)
-		btrfs_end_transaction_throttle(trans, root);
+		btrfs_end_transaction_throttle(trans);
 
 	btrfs_btree_balance_dirty(fs_info);
 
@@ -2310,7 +2310,7 @@ again:
 
 	if (!err) {
 		if (num_bytes != rc->merging_rsv_size) {
-			btrfs_end_transaction(trans, rc->extent_root);
+			btrfs_end_transaction(trans);
 			btrfs_block_rsv_release(fs_info, rc->block_rsv,
 						num_bytes);
 			goto again;
@@ -2344,7 +2344,7 @@ again:
 	if (!err)
 		btrfs_commit_transaction(trans);
 	else
-		btrfs_end_transaction(trans, rc->extent_root);
+		btrfs_end_transaction(trans);
 	return err;
 }
 
@@ -3492,7 +3492,7 @@ truncate:
 
 	ret = btrfs_truncate_free_space_cache(root, trans, block_group, inode);
 
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
 out:
 	iput(inode);
@@ -3964,7 +3964,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		}
 restart:
 		if (update_backref_cache(trans, &rc->backref_cache)) {
-			btrfs_end_transaction(trans, rc->extent_root);
+			btrfs_end_transaction(trans);
 			continue;
 		}
 
@@ -4052,7 +4052,7 @@ restart:
 			}
 		}
 
-		btrfs_end_transaction_throttle(trans, rc->extent_root);
+		btrfs_end_transaction_throttle(trans);
 		btrfs_btree_balance_dirty(fs_info);
 		trans = NULL;
 
@@ -4081,7 +4081,7 @@ restart:
 	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY);
 
 	if (trans) {
-		btrfs_end_transaction_throttle(trans, rc->extent_root);
+		btrfs_end_transaction_throttle(trans);
 		btrfs_btree_balance_dirty(fs_info);
 	}
 
@@ -4187,7 +4187,7 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 
 	err = btrfs_orphan_add(trans, inode);
 out:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
 	if (err) {
 		if (inode)
@@ -4334,7 +4334,7 @@ static noinline_for_stack int mark_garbage_root(struct btrfs_root *root)
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
 
-	err = btrfs_end_transaction(trans, fs_info->tree_root);
+	err = btrfs_end_transaction(trans);
 	if (err)
 		return err;
 	return ret;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 0ed6b97..53e81cb1 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -293,7 +293,7 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 			}
 			err = btrfs_del_orphan_item(trans, tree_root,
 						    root_key.objectid);
-			btrfs_end_transaction(trans, tree_root);
+			btrfs_end_transaction(trans);
 			if (err) {
 				btrfs_handle_fs_error(fs_info, err,
 					    "Failed to delete root orphan "
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c98b91b..fb4d09d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -838,7 +838,7 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 
 out:
 	if (trans && !IS_ERR(trans))
-		btrfs_end_transaction(trans, fixup->root);
+		btrfs_end_transaction(trans);
 	if (uncorrectable) {
 		spin_lock(&sctx->stat_lock);
 		++sctx->stat.uncorrectable_errors;
@@ -4197,7 +4197,7 @@ static void copy_nocow_pages_worker(struct btrfs_work *work)
 		goto out;
 	}
 
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	trans = NULL;
 	while (!list_empty(&nocow_ctx->inodes)) {
 		struct scrub_nocow_inode *entry;
@@ -4225,7 +4225,7 @@ out:
 		kfree(entry);
 	}
 	if (trans && !IS_ERR(trans))
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 	if (not_written)
 		btrfs_dev_replace_stats_inc(&fs_info->dev_replace.
 					    num_uncorrectable_read_errors);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index cd0a052..eaf85db 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5898,7 +5898,7 @@ again:
 			goto commit_trans;
 
 	if (trans)
-		return btrfs_end_transaction(trans, sctx->send_root);
+		return btrfs_end_transaction(trans);
 
 	return 0;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a546c08..091cb0d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -640,7 +640,7 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 	ret = btrfs_cond_migrate_bytes(fs_info, &fs_info->trans_block_rsv,
 				       num_bytes, min_factor);
 	if (ret) {
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		return ERR_PTR(ret);
 	}
 
@@ -822,10 +822,10 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 }
 
 static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, int throttle)
+				   int throttle)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_fs_info *info = trans->fs_info;
 	unsigned long cur = trans->delayed_ref_updates;
 	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
@@ -919,16 +919,14 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	return err;
 }
 
-int btrfs_end_transaction(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root)
+int btrfs_end_transaction(struct btrfs_trans_handle *trans)
 {
-	return __btrfs_end_transaction(trans, root, 0);
+	return __btrfs_end_transaction(trans, 0);
 }
 
-int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root)
+int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans)
 {
-	return __btrfs_end_transaction(trans, root, 1);
+	return __btrfs_end_transaction(trans, 1);
 }
 
 /*
@@ -1305,7 +1303,7 @@ int btrfs_defrag_root(struct btrfs_root *root)
 
 		ret = btrfs_defrag_leaves(trans, root);
 
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		btrfs_btree_balance_dirty(info);
 		cond_resched();
 
@@ -1827,7 +1825,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	cur_trans = trans->transaction;
 	atomic_inc(&cur_trans->use_count);
 
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 
 	/*
 	 * Tell lockdep we've released the freeze rwsem, since the
@@ -1936,7 +1934,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	/* Stop the commit early if ->aborted is set */
 	if (unlikely(ACCESS_ONCE(cur_trans->aborted))) {
 		ret = cur_trans->aborted;
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
@@ -1945,7 +1943,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 */
 	ret = btrfs_run_delayed_refs(trans, root, 0);
 	if (ret) {
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
@@ -1966,7 +1964,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	ret = btrfs_run_delayed_refs(trans, root, 0);
 	if (ret) {
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
@@ -1996,7 +1994,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 			ret = btrfs_start_dirty_block_groups(trans, root);
 	}
 	if (ret) {
-		btrfs_end_transaction(trans, root);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
@@ -2004,7 +2002,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (cur_trans->state >= TRANS_STATE_COMMIT_START) {
 		spin_unlock(&fs_info->trans_lock);
 		atomic_inc(&cur_trans->use_count);
-		ret = btrfs_end_transaction(trans, root);
+		ret = btrfs_end_transaction(trans);
 
 		wait_for_commit(cur_trans);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7d3b358..f502514 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -184,8 +184,7 @@ static inline void btrfs_clear_skip_qgroup(struct btrfs_trans_handle *trans)
 	delayed_refs->qgroup_to_skip = 0;
 }
 
-int btrfs_end_transaction(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root);
+int btrfs_end_transaction(struct btrfs_trans_handle *trans);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   unsigned int num_items);
 struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
@@ -210,8 +209,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   int wait_for_unblock);
-int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root);
+int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans);
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 void btrfs_throttle(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e714eb5..ccdff9c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5626,7 +5626,7 @@ again:
 	return 0;
 error:
 	if (wc.trans)
-		btrfs_end_transaction(wc.trans, fs_info->tree_root);
+		btrfs_end_transaction(wc.trans);
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 24b4cfb..3476e91 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -251,7 +251,7 @@ static int btrfs_uuid_iter_rem(struct btrfs_root *uuid_root, u8 *uuid, u8 type,
 	}
 
 	ret = btrfs_uuid_tree_rem(trans, uuid_root->fs_info, uuid, type, subid);
-	btrfs_end_transaction(trans, uuid_root);
+	btrfs_end_transaction(trans);
 
 out:
 	return ret;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5953948..b760933 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2457,7 +2457,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 	return ret;
 
 error_trans:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	rcu_string_free(device->name);
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
 	kfree(device);
@@ -2894,7 +2894,7 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	 * chunk tree entries
 	 */
 	ret = btrfs_remove_chunk(trans, fs_info, chunk_offset);
-	btrfs_end_transaction(trans, fs_info->extent_root);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
@@ -3456,7 +3456,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 		ret = btrfs_grow_device(trans, device, old_size);
 		BUG_ON(ret);
 
-		btrfs_end_transaction(trans, dev_root);
+		btrfs_end_transaction(trans);
 	}
 
 	/* step two, relocate all the chunks */
@@ -3586,7 +3586,7 @@ again:
 
 			ret = btrfs_force_chunk_alloc(trans, fs_info,
 						      BTRFS_BLOCK_GROUP_DATA);
-			btrfs_end_transaction(trans, chunk_root);
+			btrfs_end_transaction(trans);
 			if (ret < 0) {
 				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
 				goto error;
@@ -4114,7 +4114,7 @@ update_tree:
 
 skip:
 		if (trans) {
-			ret = btrfs_end_transaction(trans, fs_info->uuid_root);
+			ret = btrfs_end_transaction(trans);
 			trans = NULL;
 			if (ret)
 				break;
@@ -4139,7 +4139,7 @@ skip:
 out:
 	btrfs_free_path(path);
 	if (trans && !IS_ERR(trans))
-		btrfs_end_transaction(trans, fs_info->uuid_root);
+		btrfs_end_transaction(trans);
 	if (ret)
 		btrfs_warn(fs_info, "btrfs_uuid_scan_kthread failed %d", ret);
 	else
@@ -4233,7 +4233,7 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 	if (IS_ERR(uuid_root)) {
 		ret = PTR_ERR(uuid_root);
 		btrfs_abort_transaction(trans, ret);
-		btrfs_end_transaction(trans, tree_root);
+		btrfs_end_transaction(trans);
 		return ret;
 	}
 
@@ -4429,7 +4429,7 @@ again:
 
 	/* Now btrfs_update_device() will change the on-disk size. */
 	ret = btrfs_update_device(trans, device);
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 done:
 	btrfs_free_path(path);
 	if (ret) {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 8ee6e19..7a8ddfe 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -259,7 +259,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
 out:
-	btrfs_end_transaction(trans, root);
+	btrfs_end_transaction(trans);
 	return ret;
 }
 
-- 
2.7.1

