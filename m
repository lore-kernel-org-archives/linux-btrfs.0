Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54229 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933223AbdKFTcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:55 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8F61EAC6F
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:54 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/10] btrfs: sink get_extent parameter to __do_contiguous_readpages
Date: Mon,  6 Nov 2017 20:31:02 +0100
Message-Id: <88c743ee58491f76225c8241819ec09c57c19733.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass btrfs_get_extent.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a266239716f7..72620cf41423 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3089,7 +3089,6 @@ static int __do_readpage(struct extent_io_tree *tree,
 static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 					     struct page *pages[], int nr_pages,
 					     u64 start, u64 end,
-					     get_extent_t *get_extent,
 					     struct extent_map **em_cached,
 					     struct bio **bio,
 					     unsigned long *bio_flags,
@@ -3112,8 +3111,8 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 	}
 
 	for (index = 0; index < nr_pages; index++) {
-		__do_readpage(tree, pages[index], get_extent, em_cached, bio,
-			      0, bio_flags, 0, prev_em_start);
+		__do_readpage(tree, pages[index], btrfs_get_extent, em_cached,
+				bio, 0, bio_flags, 0, prev_em_start);
 		put_page(pages[index]);
 	}
 }
@@ -3142,8 +3141,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 		} else {
 			__do_contiguous_readpages(tree, &pages[first_index],
 						  index - first_index, start,
-						  end, btrfs_get_extent,
-						  em_cached,
+						  end, em_cached,
 						  bio, bio_flags,
 						  prev_em_start);
 			start = page_start;
@@ -3155,7 +3153,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 	if (end)
 		__do_contiguous_readpages(tree, &pages[first_index],
 					  index - first_index, start,
-					  end, btrfs_get_extent, em_cached, bio,
+					  end, em_cached, bio,
 					  bio_flags, prev_em_start);
 }
 
-- 
2.14.3

