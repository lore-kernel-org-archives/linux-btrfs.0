Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:37679 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971626AbeEXVll (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 17:41:41 -0400
Received: by mail-pl0-f67.google.com with SMTP id w19-v6so1829701plq.4
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 14:41:41 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH v4 1/6] mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
Date: Thu, 24 May 2018 14:41:25 -0700
Message-Id: <289f334fa8e5d1239eab667415d287edf0e13f14.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The SWP_FILE flag serves two purposes: to make swap_{read,write}page()
go through the filesystem, and to make swapoff() call
->swap_deactivate(). For Btrfs, we want the latter but not the former,
so split this flag into two. This makes us always call
->swap_deactivate() if ->swap_activate() succeeded, not just if it
didn't add any swap extents itself.

This also resolves the issue of the very misleading name of SWP_FILE,
which is only used for swap files over NFS.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 include/linux/swap.h | 13 +++++++------
 mm/page_io.c         |  6 +++---
 mm/swapfile.c        | 13 ++++++++-----
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2417d288e016..29dfd436435c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -167,13 +167,14 @@ enum {
 	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 	SWP_CONTINUED	= (1 << 5),	/* swap_map has count continuation */
 	SWP_BLKDEV	= (1 << 6),	/* its a block device */
-	SWP_FILE	= (1 << 7),	/* set after swap_activate success */
-	SWP_AREA_DISCARD = (1 << 8),	/* single-time swap area discards */
-	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
-	SWP_STABLE_WRITES = (1 << 10),	/* no overwrite PG_writeback pages */
-	SWP_SYNCHRONOUS_IO = (1 << 11),	/* synchronous IO is efficient */
+	SWP_ACTIVATED	= (1 << 7),	/* set after swap_activate success */
+	SWP_FS		= (1 << 8),	/* swap file goes through fs */
+	SWP_AREA_DISCARD = (1 << 9),	/* single-time swap area discards */
+	SWP_PAGE_DISCARD = (1 << 10),	/* freed swap page-cluster discards */
+	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
+	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 12),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 13),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
diff --git a/mm/page_io.c b/mm/page_io.c
index b41cf9644585..f2d06c1d0cc1 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -283,7 +283,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_FS) {
 		struct kiocb kiocb;
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
@@ -364,7 +364,7 @@ int swap_readpage(struct page *page, bool synchronous)
 		goto out;
 	}
 
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_FS) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
@@ -422,7 +422,7 @@ int swap_set_page_dirty(struct page *page)
 {
 	struct swap_info_struct *sis = page_swap_info(page);
 
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_FS) {
 		struct address_space *mapping = sis->swap_file->f_mapping;
 
 		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cc2cf04d9018..886c9d89b144 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -973,7 +973,7 @@ int get_swap_pages(int n_goal, bool cluster, swp_entry_t swp_entries[])
 			goto nextsi;
 		}
 		if (cluster) {
-			if (!(si->flags & SWP_FILE))
+			if (!(si->flags & SWP_FS))
 				n_ret = swap_alloc_cluster(si, swp_entries);
 		} else
 			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
@@ -2327,12 +2327,13 @@ static void destroy_swap_extents(struct swap_info_struct *sis)
 		kfree(se);
 	}
 
-	if (sis->flags & SWP_FILE) {
+	if (sis->flags & SWP_ACTIVATED) {
 		struct file *swap_file = sis->swap_file;
 		struct address_space *mapping = swap_file->f_mapping;
 
-		sis->flags &= ~SWP_FILE;
-		mapping->a_ops->swap_deactivate(swap_file);
+		sis->flags &= ~SWP_ACTIVATED;
+		if (mapping->a_ops->swap_deactivate)
+			mapping->a_ops->swap_deactivate(swap_file);
 	}
 }
 
@@ -2428,8 +2429,10 @@ static int setup_swap_extents(struct swap_info_struct *sis, sector_t *span)
 
 	if (mapping->a_ops->swap_activate) {
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
+		if (ret >= 0)
+			sis->flags |= SWP_ACTIVATED;
 		if (!ret) {
-			sis->flags |= SWP_FILE;
+			sis->flags |= SWP_FS;
 			ret = add_swap_extent(sis, 0, sis->max, 0);
 			*span = sis->pages;
 		}
-- 
2.17.0

