Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54147 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752510AbeDSHqo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 03:46:44 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6678CADFA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 07:46:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/6] btrfs: Remove redundant tree argument from extent_readpages
Date: Thu, 19 Apr 2018 10:46:36 +0300
Message-Id: <1524123999-4220-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1524123999-4220-1-git-send-email-nborisov@suse.com>
References: <1524123999-4220-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is called only from btrfs_readpage and is already passed
the mapping. Simplify its signature by moving the code obtaining
reference to the extent tree in the function. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 6 +++---
 fs/btrfs/extent_io.h | 5 ++---
 fs/btrfs/inode.c     | 5 ++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ffa7bf370f14..5cde345fa0b6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4126,9 +4126,8 @@ int extent_writepages(struct extent_io_tree *tree,
 	return ret;
 }
 
-int extent_readpages(struct extent_io_tree *tree,
-		     struct address_space *mapping,
-		     struct list_head *pages, unsigned nr_pages)
+int extent_readpages(struct address_space *mapping, struct list_head *pages,
+		     unsigned nr_pages)
 {
 	struct bio *bio = NULL;
 	unsigned page_idx;
@@ -4136,6 +4135,7 @@ int extent_readpages(struct extent_io_tree *tree,
 	struct page *pagepool[16];
 	struct page *page;
 	struct extent_map *em_cached = NULL;
+	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
 	int nr = 0;
 	u64 prev_em_start = (u64)-1;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index cf131fcbecc1..2f085108335d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -424,9 +424,8 @@ int extent_writepages(struct extent_io_tree *tree,
 		      struct writeback_control *wbc);
 int btree_write_cache_pages(struct address_space *mapping,
 			    struct writeback_control *wbc);
-int extent_readpages(struct extent_io_tree *tree,
-		     struct address_space *mapping,
-		     struct list_head *pages, unsigned nr_pages);
+int extent_readpages(struct address_space *mapping, struct list_head *pages,
+		     unsigned nr_pages);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len);
 void set_page_extent_mapped(struct page *page);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a5b8229aa2d8..7b1026a7ffab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8740,10 +8740,9 @@ static int
 btrfs_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
-	struct extent_io_tree *tree;
-	tree = &BTRFS_I(mapping->host)->io_tree;
-	return extent_readpages(tree, mapping, pages, nr_pages);
+	return extent_readpages(mapping, pages, nr_pages);
 }
+
 static int __btrfs_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	int ret = try_release_extent_mapping(page, gfp_flags);
-- 
2.7.4

