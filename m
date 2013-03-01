Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3CAQRz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Mar 2013 11:17:55 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: clean snapshots one by one
Date: Fri,  1 Mar 2013 17:17:34 +0100
Message-Id: <1362154654-17655-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
References: <CAOcd+r152Ot9RYjGfCc_sW46BNKuKrhEN=xR_hw_9QKSu5Agpw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Each time pick one dead root from the list and let the caller know if
it's needed to continue. This should improve responsiveness during
umount and balance which at some point wait for cleaning all currently
queued dead roots.

A new dead root is added to the end of the list, so the snapshots
disappear in the order of deletion.

Process snapshot cleaning is now done only from the cleaner thread and
the others wake it if needed.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

v1->v2:
- added s_umount trylock in cleaner thread
- added exit into drop_snapshot if fs is going down

patch based on cmason/integration

 fs/btrfs/disk-io.c     |   10 ++++++--
 fs/btrfs/extent-tree.c |    8 ++++++
 fs/btrfs/relocation.c  |    3 --
 fs/btrfs/transaction.c |   57 ++++++++++++++++++++++++++++++++----------------
 fs/btrfs/transaction.h |    2 +-
 5 files changed, 54 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index eb7c143..cc85fc7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1652,15 +1652,19 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 
 	do {
+		int again = 0;
+
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
+		    down_read_trylock(&root->fs_info->sb->s_umount) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
 			btrfs_run_delayed_iputs(root);
-			btrfs_clean_old_snapshots(root);
+			again = btrfs_clean_one_deleted_snapshot(root);
 			mutex_unlock(&root->fs_info->cleaner_mutex);
 			btrfs_run_defrag_inodes(root->fs_info);
+			up_read(&root->fs_info->sb->s_umount);
 		}
 
-		if (!try_to_freeze()) {
+		if (!try_to_freeze() && !again) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop())
 				schedule();
@@ -3338,8 +3342,8 @@ int btrfs_commit_super(struct btrfs_root *root)
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(root);
-	btrfs_clean_old_snapshots(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
+	wake_up_process(root->fs_info->cleaner_kthread);
 
 	/* wait until ongoing cleanup work done */
 	down_write(&root->fs_info->cleanup_work_sem);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d2b3a5e..0119ae7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7078,6 +7078,8 @@ static noinline int walk_up_tree(struct btrfs_trans_handle *trans,
  * reference count by one. if update_ref is true, this function
  * also make sure backrefs for the shared block and all lower level
  * blocks are properly updated.
+ *
+ * If called with for_reloc == 0, may exit early with -EAGAIN
  */
 int btrfs_drop_snapshot(struct btrfs_root *root,
 			 struct btrfs_block_rsv *block_rsv, int update_ref,
@@ -7179,6 +7181,12 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
+		if (!for_reloc && btrfs_fs_closing(root->fs_info)) {
+			pr_debug("btrfs: drop snapshot early exit\n");
+			err = -EAGAIN;
+			goto out_end_trans;
+		}
+
 		ret = walk_down_tree(trans, root, path, wc);
 		if (ret < 0) {
 			err = ret;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ba5a321..ab6a718 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4060,10 +4060,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 
 	while (1) {
 		mutex_lock(&fs_info->cleaner_mutex);
-
-		btrfs_clean_old_snapshots(fs_info->tree_root);
 		ret = relocate_block_group(rc);
-
 		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret < 0) {
 			err = ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a83d486..6b233c15 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -950,7 +950,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 int btrfs_add_dead_root(struct btrfs_root *root)
 {
 	spin_lock(&root->fs_info->trans_lock);
-	list_add(&root->root_list, &root->fs_info->dead_roots);
+	list_add_tail(&root->root_list, &root->fs_info->dead_roots);
 	spin_unlock(&root->fs_info->trans_lock);
 	return 0;
 }
@@ -1858,31 +1858,50 @@ cleanup_transaction:
 }
 
 /*
- * interface function to delete all the snapshots we have scheduled for deletion
+ * return < 0 if error
+ * 0 if there are no more dead_roots at the time of call
+ * 1 there are more to be processed, call me again
+ *
+ * The return value indicates there are certainly more snapshots to delete, but
+ * if there comes a new one during processing, it may return 0. We don't mind,
+ * because btrfs_commit_super will poke cleaner thread and it will process it a
+ * few seconds later.
  */
-int btrfs_clean_old_snapshots(struct btrfs_root *root)
+int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root)
 {
-	LIST_HEAD(list);
+	int ret;
+	int run_again = 1;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
+	if (root->fs_info->sb->s_flags & MS_RDONLY) {
+		pr_debug("btrfs: cleaner called for RO fs!\n");
+		return 0;
+	}
+
 	spin_lock(&fs_info->trans_lock);
-	list_splice_init(&fs_info->dead_roots, &list);
+	if (list_empty(&fs_info->dead_roots)) {
+		spin_unlock(&fs_info->trans_lock);
+		return 0;
+	}
+	root = list_first_entry(&fs_info->dead_roots,
+			struct btrfs_root, root_list);
+	list_del(&root->root_list);
 	spin_unlock(&fs_info->trans_lock);
 
-	while (!list_empty(&list)) {
-		int ret;
-
-		root = list_entry(list.next, struct btrfs_root, root_list);
-		list_del(&root->root_list);
+	pr_debug("btrfs: cleaner removing %llu\n",
+			(unsigned long long)root->objectid);
 
-		btrfs_kill_all_delayed_nodes(root);
+	btrfs_kill_all_delayed_nodes(root);
 
-		if (btrfs_header_backref_rev(root->node) <
-		    BTRFS_MIXED_BACKREF_REV)
-			ret = btrfs_drop_snapshot(root, NULL, 0, 0);
-		else
-			ret =btrfs_drop_snapshot(root, NULL, 1, 0);
-		BUG_ON(ret < 0);
-	}
-	return 0;
+	if (btrfs_header_backref_rev(root->node) <
+			BTRFS_MIXED_BACKREF_REV)
+		ret = btrfs_drop_snapshot(root, NULL, 0, 0);
+	else
+		ret = btrfs_drop_snapshot(root, NULL, 1, 0);
+	/*
+	 * If we encounter a transaction abort during snapshot cleaning, we
+	 * don't want to crash here
+	 */
+	BUG_ON(ret < 0 && (ret != -EAGAIN || ret != -EROFS));
+	return run_again || ret == -EAGAIN;
 }
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5afd7b1..52f6f25 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -121,7 +121,7 @@ int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 
 int btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root);
-int btrfs_clean_old_snapshots(struct btrfs_root *root);
+int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
-- 
1.7.9

