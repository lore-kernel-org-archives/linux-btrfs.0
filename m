From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/4] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Thu, 26 Apr 2012 13:44:56 +0200
Message-ID: <20120426114456.GN20982@twin.jikos.cz>
References: <4F98B9BC.7010905@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>, miaox@cn.fujitsu.com,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>
To: Miao Xie <miaoxie1984@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F98B9BC.7010905@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 10:58:04AM +0800, Miao Xie wrote:
> The reason the deadlock is that:
>   Task					Btrfs-cleaner
>   umount()
>     down_write(&s->s_umount)
>     sync_filesystem()
> 					do auto-defragment and produce
> 					lots of dirty pages
>     close_ctree()
>       wait for the end of
>       btrfs-cleaner

why it's needed to wait for cleaner during close_ctree? I got bitten
yesterday by (a non-deadlock) scenario, when there were tons of deleted
snapshots, filesystem almost full, so getting and managing free space
was slow (btrfs-cache thread was more active than btrfs-cleaner), and
umount just did not end. interruptible by reboot only.

avoiding this particular case of waiting for cleaner:

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3064,7 +3066,13 @@ int btrfs_commit_super(struct btrfs_root *root)

        mutex_lock(&root->fs_info->cleaner_mutex);
        btrfs_run_delayed_iputs(root);
-       btrfs_clean_old_snapshots(root);
+       if (!btrfs_fs_closing(root->fs_info)) {
+               /* btrfs_clean_old_snapshots(root); */
+               wake_up_process(root->fs_info->cleaner_kthread);
+               printk(KERN_DEBUG "btrfs: wake cleaner from commit_super\n");
+       } else {
+               printk(KERN_DEBUG "btrfs: skip cleaning when going down\n");
+       }
        mutex_unlock(&root->fs_info->cleaner_mutex);

        /* wait until ongoing cleanup work done */


plus not even trying to call the cleaner directly, rather waking the cleaner
thread. (attached whole work-in-progress patch).

david
---

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 58a232d..0651f6f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1617,13 +1617,14 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 
 	do {
+		int again = 0;
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
 
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 			down_read_trylock(&root->fs_info->sb->s_umount) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
 			btrfs_run_delayed_iputs(root);
-			btrfs_clean_old_snapshots(root);
+			again = btrfs_clean_one_old_snapshot(root);
 			mutex_unlock(&root->fs_info->cleaner_mutex);
 			btrfs_run_defrag_inodes(root->fs_info);
 			up_read(&root->fs_info->sb->s_umount);
@@ -1631,7 +1632,7 @@ static int cleaner_kthread(void *arg)
 
 		if (freezing(current)) {
 			refrigerator();
-		} else {
+		} else if (!again) {//FIXME: check again now directly from dead_roots?
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop())
 				schedule();
@@ -3064,7 +3066,13 @@ int btrfs_commit_super(struct btrfs_root *root)
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_run_delayed_iputs(root);
-	btrfs_clean_old_snapshots(root);
+	if (!btrfs_fs_closing(root->fs_info)) {
+		/* btrfs_clean_old_snapshots(root); */
+		wake_up_process(root->fs_info->cleaner_kthread);
+		printk(KERN_DEBUG "btrfs: wake cleaner from commit_super\n");
+	} else {
+		printk(KERN_DEBUG "btrfs: skip cleaning when going down\n");
+	}
 	mutex_unlock(&root->fs_info->cleaner_mutex);
 
 	/* wait until ongoing cleanup work done */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ec1e0c6..3aba911 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6995,6 +6995,11 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
+		if (btrfs_fs_closing(root->fs_info)) {
+			printk(KERN_DEBUG "btrfs: drop early exit\n");
+			err = -EAGAIN;
+			goto out_end_trans;
+		}
 		ret = walk_down_tree(trans, root, path, wc);
 		if (ret < 0) {
 			err = ret;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 922e6ec..c9dc857 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4060,6 +4060,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	while (1) {
 		mutex_lock(&fs_info->cleaner_mutex);
 
+		// FIXME: wake cleaner
 		btrfs_clean_old_snapshots(fs_info->tree_root);
 		ret = relocate_block_group(rc);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index de2942f..3d83f6b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -783,7 +783,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 int btrfs_add_dead_root(struct btrfs_root *root)
 {
 	spin_lock(&root->fs_info->trans_lock);
-	list_add(&root->root_list, &root->fs_info->dead_roots);
+	list_add_tail(&root->root_list, &root->fs_info->dead_roots);
 	spin_unlock(&root->fs_info->trans_lock);
 	return 0;
 }
@@ -1533,7 +1533,45 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 			ret = btrfs_drop_snapshot(root, NULL, 0, 0);
 		else
 			ret =btrfs_drop_snapshot(root, NULL, 1, 0);
-		BUG_ON(ret < 0);
+		BUG_ON(ret < 0 && ret != -EAGAIN);
 	}
 	return 0;
 }
+/*
+ * return < 0 if error
+ * 0 if there are no more dead_roots at the time of call
+ * 1 there are more to be processed, call me again
+ *
+ * (racy)
+ */
+int btrfs_clean_one_old_snapshot(struct btrfs_root *root)
+{
+	int ret;
+	int run_again = 1;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	if (root->fs_info->sb->s_flags & MS_RDONLY) {
+		printk(KERN_WARNING "btrfs: cleaner called for RO fs!\n");
+	}
+
+	spin_lock(&fs_info->trans_lock);
+	root = list_first_entry(&fs_info->dead_roots,
+			struct btrfs_root, root_list);
+	list_del(&root->root_list);
+	if (list_empty(&fs_info->dead_roots))
+		run_again = 0;
+	spin_unlock(&fs_info->trans_lock);
+
+	printk(KERN_DEBUG "btrfs: cleaner removing %llu\n",
+			(unsigned long long)root->objectid);
+
+	btrfs_kill_all_delayed_nodes(root);
+
+	if (btrfs_header_backref_rev(root->node) <
+			BTRFS_MIXED_BACKREF_REV)
+		ret = btrfs_drop_snapshot(root, NULL, 0, 0);
+	else
+		ret = btrfs_drop_snapshot(root, NULL, 1, 0);
+	BUG_ON(ret < 0 && ret != -EAGAIN);
+	return run_again || ret == -EAGAIN;
+}
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index fe27379..7071ca5 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -94,6 +94,7 @@ int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 int btrfs_add_dead_root(struct btrfs_root *root);
 int btrfs_defrag_root(struct btrfs_root *root, int cacheonly);
 int btrfs_clean_old_snapshots(struct btrfs_root *root);
+int btrfs_clean_one_old_snapshot(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
---
