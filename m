From: Jan Kara <jack@suse.cz>
Subject: [PATCH 17/19] btrfs: Convert to new freezing mechanism
Date: Thu, 29 Mar 2012 01:43:32 +0200
Message-ID: <1332978214-15535-18-git-send-email-jack@suse.cz>
References: <1332978214-15535-1-git-send-email-jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, dchinner@redhat.com,
	sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
	Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332978214-15535-1-git-send-email-jack@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

We convert btrfs_file_aio_write() to use new freeze check.  We also add proper
freeze protection to btrfs_page_mkwrite(). Checks in cleaner_kthread() and
transaction_kthread() can be safely removed since btrfs_freeze() will lock
the mutexes and thus block the threads (and they shouldn't have anything to
do anyway).

CC: linux-btrfs@vger.kernel.org
CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/disk-io.c |    3 ---
 fs/btrfs/file.c    |    3 ++-
 fs/btrfs/inode.c   |    6 +++++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 811d9f9..fc0f74c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1586,8 +1586,6 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 
 	do {
-		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
-
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
 			btrfs_run_delayed_iputs(root);
@@ -1618,7 +1616,6 @@ static int transaction_kthread(void *arg)
 
 	do {
 		delay = HZ * 30;
-		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
 		spin_lock(&root->fs_info->trans_lock);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 859ba2d..1aac7ca 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1348,7 +1348,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	ssize_t err = 0;
 	size_t count, ocount;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb);
 
 	mutex_lock(&inode->i_mutex);
 
@@ -1439,6 +1439,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 			num_written = err;
 	}
 out:
+	sb_end_write(inode->i_sb);
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32214fe..63c9006 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6405,6 +6405,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 page_start;
 	u64 page_end;
 
+	sb_start_pagefault(inode->i_sb);
 	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
 	if (!ret) {
 		ret = btrfs_update_time(vma->vm_file);
@@ -6495,12 +6496,15 @@ again:
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
 
-- 
1.7.1

