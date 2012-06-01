Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965845Ab2FAWbh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jun 2012 18:31:37 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com,
        Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 24/27] btrfs: Convert to new freezing mechanism
Date: Sat,  2 Jun 2012 00:30:38 +0200
Message-Id: <1338589841-9568-25-git-send-email-jack@suse.cz>
In-Reply-To: <1338589841-9568-1-git-send-email-jack@suse.cz>
References: <1338589841-9568-1-git-send-email-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We convert btrfs_file_aio_write() to use new freeze check.  We also add proper
freeze protection to btrfs_page_mkwrite(). We also add freeze protection to
the transaction mechanism to avoid starting transactions on frozen filesystem.
At minimum this is necessary to stop iput() of unlinked file to change frozen
filesystem during truncation.

Checks in cleaner_kthread() and transaction_kthread() can be safely removed
since btrfs_freeze() will lock the mutexes and thus block the threads (and they
shouldn't have anything to do anyway).

CC: linux-btrfs@vger.kernel.org
CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/disk-io.c     |    3 ---
 fs/btrfs/file.c        |    3 ++-
 fs/btrfs/inode.c       |    6 +++++-
 fs/btrfs/transaction.c |    7 +++++++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7ae51de..663f3a0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1532,8 +1532,6 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 
 	do {
-		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
-
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
 			btrfs_run_delayed_iputs(root);
@@ -1565,7 +1563,6 @@ static int transaction_kthread(void *arg)
 	do {
 		cannot_commit = false;
 		delay = HZ * 30;
-		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
 		spin_lock(&root->fs_info->trans_lock);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 876cddd..7f3d7fe 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1392,7 +1392,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	ssize_t err = 0;
 	size_t count, ocount;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb);
 
 	mutex_lock(&inode->i_mutex);
 
@@ -1482,6 +1482,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 			num_written = err;
 	}
 out:
+	sb_end_write(inode->i_sb);
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e9991ad..54e5378 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6563,6 +6563,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 page_start;
 	u64 page_end;
 
+	sb_start_pagefault(inode->i_sb);
 	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (!ret) {
 		ret = btrfs_update_time(vma->vm_file);
@@ -6652,12 +6653,15 @@ again:
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state, GFP_NOFS);
 
 out_unlock:
-	if (!ret)
+	if (!ret) {
+		sb_end_pagefault(inode->i_sb);
 		return VM_FAULT_LOCKED;
+	}
 	unlock_page(page);
 out:
 	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
 out_noreserve:
+	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1791c6e..05d8c29 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -325,6 +325,8 @@ again:
 	if (!h)
 		return ERR_PTR(-ENOMEM);
 
+	sb_start_intwrite(root->fs_info->sb);
+
 	if (may_wait_transaction(root, type))
 		wait_current_trans(root);
 
@@ -335,6 +337,7 @@ again:
 	} while (ret == -EBUSY);
 
 	if (ret < 0) {
+		sb_end_intwrite(root->fs_info->sb);
 		kmem_cache_free(btrfs_trans_handle_cachep, h);
 		return ERR_PTR(ret);
 	}
@@ -524,6 +527,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		count++;
 	}
 
+	sb_end_intwrite(root->fs_info->sb);
+
 	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
 	    should_end_transaction(trans, root)) {
 		trans->transaction->blocked = 1;
@@ -1507,6 +1512,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	put_transaction(cur_trans);
 	put_transaction(cur_trans);
 
+	sb_end_intwrite(root->fs_info->sb);
+
 	trace_btrfs_transaction_commit(root);
 
 	btrfs_scrub_continue(root);
-- 
1.7.1

