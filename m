Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3LJLYD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 06:24:03 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBABNw7v020270
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Dec 2013 19:23:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: fix the reserved space leak caused by the race between nonlock dio and buffered io
Date: Tue, 10 Dec 2013 19:25:04 +0800
Message-Id: <1386674704-8501-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1386674704-8501-1-git-send-email-miaox@cn.fujitsu.com>
References: <1386674704-8501-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we ran sysbench on the fs with compression, the following WARN_ONs were
triggered:
 fs/btrfs/inode.c:7829	WARN_ON(BTRFS_I(inode)->outstanding_extents);
 fs/btrfs/inode.c:7830	WARN_ON(BTRFS_I(inode)->reserved_extents);
 fs/btrfs/inode.c:7832	WARN_ON(BTRFS_I(inode)->csum_bytes);

Steps to reproduce:
 # mkfs.btrfs -f <dev>
 # mount -o compress <dev> <mnt>
 # cd <mnt>
 # sysbench --test=fileio --num-threads=8 --file-total-size=8G \
 > --file-block-size=32K --file-io-mode=rndwr --file-fsync-freq=0 \
 > --file-fsync-end=no --max-requests=300000 --file-extra-flags=direct \
 > --file-test-mode=sync prepare
 # cd -
 # umount <mnt>
 # mount -o compress <dev> <mnt>
 # cd <mnt>
 # sysbench --test=fileio --num-threads=8 --file-total-size=8G \
 > --file-block-size=32K --file-io-mode=rndwr --file-fsync-freq=0 \
 > --file-fsync-end=no --max-requests=300000 --file-extra-flags=direct \
 > --file-test-mode=sync run
 # cd -
 # umount <mnt>

The reason of this problem is:
Task0				Task1
btrfs_direct_IO
  unlock(&inode->i_mutex)
				lock(&inode->i_mutex)
				reserve_space()
				prepare_pages()
				  lock_extent()
				  clear_extent()
				  unlock_extent()
  lock_extent()
  test_extent(uptodate)
    return false
				copy_data()
				set_delalloc_extent()
  extent need compress
    go back to buffered write
  clear_extent(DELALLOC | DIRTY)
  unlock_extent()

Task 0 and 1 wrote the same place, and task0 cleared the delalloc flag which
was set by task1, it made the dirty pages in that extents couldn't be flushed
into the disk, so the reserved space for that extent was not released at
the end.

This patch fixes the above bug by unlocking the extent after the delalloc.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 131 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 84 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ecb4f1f..453e43c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1235,27 +1235,18 @@ static int prepare_uptodate_page(struct page *page, u64 pos,
 }
 
 /*
- * this gets pages into the page cache and locks them down, it also properly
- * waits for data=ordered extents to finish before allowing the pages to be
- * modified.
+ * this just gets pages into the page cache and locks them down.
  */
 static noinline int prepare_pages(struct inode *inode, struct page **pages,
 				  size_t num_pages, loff_t pos,
 				  size_t write_bytes, bool force_uptodate)
 {
-	struct extent_state *cached_state = NULL;
 	int i;
 	unsigned long index = pos >> PAGE_CACHE_SHIFT;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
-	int err = 0;
-	int faili = 0;
-	u64 start_pos;
-	u64 last_pos;
-
-	start_pos = pos & ~((u64)PAGE_CACHE_SIZE - 1);
-	last_pos = ((u64)index + num_pages) << PAGE_CACHE_SHIFT;
+	int err;
+	int faili;
 
-again:
 	for (i = 0; i < num_pages; i++) {
 		pages[i] = find_or_create_page(inode->i_mapping, index + i,
 					       mask | __GFP_WRITE);
@@ -1278,57 +1269,85 @@ again:
 		}
 		wait_on_page_writeback(pages[i]);
 	}
-	faili = num_pages - 1;
-	err = 0;
+
+	return 0;
+fail:
+	while (faili >= 0) {
+		unlock_page(pages[faili]);
+		page_cache_release(pages[faili]);
+		faili--;
+	}
+	return err;
+
+}
+
+/*
+ * This function locks the extent and properly waits for data=ordered extents
+ * to finish before allowing the pages to be modified if need.
+ *
+ * The return value:
+ * 1 - the extent is locked
+ * 0 - the extent is not locked, and everything is OK
+ * -EAGAIN - need re-prepare the pages
+ * the other < 0 number - Something wrong happens
+ */
+static noinline int
+lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
+				size_t num_pages, loff_t pos,
+				u64 *lockstart, u64 *lockend,
+				struct extent_state **cached_state)
+{
+	u64 start_pos;
+	u64 last_pos;
+	int i;
+	int ret = 0;
+
+	start_pos = pos & ~((u64)PAGE_CACHE_SIZE - 1);
+	last_pos = start_pos + ((u64)num_pages << PAGE_CACHE_SHIFT) - 1;
+
 	if (start_pos < inode->i_size) {
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
-				 start_pos, last_pos - 1, 0, &cached_state);
-		ordered = btrfs_lookup_first_ordered_extent(inode,
-							    last_pos - 1);
+				 start_pos, last_pos, 0, cached_state);
+		ordered = btrfs_lookup_first_ordered_extent(inode, last_pos);
 		if (ordered &&
 		    ordered->file_offset + ordered->len > start_pos &&
-		    ordered->file_offset < last_pos) {
+		    ordered->file_offset <= last_pos) {
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     start_pos, last_pos - 1,
-					     &cached_state, GFP_NOFS);
+					     start_pos, last_pos,
+					     cached_state, GFP_NOFS);
 			for (i = 0; i < num_pages; i++) {
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
 			}
-			err = btrfs_wait_ordered_range(inode, start_pos,
-						       last_pos - start_pos);
-			if (err)
-				goto fail;
-			goto again;
+			ret = btrfs_wait_ordered_range(inode, start_pos,
+						last_pos - start_pos + 1);
+			if (ret)
+				return ret;
+			else
+				return -EAGAIN;
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
 
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, start_pos,
-				  last_pos - 1, EXTENT_DIRTY | EXTENT_DELALLOC |
+				  last_pos, EXTENT_DIRTY | EXTENT_DELALLOC |
 				  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-				  0, 0, &cached_state, GFP_NOFS);
-		unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-				     start_pos, last_pos - 1, &cached_state,
-				     GFP_NOFS);
+				  0, 0, cached_state, GFP_NOFS);
+		*lockstart = start_pos;
+		*lockend = last_pos;
+		ret = 1;
 	}
+
 	for (i = 0; i < num_pages; i++) {
 		if (clear_page_dirty_for_io(pages[i]))
 			account_page_redirty(pages[i]);
 		set_page_extent_mapped(pages[i]);
 		WARN_ON(!PageLocked(pages[i]));
 	}
-	return 0;
-fail:
-	while (faili >= 0) {
-		unlock_page(pages[faili]);
-		page_cache_release(pages[faili]);
-		faili--;
-	}
-	return err;
 
+	return ret;
 }
 
 static noinline int check_can_nocow(struct inode *inode, loff_t pos,
@@ -1379,13 +1398,17 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	struct inode *inode = file_inode(file);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct page **pages = NULL;
+	struct extent_state *cached_state = NULL;
 	u64 release_bytes = 0;
+	u64 lockstart;
+	u64 lockend;
 	unsigned long first_index;
 	size_t num_written = 0;
 	int nrptrs;
 	int ret = 0;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
+	bool need_unlock;
 
 	nrptrs = min((iov_iter_count(i) + PAGE_CACHE_SIZE - 1) /
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
@@ -1454,7 +1477,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		release_bytes = reserve_bytes;
-
+		need_unlock = false;
+again:
 		/*
 		 * This is going to setup the pages array with the number of
 		 * pages we want, so we don't really need to worry about the
@@ -1466,6 +1490,18 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		if (ret)
 			break;
 
+		ret = lock_and_cleanup_extent_if_need(inode, pages, num_pages,
+						      pos, &lockstart, &lockend,
+						      &cached_state);
+		if (ret < 0) {
+			if (ret == -EAGAIN)
+				goto again;
+			break;
+		} else if (ret > 0) {
+			need_unlock = true;
+			ret = 0;
+		}
+
 		copied = btrfs_copy_from_user(pos, num_pages,
 					   write_bytes, pages, i);
 
@@ -1510,19 +1546,20 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		release_bytes = dirty_pages << PAGE_CACHE_SHIFT;
-		if (copied > 0) {
+
+		if (copied > 0)
 			ret = btrfs_dirty_pages(root, inode, pages,
 						dirty_pages, pos, copied,
 						NULL);
-			if (ret) {
-				btrfs_drop_pages(pages, num_pages);
-				break;
-			}
-		}
-
-		release_bytes = 0;
+		if (need_unlock)
+			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+					     lockstart, lockend, &cached_state,
+					     GFP_NOFS);
 		btrfs_drop_pages(pages, num_pages);
+		if (ret)
+			break;
 
+		release_bytes = 0;
 		if (only_release_metadata && copied > 0) {
 			u64 lockstart = round_down(pos, root->sectorsize);
 			u64 lockend = lockstart +
-- 
1.8.3.1

