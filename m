Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59362 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757495Ab3FCS55 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 14:57:57 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 2/2] btrfs: use list_for_each_entry_del
Date: Mon,  3 Jun 2013 13:28:05 -0400
Message-Id: <1370280485-10047-3-git-send-email-joern@logfs.org>
In-Reply-To: <1370280485-10047-1-git-send-email-joern@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Joern Engel <joern@logfs.org>
---
 fs/btrfs/backref.c      |   15 +++------------
 fs/btrfs/compression.c  |    4 +---
 fs/btrfs/disk-io.c      |    6 +-----
 fs/btrfs/extent-tree.c  |   17 +++--------------
 fs/btrfs/extent_io.c    |    8 ++------
 fs/btrfs/inode.c        |   16 +++-------------
 fs/btrfs/ordered-data.c |    7 +------
 fs/btrfs/qgroup.c       |   22 ++++------------------
 fs/btrfs/relocation.c   |    6 +-----
 fs/btrfs/scrub.c        |    9 +++------
 fs/btrfs/transaction.c  |    5 +----
 fs/btrfs/volumes.c      |   11 ++---------
 12 files changed, 25 insertions(+), 101 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bd605c8..ab51655 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -893,9 +893,7 @@ again:
 	if (ret)
 		goto out;
 
-	while (!list_empty(&prefs)) {
-		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-		list_del(&ref->list);
+	list_for_each_entry_del(ref, &prefs, list) {
 		WARN_ON(ref->count < 0);
 		if (ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
@@ -937,17 +935,10 @@ again:
 
 out:
 	btrfs_free_path(path);
-	while (!list_empty(&prefs)) {
-		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-		list_del(&ref->list);
+	list_for_each_entry_del(ref, &prefs, list)
 		kfree(ref);
-	}
-	while (!list_empty(&prefs_delayed)) {
-		ref = list_first_entry(&prefs_delayed, struct __prelim_ref,
-				       list);
-		list_del(&ref->list);
+	list_for_each_entry_del(ref, &prefs_delayed, list)
 		kfree(ref);
-	}
 
 	return ret;
 }
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 15b9408..c8a890b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -841,9 +841,7 @@ static void free_workspaces(void)
 	int i;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		while (!list_empty(&comp_idle_workspace[i])) {
-			workspace = comp_idle_workspace[i].next;
-			list_del(workspace);
+		list_for_each_del(workspace, &comp_idle_workspace[i]) {
 			btrfs_compress_op[i]->free_workspace(workspace);
 			atomic_dec(&comp_alloc_workspace[i]);
 		}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d19a0a..66d99c9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3289,11 +3289,7 @@ static void del_fs_roots(struct btrfs_fs_info *fs_info)
 	struct btrfs_root *gang[8];
 	int i;
 
-	while (!list_empty(&fs_info->dead_roots)) {
-		gang[0] = list_entry(fs_info->dead_roots.next,
-				     struct btrfs_root, root_list);
-		list_del(&gang[0]->root_list);
-
+	list_for_each_entry_del(gang[0], &fs_info->dead_roots, root_list) {
 		if (gang[0]->in_radix) {
 			btrfs_free_fs_root(fs_info, gang[0]);
 		} else {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d55123..42de094 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2435,10 +2435,7 @@ int btrfs_delayed_refs_qgroup_accounting(struct btrfs_trans_handle *trans,
 	if (!trans->delayed_ref_elem.seq)
 		return 0;
 
-	while (!list_empty(&trans->qgroup_ref_list)) {
-		qgroup_update = list_first_entry(&trans->qgroup_ref_list,
-						 struct qgroup_update, list);
-		list_del(&qgroup_update->list);
+	list_for_each_entry_del(qgroup_update, &trans->qgroup_ref_list, list) {
 		if (!ret)
 			ret = btrfs_qgroup_account_ref(
 					trans, fs_info, qgroup_update->node,
@@ -7821,12 +7818,8 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 	struct rb_node *n;
 
 	down_write(&info->extent_commit_sem);
-	while (!list_empty(&info->caching_block_groups)) {
-		caching_ctl = list_entry(info->caching_block_groups.next,
-					 struct btrfs_caching_control, list);
-		list_del(&caching_ctl->list);
+	list_for_each_entry_del(caching_ctl, &info->caching_block_groups, list)
 		put_caching_control(caching_ctl);
-	}
 	up_write(&info->extent_commit_sem);
 
 	spin_lock(&info->block_group_cache_lock);
@@ -7868,10 +7861,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 
 	release_global_block_rsv(info);
 
-	while(!list_empty(&info->space_info)) {
-		space_info = list_entry(info->space_info.next,
-					struct btrfs_space_info,
-					list);
+	list_for_each_entry_del(space_info, &info->space_info, list) {
 		if (btrfs_test_opt(info->tree_root, ENOSPC_DEBUG)) {
 			if (space_info->bytes_pinned > 0 ||
 			    space_info->bytes_reserved > 0 ||
@@ -7880,7 +7870,6 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 				dump_space_info(space_info, 0, 0);
 			}
 		}
-		list_del(&space_info->list);
 		kfree(space_info);
 	}
 	return 0;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cdee391..2b226dd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -87,24 +87,20 @@ void extent_io_exit(void)
 	struct extent_state *state;
 	struct extent_buffer *eb;
 
-	while (!list_empty(&states)) {
-		state = list_entry(states.next, struct extent_state, leak_list);
+	list_for_each_entry_del(state, &states, leak_list) {
 		printk(KERN_ERR "btrfs state leak: start %llu end %llu "
 		       "state %lu in tree %p refs %d\n",
 		       (unsigned long long)state->start,
 		       (unsigned long long)state->end,
 		       state->state, state->tree, atomic_read(&state->refs));
-		list_del(&state->leak_list);
 		kmem_cache_free(extent_state_cache, state);
 
 	}
 
-	while (!list_empty(&buffers)) {
-		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
+	list_for_each_entry_del(eb, &buffers, leak_list) {
 		printk(KERN_ERR "btrfs buffer leak start %llu len %lu "
 		       "refs %d\n", (unsigned long long)eb->start,
 		       eb->len, atomic_read(&eb->refs));
-		list_del(&eb->leak_list);
 		kmem_cache_free(extent_buffer_cache, eb);
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 09c58a3..0230755 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -623,13 +623,8 @@ static noinline int submit_compressed_extents(struct inode *inode,
 		return 0;
 
 again:
-	while (!list_empty(&async_cow->extents)) {
-		async_extent = list_entry(async_cow->extents.next,
-					  struct async_extent, list);
-		list_del(&async_extent->list);
-
+	list_for_each_entry_del(async_extent, &async_cow->extents, list) {
 		io_tree = &BTRFS_I(inode)->io_tree;
-
 retry:
 		/* did the compression code fall back to uncompressed IO? */
 		if (!async_extent->pages) {
@@ -1161,11 +1156,8 @@ static noinline int csum_exist_in_range(struct btrfs_root *root,
 	if (ret == 0 && list_empty(&list))
 		return 0;
 
-	while (!list_empty(&list)) {
-		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
-		list_del(&sums->list);
+	list_for_each_entry_del(sums, &list, list)
 		kfree(sums);
-	}
 	return 1;
 }
 
@@ -2882,9 +2874,7 @@ void btrfs_run_delayed_iputs(struct btrfs_root *root)
 	list_splice_init(&fs_info->delayed_iputs, &list);
 	spin_unlock(&fs_info->delayed_iput_lock);
 
-	while (!list_empty(&list)) {
-		delayed = list_entry(list.next, struct delayed_iput, list);
-		list_del(&delayed->list);
+	list_for_each_entry_del(delayed, &list, list) {
 		iput(delayed->inode);
 		kfree(delayed);
 	}
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 005c45d..f2a2f19 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -479,7 +479,6 @@ void btrfs_free_logged_extents(struct btrfs_root *log, u64 transid)
  */
 void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 {
-	struct list_head *cur;
 	struct btrfs_ordered_sum *sum;
 
 	trace_btrfs_ordered_extent_put(entry->inode, entry);
@@ -487,12 +486,8 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 	if (atomic_dec_and_test(&entry->refs)) {
 		if (entry->inode)
 			btrfs_add_delayed_iput(entry->inode);
-		while (!list_empty(&entry->list)) {
-			cur = entry->list.next;
-			sum = list_entry(cur, struct btrfs_ordered_sum, list);
-			list_del(&sum->list);
+		list_for_each_entry_del(sum, &entry->list, list)
 			kfree(sum);
-		}
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b44124d..3228737 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -164,19 +164,13 @@ static int del_qgroup_rb(struct btrfs_fs_info *fs_info, u64 qgroupid)
 	rb_erase(&qgroup->node, &fs_info->qgroup_tree);
 	list_del(&qgroup->dirty);
 
-	while (!list_empty(&qgroup->groups)) {
-		list = list_first_entry(&qgroup->groups,
-					struct btrfs_qgroup_list, next_group);
-		list_del(&list->next_group);
+	list_for_each_entry_del(list, &qgroup->groups, next_group) {
 		list_del(&list->next_member);
 		kfree(list);
 	}
 
-	while (!list_empty(&qgroup->members)) {
-		list = list_first_entry(&qgroup->members,
-					struct btrfs_qgroup_list, next_member);
+	list_for_each_entry_del(list, &qgroup->members, next_member) {
 		list_del(&list->next_group);
-		list_del(&list->next_member);
 		kfree(list);
 	}
 	kfree(qgroup);
@@ -422,21 +416,13 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 
 		WARN_ON(!list_empty(&qgroup->dirty));
 
-		while (!list_empty(&qgroup->groups)) {
-			list = list_first_entry(&qgroup->groups,
-						struct btrfs_qgroup_list,
-						next_group);
-			list_del(&list->next_group);
+		list_for_each_entry_del(list, &qgroup->groups, next_group) {
 			list_del(&list->next_member);
 			kfree(list);
 		}
 
-		while (!list_empty(&qgroup->members)) {
-			list = list_first_entry(&qgroup->members,
-						struct btrfs_qgroup_list,
-						next_member);
+		list_for_each_entry_del(list, &qgroup->members, next_member) {
 			list_del(&list->next_group);
-			list_del(&list->next_member);
 			kfree(list);
 		}
 		kfree(qgroup);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b67171e..385105e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4270,11 +4270,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 
 	rc->merge_reloc_tree = 1;
 
-	while (!list_empty(&reloc_roots)) {
-		reloc_root = list_entry(reloc_roots.next,
-					struct btrfs_root, root_list);
-		list_del(&reloc_root->root_list);
-
+	list_for_each_entry_del(reloc_root, &reloc_roots, root_list) {
 		if (btrfs_root_refs(&reloc_root->root_item) == 0) {
 			list_add_tail(&reloc_root->root_list,
 				      &rc->reloc_roots);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 85e072b..b8954312 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -306,13 +306,10 @@ static void scrub_pending_trans_workers_dec(struct scrub_ctx *sctx)
 
 static void scrub_free_csums(struct scrub_ctx *sctx)
 {
-	while (!list_empty(&sctx->csum_list)) {
-		struct btrfs_ordered_sum *sum;
-		sum = list_first_entry(&sctx->csum_list,
-				       struct btrfs_ordered_sum, list);
-		list_del(&sum->list);
+	struct btrfs_ordered_sum *sum;
+
+	list_for_each_entry_del(sum, &sctx->csum_list, list)
 		kfree(sum);
-	}
 }
 
 static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 50767bb..70b092b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1885,12 +1885,9 @@ int btrfs_clean_old_snapshots(struct btrfs_root *root)
 	list_splice_init(&fs_info->dead_roots, &list);
 	spin_unlock(&fs_info->trans_lock);
 
-	while (!list_empty(&list)) {
+	list_for_each_entry_del(root, &list, root_list) {
 		int ret;
 
-		root = list_entry(list.next, struct btrfs_root, root_list);
-		list_del(&root->root_list);
-
 		btrfs_kill_all_delayed_nodes(root);
 
 		if (btrfs_header_backref_rev(root->node) <
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2854c82..1117d36 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -65,10 +65,7 @@ static void free_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device;
 	WARN_ON(fs_devices->opened);
-	while (!list_empty(&fs_devices->devices)) {
-		device = list_entry(fs_devices->devices.next,
-				    struct btrfs_device, dev_list);
-		list_del(&device->dev_list);
+	list_for_each_entry_del(device, &fs_devices->devices, dev_list) {
 		rcu_string_free(device->name);
 		kfree(device);
 	}
@@ -92,12 +89,8 @@ void btrfs_cleanup_fs_uuids(void)
 {
 	struct btrfs_fs_devices *fs_devices;
 
-	while (!list_empty(&fs_uuids)) {
-		fs_devices = list_entry(fs_uuids.next,
-					struct btrfs_fs_devices, list);
-		list_del(&fs_devices->list);
+	list_for_each_entry_del(fs_devices, &fs_uuids, list)
 		free_fs_devices(fs_devices);
-	}
 }
 
 static noinline struct btrfs_device *__find_device(struct list_head *head,
-- 
1.7.10.4

