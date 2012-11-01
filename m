Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab2KAHb5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 03:31:57 -0400
Message-ID: <50922582.2040206@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 15:32:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH 1/5] Btrfs: fix joining the same transaction handler more
 than 2 times
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we flush inodes with pending delalloc in a transaction, we may join
the same transaction handler more than 2 times.

The reason is:
  Task						use_count of trans handle
  commit_transaction				1
    |-> btrfs_start_delalloc_inodes		1
	  |-> run_delalloc_nocow		1
		|-> join_transaction		2
		|-> cow_file_range		2
			|-> join_transaction	3

In fact, cow_file_range needn't join the transaction again because the caller
have joined the transaction, so we fix this problem by this way.

Reported-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c       |   77 +++++++++++++++++++++++++++++------------------
 fs/btrfs/transaction.c |    1 +
 2 files changed, 48 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5fc0990..aadcdd6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -803,14 +803,14 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
  * required to start IO on it.  It may be clean and already done with
  * IO when we return.
  */
-static noinline int cow_file_range(struct inode *inode,
-				   struct page *locked_page,
-				   u64 start, u64 end, int *page_started,
-				   unsigned long *nr_written,
-				   int unlock)
+static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
+				     struct inode *inode,
+				     struct btrfs_root *root,
+				     struct page *locked_page,
+				     u64 start, u64 end, int *page_started,
+				     unsigned long *nr_written,
+				     int unlock)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
 	u64 alloc_hint = 0;
 	u64 num_bytes;
 	unsigned long ram_size;
@@ -823,25 +823,10 @@ static noinline int cow_file_range(struct inode *inode,
 	int ret = 0;
 
 	BUG_ON(btrfs_is_free_space_inode(inode));
-	trans = btrfs_join_transaction(root);
-	if (IS_ERR(trans)) {
-		extent_clear_unlock_delalloc(inode,
-			     &BTRFS_I(inode)->io_tree,
-			     start, end, locked_page,
-			     EXTENT_CLEAR_UNLOCK_PAGE |
-			     EXTENT_CLEAR_UNLOCK |
-			     EXTENT_CLEAR_DELALLOC |
-			     EXTENT_CLEAR_DIRTY |
-			     EXTENT_SET_WRITEBACK |
-			     EXTENT_END_WRITEBACK);
-		return PTR_ERR(trans);
-	}
-	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
 	num_bytes = max(blocksize,  num_bytes);
 	disk_num_bytes = num_bytes;
-	ret = 0;
 
 	/* if this is a small write inside eof, kick off defrag */
 	if (num_bytes < 64 * 1024 &&
@@ -952,11 +937,9 @@ static noinline int cow_file_range(struct inode *inode,
 		alloc_hint = ins.objectid + ins.offset;
 		start += cur_alloc_size;
 	}
-	ret = 0;
 out:
-	btrfs_end_transaction(trans, root);
-
 	return ret;
+
 out_unlock:
 	extent_clear_unlock_delalloc(inode,
 		     &BTRFS_I(inode)->io_tree,
@@ -971,6 +954,39 @@ out_unlock:
 	goto out;
 }
 
+static noinline int cow_file_range(struct inode *inode,
+				   struct page *locked_page,
+				   u64 start, u64 end, int *page_started,
+				   unsigned long *nr_written,
+				   int unlock)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		extent_clear_unlock_delalloc(inode,
+			     &BTRFS_I(inode)->io_tree,
+			     start, end, locked_page,
+			     EXTENT_CLEAR_UNLOCK_PAGE |
+			     EXTENT_CLEAR_UNLOCK |
+			     EXTENT_CLEAR_DELALLOC |
+			     EXTENT_CLEAR_DIRTY |
+			     EXTENT_SET_WRITEBACK |
+			     EXTENT_END_WRITEBACK);
+		return PTR_ERR(trans);
+	}
+	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
+
+	ret = __cow_file_range(trans, inode, root, locked_page, start, end,
+			       page_started, nr_written, unlock);
+
+	btrfs_end_transaction(trans, root);
+
+	return ret;
+}
+
 /*
  * work queue call back to started compression on a file and pages
  */
@@ -1281,9 +1297,9 @@ out_check:
 
 		btrfs_release_path(path);
 		if (cow_start != (u64)-1) {
-			ret = cow_file_range(inode, locked_page, cow_start,
-					found_key.offset - 1, page_started,
-					nr_written, 1);
+			ret = __cow_file_range(trans, inode, root, locked_page,
+					       cow_start, found_key.offset - 1,
+					       page_started, nr_written, 1);
 			if (ret) {
 				btrfs_abort_transaction(trans, root, ret);
 				goto error;
@@ -1352,8 +1368,9 @@ out_check:
 	}
 
 	if (cow_start != (u64)-1) {
-		ret = cow_file_range(inode, locked_page, cow_start, end,
-				     page_started, nr_written, 1);
+		ret = __cow_file_range(trans, inode, root, locked_page,
+				       cow_start, end,
+				       page_started, nr_written, 1);
 		if (ret) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto error;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04bbfb1..6d0d5a0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -312,6 +312,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK);
 		h = current->journal_info;
 		h->use_count++;
+		WARN_ON(h->use_count > 2);
 		h->orig_rsv = h->block_rsv;
 		h->block_rsv = NULL;
 		goto got_it;
-- 
1.7.6.5
