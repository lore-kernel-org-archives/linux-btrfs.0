Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbcE0ASJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 20:18:09 -0400
Date: Thu, 26 May 2016 17:18:06 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH] Improve balance performance when qgroups are turned on
Message-ID: <20160527001806.GX7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs balance operation is significantly slower when qgroups are
enabled. To the best of my knowledge, a balance shouldn't have an effect on
qgroups counts (extents are not changing between subvolumes), so we don't
need to actually run the qgroup code when we balance.

Since there's only one thread doing balance at a time, it's easy to recored
that thread on the fs_info and check it inside qgroup_insert_dirty_extent().
If we're the balance thread, we drop the qgroup record instead of inserting
it.

Here are some sample numbers before and after this patch. The example fs
below is 22 gigabytes in size and was creating by copying /usr and /boot
from my test machine (a few times).

Balance with qgroups enabled, before patch:
	# time btrfs balance start --full-balance /btrfs
	Done, had to relocate 26 out of 26 chunks

	real    3m7.515s
	user    0m0.002s
	sys     2m0.852s

Balance with qgroups enabeld, after patch:
	# time btrfs balance start --full-balance /btrfs
	Done, had to relocate 26 out of 26 chunks

	real    2m2.806s
	user    0m0.000s
	sys     0m54.174s

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ctree.h       | 1 +
 fs/btrfs/delayed-ref.c | 2 +-
 fs/btrfs/disk-io.c     | 1 +
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/qgroup.c      | 6 +++++-
 fs/btrfs/qgroup.h      | 3 ++-
 fs/btrfs/volumes.c     | 4 ++++
 7 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bfe4a33..994f19a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1748,6 +1748,7 @@ struct btrfs_fs_info {
 	atomic_t balance_cancel_req;
 	struct btrfs_balance_control *balance_ctl;
 	wait_queue_head_t balance_wait_q;
+	struct task_struct *balance_thread;
 
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 914ac13..81e9b92 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -606,7 +606,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		qrecord->num_bytes = num_bytes;
 		qrecord->old_roots = NULL;
 
-		qexisting = btrfs_qgroup_insert_dirty_extent(delayed_refs,
+		qexisting = btrfs_qgroup_insert_dirty_extent(fs_info, delayed_refs,
 							     qrecord);
 		if (qexisting)
 			kfree(qrecord);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4545e2e..0bbdf808 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2236,6 +2236,7 @@ static void btrfs_init_balance(struct btrfs_fs_info *fs_info)
 	atomic_set(&fs_info->balance_cancel_req, 0);
 	fs_info->balance_ctl = NULL;
 	init_waitqueue_head(&fs_info->balance_wait_q);
+	fs_info->balance_thread = NULL;
 }
 
 static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7..33c784c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8195,7 +8195,7 @@ static int record_one_subtree_extent(struct btrfs_trans_handle *trans,
 
 	delayed_refs = &trans->transaction->delayed_refs;
 	spin_lock(&delayed_refs->lock);
-	if (btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
+	if (btrfs_qgroup_insert_dirty_extent(root->fs_info, delayed_refs, qrecord))
 		kfree(qrecord);
 	spin_unlock(&delayed_refs->lock);
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6541d56..994ccb2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1454,7 +1454,8 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 }
 
 struct btrfs_qgroup_extent_record
-*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
+*btrfs_qgroup_insert_dirty_extent(struct btrfs_fs_info *fs_info,
+				  struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_qgroup_extent_record *record)
 {
 	struct rb_node **p = &delayed_refs->dirty_extent_root.rb_node;
@@ -1462,6 +1463,9 @@ struct btrfs_qgroup_extent_record
 	struct btrfs_qgroup_extent_record *entry;
 	u64 bytenr = record->bytenr;
 
+	if (fs_info->balance_thread == current)
+		return record;
+
 	assert_spin_locked(&delayed_refs->lock);
 	trace_btrfs_qgroup_insert_dirty_extent(record);
 
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index ecb2c14..74e683d 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -64,7 +64,8 @@ struct btrfs_delayed_extent_op;
 int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info);
 struct btrfs_qgroup_extent_record
-*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
+*btrfs_qgroup_insert_dirty_extent(struct btrfs_fs_info *fs_info,
+				  struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_qgroup_extent_record *record);
 int
 btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335..ef40d58 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3685,6 +3685,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		}
 	}
 
+	fs_info->balance_thread = current;
+
 	num_devices = fs_info->fs_devices->num_devices;
 	btrfs_dev_replace_lock(&fs_info->dev_replace);
 	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
@@ -3802,6 +3804,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 
 	wake_up(&fs_info->balance_wait_q);
 
+	fs_info->balance_thread = NULL;
 	return ret;
 out:
 	if (bctl->flags & BTRFS_BALANCE_RESUME)
@@ -3810,6 +3813,7 @@ out:
 		kfree(bctl);
 		atomic_set(&fs_info->mutually_exclusive_operation_running, 0);
 	}
+	fs_info->balance_thread = NULL;
 	return ret;
 }
 
-- 
2.1.4

