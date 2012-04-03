From: David Sterba <dsterba@suse.cz>
Subject: Re: btrfs io errors on 3.4rc1
Date: Tue, 3 Apr 2012 16:26:07 +0200
Message-ID: <20120403142607.GA14083@ds.suse.cz>
References: <20120402194814.GA10965@shiny.msi.event>
 <20120402211622.GA2487@redhat.com>
 <20120402212608.GA14958@shiny.msi.event>
 <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120403014722.GA618@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2012 at 09:47:22PM -0400, Dave Jones wrote:
> 49b25e0540904be0bf558b84475c69d72e4de66e is the first bad commit
>     btrfs: enhance transaction abort infrastructure

Attached patch adds several debugging printks to help to track down
where the EIOs come from. As there are no messages in syslog, it happens
on a regular path and not after a transaction abort.

I was not able to trigger the problem with either fsx or full xfstests
suite (3.4-rc).

Patch is based on top of the bisected commit, please retest, thanks.


david

---------8<--------
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0517bd7..161baa4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -216,12 +216,12 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, const char *function,
 			       unsigned int line, int errno)
 {
-	WARN_ON_ONCE(1);
+	WARN_ON(1);
 	trans->aborted = errno;
 	/* Nothing used. The other threads that have joined this
 	 * transaction may be able to continue. */
 	if (!trans->blocks_used) {
-		btrfs_printk(root->fs_info, "Aborting unused transaction.\n");
+		btrfs_printk(root->fs_info, "Aborting unused transaction (errno=%d).\n", errno);
 		return;
 	}
 	trans->transaction->aborted = errno;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 5a4999a..b7ae8e2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -73,8 +73,10 @@ loop:
 
 	cur_trans = root->fs_info->running_transaction;
 	if (cur_trans) {
-		if (cur_trans->aborted)
+		if (cur_trans->aborted) {
+			spin_unlock(&root->fs_info->trans_lock);
 			return cur_trans->aborted;
+		}
 		atomic_inc(&cur_trans->use_count);
 		atomic_inc(&cur_trans->num_writers);
 		cur_trans->num_joined++;
@@ -466,8 +468,10 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 	trans->delayed_ref_updates = 0;
 	if (updates) {
 		err = btrfs_run_delayed_refs(trans, root, updates);
-		if (err) /* Error code will also eval true */
+		if (err) { /* Error code will also eval true */
+			printk(KERN_DEBUG "btrfs: %s %d from btrfs_run_delayed_refs\n", __func__, err);
 			return err;
+		}
 	}
 
 	trans->block_rsv = rsv;
@@ -491,11 +495,14 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	trans->block_rsv = NULL;
 	while (count < 2) {
 		unsigned long cur = trans->delayed_ref_updates;
+		int ret;
+
 		trans->delayed_ref_updates = 0;
 		if (cur &&
 		    trans->transaction->delayed_refs.num_heads_ready > 64) {
 			trans->delayed_ref_updates = 0;
-			btrfs_run_delayed_refs(trans, root, cur);
+			ret = btrfs_run_delayed_refs(trans, root, cur);
+			if (ret) printk(KERN_DEBUG "btrfs: %s %d from btrfs_run_delayed_refs\n", __func__, ret);
 		} else {
 			break;
 		}
@@ -541,6 +548,10 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	if (trans->aborted ||
 	    root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		printk(KERN_DEBUG "btrfs: %s -EIO abored=%d (%s)\n", __func__,
+			trans->aborted,
+			(root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) ?
+				"super error" : "no super error");
 		return -EIO;
 	}
 
@@ -740,8 +751,10 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	int ret;
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	if (ret)
+	if (ret) {
+		printk(KERN_DEBUG "btrfs: %s %d from btrfs_run_delayed_refs\n", __func__, ret);
 		return ret;
+	}
 
 	eb = btrfs_lock_root_node(fs_info->tree_root);
 	ret = btrfs_cow_block(trans, fs_info->tree_root, eb, NULL,
@@ -749,12 +762,16 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	btrfs_tree_unlock(eb);
 	free_extent_buffer(eb);
 
-	if (ret)
+	if (ret) {
+		printk(KERN_DEBUG "btrfs: %s %d from btrfs_cow_block\n", __func__, ret);
 		return ret;
+	}
 
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	if (ret)
+	if (ret) {
+		printk(KERN_DEBUG "btrfs: %s %d from btrfs_run_delayed_refs\n", __func__, ret);
 		return ret;
+	}
 
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
@@ -762,8 +779,10 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 		root = list_entry(next, struct btrfs_root, dirty_list);
 
 		ret = update_cowonly_root(trans, root);
-		if (ret)
+		if (ret) {
+			printk(KERN_DEBUG "btrfs: %s %d from update_cowonly_root\n", __func__, ret);
 			return ret;
+		}
 	}
 
 	down_write(&fs_info->extent_commit_sem);
@@ -1234,8 +1253,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 * any runnings procs may add more while we are here
 	 */
 	ret = btrfs_run_delayed_refs(trans, root, 0);
-	if (ret)
+	if (ret) {
+		printk(KERN_DEBUG "btrfs: %s %d from btrfs_run_delayed_refs\n", __func__, ret);
 		goto cleanup_transaction;
+	}
 
 	cur_trans = trans->transaction;
 
@@ -1246,8 +1267,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	cur_trans->delayed_refs.flushing = 1;
 
 	ret = btrfs_run_delayed_refs(trans, root, 0);
-	if (ret)
+	if (ret) {
+		printk(KERN_DEBUG "btrfs: %s %d from btrfs_run_delayed_refs\n", __func__, ret);
 		goto cleanup_transaction;
+	}
 
 	spin_lock(&cur_trans->commit_lock);
 	if (cur_trans->in_commit) {
@@ -1360,6 +1383,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
 	if (ret) {
 		mutex_unlock(&root->fs_info->reloc_mutex);
+		printk(KERN_DEBUG "btrfs: %s %d from btrfs_run_delayed_refs\n", __func__, ret);
 		goto cleanup_transaction;
 	}
 
@@ -1390,6 +1414,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = commit_fs_roots(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
@@ -1401,6 +1426,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	ret = commit_cowonly_roots(trans, root);
 	if (ret) {
 		mutex_unlock(&root->fs_info->tree_log_mutex);
+		mutex_unlock(&root->fs_info->reloc_mutex);
 		goto cleanup_transaction;
 	}
 
-- 
1.7.6.233.gd79bc
