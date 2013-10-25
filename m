Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58903 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3JYUPq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 16:15:46 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 779907C040A
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 14:15:45 -0600 (MDT)
Received: from CAS1.int.fusionio.com ([10.101.1.40]) by mx2.fusionio.com with ESMTP id D2EXEcGaFcG3CnwZ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 14:15:44 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: return an error from btrfs_wait_ordered_range
Date: Fri, 25 Oct 2013 16:15:42 -0400
Message-ID: <1382732142-11187-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed that if the free space cache has an error writing out it's data it
won't actually error out, it will just carry on.  This is because it doesn't
check the return value of btrfs_wait_ordered_range, which didn't actually return
anything.  So fix this in order to keep us from making free space cache look
valid when it really isnt.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file.c             | 66 ++++++++++++++++++++++++++-------------------
 fs/btrfs/free-space-cache.c |  9 +++++--
 fs/btrfs/inode.c            |  9 +++++--
 fs/btrfs/ordered-data.c     | 26 ++++++++++++------
 fs/btrfs/ordered-data.h     |  2 +-
 fs/btrfs/relocation.c       |  7 ++++-
 6 files changed, 78 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3591e8f..3c790ef 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1280,6 +1280,7 @@ again:
 		}
 		wait_on_page_writeback(pages[i]);
 	}
+	faili = num_pages - 1;
 	err = 0;
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
@@ -1298,8 +1299,10 @@ again:
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
 			}
-			btrfs_wait_ordered_range(inode, start_pos,
-						 last_pos - start_pos);
+			err = btrfs_wait_ordered_range(inode, start_pos,
+						       last_pos - start_pos);
+			if (err)
+				goto fail;
 			goto again;
 		}
 		if (ordered)
@@ -1808,8 +1811,13 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	atomic_inc(&root->log_batch);
 	full_sync = test_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 			     &BTRFS_I(inode)->runtime_flags);
-	if (full_sync)
-		btrfs_wait_ordered_range(inode, start, end - start + 1);
+	if (full_sync) {
+		ret = btrfs_wait_ordered_range(inode, start, end - start + 1);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+	}
 	atomic_inc(&root->log_batch);
 
 	/*
@@ -1875,27 +1883,20 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret != BTRFS_NO_LOG_SYNC) {
-		if (ret > 0) {
-			/*
-			 * If we didn't already wait for ordered extents we need
-			 * to do that now.
-			 */
-			if (!full_sync)
-				btrfs_wait_ordered_range(inode, start,
-							 end - start + 1);
-			ret = btrfs_commit_transaction(trans, root);
-		} else {
+		if (!ret) {
 			ret = btrfs_sync_log(trans, root);
-			if (ret == 0) {
+			if (!ret) {
 				ret = btrfs_end_transaction(trans, root);
-			} else {
-				if (!full_sync)
-					btrfs_wait_ordered_range(inode, start,
-								 end -
-								 start + 1);
-				ret = btrfs_commit_transaction(trans, root);
+				goto out;
 			}
 		}
+		if (!full_sync) {
+			ret = btrfs_wait_ordered_range(inode, start,
+						       end - start + 1);
+			if (ret)
+				goto out;
+		}
+		ret = btrfs_commit_transaction(trans, root);
 	} else {
 		ret = btrfs_end_transaction(trans, root);
 	}
@@ -2070,7 +2071,9 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			  ((offset + len - 1) >> PAGE_CACHE_SHIFT));
 	bool no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
 
-	btrfs_wait_ordered_range(inode, offset, len);
+	ret = btrfs_wait_ordered_range(inode, offset, len);
+	if (ret)
+		return ret;
 
 	mutex_lock(&inode->i_mutex);
 	/*
@@ -2139,8 +2142,12 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			btrfs_put_ordered_extent(ordered);
 		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
 				     lockend, &cached_state, GFP_NOFS);
-		btrfs_wait_ordered_range(inode, lockstart,
-					 lockend - lockstart + 1);
+		ret = btrfs_wait_ordered_range(inode, lockstart,
+					       lockend - lockstart + 1);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
 	}
 
 	path = btrfs_alloc_path();
@@ -2312,7 +2319,10 @@ static long btrfs_fallocate(struct file *file, int mode,
 	 * wait for ordered IO before we have any locks.  We'll loop again
 	 * below with the locks held.
 	 */
-	btrfs_wait_ordered_range(inode, alloc_start, alloc_end - alloc_start);
+	ret = btrfs_wait_ordered_range(inode, alloc_start,
+				       alloc_end - alloc_start);
+	if (ret)
+		goto out;
 
 	locked_end = alloc_end - 1;
 	while (1) {
@@ -2336,8 +2346,10 @@ static long btrfs_fallocate(struct file *file, int mode,
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
 			 */
-			btrfs_wait_ordered_range(inode, alloc_start,
-						 alloc_end - alloc_start);
+			ret = btrfs_wait_ordered_range(inode, alloc_start,
+						       alloc_end - alloc_start);
+			if (ret)
+				goto out;
 		} else {
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7fd48df..fa776bb 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1010,8 +1010,13 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	if (ret)
 		goto out;
 
-
-	btrfs_wait_ordered_range(inode, 0, (u64)-1);
+	ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
+	if (ret) {
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, 0, inode->i_size - 1,
+				 EXTENT_DIRTY | EXTENT_DELALLOC, 0, 0, NULL,
+				 GFP_NOFS);
+		goto out;
+	}
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
 	key.offset = offset;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ef08cbd..961ae6f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7254,7 +7254,9 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	 * outstanding dirty pages are on disk.
 	 */
 	count = iov_length(iov, nr_segs);
-	btrfs_wait_ordered_range(inode, offset, count);
+	ret = btrfs_wait_ordered_range(inode, offset, count);
+	if (ret)
+		return ret;
 
 	if (rw & WRITE) {
 		/*
@@ -7595,7 +7597,10 @@ static int btrfs_truncate(struct inode *inode)
 	u64 mask = root->sectorsize - 1;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 
-	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
+	ret = btrfs_wait_ordered_range(inode, inode->i_size & (~mask),
+				       (u64)-1);
+	if (ret)
+		return ret;
 
 	/*
 	 * Yes ladies and gentelment, this is indeed ugly.  The fact is we have
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 1a36a0c..bbb1a38 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -734,8 +734,9 @@ void btrfs_start_ordered_extent(struct inode *inode,
 /*
  * Used to wait on ordered extents across a large range of bytes.
  */
-void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
+int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 {
+	int ret = 0;
 	u64 end;
 	u64 orig_end;
 	struct btrfs_ordered_extent *ordered;
@@ -751,8 +752,9 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 	/* start IO across the range first to instantiate any delalloc
 	 * extents
 	 */
-	filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
-
+	ret = filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
+	if (ret)
+		return ret;
 	/*
 	 * So with compression we will find and lock a dirty page and clear the
 	 * first one as dirty, setup an async extent, and immediately return
@@ -768,10 +770,15 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 	 * right and you are wrong.
 	 */
 	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-		     &BTRFS_I(inode)->runtime_flags))
-		filemap_fdatawrite_range(inode->i_mapping, start, orig_end);
-
-	filemap_fdatawait_range(inode->i_mapping, start, orig_end);
+		     &BTRFS_I(inode)->runtime_flags)) {
+		ret = filemap_fdatawrite_range(inode->i_mapping, start,
+					       orig_end);
+		if (ret)
+			return ret;
+	}
+	ret = filemap_fdatawait_range(inode->i_mapping, start, orig_end);
+	if (ret)
+		return ret;
 
 	end = orig_end;
 	while (1) {
@@ -788,11 +795,14 @@ void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len)
 		}
 		btrfs_start_ordered_extent(inode, ordered, 1);
 		end = ordered->file_offset;
+		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
+			ret = -EIO;
 		btrfs_put_ordered_extent(ordered);
-		if (end == 0 || end == start)
+		if (ret || end == 0 || end == start)
 			break;
 		end--;
 	}
+	return ret;
 }
 
 /*
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 0c0b356..3982db1 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -180,7 +180,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 							 u64 file_offset);
 void btrfs_start_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry, int wait);
-void btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
+int btrfs_wait_ordered_range(struct inode *inode, u64 start, u64 len);
 struct btrfs_ordered_extent *
 btrfs_lookup_first_ordered_extent(struct inode * inode, u64 file_offset);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a945374..729c91e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4257,7 +4257,12 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 			rc->extents_found);
 
 		if (rc->stage == MOVE_DATA_EXTENTS && rc->found_file_extent) {
-			btrfs_wait_ordered_range(rc->data_inode, 0, (u64)-1);
+			ret = btrfs_wait_ordered_range(rc->data_inode, 0,
+						       (u64)-1);
+			if (ret) {
+				err = ret;
+				goto out;
+			}
 			invalidate_mapping_pages(rc->data_inode->i_mapping,
 						 0, -1);
 			rc->stage = UPDATE_DATA_PTRS;
-- 
1.8.3.1

