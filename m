Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34906 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161092AbdKQRpO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:14 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 90741ABFC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:13 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 6/8] btrfs: read the first/last page of the write
Date: Fri, 17 Nov 2017 11:44:52 -0600
Message-Id: <20171117174456.13393-7-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We cannot perform a readpage in iomap_apply after
iomap_begin() because we have our extents locked. So,
we perform a readpage and make sure we unlock it, but
increase the page count.

Question: How do we deal with -EAGAIN return from
prepare_uptodate_page()? Under what scenario's would this occur?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c  | 116 ++++++++++++++++++++++---------------------------------
 fs/btrfs/iomap.h |   1 +
 2 files changed, 47 insertions(+), 70 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b7390214ef3a..b34ec493fe4b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1252,84 +1252,36 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-/*
- * on error we return an unlocked page and the error value
- * on success we return a locked page and 0
- */
-static int prepare_uptodate_page(struct inode *inode,
-				 struct page *page, u64 pos,
-				 bool force_uptodate)
+static int prepare_uptodate_page(struct inode *inode, u64 pos, struct page **pagep)
 {
+	struct page *page = NULL;
 	int ret = 0;
+	int index = pos >> PAGE_SHIFT;
+
+	if (!(pos & (PAGE_SIZE - 1)))
+		goto out;
+
+	page = grab_cache_page_write_begin(inode->i_mapping, index,
+			AOP_FLAG_NOFS);
 
-	if (((pos & (PAGE_SIZE - 1)) || force_uptodate) &&
-	    !PageUptodate(page)) {
+	if (!PageUptodate(page)) {
 		ret = btrfs_readpage(NULL, page);
 		if (ret)
-			return ret;
-		lock_page(page);
+			goto out;
 		if (!PageUptodate(page)) {
-			unlock_page(page);
-			return -EIO;
+			ret = -EIO;
+			goto out;
 		}
 		if (page->mapping != inode->i_mapping) {
-			unlock_page(page);
-			return -EAGAIN;
-		}
-	}
-	return 0;
-}
-
-/*
- * this just gets pages into the page cache and locks them down.
- */
-static noinline int prepare_pages(struct inode *inode, struct page **pages,
-				  size_t num_pages, loff_t pos,
-				  size_t write_bytes, bool force_uptodate)
-{
-	int i;
-	unsigned long index = pos >> PAGE_SHIFT;
-	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
-	int err = 0;
-	int faili;
-
-	for (i = 0; i < num_pages; i++) {
-again:
-		pages[i] = find_or_create_page(inode->i_mapping, index + i,
-					       mask | __GFP_WRITE);
-		if (!pages[i]) {
-			faili = i - 1;
-			err = -ENOMEM;
-			goto fail;
-		}
-
-		if (i == 0)
-			err = prepare_uptodate_page(inode, pages[i], pos,
-						    force_uptodate);
-		if (!err && i == num_pages - 1)
-			err = prepare_uptodate_page(inode, pages[i],
-						    pos + write_bytes, false);
-		if (err) {
-			put_page(pages[i]);
-			if (err == -EAGAIN) {
-				err = 0;
-				goto again;
-			}
-			faili = i - 1;
-			goto fail;
+			ret = -EAGAIN;
+			goto out;
 		}
-		wait_on_page_writeback(pages[i]);
 	}
-
-	return 0;
-fail:
-	while (faili >= 0) {
-		unlock_page(pages[faili]);
-		put_page(pages[faili]);
-		faili--;
-	}
-	return err;
-
+out:
+	if (page)
+		unlock_page(page);
+	*pagep = page;
+	return ret;
 }
 
 static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
@@ -1502,7 +1454,7 @@ int btrfs_file_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
                         fs_info->sectorsize);
         bim->extent_locked = false;
         iomap->type = IOMAP_DELALLOC;
-        iomap->flags = IOMAP_F_NEW;
+        iomap->flags = IOMAP_F_NEW | IOMAP_F_NOBH;
 
 	extent_changeset_release(bim->data_reserved);
         /* Reserve data/quota space */
@@ -1526,7 +1478,7 @@ int btrfs_file_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
                                         sector_offset,
                                         fs_info->sectorsize);
                         iomap->type = IOMAP_UNWRITTEN;
-                        iomap->flags = 0;
+                        iomap->flags &= ~IOMAP_F_NEW;
                 } else {
                         return ret;
                 }
@@ -1543,6 +1495,20 @@ int btrfs_file_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
         }
 
 	bim->extent_locked = 0;
+
+	if (pos < inode->i_size) {
+		ret = prepare_uptodate_page(inode, pos, &bim->first_page);
+		if (ret)
+			goto release;
+	}
+
+	if ((length > PAGE_SIZE) &&
+			(round_down(length + pos, PAGE_SIZE) < inode->i_size)) {
+		ret = prepare_uptodate_page(inode, pos + length, &bim->last_page);
+		if (ret)
+			goto release;
+	}
+
 again:
         bim->extent_locked = lock_and_cleanup_extent(BTRFS_I(inode),
                         pos, write_bytes, &bim->lockstart,
@@ -1597,6 +1563,16 @@ int btrfs_file_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	dirty_sectors = BTRFS_BYTES_TO_BLKS(fs_info, dirty_sectors);
 
+	if (bim->first_page) {
+		put_page(bim->first_page);
+		bim->first_page = NULL;
+	}
+
+	if (bim->last_page) {
+		put_page(bim->last_page);
+		bim->last_page = NULL;
+	}
+
 	if (unlikely(copied == 0))
 		dirty_sectors = 0;
 	else
diff --git a/fs/btrfs/iomap.h b/fs/btrfs/iomap.h
index ac34b3412f64..f62e3ee6d4de 100644
--- a/fs/btrfs/iomap.h
+++ b/fs/btrfs/iomap.h
@@ -14,6 +14,7 @@ struct btrfs_iomap {
 	int extent_locked;
 	struct extent_state *cached_state;
 	struct extent_changeset *data_reserved;
+	struct page *first_page, *last_page;
 };
 
 #endif
-- 
2.14.2

