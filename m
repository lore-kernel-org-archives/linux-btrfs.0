Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933153AbeCFTY3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 14:24:29 -0500
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v8 26/63] page cache: Rearrange address_space
Date: Tue,  6 Mar 2018 11:23:36 -0800
Message-Id: <20180306192413.5499-27-willy@infradead.org>
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Matthew Wilcox <mawilcox@microsoft.com>

Change i_pages from a radix_tree_root to an xarray, convert the
documentation into kernel-doc format and change the order of the elements
to pack them better on 64-bit systems.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/fs.h | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 75f1f66aec35..785100c2b835 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -389,24 +389,40 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata);
 
+/**
+ * struct address_space - Contents of a cacheable, mappable object.
+ * @host: Owner, either the inode or the block_device.
+ * @i_pages: Cached pages.
+ * @gfp_mask: Memory allocation flags to use for allocating pages.
+ * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap: Tree of private and shared mappings.
+ * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
+ * @nrpages: Number of page entries, protected by the i_pages lock.
+ * @nrexceptional: Shadow or DAX entries, protected by the i_pages lock.
+ * @writeback_index: Writeback starts here.
+ * @a_ops: Methods.
+ * @flags: Error bits and flags (AS_*).
+ * @wb_err: The most recent error which has occurred.
+ * @private_lock: For use by the owner of the address_space.
+ * @private_list: For use by the owner of the address_space.
+ * @private_data: For use by the owner of the address_space.
+ */
 struct address_space {
-	struct inode		*host;		/* owner: inode, block_device */
-	struct radix_tree_root	i_pages;	/* cached pages */
-	atomic_t		i_mmap_writable;/* count VM_SHARED mappings */
-	struct rb_root_cached	i_mmap;		/* tree of private and shared mappings */
-	struct rw_semaphore	i_mmap_rwsem;	/* protect tree, count, list */
-	/* Protected by the i_pages lock */
-	unsigned long		nrpages;	/* number of total pages */
-	/* number of shadow or DAX exceptional entries */
+	struct inode		*host;
+	struct xarray		i_pages;
+	gfp_t			gfp_mask;
+	atomic_t		i_mmap_writable;
+	struct rb_root_cached	i_mmap;
+	struct rw_semaphore	i_mmap_rwsem;
+	unsigned long		nrpages;
 	unsigned long		nrexceptional;
-	pgoff_t			writeback_index;/* writeback starts here */
-	const struct address_space_operations *a_ops;	/* methods */
-	unsigned long		flags;		/* error bits */
-	spinlock_t		private_lock;	/* for use by the address_space */
-	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
-	struct list_head	private_list;	/* for use by the address_space */
-	void			*private_data;	/* ditto */
+	pgoff_t			writeback_index;
+	const struct address_space_operations *a_ops;
+	unsigned long		flags;
 	errseq_t		wb_err;
+	spinlock_t		private_lock;
+	struct list_head	private_list;
+	void			*private_data;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
-- 
2.16.1

