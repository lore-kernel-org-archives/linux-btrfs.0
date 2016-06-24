Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbcFXWPc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8E61AADE9
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 30/31] btrfs: root->fs_info cleanup, btrfs_commit_transaction already has root
Date: Fri, 24 Jun 2016 18:15:23 -0400
Message-Id: <1466806524-27508-31-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_commit_transaction is always called using the root that was used
to create the transaction handle.  Passing it separately is unnecessary.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/dev-replace.c     | 10 +++++-----
 fs/btrfs/disk-io.c         |  6 +++---
 fs/btrfs/extent-tree.c     |  4 ++--
 fs/btrfs/file.c            |  2 +-
 fs/btrfs/free-space-tree.c |  4 ++--
 fs/btrfs/inode.c           |  4 ++--
 fs/btrfs/ioctl.c           | 23 +++++++++++------------
 fs/btrfs/qgroup.c          |  4 ++--
 fs/btrfs/relocation.c      | 10 +++++-----
 fs/btrfs/scrub.c           |  3 +--
 fs/btrfs/send.c            |  2 +-
 fs/btrfs/super.c           |  4 ++--
 fs/btrfs/transaction.c     | 10 +++++-----
 fs/btrfs/transaction.h     |  3 +--
 fs/btrfs/tree-log.c        |  2 +-
 fs/btrfs/volumes.c         | 14 +++++++-------
 16 files changed, 51 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 3eb0017..57dee36 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -333,7 +333,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info, char *tgtdev_name,
 	 */
 	trans = btrfs_attach_transaction(root);
 	if (!IS_ERR(trans)) {
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans);
 		if (ret)
 			return ret;
 	} else if (PTR_ERR(trans) != -ENOENT) {
@@ -395,7 +395,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info, char *tgtdev_name,
 		goto leave;
 	}
 
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans);
 	WARN_ON(ret);
 
 	/* the disk copy procedure reuses the scrub code */
@@ -511,7 +511,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return PTR_ERR(trans);
 	}
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans);
 	WARN_ON(ret);
 
 	mutex_lock(&uuid_mutex);
@@ -601,7 +601,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	/* write back the superblocks */
 	trans = btrfs_start_transaction(root, 0);
 	if (!IS_ERR(trans))
-		btrfs_commit_transaction(trans, root);
+		btrfs_commit_transaction(trans);
 
 	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
@@ -716,7 +716,7 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return PTR_ERR(trans);
 	}
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans);
 	WARN_ON(ret);
 	if (tgt_device)
 		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f60be47..153e03e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1874,7 +1874,7 @@ sleep:
 	} else {
 		int ret;
 
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans);
 		if (ret)
 			btrfs_err(fs_info,
 				  "cleaner open transaction commit returned %d",
@@ -1926,7 +1926,7 @@ static int transaction_kthread(void *arg)
 			goto sleep;
 		}
 		if (transid == trans->transid) {
-			btrfs_commit_transaction(trans, root);
+			btrfs_commit_transaction(trans);
 		} else {
 			btrfs_end_transaction(trans, root);
 		}
@@ -3848,7 +3848,7 @@ int btrfs_commit_super(struct btrfs_fs_info *fs_info)
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	return btrfs_commit_transaction(trans, root);
+	return btrfs_commit_transaction(trans);
 }
 
 void close_ctree(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 778ef17..31478eb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4204,7 +4204,7 @@ commit_trans:
 			    test_bit(BTRFS_TRANS_HAVE_FREE_BGS,
 				     &trans->transaction->flags) ||
 			    need_commit > 0) {
-				ret = btrfs_commit_transaction(trans, root);
+				ret = btrfs_commit_transaction(trans);
 				if (ret)
 					return ret;
 				/*
@@ -4785,7 +4785,7 @@ commit:
 	if (IS_ERR(trans))
 		return -ENOSPC;
 
-	return btrfs_commit_transaction(trans, root);
+	return btrfs_commit_transaction(trans);
 }
 
 enum flush_state {
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 51f77a2..5fa030f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2129,7 +2129,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 				goto out;
 			}
 		}
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans);
 	} else {
 		ret = btrfs_end_transaction(trans, root);
 	}
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 58daa0e..671865b 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1187,7 +1187,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
 	fs_info->creating_free_space_tree = 0;
 
-	ret = btrfs_commit_transaction(trans, tree_root);
+	ret = btrfs_commit_transaction(trans);
 	if (ret)
 		return ret;
 
@@ -1275,7 +1275,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	free_extent_buffer(free_space_root->commit_root);
 	kfree(free_space_root);
 
-	ret = btrfs_commit_transaction(trans, tree_root);
+	ret = btrfs_commit_transaction(trans);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 37ef685..4600e93 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5296,7 +5296,7 @@ void btrfs_evict_inode(struct inode *inode)
 		 * again.
 		 */
 		if (ret) {
-			ret = btrfs_commit_transaction(trans, root);
+			ret = btrfs_commit_transaction(trans);
 			if (ret) {
 				btrfs_orphan_del(NULL, inode);
 				btrfs_free_block_rsv(fs_info, rsv);
@@ -5972,7 +5972,7 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans);
 	}
 	return ret;
 }
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 50fc151..04e8061 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -623,9 +623,9 @@ fail:
 		*async_transid = trans->transid;
 		err = btrfs_commit_transaction_async(trans, root, 1);
 		if (err)
-			err = btrfs_commit_transaction(trans, root);
+			err = btrfs_commit_transaction(trans);
 	} else {
-		err = btrfs_commit_transaction(trans, root);
+		err = btrfs_commit_transaction(trans);
 	}
 	if (err && !ret)
 		ret = err;
@@ -732,12 +732,11 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 	if (async_transid) {
 		*async_transid = trans->transid;
 		ret = btrfs_commit_transaction_async(trans,
-				     fs_info->extent_root, 1);
+						     fs_info->extent_root, 1);
 		if (ret)
-			ret = btrfs_commit_transaction(trans, root);
+			ret = btrfs_commit_transaction(trans);
 	} else {
-		ret = btrfs_commit_transaction(trans,
-					       fs_info->extent_root);
+		ret = btrfs_commit_transaction(trans);
 	}
 	if (ret)
 		goto fail;
@@ -1619,7 +1618,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			goto out_free;
 		}
 		ret = btrfs_grow_device(trans, device, new_size);
-		btrfs_commit_transaction(trans, root);
+		btrfs_commit_transaction(trans);
 	} else if (new_size < old_size) {
 		ret = btrfs_shrink_device(device, new_size);
 	} /* equal, nothing need to do */
@@ -1868,7 +1867,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	ret = btrfs_update_root(trans, fs_info->tree_root,
 				&root->root_key, &root->root_item);
 
-	btrfs_commit_transaction(trans, root);
+	btrfs_commit_transaction(trans);
 out_reset:
 	if (ret)
 		btrfs_set_root_flags(&root->root_item, root_flags);
@@ -4875,7 +4874,7 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		break;
 	}
 
-	err = btrfs_commit_transaction(trans, fs_info->tree_root);
+	err = btrfs_commit_transaction(trans);
 	if (err && !ret)
 		ret = err;
 out:
@@ -5189,7 +5188,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 			goto out;
 		}
 	}
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans);
 	if (ret < 0) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
@@ -5343,7 +5342,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
 	spin_lock(&fs_info->super_lock);
 	strcpy(super_block->label, label);
 	spin_unlock(&fs_info->super_lock);
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans);
 
 out_unlock:
 	mnt_drop_write_file(file);
@@ -5515,7 +5514,7 @@ static int btrfs_ioctl_set_features(struct file *file, void __user *arg)
 	btrfs_set_super_incompat_flags(super_block, newflags);
 	spin_unlock(&fs_info->super_lock);
 
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans);
 out_drop_write:
 	mnt_drop_write_file(file);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6d45fb4..b00c2ea 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2319,7 +2319,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			err = qgroup_rescan_leaf(fs_info, path, trans);
 		}
 		if (err > 0)
-			btrfs_commit_transaction(trans, fs_info->fs_root);
+			btrfs_commit_transaction(trans);
 		else
 			btrfs_end_transaction(trans, fs_info->fs_root);
 	}
@@ -2472,7 +2472,7 @@ btrfs_qgroup_rescan(struct btrfs_fs_info *fs_info)
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 		return PTR_ERR(trans);
 	}
-	ret = btrfs_commit_transaction(trans, fs_info->fs_root);
+	ret = btrfs_commit_transaction(trans);
 	if (ret) {
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_RESCAN;
 		return ret;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a2ca2f0..d64a805 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2342,7 +2342,7 @@ again:
 	list_splice(&reloc_roots, &rc->reloc_roots);
 
 	if (!err)
-		btrfs_commit_transaction(trans, rc->extent_root);
+		btrfs_commit_transaction(trans);
 	else
 		btrfs_end_transaction(trans, rc->extent_root);
 	return err;
@@ -3917,7 +3917,7 @@ int prepare_to_relocate(struct reloc_control *rc)
 		 */
 		return PTR_ERR(trans);
 	}
-	btrfs_commit_transaction(trans, rc->extent_root);
+	btrfs_commit_transaction(trans);
 	return 0;
 }
 
@@ -4111,7 +4111,7 @@ restart:
 	if (IS_ERR(trans))
 		err = PTR_ERR(trans);
 	else
-		btrfs_commit_transaction(trans, rc->extent_root);
+		btrfs_commit_transaction(trans);
 out_free:
 	btrfs_free_block_rsv(fs_info, rc->block_rsv);
 	btrfs_free_path(path);
@@ -4465,7 +4465,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 		fs_root->reloc_root = reloc_root;
 	}
 
-	err = btrfs_commit_transaction(trans, rc->extent_root);
+	err = btrfs_commit_transaction(trans);
 	if (err)
 		goto out_free;
 
@@ -4477,7 +4477,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 	if (IS_ERR(trans))
 		err = PTR_ERR(trans);
 	else
-		err = btrfs_commit_transaction(trans, rc->extent_root);
+		err = btrfs_commit_transaction(trans);
 out_free:
 	kfree(rc);
 out:
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 5b0fcc9..c98b91b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3612,8 +3612,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 				if (IS_ERR(trans))
 					ret = PTR_ERR(trans);
 				else
-					ret = btrfs_commit_transaction(trans,
-								       root);
+					ret = btrfs_commit_transaction(trans);
 				if (ret) {
 					scrub_pause_off(fs_info);
 					btrfs_put_block_group(cache);
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5f4f853..cd0a052 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5911,7 +5911,7 @@ commit_trans:
 		goto again;
 	}
 
-	return btrfs_commit_transaction(trans, sctx->send_root);
+	return btrfs_commit_transaction(trans);
 }
 
 static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3a160e1..d407826 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1188,7 +1188,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 	}
-	return btrfs_commit_transaction(trans, root);
+	return btrfs_commit_transaction(trans);
 }
 
 static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
@@ -2228,7 +2228,7 @@ static int btrfs_freeze(struct super_block *sb)
 			return 0;
 		return PTR_ERR(trans);
 	}
-	return btrfs_commit_transaction(trans, root);
+	return btrfs_commit_transaction(trans);
 }
 
 static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 57d3187..a546c08 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -580,7 +580,7 @@ again:
 	if (cur_trans->state >= TRANS_STATE_BLOCKED &&
 	    may_wait_transaction(fs_info, type)) {
 		current->journal_info = h;
-		btrfs_commit_transaction(h, root);
+		btrfs_commit_transaction(h);
 		goto again;
 	}
 
@@ -877,7 +877,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	if (lock && ACCESS_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
 		if (throttle)
-			return btrfs_commit_transaction(trans, root);
+			return btrfs_commit_transaction(trans);
 		else
 			wake_up_process(info->transaction_kthread);
 	}
@@ -1798,7 +1798,7 @@ static void do_async_commit(struct work_struct *work)
 
 	current->journal_info = ac->newtrans;
 
-	btrfs_commit_transaction(ac->newtrans, ac->root);
+	btrfs_commit_transaction(ac->newtrans);
 	kfree(ac);
 }
 
@@ -1924,9 +1924,9 @@ btrfs_wait_pending_ordered(struct btrfs_transaction *cur_trans)
 		   atomic_read(&cur_trans->pending_ordered) == 0);
 }
 
-int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root)
+int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_root *root = trans->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 8bcf529..7d3b358 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -206,8 +206,7 @@ int btrfs_wait_for_commit(struct btrfs_fs_info *fs_info, u64 transid);
 void btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root);
 int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root);
-int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root);
+int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   int wait_for_unblock);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 945f02c..e714eb5 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5614,7 +5614,7 @@ again:
 	btrfs_free_path(path);
 
 	/* step 4: commit the transaction, which also unpins the blocks */
-	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+	ret = btrfs_commit_transaction(trans);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fadb37f..5953948 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1717,7 +1717,7 @@ static int btrfs_rm_dev_item(struct btrfs_fs_info *fs_info,
 		goto out;
 out:
 	btrfs_free_path(path);
-	btrfs_commit_transaction(trans, root);
+	btrfs_commit_transaction(trans);
 	return ret;
 }
 
@@ -2428,7 +2428,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 
 	fs_info->num_tolerated_disk_barrier_failures =
 		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
-	ret = btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans);
 
 	if (seeding_dev) {
 		mutex_unlock(&uuid_mutex);
@@ -2449,7 +2449,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 				return 0;
 			return PTR_ERR(trans);
 		}
-		ret = btrfs_commit_transaction(trans, root);
+		ret = btrfs_commit_transaction(trans);
 	}
 
 	/* Update ctime/mtime for libblkid */
@@ -3020,7 +3020,7 @@ static int insert_balance_item(struct btrfs_fs_info *fs_info,
 	btrfs_mark_buffer_dirty(leaf);
 out:
 	btrfs_free_path(path);
-	err = btrfs_commit_transaction(trans, root);
+	err = btrfs_commit_transaction(trans);
 	if (err && !ret)
 		ret = err;
 	return ret;
@@ -3059,7 +3059,7 @@ static int del_balance_item(struct btrfs_fs_info *fs_info)
 	ret = btrfs_del_item(trans, root, path);
 out:
 	btrfs_free_path(path);
-	err = btrfs_commit_transaction(trans, root);
+	err = btrfs_commit_transaction(trans);
 	if (err && !ret)
 		ret = err;
 	return ret;
@@ -4239,7 +4239,7 @@ int btrfs_create_uuid_tree(struct btrfs_fs_info *fs_info)
 
 	fs_info->uuid_root = uuid_root;
 
-	ret = btrfs_commit_transaction(trans, tree_root);
+	ret = btrfs_commit_transaction(trans);
 	if (ret)
 		return ret;
 
@@ -4411,7 +4411,7 @@ again:
 			checked_pending_chunks = true;
 			failed = 0;
 			retried = false;
-			ret = btrfs_commit_transaction(trans, root);
+			ret = btrfs_commit_transaction(trans);
 			if (ret)
 				goto done;
 			goto again;
-- 
2.7.1

