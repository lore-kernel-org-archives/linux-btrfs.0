From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 5/5] btrfs: use droptree for snapshot deletion
Date: Thu, 12 Apr 2012 17:54:42 +0200
Message-ID: <fbdcedb2ec7d4b0eee1a7cf22fc3550db26bd710.1334241664.git.sensille@gmx.net>
References: <cover.1334241664.git.sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
In-Reply-To: <cover.1334241664.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Update btrfs_clean_old_snapshots to make use of droptree. Snapshots
with old backrefs and snapshots which deletion is always in progress
are deleted with the old code, all other snapshots deletions use
droptree.
Some droptree-related debug code is also added to reada.c.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/reada.c       |   13 +++++++++++++
 fs/btrfs/transaction.c |   35 +++++++++++++++++++++++++++++++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7b3ddd7..b175cfa 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3041,6 +3041,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_pause_balance(root->fs_info);
 
 	btrfs_scrub_cancel(root);
+	btrfs_droptree_pause(fs_info);
 
 	/* wait for any defraggers to finish */
 	wait_event(fs_info->transaction_wait,
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 0d88163..69a9409 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -1112,6 +1112,19 @@ int btrfs_reada_wait(struct reada_control *rc)
 		dump_devs(fs_info, atomic_read(&rc->elems) < 10 ? 1 : 0);
 		printk(KERN_DEBUG "reada_wait on %p: %d elems\n", rc,
 			atomic_read(&rc->elems));
+		mutex_lock(&fs_info->droptree_lock);
+
+		for (i = 0; i < BTRFS_MAX_LEVEL; ++i) {
+			if (fs_info->droptree_req[i] == 0)
+				continue;
+			printk(KERN_DEBUG "droptree req on level %d: %ld out "
+				"of %ld, queue is %sempty\n",
+				i, fs_info->droptree_req[i],
+				fs_info->droptree_limit[i],
+				list_empty(&fs_info->droptree_queue[i]) ?
+						"" : "not ");
+		}
+		mutex_unlock(&fs_info->droptree_lock);
 	}
 
 	dump_devs(fs_info, atomic_read(&rc->elems) < 10 ? 1 : 0);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04b77e3..2d72a7e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1182,6 +1182,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	spin_unlock(&cur_trans->commit_lock);
 	wake_up(&root->fs_info->transaction_blocked_wait);
 
+	ret = btrfs_droptree_pause(root->fs_info);
+	BUG_ON(ret);
+
 	spin_lock(&root->fs_info->trans_lock);
 	if (cur_trans->list.prev != &root->fs_info->trans_list) {
 		prev_trans = list_entry(cur_trans->list.prev,
@@ -1363,6 +1366,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	trace_btrfs_transaction_commit(root);
 
 	btrfs_scrub_continue(root);
+	btrfs_droptree_continue(root->fs_info);
 
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
@@ -1381,12 +1385,22 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 int btrfs_clean_old_snapshots(struct btrfs_root *root)
 {
 	LIST_HEAD(list);
+	LIST_HEAD(new);
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root_item *root_item = &root->root_item;
 
 	spin_lock(&fs_info->trans_lock);
 	list_splice_init(&fs_info->dead_roots, &list);
 	spin_unlock(&fs_info->trans_lock);
 
+	/*
+	 * in a first pass, pick out all snapshot deletions that have been
+	 * interrupted from a previous mount on an older kernel that didn't
+	 * support the droptree version of snapshot deletion. We continue
+	 * it with the old code. Also deletions of roots from very old
+	 * filesystems with old-style backrefs will be handled by the old
+	 * code
+	 */
 	while (!list_empty(&list)) {
 		root = list_entry(list.next, struct btrfs_root, root_list);
 		list_del(&root->root_list);
@@ -1394,10 +1408,27 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 		btrfs_kill_all_delayed_nodes(root);
 
 		if (btrfs_header_backref_rev(root->node) <
-		    BTRFS_MIXED_BACKREF_REV)
+		    BTRFS_MIXED_BACKREF_REV) {
 			btrfs_drop_snapshot(root, NULL, 0, 0);
-		else
+		} else if (btrfs_disk_key_objectid(&root_item->drop_progress)) {
 			btrfs_drop_snapshot(root, NULL, 1, 0);
+		} else {
+			/* put on list for processing by droptree */
+			list_add_tail(&root->root_list, &new);
+		}
 	}
+
+	droptree_drop_list(fs_info, &new);
+	while (!list_empty(&new)) {
+		/*
+		 * if there are any roots left on the list after drop_list,
+		 * delete them with the old code. This can happen in when the
+		 * fs hasn't got enough space for the droptree inode left.
+		 */
+		root = list_entry(list.next, struct btrfs_root, root_list);
+		list_del(&root->root_list);
+		btrfs_drop_snapshot(root, NULL, 1, 0);
+	}
+
 	return 0;
 }
-- 
1.7.3.4

