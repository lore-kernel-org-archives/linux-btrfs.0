Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48018 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932917AbcLGVhg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 16:37:36 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Jan Kara <jack@suse.cz>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
Date: Wed,  7 Dec 2016 13:45:08 -0800
Message-Id: <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has implemented DAX support for btrfs with nocow and single-device.

DAX is developed for block devices that are memory-like in order to avoid
double buffer in both page cache and the storage, so DAX can performs reads and
writes directly to the storage device, and for those who prefer to using
filesystem, filesystem dax support can help to map the storage into userspace
for file-mapping.

Since I haven't figure out how to map multiple devices to userspace without
pagecache, this DAX support is only for single-device, and I don't think
DAX(Direct Access) can work with cow, this is limited to nocow case.  I made
this by setting nodatacow in dax mount option.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/Kconfig |   1 +
 fs/btrfs/ctree.h |   5 +
 fs/btrfs/file.c  | 214 ++++++++++++++++++---
 fs/btrfs/inode.c | 576 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/ioctl.c |  20 +-
 5 files changed, 780 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 80e9c18..297d7509 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -9,6 +9,7 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
+	select FS_IOMAP
 
 	help
 	  Btrfs is a general purpose copy-on-write filesystem with extents,
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e54c6e6..a80b65d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -38,6 +38,8 @@
 #include <linux/security.h>
 #include <linux/sizes.h>
 #include <linux/dynamic_debug.h>
+#include <linux/iomap.h>
+#include <linux/dax.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -3081,6 +3083,8 @@ void btrfs_extent_item_to_extent_map(struct inode *inode,
 				     struct extent_map *em);
 
 /* inode.c */
+extern struct iomap_ops btrfs_iomap_ops;
+
 struct btrfs_delalloc_work {
 	struct inode *inode;
 	int delay_iput;
@@ -3096,6 +3100,7 @@ void btrfs_wait_and_free_delalloc_work(struct btrfs_delalloc_work *work);
 struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
 					   size_t pg_offset, u64 start, u64 len,
 					   int create);
+
 noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
 			      u64 *ram_bytes);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 06e55e8..2d6ee1e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1782,22 +1782,54 @@ static ssize_t btrfs_file_direct_write(struct kiocb *iocb,
 	return written ? written : err;
 }
 
-static void update_time_for_write(struct inode *inode)
+static ssize_t btrfs_file_dax_write(struct kiocb *iocb,
+				    struct iov_iter *from)
 {
-	struct timespec now;
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	ssize_t ret;
 
-	if (IS_NOCMTIME(inode))
-		return;
+	inode_lock(inode);
+	ret = btrfs_file_write_check(iocb, from);
+	if (ret)
+		goto out;
 
-	now = current_time(inode);
-	if (!timespec_equal(&inode->i_mtime, &now))
-		inode->i_mtime = now;
+	ret = iomap_dax_rw(iocb, from, &btrfs_iomap_ops);
+	if (ret > 0 && iocb->ki_pos > i_size_read(inode)) {
+		struct btrfs_trans_handle *trans = NULL;
+		ssize_t err;
 
-	if (!timespec_equal(&inode->i_ctime, &now))
-		inode->i_ctime = now;
+		trans = btrfs_start_transaction(root, 1);
+		if (IS_ERR(trans)) {
+			/* lets bail out and pretend the write failed */
+			ret = PTR_ERR(trans);
+			goto out;
+		}
 
-	if (IS_I_VERSION(inode))
-		inode_inc_iversion(inode);
+		/* iocb->ki_pos has been updated to new size in iomap_dax_rw. */
+		i_size_write(inode, iocb->ki_pos);
+
+		/* update i_disksize accordingly. */
+		btrfs_ordered_update_i_size(inode, iocb->ki_pos, NULL);
+
+		err = btrfs_update_inode_fallback(trans, root, inode);
+		btrfs_end_transaction(trans, root);
+		if (err) {
+			/* lets bail out and pretend the write failed */
+			ret = err;
+			goto out;
+		}
+
+		/*
+		 * no pagecache involved, thus no need to call
+		 * pagecache_isize_extended
+		 */
+	}
+
+out:
+	inode_unlock(inode);
+	return ret;
 }
 
 static ssize_t btrfs_file_buffered_write(struct kiocb *iocb,
@@ -1830,6 +1862,24 @@ static ssize_t btrfs_file_buffered_write(struct kiocb *iocb,
 	return ret;
 }
 
+static void update_time_for_write(struct inode *inode)
+{
+	struct timespec now;
+
+	if (IS_NOCMTIME(inode))
+		return;
+
+	now = current_time(inode);
+	if (!timespec_equal(&inode->i_mtime, &now))
+		inode->i_mtime = now;
+
+	if (!timespec_equal(&inode->i_ctime, &now))
+		inode->i_ctime = now;
+
+	if (IS_I_VERSION(inode))
+		inode_inc_iversion(inode);
+}
+
 static ssize_t btrfs_file_write_check(struct kiocb *iocb,
 				      struct iov_iter *from)
 {
@@ -1838,10 +1888,7 @@ static ssize_t btrfs_file_write_check(struct kiocb *iocb,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	ssize_t err;
 	loff_t pos;
-	size_t count;
 	loff_t oldsize;
-	u64 start_pos;
-	u64 end_pos;
 
 	err = generic_write_checks(iocb, from);
 	if (err <= 0)
@@ -1860,12 +1907,16 @@ static ssize_t btrfs_file_write_check(struct kiocb *iocb,
 	update_time_for_write(inode);
 
 	pos = iocb->ki_pos;
-	count = iov_iter_count(from);
-	start_pos = round_down(pos, root->sectorsize);
 	oldsize = i_size_read(inode);
-	if (start_pos > oldsize) {
+	/*
+	 * Use pos instead of round_down(pos, root->sectorsize) to ensure that
+	 * we don't expose stale data if @pos is in the middle of a block.
+	 */
+	if (pos > oldsize) {
+		u64 end_pos;
 		/* Expand hole size to cover write data, preventing empty gap */
-		end_pos = round_up(pos + count, root->sectorsize);
+		end_pos = round_up(pos + iov_iter_count(from),
+				   root->sectorsize);
 		err = btrfs_cont_expand(inode, oldsize, end_pos);
 		if (err)
 			return err;
@@ -1898,9 +1949,14 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	if (sync)
 		atomic_inc(&BTRFS_I(inode)->sync_writers);
 
-	if (iocb->ki_flags & IOCB_DIRECT) {
+	if (IS_DAX(inode)) {
+		num_written = btrfs_file_dax_write(iocb, from);
+		if (num_written == -EAGAIN)
+			goto buffered;
+	} else if (iocb->ki_flags & IOCB_DIRECT) {
 		num_written = btrfs_file_direct_write(iocb, from);
 	} else {
+buffered:
 		num_written = btrfs_file_buffered_write(iocb, from);
 	}
 
@@ -1921,6 +1977,47 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	return num_written;
 }
 
+static noinline ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(iocb->ki_filp);
+	ssize_t ret;
+
+	if (!iov_iter_count(to))
+		return 0;	/* skip atime */
+
+	inode_lock_shared(inode);
+	ret = iomap_dax_rw(iocb, to, &btrfs_iomap_ops);
+	inode_unlock_shared(inode);
+
+	/*
+	 * update atime.
+	 */
+	file_accessed(file);
+
+	return ret;
+}
+
+static noinline ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	ssize_t ret;
+
+	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
+		return -EROFS;
+
+	if (IS_DAX(inode)) {
+		ret = btrfs_file_dax_read(iocb, to);
+		if (ret == -EAGAIN)
+			goto buffered;
+	} else {
+buffered:
+		ret = generic_file_read_iter(iocb, to);
+	}
+	return ret;
+}
+
 int btrfs_release_file(struct inode *inode, struct file *filp)
 {
 	if (filp->private_data)
@@ -2185,10 +2282,81 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	return ret > 0 ? -EIO : ret;
 }
 
+static int btrfs_filemap_page_mkwrite(struct vm_area_struct *vma,
+				      struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	int ret;
+
+	sb_start_pagefault(inode->i_sb);
+	ret = file_update_time(vma->vm_file);
+	if (ret) {
+		if (ret == -ENOMEM)
+			ret = VM_FAULT_OOM;
+		else
+			ret = VM_FAULT_SIGBUS;
+		goto out;
+	}
+
+	if (IS_DAX(inode))
+		ret = iomap_dax_fault(vma, vmf, &btrfs_iomap_ops);
+	else
+		ret = btrfs_page_mkwrite(vma, vmf);
+
+out:
+	sb_end_pagefault(inode->i_sb);
+	return ret;
+}
+
+static int btrfs_filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	int ret;
+
+	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
+		return btrfs_filemap_page_mkwrite(vma, vmf);
+
+	if (IS_DAX(inode))
+		ret = iomap_dax_fault(vma, vmf, &btrfs_iomap_ops);
+	else
+		ret = filemap_fault(vma, vmf);
+
+	return ret;
+}
+
+static int btrfs_filemap_pfn_mkwrite(struct vm_area_struct *vma,
+				     struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vma->vm_file);
+	struct super_block *sb = inode->i_sb;
+	loff_t size;
+	int ret = VM_FAULT_NOPAGE;
+
+	sb_start_pagefault(sb);
+	file_update_time(vma->vm_file);
+
+	/*
+	 * How to serialise against truncate/hole punch similar to page_mkwrite?
+	 * For truncate, we firstly update isize and then truncate pagecache in
+	 * order to avoid race against page fault.
+	 * For punch_hole, we use lock_extent and truncate pagecache.
+	 */
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		ret = VM_FAULT_SIGBUS;
+	else
+		ret = dax_pfn_mkwrite(vma, vmf);
+
+	sb_end_pagefault(sb);
+	return ret;
+}
+
 static const struct vm_operations_struct btrfs_file_vm_ops = {
-	.fault		= filemap_fault,
+	.fault		= btrfs_filemap_fault,
+//	.pmd_fault	= btrfs_filemap_pmd_fault,
 	.map_pages	= filemap_map_pages,
-	.page_mkwrite	= btrfs_page_mkwrite,
+	.page_mkwrite	= btrfs_filemap_page_mkwrite,
+	.pfn_mkwrite	= btrfs_filemap_pfn_mkwrite,
 };
 
 static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
@@ -2200,6 +2368,8 @@ static int btrfs_file_mmap(struct file	*filp, struct vm_area_struct *vma)
 
 	file_accessed(filp);
 	vma->vm_ops = &btrfs_file_vm_ops;
+	if (IS_DAX(file_inode(filp)))
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 
 	return 0;
 }
@@ -3014,7 +3184,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int whence)
 
 const struct file_operations btrfs_file_operations = {
 	.llseek		= btrfs_file_llseek,
-	.read_iter      = generic_file_read_iter,
+	.read_iter      = btrfs_file_read_iter,
 	.splice_read	= generic_file_splice_read,
 	.write_iter	= btrfs_file_write_iter,
 	.mmap		= btrfs_file_mmap,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1cf8e20..227ee4e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4727,6 +4727,23 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
 
+	/*
+	 * for dax inode, this zeroout is necessary because flushing pages
+	 * doesn't work for dax inode.
+	 */
+	if (IS_DAX(inode)) {
+
+		if (front) {
+			return iomap_zero_range(inode, from - offset, offset,
+						NULL, &btrfs_iomap_ops);
+		} else {
+			if (!len)
+				len = blocksize - offset;
+			return iomap_zero_range(inode, from, len, NULL,
+						&btrfs_iomap_ops);
+		}
+	}
+
 	ret = btrfs_delalloc_reserve_space(inode,
 			round_down(from, blocksize), blocksize);
 	if (ret)
@@ -5081,6 +5098,17 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 				btrfs_abort_transaction(trans, err);
 			btrfs_end_transaction(trans, root);
 		}
+
+		if (!ret) {
+			/*
+			 * This is required by only truncating down dax inode,
+			 * non-dax inode can buffer read the end page and set
+			 * all zero beyond isize, DIO read will fallback to
+			 * buffered read thanks to unalignment sanity check.
+			 */
+			if (IS_DAX(inode))
+				ret = btrfs_truncate_block(inode, newsize, 0, 0);
+		}
 	}
 
 	return ret;
@@ -6304,8 +6332,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	btrfs_inherit_iflags(inode, dir);
-
 	if (S_ISREG(mode)) {
 		if (btrfs_test_opt(root->fs_info, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
@@ -6314,6 +6340,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 				BTRFS_INODE_NODATASUM;
 	}
 
+	btrfs_inherit_iflags(inode, dir);
+
 	inode_tree_add(inode);
 
 	trace_btrfs_inode_new(inode);
@@ -7661,6 +7689,508 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
 	}
 }
 
+/**
+ * btrfs_issue_zeroout - zeroout the content of the underlying device
+ * @fs_info:	the global btrfs_fs_info
+ * @start:	btrfs specific offset(bytenr)
+ * @len:	IO length
+ *
+ * This maps the IO range to the underlying device and zeroout the content.
+ *
+ * Return 0 for success, otherwise return errors.
+ */
+static noinline int btrfs_issue_zeroout(struct btrfs_fs_info *fs_info, u64 start,
+					u64 len)
+{
+	struct btrfs_bio *bbio = NULL;
+	struct btrfs_bio_stripe *stripe = NULL;
+	u64 map_length = len;
+	int rw;
+	int ret;
+
+	rw = REQ_OP_WRITE;
+	map_length = len;
+
+	ret = btrfs_map_block(fs_info, rw, start, &map_length, &bbio, 0);
+	if (ret)
+		return ret;
+
+	/* we assume that dax uses only one device. */
+	ASSERT(bbio->num_stripes == 1);
+	stripe = &bbio->stripes[0];
+
+	/* zero out the extent */
+	/*
+	 * without REQ_OP_DISCARD, stripe->length is not set, thus use len
+	 * instead.
+	 */
+	ret = blkdev_issue_zeroout(stripe->dev->bdev,
+				   stripe->physical >> 9,
+				   len >> 9,
+				   GFP_NOFS, true);
+	btrfs_put_bbio(bbio);
+
+	return ret;
+}
+
+/**
+ * btrfs_new_extent_dax - create file extent (metadata) for IO
+ * @inode:	inode
+ * @start:	aligned file offset
+ * @len:	aligned IO length
+ *
+ * This allocates a new file extent for the IO range and inserts it to fs/file
+ * tree.  This also does zeroout extent before insertion in order to avoid
+ * exposing stale data.
+ *
+ * Return 0 for success, otherwise return errors.
+ */
+static noinline struct extent_map *btrfs_new_extent_dax(struct inode *inode,
+							u64 start, u64 len)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans = NULL;
+	struct extent_map *em = NULL;
+	struct btrfs_key ins;
+	u64 alloc_hint;
+	bool reserved_extent = false;
+	int ret;
+
+	/*
+	 * reserve data space and metadata space seperately, in order to keep
+	 * it simple, we're not going to use btrfs_reserve_metadata_space to
+	 * avoid playing with outstanding extent etc.
+	 */
+	ret = btrfs_check_data_free_space(inode, start, len);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/*
+	 * 2 is to update fs tree with new extent and inode ltem.
+	 * Besides inode disk size, we also need update inode for inode
+	 * nbytes and last_trans, etc.
+	 */
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		goto out;
+	}
+
+
+	alloc_hint = get_extent_allocation_hint(inode, start, len);
+	ret = btrfs_reserve_extent(root, len, len, root->sectorsize, 0,
+				   alloc_hint, &ins, 1,
+				   0 /* We don't use delalloc here */ );
+	if (ret)
+		goto out;
+	reserved_extent = true;
+
+
+	ASSERT(len >= ins.offset);
+	if (len != ins.offset) {
+		/*
+		 * Since len has been adjusted shorter, free the reserved
+		 * data space.
+		 * This is for btrfs_check_data_free_space.
+		 */
+		btrfs_free_reserved_data_space(inode, start + ins.offset,
+					       len - ins.offset);
+		len = min_t(u64, len, ins.offset);
+	}
+
+	em = create_pinned_em(inode, start, len, start, ins.objectid,
+			      len, len, len, 0);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		em = NULL;
+		goto out;
+	}
+	/* zeroout the newly allocated extent */
+	ret = btrfs_issue_zeroout(BTRFS_I(inode)->root->fs_info,
+				  em->block_start, len);
+	if (ret)
+		goto out;
+
+	ret = insert_reserved_file_extent(trans, inode,
+					  start, /* file_pos */
+					  ins.objectid, /* disk_bytenr */
+					  len, /* disk_num_bytes */
+					  len, /* num_bytes */
+					  len, /* ram_bytes */
+					  0, /* compression */
+					  0, /* encryption */
+					  0, /* other_encoding */
+					  BTRFS_FILE_EXTENT_REG);
+	unpin_extent_cache(&BTRFS_I(inode)->extent_tree, start, len, trans->transid);
+
+	/*
+	 * inc has been done in btrfs_reserve_extent.
+	 * Here we don't use ordered extent, but we've inserted file extent
+	 * so that relocate_block_group will get a consistent fs/file tree.
+	 */
+	btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
+	if (ret)
+		goto out;
+
+	ret = btrfs_update_inode_fallback(trans, root, inode);
+
+out:
+	if (trans)
+		btrfs_end_transaction(trans, root);
+
+	if (ret) {
+		/* this is for btrfs_check_data_free_space.  */
+		btrfs_free_reserved_data_space(inode, start, len);
+
+		/* this is for btrfs_reserve_extent */
+		if (reserved_extent)
+			btrfs_free_reserved_extent(root, ins.objectid, ins.offset, 0);
+
+		if (em) {
+			free_extent_map(em);
+			btrfs_drop_extent_cache(inode, start, start + len - 1, 0);
+		}
+
+		em = ERR_PTR(ret);
+	}
+
+	return em;
+}
+
+/**
+ * btrfs_apply_nocow_or_prealloc_extent - apply IO on existing/prealloc extent
+ * @inode:	inode
+ * @em_ret:	extent map for return
+ * @start:	file offset
+ * @len_ret:	IO length for return
+ *
+ * This checks if the IO range covers any shared extent, if not, apply
+ * overwrite on existing/prealloc extent (prealloc extent needs to be converted
+ * to regular extent before applying overwrite).
+ *
+ * Return 0 for success, otherwise return error.
+ */
+static noinline int
+btrfs_apply_nocow_or_prealloc_extent(struct inode *inode, struct extent_map **em_ret,
+				     u64 start, u64 *len_ret)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_map *em_insert = NULL;
+	struct extent_map *em = NULL;
+	struct btrfs_trans_handle *trans = NULL;
+	u64 block_start;
+	u64 orig_start;
+	u64 orig_block_len;
+	u64 ram_bytes;
+	u64 len;
+	int ret;
+
+	em = *em_ret;
+	len = *len_ret;
+
+	block_start = em->block_start + (start - em->start);
+	ASSERT(IS_ALIGNED(len, PAGE_SIZE));
+	ASSERT(len >= PAGE_SIZE);
+
+	if (can_nocow_extent(inode, start, &len, &orig_start,
+			     &orig_block_len, &ram_bytes) != 1) {
+		/* This has been shared, however dax cannot handle this. */
+		btrfs_err_rl(root->fs_info, "Ooops, dax inode %llu has shared extent!\n", btrfs_ino(inode));
+		return -EIO;
+	}
+
+	/*
+	 * if it is a non shared extent and non-prealloc extent,
+	 * we're good to return and do overwrite.
+	 */
+	if (!test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
+		return 0;
+	}
+
+	/* now we have a prealloc extent to fill */
+	btrfs_inc_nocow_writers(root->fs_info, block_start);
+
+	/*
+	 * we may change @len if prealloc extent length is
+	 * smaller than @len.
+	 */
+	ASSERT(IS_ALIGNED(len, PAGE_SIZE));
+	ASSERT(len >= PAGE_SIZE);
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		btrfs_err_rl(root->fs_info, "start_transaction error %d inode %llu start %llu len %llu\n", ret, btrfs_ino(inode), start, len);
+		goto out;
+	}
+
+	em_insert = create_pinned_em(inode, start, len,
+				     orig_start,
+				     block_start, len,
+				     orig_block_len,
+				     ram_bytes,
+				     BTRFS_ORDERED_PREALLOC);
+	if (em_insert && IS_ERR(em_insert)) {
+		ret = PTR_ERR(em_insert);
+		btrfs_err_rl(root->fs_info, "create_pinned_em error %d inode %llu start %llu len %llu\n", ret, btrfs_ino(inode), start, len);
+		goto out;
+	}
+
+	free_extent_map(em);
+	em = em_insert;
+	ASSERT(start == em->start);
+
+	ret = btrfs_issue_zeroout(BTRFS_I(inode)->root->fs_info,
+				  em->block_start, len);
+	if (ret)
+		goto out;
+
+	/*
+	 * This takes care of
+	 * - splitting extents
+	 * - convert extent from prealloc to REG.
+	 */
+	ret = btrfs_mark_extent_written(trans, inode, start,
+					start + len);
+
+	unpin_extent_cache(&BTRFS_I(inode)->extent_tree, start,
+			   len, trans->transid);
+
+	if (ret < 0) {
+		btrfs_err_rl(root->fs_info, "mark_extent error %d inode %llu start %llu len %llu\n", ret, btrfs_ino(inode), start, len);
+		goto out;
+	}
+	*em_ret = em;
+	*len_ret = len;
+
+out:
+	if (ret) {
+		free_extent_map(em);
+		btrfs_drop_extent_cache(inode, start,
+					start + len - 1, 0);
+	}
+	if (trans)
+		btrfs_end_transaction(trans, root);
+
+	btrfs_dec_nocow_writers(root->fs_info, block_start);
+	return ret;
+}
+
+/**
+ * btrfs_em_to_iomap - convert em to iomap
+ * @fs_info:	the global btrfs_fs_info
+ * @start:	file offset
+ * @len:	IO length
+ * @em:		extent map which contains mapping info.
+ * @create:	flag of read/write
+ * @iomap:	IO mapping
+ *
+ * This maps from em's filesystem specific offset(bytenr) to disk offset of the
+ * underlying device that is required by @iomap.
+ *
+ * Return 0 for success, otherwise return error.
+ */
+static int btrfs_em_to_iomap(struct btrfs_fs_info *fs_info, u64 start, u64 len,
+			     struct extent_map *em, int create,
+			     struct iomap *iomap)
+{
+	struct btrfs_bio *bbio = NULL;
+	struct btrfs_bio_stripe *stripe = NULL;
+	u64 logical;
+	u64 map_length;
+	int rw;
+	int ret;
+
+	if (create)
+		rw = REQ_OP_WRITE;
+	else
+		rw = REQ_OP_READ;
+
+	logical = em->block_start + (start - em->start);
+	map_length = em->len;
+
+	/*
+	 * btrfs_map_block needs a btrfs logical bytenr,
+	 * not sector off.
+	 */
+	ret = btrfs_map_block(fs_info, rw, logical, &map_length, &bbio, 0);
+	if (ret)
+		return ret;
+
+	/* we assume that dax uses only one device. */
+	ASSERT(bbio->num_stripes == 1);
+	stripe = &bbio->stripes[0];
+
+	iomap->flags = 0;
+	iomap->bdev = stripe->dev->bdev;
+	iomap->type = IOMAP_MAPPED;
+	iomap->offset = start;
+	/* this requires sector */
+	iomap->blkno = stripe->physical >> 9;
+	iomap->length = len;
+
+	btrfs_put_bbio(bbio);
+	return 0;
+}
+
+/**
+ * btrfs_get_blocks_dax_fault - map file offset to disk offset
+ * @inode:	inode
+ * @start:	aligned file offset
+ * @len:	aligned IO length
+ * @iomap:	IO mapping
+ * @create:	flag of read/write
+ *
+ * This function provides mapping from file offset to offset of directly mapped
+ * persistent memory for IO operations including mmap.
+ *
+ * Return 0 for success, otherwise return error.
+ */
+static noinline int
+btrfs_get_blocks_dax_fault(struct inode *inode, u64 start, u64 len,
+			   struct iomap *iomap, int create)
+{
+	u64 lockstart, lockend;
+	struct extent_state *cached_state = NULL;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct extent_map *em;
+	int ret = 0;
+
+	if (!create && start >= i_size_read(inode)) {
+		return 0;
+	}
+
+	lockstart = start;
+	lockend = start + len - 1;
+
+	ASSERT(IS_ALIGNED(start, PAGE_SIZE));
+	ASSERT(IS_ALIGNED(start, root->sectorsize));
+	ASSERT(len >= PAGE_SIZE);
+
+	ASSERT(!!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) == 1);
+	ASSERT(!!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) == 1);
+
+	/* dax inode doesn't have ordered extent. */
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, &cached_state);
+
+	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		em = NULL;
+		goto out;
+	}
+
+	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) ||
+	    em->block_start == EXTENT_MAP_INLINE) {
+		/* Fallback to buffered. */
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	if (!create &&
+	    (em->block_start == EXTENT_MAP_HOLE ||
+	     test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
+		iomap->flags = 0;
+
+		if (em->block_start == EXTENT_MAP_HOLE)
+			iomap->type = IOMAP_HOLE;
+		else if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+			iomap->type = IOMAP_UNWRITTEN;
+
+		iomap->offset = start;
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->length = 1 << inode->i_blkbits;
+
+		goto out;
+	}
+
+	if (!create) {
+		len = min(len, em->len - (start - em->start));
+		goto map_block;
+	}
+
+	/* We make sure that dax inode is nodatacow */
+	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
+	    (em->block_start != EXTENT_MAP_HOLE)) {
+		/* prealloc minimum size is blocksize */
+		len = min_t(u64, len, em->len - (start - em->start));
+
+		/*
+		 * em may be merged in em tree, which means this em contains
+		 * two or more contiguous extents, but we search and process
+		 * file extent one by one, so em and len may be changed in
+		 * the following function.
+		 */
+		ret = btrfs_apply_nocow_or_prealloc_extent(inode, &em,
+							   start, &len);
+		if (ret) {
+			/*
+			 * em has been freed inside
+			 * btrfs_apply_nocow_or_prealloc_extent.
+			 */
+			em = NULL;
+			goto out;
+		}
+
+		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
+			ASSERT(len == em->len);
+		goto map_block;
+	}
+
+	ASSERT(em->block_start == EXTENT_MAP_HOLE);
+	if (em->block_start == EXTENT_MAP_HOLE) {
+		/*
+		 * |-------hole--------||------extent------|
+		 *      |----range to write----|
+		 * the range should be splitted to two part, the first one
+		 * will be new allocated extent, the rest will be overwriting
+		 * on the existing extent because of nocow that dax implies.
+		 *
+		 * The above can happen because DAX io can be unaligned to
+		 * blocksize, so be careful to not zero out the existing
+		 * block that (start+len) belongs to because it can end up
+		 * _data loss of the existing block_.
+		 * Note that (start + len) here is aligned but the actual
+		 * (start + len) of IO may not.
+		 */
+		len = min_t(u64, extent_map_end(em) - start, len);
+
+		/*
+		 * em->len may NOT be AGIGN to PAGE_SIZE/sectorsize if a hole
+		 * extent was created by find_first_non_hole in
+		 * btrfs_punch_hole.
+		 */
+		len = ALIGN(len, root->sectorsize);
+
+		ASSERT(IS_ALIGNED(len, PAGE_SIZE));
+		free_extent_map(em);
+
+		em = btrfs_new_extent_dax(inode, start, len);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			em = NULL;
+			goto out;
+		}
+		ASSERT(start == em->start);
+		len = min_t(u64, len, em->len - (start - em->start));
+		ASSERT(IS_ALIGNED(len, PAGE_SIZE));
+		iomap->flags = IOMAP_F_NEW;
+	}
+
+map_block:
+	ret = btrfs_em_to_iomap(root->fs_info, start, len, em, create, iomap);
+
+out:
+	free_extent_map(em);
+
+	ASSERT(lockstart < lockend);
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend, &cached_state, GFP_NOFS);
+
+	return ret;
+}
+
 static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
@@ -8995,7 +9525,6 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	unsigned long zero_start;
 	loff_t size;
 	int ret;
-	int reserved = 0;
 	u64 reserved_space;
 	u64 page_start;
 	u64 page_end;
@@ -9003,7 +9532,6 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	reserved_space = PAGE_SIZE;
 
-	sb_start_pagefault(inode->i_sb);
 	page_start = page_offset(page);
 	page_end = page_start + PAGE_SIZE - 1;
 	end = page_end;
@@ -9018,21 +9546,16 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 */
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
 					   reserved_space);
-	if (!ret) {
-		ret = file_update_time(vma->vm_file);
-		reserved = 1;
-	}
 	if (ret) {
 		if (ret == -ENOMEM)
 			ret = VM_FAULT_OOM;
 		else /* -ENOSPC, -EIO, etc */
 			ret = VM_FAULT_SIGBUS;
-		if (reserved)
-			goto out;
 		goto out_noreserve;
 	}
 
 	ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
+
 again:
 	lock_page(page);
 	size = i_size_read(inode);
@@ -9119,14 +9642,11 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 out_unlock:
 	if (!ret) {
-		sb_end_pagefault(inode->i_sb);
 		return VM_FAULT_LOCKED;
 	}
 	unlock_page(page);
-out:
 	btrfs_delalloc_release_space(inode, page_start, reserved_space);
 out_noreserve:
-	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 
@@ -10576,6 +11096,36 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 
 }
 
+static noinline int btrfs_file_iomap_begin(struct inode *inode, loff_t offset,
+					   loff_t length, unsigned flags,
+					   struct iomap *iomap)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+	u64 start;
+	u64 len;
+
+	start = round_down(offset, root->sectorsize);
+	len = ALIGN(length, root->sectorsize);
+
+	ret = btrfs_get_blocks_dax_fault(inode, start, len, iomap, flags &
+					 IOMAP_WRITE);
+
+	return ret;
+}
+
+static noinline int btrfs_file_iomap_end(struct inode *inode, loff_t offset,
+					 loff_t length, ssize_t written,
+					 unsigned flags, struct iomap *iomap)
+{
+	return 0;
+}
+
+struct iomap_ops btrfs_iomap_ops = {
+	.iomap_begin		= btrfs_file_iomap_begin,
+	.iomap_end		= btrfs_file_iomap_end,
+};
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab30d88..605cbc4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -152,8 +152,23 @@ void btrfs_update_iflags(struct inode *inode)
 	if (ip->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
 
+	/*
+	 * Do not set DAX flag if
+	 *   a) not with dax mount option or
+	 *   b) not a regular file or
+	 *   c) not a free space inode or
+	 *   d) not with nodatacow flag or
+	 *   e) with compress flag
+	 */
+	if (btrfs_test_opt(ip->root->fs_info, DAX) &&
+	    S_ISREG(inode->i_mode) &&
+	    !btrfs_is_free_space_inode(inode) &&
+	    (ip->flags & BTRFS_INODE_NODATACOW) &&
+	    !(ip->flags & BTRFS_INODE_COMPRESS))
+		new_fl |= S_DAX;
+
 	set_mask_bits(&inode->i_flags,
-		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
+		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC | S_DAX,
 		      new_fl);
 }
 
@@ -3893,6 +3908,9 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	    src->i_sb != inode->i_sb)
 		return -EXDEV;
 
+	if (IS_DAX(inode))
+		return -EINVAL;
+
 	/* don't make the dst file partly checksummed */
 	if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
 	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
-- 
2.5.5

