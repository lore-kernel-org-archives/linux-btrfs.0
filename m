Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46742 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab3DYRsL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 13:48:11 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 73CF39A0699
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 11:48:10 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id vJgbxaMCbJ4gEOWf (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 11:48:09 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: various abort cleanups
Date: Thu, 25 Apr 2013 13:48:07 -0400
Message-ID: <1366912087-4146-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a broken file system that when it aborts leaves all sorts of accounting
things wrong and gives you lots of WARN_ON()'s other than the abort.  This is
because we're not cleaning up various parts of the file system when we abort.
The first chunks are specific to mount failures, we weren't cleaning up the
block group cached inodes and we weren't cleaning up any transactions that had
been aborted, which leaves a bunch of things laying around.

The second half of this are related to the cleanup parts.  First we don't need
to release space for the dirty pages from the trans_block_rsv, that's all
handled by the trans handles so this is just plain wrong.  The other thing is we
need to pin down extents that were set ->must_insert_reserved for delayed refs.
This isn't so much for the pinning but more for the cleaning up the
cache->reserved counter since we are no longer going to use those reserved
bytes.  With this patch I no longer see a bunch of WARN_ON()'s when I try to
mount this broken file system, just the initial one from the abort.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c     |    9 +++++----
 fs/btrfs/extent-tree.c |    3 +++
 fs/btrfs/transaction.c |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7717363..eb0f206 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2883,6 +2883,7 @@ fail_qgroup:
 fail_trans_kthread:
 	kthread_stop(fs_info->transaction_kthread);
 	del_fs_roots(fs_info);
+	btrfs_cleanup_transaction(fs_info->tree_root);
 fail_cleaner:
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -2893,6 +2894,7 @@ fail_cleaner:
 	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
 
 fail_block_groups:
+	btrfs_put_block_group_cache(fs_info);
 	btrfs_free_block_groups(fs_info);
 
 fail_tree_roots:
@@ -3733,6 +3735,9 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				continue;
 			}
 
+			if (head->must_insert_reserved)
+				btrfs_pin_extent(root, ref->bytenr,
+						 ref->num_bytes, 1);
 			btrfs_free_delayed_extent_op(head->extent_op);
 			delayed_refs->num_heads--;
 			if (list_empty(&head->cluster))
@@ -3929,10 +3934,6 @@ int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 		btrfs_destroy_delayed_refs(t, root);
 
-		btrfs_block_rsv_release(root,
-					&root->fs_info->trans_block_rsv,
-					t->dirty_pages.dirty_bytes);
-
 		/* FIXME: cleanup wait for commit */
 		t->in_commit = 1;
 		t->blocked = 1;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 796c4ef..8f94c89 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4650,6 +4650,7 @@ void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 	if (!trans->bytes_reserved)
 		return;
 
+	printk(KERN_ERR "release %Lu for %p\n", trans->bytes_reserved, trans);
 	trace_btrfs_space_reservation(root->fs_info, "transaction",
 				      trans->transid, trans->bytes_reserved, 0);
 	btrfs_block_rsv_release(root, trans->block_rsv, trans->bytes_reserved);
@@ -6658,6 +6659,8 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_put_block_group(block_group);
 	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
 					 0, owner, offset, ins, 1);
+	if (ret)
+		printk(KERN_ERR "this is probably where we went wrong\n");
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 94cbd10..95ae2f1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -419,6 +419,7 @@ again:
 					      h->transid, num_bytes, 1);
 		h->block_rsv = &root->fs_info->trans_block_rsv;
 		h->bytes_reserved = num_bytes;
+		printk(KERN_ERR "reserved %Lu for %p\n", num_bytes, h);
 	}
 	h->qgroup_reserved = qgroup_reserved;
 
-- 
1.7.7.6

