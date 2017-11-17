Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34889 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161083AbdKQRpJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:09 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5A0BBADF4
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:07 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 3/8] fs: Introduce IOMAP_F_NOBH
Date: Fri, 17 Nov 2017 11:44:49 -0600
Message-Id: <20171117174456.13393-4-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

IOMAP_F_NOBH tells iomap functions not to use or attach buffer heads
to the page. Page flush and writeback is the responsibility of the
filesystem (such as btrfs) code, which use bio to perform it.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/iomap.c            | 20 ++++++++++++--------
 include/linux/iomap.h |  1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index d4801f8dd4fd..9ec9cc3077b3 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -123,7 +123,8 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 	if (!page)
 		return -ENOMEM;
 
-	status = __block_write_begin_int(page, pos, len, NULL, iomap);
+	if (!(iomap->flags & IOMAP_F_NOBH))
+		status = __block_write_begin_int(page, pos, len, NULL, iomap);
 	if (unlikely(status)) {
 		unlock_page(page);
 		put_page(page);
@@ -138,12 +139,15 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 
 static int
 iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
-		unsigned copied, struct page *page)
+		unsigned copied, struct page *page, struct iomap *iomap)
 {
-	int ret;
+	int ret = len;
 
-	ret = generic_write_end(NULL, inode->i_mapping, pos, len,
-			copied, page, NULL);
+	if (iomap->flags & IOMAP_F_NOBH)
+		ret = inode_extend_page(inode, pos, copied, page);
+	else
+		ret = generic_write_end(NULL, inode->i_mapping, pos, len,
+					copied, page, NULL);
 	if (ret < len)
 		iomap_write_failed(inode, pos, len);
 	return ret;
@@ -198,7 +202,7 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		flush_dcache_page(page);
 
-		status = iomap_write_end(inode, pos, bytes, copied, page);
+		status = iomap_write_end(inode, pos, bytes, copied, page, iomap);
 		if (unlikely(status < 0))
 			break;
 		copied = status;
@@ -292,7 +296,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		WARN_ON_ONCE(!PageUptodate(page));
 
-		status = iomap_write_end(inode, pos, bytes, bytes, page);
+		status = iomap_write_end(inode, pos, bytes, bytes, page, iomap);
 		if (unlikely(status <= 0)) {
 			if (WARN_ON_ONCE(status == 0))
 				return -EIO;
@@ -344,7 +348,7 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 	zero_user(page, offset, bytes);
 	mark_page_accessed(page);
 
-	return iomap_write_end(inode, pos, bytes, bytes, page);
+	return iomap_write_end(inode, pos, bytes, bytes, page, iomap);
 }
 
 static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8a7c6d26b147..61af7b1bd0fc 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -29,6 +29,7 @@ struct vm_fault;
  */
 #define IOMAP_F_MERGED	0x10	/* contains multiple blocks/extents */
 #define IOMAP_F_SHARED	0x20	/* block shared with another file */
+#define IOMAP_F_NOBH	0x40	/* Do not assign buffer heads */
 
 /*
  * Magic value for blkno:
-- 
2.14.2

