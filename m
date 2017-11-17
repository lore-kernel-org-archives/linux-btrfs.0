Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161095AbdKQRpN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:13 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 81664ADF4
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:11 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 5/8] btrfs: use iomap to perform buffered writes
Date: Fri, 17 Nov 2017 11:44:51 -0600
Message-Id: <20171117174456.13393-6-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This eliminates all page related code.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/btrfs_inode.h |   4 +-
 fs/btrfs/file.c        | 488 ++++++++++++++++++-------------------------------
 2 files changed, 185 insertions(+), 307 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index eccadb5f62a5..2c2bc5fd5cc9 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -21,7 +21,7 @@
 
 #include <linux/hash.h>
 #include "extent_map.h"
-#include "extent_io.h"
+#include "iomap.h"
 #include "ordered-data.h"
 #include "delayed-inode.h"
 
@@ -207,6 +207,8 @@ struct btrfs_inode {
 	 */
 	struct rw_semaphore dio_sem;
 
+	struct btrfs_iomap *b_iomap;
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 876c2acc2a71..b7390214ef3a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -405,79 +405,6 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
-/* simple helper to fault in pages and copy.  This should go away
- * and be replaced with calls into generic code.
- */
-static noinline int btrfs_copy_from_user(loff_t pos, size_t write_bytes,
-					 struct page **prepared_pages,
-					 struct iov_iter *i)
-{
-	size_t copied = 0;
-	size_t total_copied = 0;
-	int pg = 0;
-	int offset = pos & (PAGE_SIZE - 1);
-
-	while (write_bytes > 0) {
-		size_t count = min_t(size_t,
-				     PAGE_SIZE - offset, write_bytes);
-		struct page *page = prepared_pages[pg];
-		/*
-		 * Copy data from userspace to the current page
-		 */
-		copied = iov_iter_copy_from_user_atomic(page, i, offset, count);
-
-		/* Flush processor's dcache for this page */
-		flush_dcache_page(page);
-
-		/*
-		 * if we get a partial write, we can end up with
-		 * partially up to date pages.  These add
-		 * a lot of complexity, so make sure they don't
-		 * happen by forcing this copy to be retried.
-		 *
-		 * The rest of the btrfs_file_write code will fall
-		 * back to page at a time copies after we return 0.
-		 */
-		if (!PageUptodate(page) && copied < count)
-			copied = 0;
-
-		iov_iter_advance(i, copied);
-		write_bytes -= copied;
-		total_copied += copied;
-
-		/* Return to btrfs_file_write_iter to fault page */
-		if (unlikely(copied == 0))
-			break;
-
-		if (copied < PAGE_SIZE - offset) {
-			offset += copied;
-		} else {
-			pg++;
-			offset = 0;
-		}
-	}
-	return total_copied;
-}
-
-/*
- * unlocks pages after btrfs_file_write is done with them
- */
-static void btrfs_drop_pages(struct page **pages, size_t num_pages)
-{
-	size_t i;
-	for (i = 0; i < num_pages; i++) {
-		/* page checked is some magic around finding pages that
-		 * have been modified without going through btrfs_set_page_dirty
-		 * clear it here. There should be no need to mark the pages
-		 * accessed as prepare_pages should have marked them accessed
-		 * in prepare_pages via find_or_create_page()
-		 */
-		ClearPageChecked(pages[i]);
-		unlock_page(pages[i]);
-		put_page(pages[i]);
-	}
-}
-
 /*
  * after copy_from_user, pages need to be dirtied and we need to make
  * sure holes are created between the current EOF and the start of
@@ -1457,8 +1384,7 @@ static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
  * the other < 0 number - Something wrong happens
  */
 static noinline int
-lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
-				size_t num_pages, loff_t pos,
+lock_and_cleanup_extent(struct btrfs_inode *inode, loff_t pos,
 				size_t write_bytes,
 				u64 *lockstart, u64 *lockend,
 				struct extent_state **cached_state)
@@ -1466,7 +1392,6 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	u64 start_pos;
 	u64 last_pos;
-	int i;
 	int ret = 0;
 
 	start_pos = round_down(pos, fs_info->sectorsize);
@@ -1488,10 +1413,6 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		    ordered->file_offset <= last_pos) {
 			unlock_extent_cached(&inode->io_tree, start_pos,
 					last_pos, cached_state, GFP_NOFS);
-			for (i = 0; i < num_pages; i++) {
-				unlock_page(pages[i]);
-				put_page(pages[i]);
-			}
 			btrfs_start_ordered_extent(&inode->vfs_inode,
 					ordered, 1);
 			btrfs_put_ordered_extent(ordered);
@@ -1517,13 +1438,6 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 		ret = 1;
 	}
 
-	for (i = 0; i < num_pages; i++) {
-		if (clear_page_dirty_for_io(pages[i]))
-			account_page_redirty(pages[i]);
-		set_page_extent_mapped(pages[i]);
-		WARN_ON(!PageLocked(pages[i]));
-	}
-
 	return ret;
 }
 
@@ -1573,239 +1487,201 @@ static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 	return ret;
 }
 
-static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
-					       struct iov_iter *i)
-{
-	struct file *file = iocb->ki_filp;
-	loff_t pos = iocb->ki_pos;
-	struct inode *inode = file_inode(file);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_iomap btrfs_iomap = {0};
-	struct btrfs_iomap *bim = &btrfs_iomap;
-	struct page **pages = NULL;
-	u64 release_bytes = 0;
-	size_t num_written = 0;
-	int nrptrs;
-	int ret = 0;
-	bool force_page_uptodate = false;
-
-	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
-			PAGE_SIZE / (sizeof(struct page *)));
-	nrptrs = min(nrptrs, current->nr_dirtied_pause - current->nr_dirtied);
-	nrptrs = max(nrptrs, 8);
-	pages = kmalloc_array(nrptrs, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		return -ENOMEM;
-
-	while (iov_iter_count(i) > 0) {
-		size_t offset = pos & (PAGE_SIZE - 1);
-		size_t sector_offset;
-		size_t write_bytes = min(iov_iter_count(i),
-					 nrptrs * (size_t)PAGE_SIZE -
-					 offset);
-		size_t num_pages = DIV_ROUND_UP(write_bytes + offset,
-						PAGE_SIZE);
-		size_t dirty_pages;
-		size_t copied;
-		size_t dirty_sectors;
-		size_t num_sectors;
-
-		WARN_ON(num_pages > nrptrs);
-
-		/*
-		 * Fault pages before locking them in prepare_pages
-		 * to avoid recursive lock
-		 */
-		if (unlikely(iov_iter_fault_in_readable(i, write_bytes))) {
-			ret = -EFAULT;
-			break;
-		}
-
-		sector_offset = pos & (fs_info->sectorsize - 1);
-		bim->reserve_bytes = round_up(write_bytes + sector_offset,
-				fs_info->sectorsize);
-
-		extent_changeset_release(bim->data_reserved);
-		ret = btrfs_check_data_free_space(inode, &bim->data_reserved, pos,
-						  write_bytes);
-		if (ret < 0) {
-			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
-						      BTRFS_INODE_PREALLOC)) &&
-			    check_can_nocow(BTRFS_I(inode), pos,
-					&write_bytes) > 0) {
-				/*
-				 * For nodata cow case, no need to reserve
-				 * data space.
-				 */
-				bim->only_release_metadata = true;
-				/*
-				 * our prealloc extent may be smaller than
-				 * write_bytes, so scale down.
-				 */
-				num_pages = DIV_ROUND_UP(write_bytes + offset,
-							 PAGE_SIZE);
-				bim->reserve_bytes = round_up(write_bytes +
-							 sector_offset,
-							 fs_info->sectorsize);
-			} else {
-				break;
-			}
-		}
-
-		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
-				bim->reserve_bytes);
-		if (ret) {
-			if (!bim->only_release_metadata)
-				btrfs_free_reserved_data_space(inode,
-						bim->data_reserved, pos,
-						write_bytes);
-			else
-				btrfs_end_write_no_snapshotting(root);
-			break;
-		}
 
-		release_bytes = bim->reserve_bytes;
-		bim->extent_locked = 0;
+int btrfs_file_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
+                                        unsigned flags, struct iomap *iomap)
+{
+        struct btrfs_iomap *bim = BTRFS_I(inode)->b_iomap;
+        struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+        struct btrfs_root *root = BTRFS_I(inode)->root;
+        size_t write_bytes = length;
+        size_t sector_offset = pos & (fs_info->sectorsize - 1);
+        int ret;
+
+        bim->reserve_bytes = round_up(write_bytes + sector_offset,
+                        fs_info->sectorsize);
+        bim->extent_locked = false;
+        iomap->type = IOMAP_DELALLOC;
+        iomap->flags = IOMAP_F_NEW;
+
+	extent_changeset_release(bim->data_reserved);
+        /* Reserve data/quota space */
+        ret = btrfs_check_data_free_space(inode, &bim->data_reserved, pos,
+                        write_bytes);
+        if (ret < 0) {
+                if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+                                                BTRFS_INODE_PREALLOC)) &&
+                                check_can_nocow(BTRFS_I(inode), pos,
+                                        &write_bytes) > 0) {
+                        /*
+                         * For nodata cow case, no need to reserve
+                         * data space.
+                         */
+                        bim->only_release_metadata = true;
+                        /*
+                         * our prealloc extent may be smaller than
+                         * write_bytes, so scale down.
+                         */
+                        bim->reserve_bytes = round_up(write_bytes +
+                                        sector_offset,
+                                        fs_info->sectorsize);
+                        iomap->type = IOMAP_UNWRITTEN;
+                        iomap->flags = 0;
+                } else {
+                        return ret;
+                }
+        }
+        ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), bim->reserve_bytes);
+        if (ret) {
+                if (!bim->only_release_metadata)
+                        btrfs_free_reserved_data_space(inode,
+                                        bim->data_reserved, pos, write_bytes);
+                else
+                        btrfs_end_write_no_snapshotting(root);
+                extent_changeset_free(bim->data_reserved);
+                return ret;
+        }
+
+	bim->extent_locked = 0;
 again:
-		/*
-		 * This is going to setup the pages array with the number of
-		 * pages we want, so we don't really need to worry about the
-		 * contents of pages from loop to loop
-		 */
-		ret = prepare_pages(inode, pages, num_pages,
-				    pos, write_bytes,
-				    force_page_uptodate);
-		if (ret)
-			break;
-
-		ret = lock_and_cleanup_extent_if_need(BTRFS_I(inode), pages,
-				num_pages, pos, write_bytes, &bim->lockstart,
-				&bim->lockend, &bim->cached_state);
-		if (ret < 0) {
-			if (ret == -EAGAIN)
-				goto again;
-			break;
-		} else if (ret > 0) {
-			bim->extent_locked = 1;
-			ret = 0;
-		}
-
-		copied = btrfs_copy_from_user(pos, write_bytes, pages, i);
-
-		num_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bim->reserve_bytes);
-		dirty_sectors = round_up(copied + sector_offset,
-					fs_info->sectorsize);
-		dirty_sectors = BTRFS_BYTES_TO_BLKS(fs_info, dirty_sectors);
+        bim->extent_locked = lock_and_cleanup_extent(BTRFS_I(inode),
+                        pos, write_bytes, &bim->lockstart,
+                        &bim->lockend, &bim->cached_state);
+
+        if (bim->extent_locked < 0) {
+                if (bim->extent_locked == -EAGAIN)
+                        goto again;
+                ret = bim->extent_locked;
+		goto release;
+        }
+
+
+        iomap->length = write_bytes;
+        iomap->offset = pos;
+        iomap->blkno = IOMAP_NULL_BLOCK;
+        iomap->bdev = fs_info->fs_devices->latest_bdev;
+        return 0;
+
+release:
+	if (bim->only_release_metadata) {
+		btrfs_end_write_no_snapshotting(root);
+		btrfs_delalloc_release_metadata(BTRFS_I(inode),
+				bim->reserve_bytes);
+	} else {
+		btrfs_delalloc_release_space(inode, bim->data_reserved,
+				round_down(pos, fs_info->sectorsize),
+				bim->reserve_bytes);
+	}
+	extent_changeset_free(bim->data_reserved);
+	return ret;
+}
 
-		/*
-		 * if we have trouble faulting in the pages, fall
-		 * back to one page at a time
-		 */
-		if (copied < write_bytes)
-			nrptrs = 1;
+int btrfs_file_iomap_end(struct inode *inode, loff_t pos, loff_t length,
+			 ssize_t copied, unsigned flags, struct iomap *iomap)
+{
 
-		if (copied == 0) {
-			force_page_uptodate = true;
-			dirty_sectors = 0;
-			dirty_pages = 0;
-		} else {
-			force_page_uptodate = false;
-			dirty_pages = DIV_ROUND_UP(copied + offset,
-						   PAGE_SIZE);
-		}
+        struct btrfs_iomap *bim = BTRFS_I(inode)->b_iomap;
+        struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	u64 release_bytes = bim->reserve_bytes;
+	size_t num_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bim->reserve_bytes);
+	size_t sector_offset = pos & (fs_info->sectorsize - 1);
+	size_t offset = pos & (PAGE_SIZE - 1);
+	size_t dirty_sectors = round_up(copied + sector_offset,
+			fs_info->sectorsize);
+	size_t dirty_pages = 0;
+        u64 start_pos = round_down(pos, fs_info->sectorsize);
+        u64 num_bytes = round_up(copied + pos - start_pos,
+                             fs_info->sectorsize);
+        u64 end_of_last_block = start_pos + num_bytes - 1;
+        int ret = 0;
+
+	dirty_sectors = BTRFS_BYTES_TO_BLKS(fs_info, dirty_sectors);
+
+	if (unlikely(copied == 0))
+		dirty_sectors = 0;
+	else
+		dirty_pages = DIV_ROUND_UP(copied + offset,
+				PAGE_SIZE);
 
-		/*
-		 * If we had a short copy we need to release the excess delaloc
-		 * bytes we reserved.  We need to increment outstanding_extents
-		 * because btrfs_delalloc_release_space and
-		 * btrfs_delalloc_release_metadata will decrement it, but
-		 * we still have an outstanding extent for the chunk we actually
-		 * managed to copy.
-		 */
-		if (num_sectors > dirty_sectors) {
-			/* release everything except the sectors we dirtied */
-			release_bytes -= dirty_sectors <<
-						fs_info->sb->s_blocksize_bits;
-			if (copied > 0) {
-				spin_lock(&BTRFS_I(inode)->lock);
-				BTRFS_I(inode)->outstanding_extents++;
-				spin_unlock(&BTRFS_I(inode)->lock);
-			}
-			if (bim->only_release_metadata) {
-				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-								release_bytes);
-			} else {
-				u64 __pos;
-
-				__pos = round_down(pos,
-						   fs_info->sectorsize) +
-					(dirty_pages << PAGE_SHIFT);
-				btrfs_delalloc_release_space(inode,
-						bim->data_reserved, __pos,
-						release_bytes);
-			}
+	/*
+	 * If we had a short copy we need to release the excess delaloc
+	 * bytes we reserved.  We need to increment outstanding_extents
+	 * because btrfs_delalloc_release_space and
+	 * btrfs_delalloc_release_metadata will decrement it, but
+	 * we still have an outstanding extent for the chunk we actually
+	 * managed to copy.
+	 */
+	if (num_sectors > dirty_sectors) {
+		/* release everything except the sectors we dirtied */
+		release_bytes -= dirty_sectors <<
+			fs_info->sb->s_blocksize_bits;
+		if (copied > 0) {
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->outstanding_extents++;
+			spin_unlock(&BTRFS_I(inode)->lock);
 		}
-
-		release_bytes = round_up(copied + sector_offset,
-					fs_info->sectorsize);
-
-		if (copied > 0)
-			ret = btrfs_dirty_pages(inode, pages, dirty_pages,
-						pos, copied, NULL);
-		if (bim->extent_locked)
-			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     bim->lockstart, bim->lockend,
-					     &bim->cached_state, GFP_NOFS);
-		if (ret) {
-			btrfs_drop_pages(pages, num_pages);
-			break;
+		if (bim->only_release_metadata) {
+			btrfs_delalloc_release_metadata(BTRFS_I(inode),
+					release_bytes);
+		} else {
+			u64 __pos;
+			__pos = round_down(pos,
+					fs_info->sectorsize) +
+				(dirty_pages << PAGE_SHIFT);
+			btrfs_delalloc_release_space(inode,
+					bim->data_reserved, __pos,
+					release_bytes);
 		}
+	}
 
-		release_bytes = 0;
-		if (bim->only_release_metadata)
-			btrfs_end_write_no_snapshotting(root);
+	release_bytes = round_up(copied + sector_offset,
+			fs_info->sectorsize);
 
-		if (bim->only_release_metadata && copied > 0) {
-			bim->lockstart = round_down(pos,
-					       fs_info->sectorsize);
-			bim->lockend = round_up(pos + copied,
-					   fs_info->sectorsize) - 1;
+	if (copied > 0)
+		ret = btrfs_set_extent_delalloc(inode, start_pos,
+					        end_of_last_block,
+						&bim->cached_state, 0);
 
-			set_extent_bit(&BTRFS_I(inode)->io_tree, bim->lockstart,
-				       bim->lockend, EXTENT_NORESERVE, NULL,
-				       NULL, GFP_NOFS);
-			bim->only_release_metadata = false;
-		}
+	if (bim->extent_locked)
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+				bim->lockstart, bim->lockend,
+				&bim->cached_state, GFP_NOFS);
 
-		btrfs_drop_pages(pages, num_pages);
+	if (bim->only_release_metadata)
+		btrfs_end_write_no_snapshotting(BTRFS_I(inode)->root);
 
-		cond_resched();
-
-		balance_dirty_pages_ratelimited(inode->i_mapping);
-		if (dirty_pages < (fs_info->nodesize >> PAGE_SHIFT) + 1)
-			btrfs_btree_balance_dirty(fs_info);
+	if (bim->only_release_metadata && copied > 0) {
+		bim->lockstart = round_down(pos,
+				fs_info->sectorsize);
+		bim->lockend = round_up(pos + copied,
+				fs_info->sectorsize) - 1;
 
-		pos += copied;
-		num_written += copied;
+		set_extent_bit(&BTRFS_I(inode)->io_tree, bim->lockstart,
+				bim->lockend, EXTENT_NORESERVE, NULL,
+				NULL, GFP_NOFS);
+		bim->only_release_metadata = false;
 	}
+        extent_changeset_free(bim->data_reserved);
+	return ret;
+}
 
-	kfree(pages);
-
-	if (release_bytes) {
-		if (bim->only_release_metadata) {
-			btrfs_end_write_no_snapshotting(root);
-			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-					release_bytes);
-		} else {
-			btrfs_delalloc_release_space(inode, bim->data_reserved,
-					round_down(pos, fs_info->sectorsize),
-					release_bytes);
-		}
-	}
+const struct iomap_ops btrfs_iomap_ops = {
+        .iomap_begin            = btrfs_file_iomap_begin,
+        .iomap_end              = btrfs_file_iomap_end,
+};
 
-	extent_changeset_free(bim->data_reserved);
-	return num_written ? num_written : ret;
+static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
+                                               struct iov_iter *from)
+{
+        struct btrfs_iomap bi = {0};
+        struct inode *inode = file_inode(iocb->ki_filp);
+        ssize_t written;
+        BTRFS_I(inode)->b_iomap = &bi;
+        written = iomap_file_buffered_write(iocb, from, &btrfs_iomap_ops);
+        if (written > 0)
+                iocb->ki_pos += written;
+        BTRFS_I(inode)->b_iomap = NULL;
+        return written;
 }
 
 static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
@@ -1823,7 +1699,7 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		return written;
 
 	iocb->ki_pos += written;
-	written_buffered = __btrfs_buffered_write(iocb, from);
+	written_buffered = btrfs_buffered_write(iocb, from);
 	if (written_buffered < 0) {
 		err = written_buffered;
 		goto out;
@@ -1960,7 +1836,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		num_written = __btrfs_direct_write(iocb, from);
 	} else {
-		num_written = __btrfs_buffered_write(iocb, from);
+		num_written = btrfs_buffered_write(iocb, from);
 		if (num_written > 0)
 			iocb->ki_pos = pos + num_written;
 		if (clean_page)
-- 
2.14.2

