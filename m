Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35792 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaJITTy (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 9 Oct 2014 15:19:54 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] Btrfs: add helper btrfs_fdatawrite_range
Date: Thu,  9 Oct 2014 21:18:56 +0100
Message-Id: <1412885936-16256-2-git-send-email-fdmanana@suse.com>
In-Reply-To: <1412885936-16256-1-git-send-email-fdmanana@suse.com>
References: <1412885936-16256-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To avoid duplicating this double filemap_fdatawrite_range() call for
inodes with async extents (compressed writes) so often.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h        |  1 +
 fs/btrfs/file.c         | 36 ++++++++++++++++++++++++++++--------
 fs/btrfs/inode.c        |  9 +--------
 fs/btrfs/ordered-data.c | 24 ++----------------------
 4 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 089f6da..4e0ad8c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3896,6 +3896,7 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 		      struct page **pages, size_t num_pages,
 		      loff_t pos, size_t write_bytes,
 		      struct extent_state **cached);
+int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 82c7229..2df1dce 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1697,10 +1697,7 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 	 * able to read what was just written.
 	 */
 	endbyte = pos + written_buffered - 1;
-	err = filemap_fdatawrite_range(file->f_mapping, pos, endbyte);
-	if (!err && test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-			     &BTRFS_I(file_inode(file))->runtime_flags))
-		err = filemap_fdatawrite_range(file->f_mapping, pos, endbyte);
+	err = btrfs_fdatawrite_range(file->f_mapping, pos, endbyte);
 	if (err)
 		goto out;
 	err = filemap_fdatawait_range(file->f_mapping, pos, endbyte);
@@ -1864,10 +1861,7 @@ static int start_ordered_ops(struct inode *inode, loff_t start, loff_t end)
 	int ret;
 
 	atomic_inc(&BTRFS_I(inode)->sync_writers);
-	ret = filemap_fdatawrite_range(inode->i_mapping, start, end);
-	if (!ret && test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-			     &BTRFS_I(inode)->runtime_flags))
-		ret = filemap_fdatawrite_range(inode->i_mapping, start, end);
+	ret = btrfs_fdatawrite_range(inode->i_mapping, start, end);
 	atomic_dec(&BTRFS_I(inode)->sync_writers);
 
 	return ret;
@@ -2820,3 +2814,29 @@ int btrfs_auto_defrag_init(void)
 
 	return 0;
 }
+
+int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end)
+{
+	int ret;
+
+	/*
+	 * So with compression we will find and lock a dirty page and clear the
+	 * first one as dirty, setup an async extent, and immediately return
+	 * with the entire range locked but with nobody actually marked with
+	 * writeback.  So we can't just filemap_write_and_wait_range() and
+	 * expect it to work since it will just kick off a thread to do the
+	 * actual work.  So we need to call filemap_fdatawrite_range _again_
+	 * since it will wait on the page lock, which won't be unlocked until
+	 * after the pages have been marked as writeback and so we're good to go
+	 * from there.  We have to do this otherwise we'll miss the ordered
+	 * extents and that results in badness.  Please Josef, do not think you
+	 * know better and pull this out at some point in the future, it is
+	 * right and you are wrong.
+	 */
+	ret = filemap_fdatawrite_range(inode->i_mapping, start, end);
+	if (!ret && test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
+			     &BTRFS_I(inode)->runtime_flags))
+		ret = filemap_fdatawrite_range(inode->i_mapping, start, end);
+
+	return ret;
+}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 752ff18..be955481 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7052,14 +7052,7 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 			btrfs_put_ordered_extent(ordered);
 		} else {
 			/* Screw you mmap */
-			ret = filemap_fdatawrite_range(inode->i_mapping,
-						       lockstart,
-						       lockend);
-			if (!ret && test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-					     &BTRFS_I(inode)->runtime_flags))
-				ret = filemap_fdatawrite_range(inode->i_mapping,
-							       lockstart,
-							       lockend);
+			ret = btrfs_fdatawrite_range(inode, lockstart, lockend);
 			if (ret)
 				break;
 			ret = filemap_fdatawait_range(inode->i_mapping,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index ac734ec..1401b1a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -725,30 +725,10 @@ int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 	/* start IO across the range first to instantiate any delalloc
 	 * extents
 	 */
-	ret = filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
+	ret = btrfs_fdatawrite_range(inode, start, orig_end);
 	if (ret)
 		return ret;
-	/*
-	 * So with compression we will find and lock a dirty page and clear the
-	 * first one as dirty, setup an async extent, and immediately return
-	 * with the entire range locked but with nobody actually marked with
-	 * writeback.  So we can't just filemap_write_and_wait_range() and
-	 * expect it to work since it will just kick off a thread to do the
-	 * actual work.  So we need to call filemap_fdatawrite_range _again_
-	 * since it will wait on the page lock, which won't be unlocked until
-	 * after the pages have been marked as writeback and so we're good to go
-	 * from there.  We have to do this otherwise we'll miss the ordered
-	 * extents and that results in badness.  Please Josef, do not think you
-	 * know better and pull this out at some point in the future, it is
-	 * right and you are wrong.
-	 */
-	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-		     &BTRFS_I(inode)->runtime_flags)) {
-		ret = filemap_fdatawrite_range(inode->i_mapping, start,
-					       orig_end);
-		if (ret)
-			return ret;
-	}
+
 	ret = filemap_fdatawait_range(inode->i_mapping, start, orig_end);
 	if (ret)
 		return ret;
-- 
1.9.1

