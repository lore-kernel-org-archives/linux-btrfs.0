Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab2IZLjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 07:39:10 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8QBd8UQ026073
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 19:39:08 +0800
Message-ID: <5062E964.9050701@cn.fujitsu.com>
Date: Wed, 26 Sep 2012 19:39:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [RFC][PATCH V2 4/4] Btrfs: introduce extent buffer cache for delayed
 reference
References: <5062E563.7090105@cn.fujitsu.com>
In-Reply-To: <5062E563.7090105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces extent buffer cache for the delayed reference.
It can reduce the search time and the contentions of the extent buffer's
lock when dealing with the delayed references.

Implementation:
- add a extent buffer cache into the transaction handle
- when dealing with the delayed references, we get the cache from the transaction
  handle and pass the cache into btrfs_search_slot().
- release the cached extent buffer when the transaction handle ends or we commit
  the transaction.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    5 +++++
 fs/btrfs/transaction.c |   10 ++++++++++
 fs/btrfs/transaction.h |    3 +++
 3 files changed, 18 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index af0ea25..815876b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1918,6 +1918,7 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 
 	path->reada = 1;
 	path->leave_spinning = 1;
+	path->eb_cache = &trans->eb_cache;
 	/* this will setup the path even if it fails to insert the back ref */
 	ret = insert_inline_extent_backref(trans, root->fs_info->extent_root,
 					   path, bytenr, num_bytes, parent,
@@ -2049,6 +2050,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 
 	path->reada = 1;
 	path->leave_spinning = 1;
+	path->eb_cache = &trans->eb_cache;
 	ret = btrfs_search_slot(trans, root->fs_info->extent_root, &key,
 				path, 0, 1);
 	if (ret < 0) {
@@ -5067,6 +5069,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	BUG_ON(!is_data && refs_to_drop != 1);
 
+	path->eb_cache = &trans->eb_cache;
 	ret = lookup_extent_backref(trans, extent_root, path, &iref,
 				    bytenr, num_bytes, parent,
 				    root_objectid, owner_objectid,
@@ -6062,6 +6065,7 @@ static int alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->leave_spinning = 1;
+	path->eb_cache = &trans->eb_cache;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
 	if (ret) {
@@ -6126,6 +6130,7 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->leave_spinning = 1;
+	path->eb_cache = &trans->eb_cache;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
 	if (ret) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 109c26c..845898d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -363,6 +363,7 @@ again:
 	h->block_rsv = NULL;
 	h->orig_rsv = NULL;
 	h->aborted = 0;
+	extent_buffer_cache_init(&h->eb_cache);
 	h->qgroup_reserved = qgroup_reserved;
 	h->delayed_ref_elem.seq = 0;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
@@ -590,6 +591,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	}
 	assert_qgroups_uptodate(trans);
 
+	if (trans->eb_cache.cached_eb)
+		free_extent_buffer(trans->eb_cache.cached_eb);
+
 	memset(trans, 0, sizeof(*trans));
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 	return err;
@@ -1299,6 +1303,9 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans,
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 
+	if (trans->eb_cache.cached_eb)
+		free_extent_buffer(trans->eb_cache.cached_eb);
+
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 }
 
@@ -1587,6 +1594,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	if (current->journal_info == trans)
 		current->journal_info = NULL;
 
+	if (trans->eb_cache.cached_eb)
+		free_extent_buffer(trans->eb_cache.cached_eb);
+
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 
 	if (current != root->fs_info->transaction_kthread)
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 65e2282..fe1bf95 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -46,6 +46,8 @@ struct btrfs_transaction {
 	int aborted;
 };
 
+struct extent_buffer_cache;
+
 struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
@@ -57,6 +59,7 @@ struct btrfs_trans_handle {
 	struct btrfs_transaction *transaction;
 	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_block_rsv *orig_rsv;
+	struct extent_buffer_cache eb_cache;
 	int aborted;
 	int adding_csums;
 	/*
-- 
1.7.10.2

