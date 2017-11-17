Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34880 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161078AbdKQRpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 12:45:06 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4034AABFC
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Nov 2017 17:45:05 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 2/8] fs: Add inode_extend_page()
Date: Fri, 17 Nov 2017 11:44:48 -0600
Message-Id: <20171117174456.13393-3-rgoldwyn@suse.de>
In-Reply-To: <20171117174456.13393-1-rgoldwyn@suse.de>
References: <20171117174456.13393-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This splits the generic_write_end() into functions which handle
block_write_end() and iomap_extend_page().

iomap_extend_page() performs the functions of increasing
i_size (if required) and extending pagecache.

Performed this split so we don't use buffer_heads while ending file I/O.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/buffer.c                 | 20 +++++++++++++-------
 include/linux/buffer_head.h |  1 +
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 170df856bdb9..266daa85b80e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2180,16 +2180,11 @@ int block_write_end(struct file *file, struct address_space *mapping,
 }
 EXPORT_SYMBOL(block_write_end);
 
-int generic_write_end(struct file *file, struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata)
+int inode_extend_page(struct inode *inode, loff_t pos,
+		unsigned copied, struct page *page)
 {
-	struct inode *inode = mapping->host;
 	loff_t old_size = inode->i_size;
 	int i_size_changed = 0;
-
-	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
-
 	/*
 	 * No need to use i_size_read() here, the i_size
 	 * cannot change under us because we hold i_mutex.
@@ -2218,6 +2213,17 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 
 	return copied;
 }
+EXPORT_SYMBOL(inode_extend_page);
+
+int generic_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	return inode_extend_page(inode, pos, copied, page);
+
+}
 EXPORT_SYMBOL(generic_write_end);
 
 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index afa37f807f12..16cf994be178 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -229,6 +229,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 int block_write_end(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page *, void *);
+int inode_extend_page(struct inode *, loff_t, unsigned, struct page*);
 int generic_write_end(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page *, void *);
-- 
2.14.2

