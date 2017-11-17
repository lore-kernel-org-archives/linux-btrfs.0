Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161092AbdKQRpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 75748ABFC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:09 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 4/8] btrfs: Introduce btrfs_iomap
Date: Fri, 17 Nov 2017 11:44:50 -0600
Message-Id: <20171117174456.13393-5-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Preparatory patch. btrfs_iomap structure carries extent/page
state from iomap_begin() to iomap_end().

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c  | 68 ++++++++++++++++++++++++++------------------------------
 fs/btrfs/iomap.h | 21 +++++++++++++++++
 2 files changed, 53 insertions(+), 36 deletions(-)
 create mode 100644 fs/btrfs/iomap.h

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9bceb0e61361..876c2acc2a71 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -41,6 +41,7 @@
 #include "volumes.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "iomap.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -1580,18 +1581,14 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_iomap btrfs_iomap = {0};
+	struct btrfs_iomap *bim = &btrfs_iomap;
 	struct page **pages = NULL;
-	struct extent_state *cached_state = NULL;
-	struct extent_changeset *data_reserved = NULL;
 	u64 release_bytes = 0;
-	u64 lockstart;
-	u64 lockend;
 	size_t num_written = 0;
 	int nrptrs;
 	int ret = 0;
-	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
-	bool need_unlock;
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1609,7 +1606,6 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 					 offset);
 		size_t num_pages = DIV_ROUND_UP(write_bytes + offset,
 						PAGE_SIZE);
-		size_t reserve_bytes;
 		size_t dirty_pages;
 		size_t copied;
 		size_t dirty_sectors;
@@ -1627,11 +1623,11 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 		}
 
 		sector_offset = pos & (fs_info->sectorsize - 1);
-		reserve_bytes = round_up(write_bytes + sector_offset,
+		bim->reserve_bytes = round_up(write_bytes + sector_offset,
 				fs_info->sectorsize);
 
-		extent_changeset_release(data_reserved);
-		ret = btrfs_check_data_free_space(inode, &data_reserved, pos,
+		extent_changeset_release(bim->data_reserved);
+		ret = btrfs_check_data_free_space(inode, &bim->data_reserved, pos,
 						  write_bytes);
 		if (ret < 0) {
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
@@ -1642,14 +1638,14 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 				 * For nodata cow case, no need to reserve
 				 * data space.
 				 */
-				only_release_metadata = true;
+				bim->only_release_metadata = true;
 				/*
 				 * our prealloc extent may be smaller than
 				 * write_bytes, so scale down.
 				 */
 				num_pages = DIV_ROUND_UP(write_bytes + offset,
 							 PAGE_SIZE);
-				reserve_bytes = round_up(write_bytes +
+				bim->reserve_bytes = round_up(write_bytes +
 							 sector_offset,
 							 fs_info->sectorsize);
 			} else {
@@ -1658,19 +1654,19 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 		}
 
 		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
-				reserve_bytes);
+				bim->reserve_bytes);
 		if (ret) {
-			if (!only_release_metadata)
+			if (!bim->only_release_metadata)
 				btrfs_free_reserved_data_space(inode,
-						data_reserved, pos,
+						bim->data_reserved, pos,
 						write_bytes);
 			else
 				btrfs_end_write_no_snapshotting(root);
 			break;
 		}
 
-		release_bytes = reserve_bytes;
-		need_unlock = false;
+		release_bytes = bim->reserve_bytes;
+		bim->extent_locked = 0;
 again:
 		/*
 		 * This is going to setup the pages array with the number of
@@ -1684,20 +1680,20 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 			break;
 
 		ret = lock_and_cleanup_extent_if_need(BTRFS_I(inode), pages,
-				num_pages, pos, write_bytes, &lockstart,
-				&lockend, &cached_state);
+				num_pages, pos, write_bytes, &bim->lockstart,
+				&bim->lockend, &bim->cached_state);
 		if (ret < 0) {
 			if (ret == -EAGAIN)
 				goto again;
 			break;
 		} else if (ret > 0) {
-			need_unlock = true;
+			bim->extent_locked = 1;
 			ret = 0;
 		}
 
 		copied = btrfs_copy_from_user(pos, write_bytes, pages, i);
 
-		num_sectors = BTRFS_BYTES_TO_BLKS(fs_info, reserve_bytes);
+		num_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bim->reserve_bytes);
 		dirty_sectors = round_up(copied + sector_offset,
 					fs_info->sectorsize);
 		dirty_sectors = BTRFS_BYTES_TO_BLKS(fs_info, dirty_sectors);
@@ -1736,7 +1732,7 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 				BTRFS_I(inode)->outstanding_extents++;
 				spin_unlock(&BTRFS_I(inode)->lock);
 			}
-			if (only_release_metadata) {
+			if (bim->only_release_metadata) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 								release_bytes);
 			} else {
@@ -1746,7 +1742,7 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 						   fs_info->sectorsize) +
 					(dirty_pages << PAGE_SHIFT);
 				btrfs_delalloc_release_space(inode,
-						data_reserved, __pos,
+						bim->data_reserved, __pos,
 						release_bytes);
 			}
 		}
@@ -1757,29 +1753,29 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 		if (copied > 0)
 			ret = btrfs_dirty_pages(inode, pages, dirty_pages,
 						pos, copied, NULL);
-		if (need_unlock)
+		if (bim->extent_locked)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
-					     lockstart, lockend, &cached_state,
-					     GFP_NOFS);
+					     bim->lockstart, bim->lockend,
+					     &bim->cached_state, GFP_NOFS);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
 			break;
 		}
 
 		release_bytes = 0;
-		if (only_release_metadata)
+		if (bim->only_release_metadata)
 			btrfs_end_write_no_snapshotting(root);
 
-		if (only_release_metadata && copied > 0) {
-			lockstart = round_down(pos,
+		if (bim->only_release_metadata && copied > 0) {
+			bim->lockstart = round_down(pos,
 					       fs_info->sectorsize);
-			lockend = round_up(pos + copied,
+			bim->lockend = round_up(pos + copied,
 					   fs_info->sectorsize) - 1;
 
-			set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-				       lockend, EXTENT_NORESERVE, NULL,
+			set_extent_bit(&BTRFS_I(inode)->io_tree, bim->lockstart,
+				       bim->lockend, EXTENT_NORESERVE, NULL,
 				       NULL, GFP_NOFS);
-			only_release_metadata = false;
+			bim->only_release_metadata = false;
 		}
 
 		btrfs_drop_pages(pages, num_pages);
@@ -1797,18 +1793,18 @@ static noinline ssize_t __btrfs_buffered_write(struct kiocb *iocb,
 	kfree(pages);
 
 	if (release_bytes) {
-		if (only_release_metadata) {
+		if (bim->only_release_metadata) {
 			btrfs_end_write_no_snapshotting(root);
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
 					release_bytes);
 		} else {
-			btrfs_delalloc_release_space(inode, data_reserved,
+			btrfs_delalloc_release_space(inode, bim->data_reserved,
 					round_down(pos, fs_info->sectorsize),
 					release_bytes);
 		}
 	}
 
-	extent_changeset_free(data_reserved);
+	extent_changeset_free(bim->data_reserved);
 	return num_written ? num_written : ret;
 }
 
diff --git a/fs/btrfs/iomap.h b/fs/btrfs/iomap.h
new file mode 100644
index 000000000000..ac34b3412f64
--- /dev/null
+++ b/fs/btrfs/iomap.h
@@ -0,0 +1,21 @@
+
+
+#ifndef __BTRFS_IOMAP_H__
+#define __BTRFS_IOMAP_H__
+
+#include <linux/iomap.h>
+#include "extent_io.h"
+
+struct btrfs_iomap {
+	u64 lockstart;
+	u64 lockend;
+	u64 reserve_bytes;
+	bool only_release_metadata;
+	int extent_locked;
+	struct extent_state *cached_state;
+	struct extent_changeset *data_reserved;
+};
+
+#endif
+
+
-- 
2.14.2

