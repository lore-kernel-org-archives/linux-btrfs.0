Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:50314 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758359Ab2HISEI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Aug 2012 14:04:08 -0400
Date: Thu, 9 Aug 2012 14:04:05 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting
 shared block reference
Message-ID: <20120809180405.GC32103@shiny>
References: <50232A19.2010704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50232A19.2010704@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2012 at 09:10:17PM -0600, Miao Xie wrote:
> If we create several snapshots at the same time, the following BUG_ON() will be
> triggered.
> 
> 	kernel BUG at fs/btrfs/extent-tree.c:6047!
> 
> Steps to reproduce:
>  # mkfs.btrfs <partition>
>  # mount <partition> <mnt>
>  # cd <mnt>
>  # for ((i=0;i<2400;i++)); do touch long_name_to_make_tree_more_deep$i; done
>  # for ((i=0; i<4; i++))
>  > do
>  > mkdir $i
>  > for ((j=0; j<200; j++))
>  > do
>  > btrfs sub snap . $i/$j
>  > done &
>  > done

snapshot creation has a critical section.  Once we copy a given root to
its snapshot, we're not allowed to change it until the transaction
is fully committed.

This means that if you're taking a snapshot of root A and storing the
directory item of the snapshot in root A, you can only do it once per
transaction with getting into trouble.

Looks like the code doesn't enforce this though.  Dave, could you please
give this a try:

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index fcc8c21..9e7c621 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1324,6 +1324,8 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	u64 search_start;
 	int ret;
 
+	WARN_ON(root->danger_transid == trans->transid);
+
 	if (trans->transaction != root->fs_info->running_transaction) {
 		printk(KERN_CRIT "trans %llu running %llu\n",
 		       (unsigned long long)trans->transid,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d195b5..35b5603 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1490,6 +1490,12 @@ struct btrfs_root {
 	u64 objectid;
 	u64 last_trans;
 
+	/*
+	 * the last transaction that took a snapshot of this
+	 * root.  We're only allowed one snapshot per root per transaction
+	 */
+	u64 snapshot_trans;
+
 	/* data allocations are done in sectorsize units */
 	u32 sectorsize;
 
@@ -1550,6 +1556,13 @@ struct btrfs_root {
 
 	int force_cow;
 
+	/*
+	 * this marks the critical section of snapshot creation.  If we
+	 * make any changes to a root after this critical section starts,
+	 * we corrupt the FS.  It is checked by btrfs_cow_block
+	 */
+	u64 danger_transid;
+
 	spinlock_t root_times_lock;
 };
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9df50fa..b20d835 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -524,13 +524,28 @@ static int create_snapshot(struct btrfs_root *root, struct dentry *dentry,
 		pending_snapshot->inherit = *inherit;
 		*inherit = NULL;	/* take responsibility to free it */
 	}
-
+again:
 	trans = btrfs_start_transaction(root->fs_info->extent_root, 5);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto fail;
 	}
 
+	/* we're only allowed to snapshot a given root once per transaction */
+	spin_lock(&root->fs_info->trans_lock);
+	if (root->snapshot_trans == trans->transid) {
+		spin_unlock(&root->fs_info->trans_lock);
+		ret = btrfs_commit_transaction(trans, root->fs_info->extent_root);
+		if (ret)
+			goto fail;
+		goto again;
+	}
+
+	root->snapshot_trans = trans->transid;
+
+	spin_unlock(&root->fs_info->trans_lock);
+
+
 	ret = btrfs_snap_reserve_metadata(trans, pending_snapshot);
 	BUG_ON(ret);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 27c2600..4507421 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1093,6 +1093,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	/* see comments in should_cow_block() */
 	root->force_cow = 1;
+	root->danger_transid = trans->transid;
 	smp_wmb();
 
 	btrfs_set_root_node(new_root_item, tmp);
