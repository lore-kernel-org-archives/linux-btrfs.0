Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932253AbdJXIum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Oct 2017 04:50:42 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant mirror_num arg
Date: Tue, 24 Oct 2017 11:50:39 +0300
Message-Id: <1508835039-26342-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following callpath is always invoked with mirror_num set to 0, so let's
remove it as an argument and directly pass 0 to __do_redpage. No functional 
change

extent_readpages
  __extent_readpages
    __do_contiguous_readpages
      __do_readpage

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 970190cd347e..b0dea802f24b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3093,7 +3093,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 					     u64 start, u64 end,
 					     get_extent_t *get_extent,
 					     struct extent_map **em_cached,
-					     struct bio **bio, int mirror_num,
+					     struct bio **bio,
 					     unsigned long *bio_flags,
 					     u64 *prev_em_start)
 {
@@ -3115,7 +3115,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 
 	for (index = 0; index < nr_pages; index++) {
 		__do_readpage(tree, pages[index], get_extent, em_cached, bio,
-			      mirror_num, bio_flags, 0, prev_em_start);
+			      0, bio_flags, 0, prev_em_start);
 		put_page(pages[index]);
 	}
 }
@@ -3124,8 +3124,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 			       struct page *pages[],
 			       int nr_pages, get_extent_t *get_extent,
 			       struct extent_map **em_cached,
-			       struct bio **bio, int mirror_num,
-			       unsigned long *bio_flags,
+			       struct bio **bio, unsigned long *bio_flags,
 			       u64 *prev_em_start)
 {
 	u64 start = 0;
@@ -3146,7 +3145,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 			__do_contiguous_readpages(tree, &pages[first_index],
 						  index - first_index, start,
 						  end, get_extent, em_cached,
-						  bio, mirror_num, bio_flags,
+						  bio, bio_flags,
 						  prev_em_start);
 			start = page_start;
 			end = start + PAGE_SIZE - 1;
@@ -3158,8 +3157,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 		__do_contiguous_readpages(tree, &pages[first_index],
 					  index - first_index, start,
 					  end, get_extent, em_cached, bio,
-					  mirror_num, bio_flags,
-					  prev_em_start);
+					  bio_flags, prev_em_start);
 }
 
 static int __extent_read_full_page(struct extent_io_tree *tree,
@@ -4189,12 +4187,12 @@ int extent_readpages(struct extent_io_tree *tree,
 		if (nr < ARRAY_SIZE(pagepool))
 			continue;
 		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, 0, &bio_flags, &prev_em_start);
+				   &bio, &bio_flags, &prev_em_start);
 		nr = 0;
 	}
 	if (nr)
 		__extent_readpages(tree, pagepool, nr, get_extent, &em_cached,
-				   &bio, 0, &bio_flags, &prev_em_start);
+				   &bio, &bio_flags, &prev_em_start);
 
 	if (em_cached)
 		free_extent_map(em_cached);
-- 
2.7.4

