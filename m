Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB7EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B5F20823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbfCZTDr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:03:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:37106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732718AbfCZTDq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:03:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9BE3BADF2;
        Tue, 26 Mar 2019 19:03:44 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 13/15] btrfs: handle dax page zeroing
Date:   Tue, 26 Mar 2019 14:02:59 -0500
Message-Id: <20190326190301.32365-14-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

btrfs_dax_zero_block() zeros part of the page, either from the
front or the regular rest of the block.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h      |  1 +
 fs/btrfs/dax.c        | 29 +++++++++++++++++++++++++++--
 fs/btrfs/inode.c      |  4 ++++
 fs/dax.c              | 17 ++++++++++++-----
 fs/iomap.c            |  9 +--------
 include/linux/dax.h   | 11 +++++------
 include/linux/iomap.h |  6 ++++++
 7 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 750f9c70fabe..21068dc4a95a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3806,6 +3806,7 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
 int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
 		struct inode *dest, loff_t destoff, loff_t len,
 		bool *is_same);
+int btrfs_dax_zero_block(struct inode *inode, loff_t from, loff_t len, bool front);
 #else
 static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
 {
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 7900b5773829..d73945d50b88 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -31,7 +31,7 @@ static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, length, 0);
 
-	if (flags & IOMAP_WRITE) {
+	if (flags & (IOMAP_WRITE | IOMAP_ZERO)) {
 		int ret = 0, nocow;
 		struct extent_map *map = em;
 		struct btrfs_iomap *bi;
@@ -89,7 +89,8 @@ static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
 	iomap->bdev = em->bdev;
 	iomap->dax_dev = fs_info->dax_dev;
 
-	if (em->block_start == EXTENT_MAP_HOLE) {
+	if (em->block_start == EXTENT_MAP_HOLE ||
+			em->flags == EXTENT_FLAG_FILLING) {
 		iomap->type = IOMAP_HOLE;
 		return 0;
 	}
@@ -178,4 +179,28 @@ int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
 {
 	return dax_file_range_compare(src, srcoff, dest, destoff, len, is_same, &btrfs_iomap_ops);
 }
+
+/*
+ * zero a part of the page only. This should CoW (via iomap_begin) if required
+ */
+int btrfs_dax_zero_block(struct inode *inode, loff_t from, loff_t len, bool front)
+{
+	loff_t start = round_down(from, PAGE_SIZE);
+	loff_t end = round_up(from, PAGE_SIZE);
+	loff_t offset = from;
+	int ret = 0;
+
+	if (front) {
+		len = from - start;
+		offset = start;
+	} else	{
+		if (!len)
+			len = end - from;
+	}
+
+	if (len)
+		ret = iomap_zero_range(inode, offset, len, NULL, &btrfs_iomap_ops);
+
+	return (ret < 0) ? ret : 0;
+}
 #endif /* CONFIG_FS_DAX */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 21780ea14e5a..5350e5f23728 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4833,6 +4833,10 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	    (!len || IS_ALIGNED(len, blocksize)))
 		goto out;
 
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(inode))
+		return btrfs_dax_zero_block(inode, from, len, front);
+#endif
 	block_start = round_down(from, blocksize);
 	block_end = block_start + blocksize - 1;
 
diff --git a/fs/dax.c b/fs/dax.c
index 18998c5ee27a..93146142bb00 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1068,17 +1068,21 @@ static void dax_to_dax_copy(struct iomap *iomap, loff_t pos, void *daddr,
 	blk_start = iomap->cow_addr + pos - iomap->cow_pos;
 	blk_pg = round_down(blk_start, PAGE_SIZE);
 
-	map_len = dax_direct_access(iomap->dax_dev, PHYS_PFN(blk_pg), PAGE_SIZE,
+	map_len = dax_direct_access(iomap->dax_dev, PHYS_PFN(blk_pg), 1,
 			&saddr, NULL);
 	saddr += blk_start - blk_pg;
 	memcpy(daddr, saddr, len);
 }
 
-int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int size)
+int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
+			  unsigned int offset, unsigned int size)
 {
-	if (dax_range_is_aligned(bdev, offset, size)) {
+	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
+	struct block_device *bdev = iomap->bdev;
+	struct dax_device *dax_dev = iomap->dax_dev;
+
+	if (!(iomap->flags & IOMAP_F_COW) &&
+	    dax_range_is_aligned(bdev, offset, size)) {
 		sector_t start_sector = sector + (offset >> 9);
 
 		return blkdev_issue_zeroout(bdev, start_sector,
@@ -1098,6 +1102,9 @@ int __dax_zero_page_range(struct block_device *bdev,
 			dax_read_unlock(id);
 			return rc;
 		}
+		if (iomap->flags & IOMAP_F_COW)
+			dax_to_dax_copy(iomap, pos & PAGE_MASK,
+					kaddr, PAGE_SIZE);
 		memset(kaddr + offset, 0, size);
 		dax_flush(dax_dev, kaddr + offset, size);
 		dax_read_unlock(id);
diff --git a/fs/iomap.c b/fs/iomap.c
index abdd18e404f8..90698c854883 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -98,12 +98,6 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	return written ? written : ret;
 }
 
-static sector_t
-iomap_sector(struct iomap *iomap, loff_t pos)
-{
-	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
-}
-
 static struct iomap_page *
 iomap_page_create(struct inode *inode, struct page *page)
 {
@@ -990,8 +984,7 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 		struct iomap *iomap)
 {
-	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
-			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
+	return __dax_zero_page_range(iomap, pos, offset, bytes);
 }
 
 static loff_t
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a11bc7b1f526..892c478d7073 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -9,6 +9,7 @@
 
 typedef unsigned long dax_entry_t;
 
+struct iomap;
 struct iomap_ops;
 struct dax_device;
 struct dax_operations {
@@ -161,13 +162,11 @@ int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
                 loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
 
 #ifdef CONFIG_FS_DAX
-int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int length);
+int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
+		unsigned int offset, unsigned int size);
 #else
-static inline int __dax_zero_page_range(struct block_device *bdev,
-		struct dax_device *dax_dev, sector_t sector,
-		unsigned int offset, unsigned int length)
+static inline int __dax_zero_page_range(struct iomap *iomap, loff_t pos,
+		unsigned int offset, unsigned int size)
 {
 	return -ENXIO;
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 391785de1428..e5a1b2a1962d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <linux/mm_types.h>
+#include <linux/blkdev.h>
 
 struct address_space;
 struct fiemap_extent_info;
@@ -122,6 +123,11 @@ static inline struct iomap_page *to_iomap_page(struct page *page)
 	return NULL;
 }
 
+static inline sector_t iomap_sector(struct iomap *iomap, loff_t pos)
+{
+	        return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
+}
+
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
-- 
2.16.4

