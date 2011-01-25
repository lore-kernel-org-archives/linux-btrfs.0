From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: simplify our write path
Date: Tue, 25 Jan 2011 14:59:20 -0500
Message-ID: <1295985560-29958-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Our aio_write function is huge and kind of hard to follow at times.  So this
patch fixes this by breaking out the buffered and direct write paths out into
seperate functions so it's a little clearer what's going on.  I've also fixed
some wrong typing that we had and added the ability to handle getting an error
back from btrfs_set_extent_delalloc.  Tested this with xfstests and everything
came out fine.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |  384 ++++++++++++++++++++++++++++++-------------------------
 1 files changed, 208 insertions(+), 176 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a754865..c0f312a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -45,14 +45,14 @@
  * and be replaced with calls into generic code.
  */
 static noinline int btrfs_copy_from_user(loff_t pos, int num_pages,
-					 int write_bytes,
+					 size_t write_bytes,
 					 struct page **prepared_pages,
 					 struct iov_iter *i)
 {
 	size_t copied = 0;
+	size_t total_copied = 0;
 	int pg = 0;
 	int offset = pos & (PAGE_CACHE_SIZE - 1);
-	int total_copied = 0;
 
 	while (write_bytes > 0) {
 		size_t count = min_t(size_t,
@@ -116,13 +116,12 @@ static noinline void btrfs_drop_pages(struct page **pages, size_t num_pages)
  * this also makes the decision about creating an inline extent vs
  * doing real data extents, marking pages dirty and delalloc as required.
  */
-static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root,
-				   struct file *file,
-				   struct page **pages,
-				   size_t num_pages,
-				   loff_t pos,
-				   size_t write_bytes)
+static noinline int dirty_and_release_pages(struct btrfs_root *root,
+					    struct file *file,
+					    struct page **pages,
+					    size_t num_pages,
+					    loff_t pos,
+					    size_t write_bytes)
 {
 	int err = 0;
 	int i;
@@ -140,7 +139,8 @@ static noinline int dirty_and_release_pages(struct btrfs_trans_handle *trans,
 	end_of_last_block = start_pos + num_bytes - 1;
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
 					NULL);
-	BUG_ON(err);
+	if (err)
+		return err;
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = pages[i];
@@ -839,119 +839,32 @@ again:
 	return 0;
 }
 
-static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
-				    const struct iovec *iov,
-				    unsigned long nr_segs, loff_t pos)
+static noinline ssize_t __btrfs_buffered_write(struct file *file,
+					       struct iov_iter *i,
+					       loff_t pos)
 {
-	struct file *file = iocb->ki_filp;
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page *pinned[2];
 	struct page **pages = NULL;
-	struct iov_iter i;
-	loff_t *ppos = &iocb->ki_pos;
-	loff_t start_pos;
-	ssize_t num_written = 0;
-	ssize_t err = 0;
-	size_t count;
-	size_t ocount;
-	int ret = 0;
-	int nrptrs;
 	unsigned long first_index;
 	unsigned long last_index;
-	int will_write;
-	int buffered = 0;
-	int copied = 0;
-	int dirty_pages = 0;
-
-	will_write = ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
-		      (file->f_flags & O_DIRECT));
-
-	pinned[0] = NULL;
-	pinned[1] = NULL;
-
-	start_pos = pos;
-
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
-
-	mutex_lock(&inode->i_mutex);
-
-	err = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
-	if (err)
-		goto out;
-	count = ocount;
-
-	current->backing_dev_info = inode->i_mapping->backing_dev_info;
-	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
-	if (err)
-		goto out;
-
-	if (count == 0)
-		goto out;
-
-	err = file_remove_suid(file);
-	if (err)
-		goto out;
-
-	/*
-	 * If BTRFS flips readonly due to some impossible error
-	 * (fs_info->fs_state now has BTRFS_SUPER_FLAG_ERROR),
-	 * although we have opened a file as writable, we have
-	 * to stop this write operation to ensure FS consistency.
-	 */
-	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
-		err = -EROFS;
-		goto out;
-	}
-
-	file_update_time(file);
-	BTRFS_I(inode)->sequence++;
-
-	if (unlikely(file->f_flags & O_DIRECT)) {
-		num_written = generic_file_direct_write(iocb, iov, &nr_segs,
-							pos, ppos, count,
-							ocount);
-		/*
-		 * the generic O_DIRECT will update in-memory i_size after the
-		 * DIOs are done.  But our endio handlers that update the on
-		 * disk i_size never update past the in memory i_size.  So we
-		 * need one more update here to catch any additions to the
-		 * file
-		 */
-		if (inode->i_size != BTRFS_I(inode)->disk_i_size) {
-			btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
-			mark_inode_dirty(inode);
-		}
-
-		if (num_written < 0) {
-			ret = num_written;
-			num_written = 0;
-			goto out;
-		} else if (num_written == count) {
-			/* pick up pos changes done by the generic code */
-			pos = *ppos;
-			goto out;
-		}
-		/*
-		 * We are going to do buffered for the rest of the range, so we
-		 * need to make sure to invalidate the buffered pages when we're
-		 * done.
-		 */
-		buffered = 1;
-		pos += num_written;
-	}
+	size_t num_written = 0;
+	int nrptrs;
+	int ret;
 
-	iov_iter_init(&i, iov, nr_segs, count, num_written);
-	nrptrs = min((iov_iter_count(&i) + PAGE_CACHE_SIZE - 1) /
+	nrptrs = min((iov_iter_count(i) + PAGE_CACHE_SIZE - 1) /
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
 		     (sizeof(struct page *)));
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
 
-	/* generic_write_checks can change our pos */
-	start_pos = pos;
+	pinned[0] = NULL;
+	pinned[1] = NULL;
 
 	first_index = pos >> PAGE_CACHE_SHIFT;
-	last_index = (pos + iov_iter_count(&i)) >> PAGE_CACHE_SHIFT;
+	last_index = (pos + iov_iter_count(i)) >> PAGE_CACHE_SHIFT;
 
 	/*
 	 * there are lots of better ways to do this, but this code
@@ -962,47 +875,56 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		pinned[0] = grab_cache_page(inode->i_mapping, first_index);
 		if (!PageUptodate(pinned[0])) {
 			ret = btrfs_readpage(NULL, pinned[0]);
-			BUG_ON(ret);
+			if (ret)
+				return ret;
 			wait_on_page_locked(pinned[0]);
 		} else {
 			unlock_page(pinned[0]);
 		}
 	}
-	if ((pos + iov_iter_count(&i)) & (PAGE_CACHE_SIZE - 1)) {
+
+	if ((pos + iov_iter_count(i)) & (PAGE_CACHE_SIZE - 1)) {
 		pinned[1] = grab_cache_page(inode->i_mapping, last_index);
 		if (!PageUptodate(pinned[1])) {
 			ret = btrfs_readpage(NULL, pinned[1]);
-			BUG_ON(ret);
+			if (ret) {
+				if (pinned[0])
+					page_cache_release(pinned[0]);
+				return ret;
+			}
 			wait_on_page_locked(pinned[1]);
 		} else {
 			unlock_page(pinned[1]);
 		}
 	}
 
-	while (iov_iter_count(&i) > 0) {
+	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_CACHE_SIZE - 1);
-		size_t write_bytes = min(iov_iter_count(&i),
+		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
 		size_t num_pages = (write_bytes + PAGE_CACHE_SIZE - 1) >>
 					PAGE_CACHE_SHIFT;
+		size_t dirty_pages;
+		size_t copied;
 
 		WARN_ON(num_pages > nrptrs);
+again:
 		memset(pages, 0, sizeof(struct page *) * nrptrs);
 
 		/*
 		 * Fault pages before locking them in prepare_pages
 		 * to avoid recursive lock
 		 */
-		if (unlikely(iov_iter_fault_in_readable(&i, write_bytes))) {
+		if (unlikely(iov_iter_fault_in_readable(i, write_bytes))) {
 			ret = -EFAULT;
-			goto out;
+			break;
 		}
 
 		ret = btrfs_delalloc_reserve_space(inode,
 					num_pages << PAGE_CACHE_SHIFT);
 		if (ret)
-			goto out;
+			break;
 
 		ret = prepare_pages(root, file, pages, num_pages,
 				    pos, first_index, last_index,
@@ -1010,14 +932,21 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		if (ret) {
 			btrfs_delalloc_release_space(inode,
 					num_pages << PAGE_CACHE_SHIFT);
-			goto out;
+			break;
 		}
 
 		copied = btrfs_copy_from_user(pos, num_pages,
-					   write_bytes, pages, &i);
+					   write_bytes, pages, i);
 		dirty_pages = (copied + PAGE_CACHE_SIZE - 1) >>
 					PAGE_CACHE_SHIFT;
 
+		/*
+		 * If we had a short copy we need to release the excess delaloc
+		 * bytes we reserved.  We need to increment outstanding_extents
+		 * because btrfs_delalloc_release_space will decrement it, but
+		 * we still have an outstanding extent for the chunk we actually
+		 * managed to copy.
+		 */
 		if (num_pages > dirty_pages) {
 			if (copied > 0)
 				atomic_inc(
@@ -1028,43 +957,177 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 		}
 
 		if (copied > 0) {
-			dirty_and_release_pages(NULL, root, file, pages,
-						dirty_pages, pos, copied);
+			ret = dirty_and_release_pages(root, file, pages,
+						      dirty_pages, pos,
+						      copied);
+			if (ret) {
+				btrfs_delalloc_release_space(inode,
+					dirty_pages << PAGE_CACHE_SHIFT);
+				break;
+			}
 		}
 
 		btrfs_drop_pages(pages, num_pages);
 
-		if (copied > 0) {
-			if (will_write) {
-				filemap_fdatawrite_range(inode->i_mapping, pos,
-							 pos + copied - 1);
-			} else {
-				balance_dirty_pages_ratelimited_nr(
-							inode->i_mapping,
-							dirty_pages);
-				if (dirty_pages <
-				(root->leafsize >> PAGE_CACHE_SHIFT) + 1)
-					btrfs_btree_balance_dirty(root, 1);
-				btrfs_throttle(root);
-			}
+		cond_resched();
+
+		if (unlikely(copied == 0)) {
+			/*
+			 * If we were unable to copy any data at all, we must
+			 * fall back to a single segment length write.
+			 *
+			 * If we didn't fallback here, we could livelock
+			 * because not all segments in the iov can be copied at
+			 * once without a pagefault.
+			 */
+			write_bytes = min(nrptrs * (size_t)PAGE_CACHE_SIZE -
+					  offset,
+					  iov_iter_single_seg_count(i));
+			num_pages = (write_bytes + PAGE_CACHE_SIZE - 1) >>
+				PAGE_CACHE_SHIFT;
+			goto again;
 		}
 
+		balance_dirty_pages_ratelimited_nr(inode->i_mapping,
+						   dirty_pages);
+		if (dirty_pages < (root->leafsize >> PAGE_CACHE_SHIFT) + 1)
+			btrfs_btree_balance_dirty(root, 1);
+		btrfs_throttle(root);
+
 		pos += copied;
 		num_written += copied;
-
-		cond_resched();
 	}
-out:
-	mutex_unlock(&inode->i_mutex);
-	if (ret)
-		err = ret;
 
 	kfree(pages);
 	if (pinned[0])
 		page_cache_release(pinned[0]);
 	if (pinned[1])
 		page_cache_release(pinned[1]);
-	*ppos = pos;
+
+	return num_written ? num_written : ret;
+}
+
+static ssize_t __btrfs_direct_write(struct kiocb *iocb,
+				    const struct iovec *iov,
+				    unsigned long nr_segs, loff_t pos,
+				    loff_t *ppos, size_t count, size_t ocount)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = fdentry(file)->d_inode;
+	struct iov_iter i;
+	ssize_t written;
+	ssize_t written_buffered;
+	loff_t endbyte;
+	int err;
+
+	written = generic_file_direct_write(iocb, iov, &nr_segs, pos, ppos,
+					    count, ocount);
+
+	/*
+	 * the generic O_DIRECT will update in-memory i_size after the
+	 * DIOs are done.  But our endio handlers that update the on
+	 * disk i_size never update past the in memory i_size.  So we
+	 * need one more update here to catch any additions to the
+	 * file
+	 */
+	if (inode->i_size != BTRFS_I(inode)->disk_i_size) {
+		btrfs_ordered_update_i_size(inode, inode->i_size, NULL);
+		mark_inode_dirty(inode);
+	}
+
+	if (written < 0 || written == count)
+		return written;
+
+	pos += written;
+	count -= written;
+	iov_iter_init(&i, iov, nr_segs, count, written);
+	written_buffered = __btrfs_buffered_write(file, &i, pos);
+	if (written_buffered < 0) {
+		err = written_buffered;
+		goto out;
+	}
+	endbyte = pos + written_buffered - 1;
+	err = filemap_write_and_wait_range(file->f_mapping, pos, endbyte);
+	if (err)
+		goto out;
+	written += written_buffered;
+	*ppos = pos + written_buffered;
+	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_CACHE_SHIFT,
+				 endbyte >> PAGE_CACHE_SHIFT);
+out:
+	return written ? written : err;
+}
+
+static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
+				    const struct iovec *iov,
+				    unsigned long nr_segs, loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = fdentry(file)->d_inode;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	loff_t *ppos = &iocb->ki_pos;
+	ssize_t num_written = 0;
+	ssize_t err = 0;
+	size_t count, ocount;
+
+	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+
+	mutex_lock(&inode->i_mutex);
+
+	err = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
+	if (err) {
+		mutex_unlock(&inode->i_mutex);
+		goto out;
+	}
+	count = ocount;
+
+	current->backing_dev_info = inode->i_mapping->backing_dev_info;
+	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
+	if (err) {
+		mutex_unlock(&inode->i_mutex);
+		goto out;
+	}
+
+	if (count == 0) {
+		mutex_unlock(&inode->i_mutex);
+		goto out;
+	}
+
+	err = file_remove_suid(file);
+	if (err) {
+		mutex_unlock(&inode->i_mutex);
+		goto out;
+	}
+
+	/*
+	 * If BTRFS flips readonly due to some impossible error
+	 * (fs_info->fs_state now has BTRFS_SUPER_FLAG_ERROR),
+	 * although we have opened a file as writable, we have
+	 * to stop this write operation to ensure FS consistency.
+	 */
+	if (root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
+		mutex_unlock(&inode->i_mutex);
+		err = -EROFS;
+		goto out;
+	}
+
+	file_update_time(file);
+	BTRFS_I(inode)->sequence++;
+
+	if (unlikely(file->f_flags & O_DIRECT)) {
+		num_written = __btrfs_direct_write(iocb, iov, nr_segs,
+						   pos, ppos, count, ocount);
+	} else {
+		struct iov_iter i;
+
+		iov_iter_init(&i, iov, nr_segs, count, num_written);
+
+		num_written = __btrfs_buffered_write(file, &i, pos);
+		if (num_written > 0)
+			*ppos = pos + num_written;
+	}
+
+	mutex_unlock(&inode->i_mutex);
 
 	/*
 	 * we want to make sure fsync finds this change
@@ -1079,43 +1142,12 @@ out:
 	 * one running right now.
 	 */
 	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
-
-	if (num_written > 0 && will_write) {
-		struct btrfs_trans_handle *trans;
-
-		err = btrfs_wait_ordered_range(inode, start_pos, num_written);
-		if (err)
+	if (num_written > 0 || num_written == -EIOCBQUEUED) {
+		err = generic_write_sync(file, pos, num_written);
+		if (err < 0 && num_written > 0)
 			num_written = err;
-
-		if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
-			trans = btrfs_start_transaction(root, 0);
-			if (IS_ERR(trans)) {
-				num_written = PTR_ERR(trans);
-				goto done;
-			}
-			mutex_lock(&inode->i_mutex);
-			ret = btrfs_log_dentry_safe(trans, root,
-						    file->f_dentry);
-			mutex_unlock(&inode->i_mutex);
-			if (ret == 0) {
-				ret = btrfs_sync_log(trans, root);
-				if (ret == 0)
-					btrfs_end_transaction(trans, root);
-				else
-					btrfs_commit_transaction(trans, root);
-			} else if (ret != BTRFS_NO_LOG_SYNC) {
-				btrfs_commit_transaction(trans, root);
-			} else {
-				btrfs_end_transaction(trans, root);
-			}
-		}
-		if (file->f_flags & O_DIRECT && buffered) {
-			invalidate_mapping_pages(inode->i_mapping,
-			      start_pos >> PAGE_CACHE_SHIFT,
-			     (start_pos + num_written - 1) >> PAGE_CACHE_SHIFT);
-		}
 	}
-done:
+out:
 	current->backing_dev_info = NULL;
 	return num_written ? num_written : err;
 }
-- 
1.6.6.1

