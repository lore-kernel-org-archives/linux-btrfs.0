Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbbHNVOt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 17:14:49 -0400
Date: Fri, 14 Aug 2015 14:14:48 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, jbacik@fb.com, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: Major qgroup regression in 4.2?
Message-ID: <20150814211448.GB1145@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150813231307.GA1145@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150813231307.GA1145@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 13, 2015 at 04:13:08PM -0700, Mark Fasheh wrote:
> If there *is* a plan to make this all work again, can I please hear it? The
> comment mentions something about adding those nodes to a dirty_extent_root.
> Why wasn't that done?

Ok so I had more time to look through the changes today and came up with
this naive patch, it simply inserts dirty extent records where we were doing
our qgroup refs before. This passes my micro-test but I'm unclear on whether
there's some pitfall I'm unaware of (I'm guessing there must be?). Please
advise.

Thanks,
	--Mark

--
Mark Fasheh


From: Mark Fasheh <mfasheh@suse.de>

btrfs: qgroup: account shared subtree during snapshot delete (again)

Commit 0ed4792 ('btrfs: qgroup: Switch to new extent-oriented qgroup
mechanism.') removed our qgroup accounting during
btrfs_drop_snapshot(). Predictably, this results in qgroup numbers
going bad shortly after a snapshot is removed.

Fix this by adding a dirty extent record when we encounter extents
during our shared subtree walk. This effectively restores the
functionality we had with the original shared subtree walkign code in
commit 1152651 (btrfs: qgroup: account shared subtrees during snapshot
delete)

This patch also moves the open coded allocation handling for
qgroup_extent_record into their own functions.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>

qdiff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index ac3e81d..8156f50 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -486,7 +486,7 @@ add_delayed_ref_head(struct btrfs_fs_info *fs_info,
 		qexisting = btrfs_qgroup_insert_dirty_extent(delayed_refs,
 							     qrecord);
 		if (qexisting)
-			kfree(qrecord);
+			btrfs_qgroup_free_extent_record(qrecord);
 	}
 
 	spin_lock_init(&head_ref->lock);
@@ -654,7 +654,7 @@ int btrfs_add_delayed_tree_ref(struct btrfs_fs_info *fs_info,
 		goto free_ref;
 
 	if (fs_info->quota_enabled && is_fstree(ref_root)) {
-		record = kmalloc(sizeof(*record), GFP_NOFS);
+		record = btrfs_qgroup_alloc_extent_record();
 		if (!record)
 			goto free_head_ref;
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 07204bf..ab81135 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7756,18 +7756,31 @@ reada:
 	wc->reada_slot = slot;
 }
 
-/*
- * TODO: Modify related function to add related node/leaf to dirty_extent_root,
- * for later qgroup accounting.
- *
- * Current, this function does nothing.
- */
+static int record_one_item(struct btrfs_trans_handle *trans, u64 bytenr,
+			   u64 num_bytes)
+{
+	struct btrfs_qgroup_extent_record *qrecord = btrfs_qgroup_alloc_extent_record();
+	struct btrfs_delayed_ref_root *delayed_refs = &trans->transaction->delayed_refs;
+
+	if (!qrecord)
+		return -ENOMEM;
+
+	qrecord->bytenr = bytenr;
+	qrecord->num_bytes = num_bytes;
+	qrecord->old_roots = NULL;
+
+	if (btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
+		btrfs_qgroup_free_extent_record(qrecord);
+
+	return 0;
+}
+
 static int account_leaf_items(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct extent_buffer *eb)
 {
 	int nr = btrfs_header_nritems(eb);
-	int i, extent_type;
+	int i, extent_type, ret;
 	struct btrfs_key key;
 	struct btrfs_file_extent_item *fi;
 	u64 bytenr, num_bytes;
@@ -7790,6 +7803,10 @@ static int account_leaf_items(struct btrfs_trans_handle *trans,
 			continue;
 
 		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
+
+		ret = record_one_item(trans, bytenr, num_bytes);
+		if (ret)
+			return ret;
 	}
 	return 0;
 }
@@ -7858,8 +7875,6 @@ static int adjust_slots_upwards(struct btrfs_root *root,
 
 /*
  * root_eb is the subtree root and is locked before this function is called.
- * TODO: Modify this function to mark all (including complete shared node)
- * to dirty_extent_root to allow it get accounted in qgroup.
  */
 static int account_shared_subtree(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root,
@@ -7937,6 +7952,11 @@ walk_down:
 			btrfs_tree_read_lock(eb);
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
+
+			ret = record_one_item(trans, child_bytenr,
+					      root->nodesize);
+			if (ret)
+				goto out;
 		}
 
 		if (level == 0) {
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8a82029..27ec405 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1452,6 +1452,17 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+struct btrfs_qgroup_extent_record *btrfs_qgroup_alloc_extent_record(void)
+{
+	return kmalloc(sizeof(struct btrfs_qgroup_extent_record), GFP_NOFS);
+}
+
+void btrfs_qgroup_free_extent_record(struct btrfs_qgroup_extent_record *record)
+{
+	if (record)
+		kfree(record);
+}
+
 struct btrfs_qgroup_extent_record
 *btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_qgroup_extent_record *record)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 6387dcf..dfba663 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -59,6 +59,9 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 struct btrfs_qgroup_extent_record
 *btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_qgroup_extent_record *record);
+struct btrfs_qgroup_extent_record
+*btrfs_qgroup_alloc_extent_record(void);
+void btrfs_qgroup_free_extent_record(struct btrfs_qgroup_extent_record *record);
 int
 btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info,
