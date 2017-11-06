Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54201 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933206AbdKFTcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5072FABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:49 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/10] btrfs: sink get_extent parameter to extent_readpages
Date: Mon,  6 Nov 2017 20:30:58 +0100
Message-Id: <d63f10ecc3bdac6e246cf549360aee68a9ce27e7.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's only one caller that passes btrfs_get_extent.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 11 +++++------
 fs/btrfs/extent_io.h |  3 +--
 fs/btrfs/inode.c     |  3 +--
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c30694f57d02..1140ce4d321a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4143,8 +4143,7 @@ int extent_writepages(struct extent_io_tree *tree,
 
 int extent_readpages(struct extent_io_tree *tree,
 		     struct address_space *mapping,
-		     struct list_head *pages, unsigned nr_pages,
-		     get_extent_t get_extent)
+		     struct list_head *pages, unsigned nr_pages)
 {
 	struct bio *bio = NULL;
 	unsigned page_idx;
@@ -4170,13 +4169,13 @@ int extent_readpages(struct extent_io_tree *tree,
 		pagepool[nr++] = page;
 		if (nr < ARRAY_SIZE(pagepool))
 			continue;
-		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, &bio_flags, &prev_em_start);
+		__extent_readpages(tree, pagepool, nr, btrfs_get_extent,
+				&em_cached, &bio, &bio_flags, &prev_em_start);
 		nr = 0;
 	}
 	if (nr)
-		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, &bio_flags, &prev_em_start);
+		__extent_readpages(tree, pagepool, nr, btrfs_get_extent,
+				&em_cached, &bio, &bio_flags, &prev_em_start);
 
 	if (em_cached)
 		free_extent_map(em_cached);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 917b24bc7547..5295deb8a153 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -410,8 +410,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 			    struct writeback_control *wbc);
 int extent_readpages(struct extent_io_tree *tree,
 		     struct address_space *mapping,
-		     struct list_head *pages, unsigned nr_pages,
-		     get_extent_t get_extent);
+		     struct list_head *pages, unsigned nr_pages);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len);
 void set_page_extent_mapped(struct page *page);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 588c269bfc13..ebdf2b07bb20 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8892,8 +8892,7 @@ btrfs_readpages(struct file *file, struct address_space *mapping,
 {
 	struct extent_io_tree *tree;
 	tree = &BTRFS_I(mapping->host)->io_tree;
-	return extent_readpages(tree, mapping, pages, nr_pages,
-				btrfs_get_extent);
+	return extent_readpages(tree, mapping, pages, nr_pages);
 }
 static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 {
-- 
2.14.3

