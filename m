Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161100AbdKQRpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:17 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5917ADF6
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:15 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 7/8] fs: iomap->prepare_pages() to set directives specific for the page
Date: Fri, 17 Nov 2017 11:44:53 -0600
Message-Id: <20171117174456.13393-8-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This adds prepare_pages() to iomap in order to set page directives
for the page so as FS such as btrfs may perform post-write operations
after write completes.

Can we do away with this? EXTENT_PAGE_PRIVATE is only set and not used.
However, we want the page to be set with PG_Priavate with SetPagePrivate()
for try_to_release_buffers(). Can we work around it?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/file.c       |  8 ++++++++
 fs/dax.c              |  2 +-
 fs/internal.h         |  2 +-
 fs/iomap.c            | 23 ++++++++++++++---------
 include/linux/iomap.h |  3 +++
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b34ec493fe4b..b5cc5c0a0cf5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1641,9 +1641,17 @@ int btrfs_file_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	return ret;
 }
 
+static void btrfs_file_process_page(struct inode *inode, struct page *page)
+{
+	SetPagePrivate(page);
+	set_page_private(page, EXTENT_PAGE_PRIVATE);
+	get_page(page);
+}
+
 const struct iomap_ops btrfs_iomap_ops = {
         .iomap_begin            = btrfs_file_iomap_begin,
         .iomap_end              = btrfs_file_iomap_end,
+	.iomap_process_page	= btrfs_file_process_page,
 };
 
 static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
diff --git a/fs/dax.c b/fs/dax.c
index f001d8c72a06..51d07b24b3a1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -943,7 +943,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		const struct iomap_ops *ops, struct iomap *iomap)
 {
 	struct block_device *bdev = iomap->bdev;
 	struct dax_device *dax_dev = iomap->dax_dev;
diff --git a/fs/internal.h b/fs/internal.h
index 48cee21b4f14..bd9d5a37bd23 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -176,7 +176,7 @@ extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
  * iomap support:
  */
 typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
-		void *data, struct iomap *iomap);
+		void *data, const struct iomap_ops *ops, struct iomap *iomap);
 
 loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
 		unsigned flags, const struct iomap_ops *ops, void *data,
diff --git a/fs/iomap.c b/fs/iomap.c
index 9ec9cc3077b3..a32660b1b6c5 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -78,7 +78,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	 * we can do the copy-in page by page without having to worry about
 	 * failures exposing transient data.
 	 */
-	written = actor(inode, pos, length, data, &iomap);
+	written = actor(inode, pos, length, data, ops, &iomap);
 
 	/*
 	 * Now the data has been copied, commit the range we've copied.  This
@@ -155,7 +155,7 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 
 static loff_t
 iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		const struct iomap_ops *ops, struct iomap *iomap)
 {
 	struct iov_iter *i = data;
 	long status = 0;
@@ -195,6 +195,9 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		if (unlikely(status))
 			break;
 
+		if (ops->iomap_process_page)
+			ops->iomap_process_page(inode, page);
+
 		if (mapping_writably_mapped(inode->i_mapping))
 			flush_dcache_page(page);
 
@@ -271,7 +274,7 @@ __iomap_read_page(struct inode *inode, loff_t offset)
 
 static loff_t
 iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		const struct iomap_ops *ops, struct iomap *iomap)
 {
 	long status = 0;
 	ssize_t written = 0;
@@ -363,7 +366,7 @@ static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 
 static loff_t
 iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
-		void *data, struct iomap *iomap)
+		void *data, const struct iomap_ops *ops, struct iomap *iomap)
 {
 	bool *did_zero = data;
 	loff_t written = 0;
@@ -432,7 +435,7 @@ EXPORT_SYMBOL_GPL(iomap_truncate_page);
 
 static loff_t
 iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap)
+		void *data, const struct iomap_ops *ops, struct iomap *iomap)
 {
 	struct page *page = data;
 	int ret;
@@ -523,7 +526,7 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 
 static loff_t
 iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		const struct iomap_ops *ops, struct iomap *iomap)
 {
 	struct fiemap_ctx *ctx = data;
 	loff_t ret = length;
@@ -590,7 +593,8 @@ EXPORT_SYMBOL_GPL(iomap_fiemap);
 
 static loff_t
 iomap_seek_hole_actor(struct inode *inode, loff_t offset, loff_t length,
-		      void *data, struct iomap *iomap)
+		      void *data, const struct iomap_ops *ops,
+		      struct iomap *iomap)
 {
 	switch (iomap->type) {
 	case IOMAP_UNWRITTEN:
@@ -636,7 +640,8 @@ EXPORT_SYMBOL_GPL(iomap_seek_hole);
 
 static loff_t
 iomap_seek_data_actor(struct inode *inode, loff_t offset, loff_t length,
-		      void *data, struct iomap *iomap)
+		      void *data, const struct iomap_ops *ops,
+		      struct iomap *iomap)
 {
 	switch (iomap->type) {
 	case IOMAP_HOLE:
@@ -849,7 +854,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 
 static loff_t
 iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap)
+		void *data, const struct iomap_ops *ops, struct iomap *iomap)
 {
 	struct iomap_dio *dio = data;
 	unsigned int blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 61af7b1bd0fc..fbb0194d56d6 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -6,6 +6,7 @@
 
 struct fiemap_extent_info;
 struct inode;
+struct page;
 struct iov_iter;
 struct kiocb;
 struct vm_area_struct;
@@ -73,6 +74,8 @@ struct iomap_ops {
 	 */
 	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
 			ssize_t written, unsigned flags, struct iomap *iomap);
+
+	void (*iomap_process_page)(struct inode *inode, struct page *page);
 };
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
-- 
2.14.2

