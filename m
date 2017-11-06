Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933219AbdKFTcw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A13B0ABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:51 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/10] btrfs: sink get_extent parameter to __extent_readpages
Date: Mon,  6 Nov 2017 20:31:00 +0100
Message-Id: <b1e7c6f86c7126ff810fe10c20aa08b4aab8c1aa.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass btrfs_get_extent.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1140ce4d321a..a266239716f7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3120,7 +3120,7 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 
 static void __extent_readpages(struct extent_io_tree *tree,
 			       struct page *pages[],
-			       int nr_pages, get_extent_t *get_extent,
+			       int nr_pages,
 			       struct extent_map **em_cached,
 			       struct bio **bio, unsigned long *bio_flags,
 			       u64 *prev_em_start)
@@ -3142,7 +3142,8 @@ static void __extent_readpages(struct extent_io_tree *tree,
 		} else {
 			__do_contiguous_readpages(tree, &pages[first_index],
 						  index - first_index, start,
-						  end, get_extent, em_cached,
+						  end, btrfs_get_extent,
+						  em_cached,
 						  bio, bio_flags,
 						  prev_em_start);
 			start = page_start;
@@ -3154,7 +3155,7 @@ static void __extent_readpages(struct extent_io_tree *tree,
 	if (end)
 		__do_contiguous_readpages(tree, &pages[first_index],
 					  index - first_index, start,
-					  end, get_extent, em_cached, bio,
+					  end, btrfs_get_extent, em_cached, bio,
 					  bio_flags, prev_em_start);
 }
 
@@ -4169,13 +4170,13 @@ int extent_readpages(struct extent_io_tree *tree,
 		pagepool[nr++] = page;
 		if (nr < ARRAY_SIZE(pagepool))
 			continue;
-		__extent_readpages(tree, pagepool, nr, btrfs_get_extent,
-				&em_cached, &bio, &bio_flags, &prev_em_start);
+		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
+				&bio_flags, &prev_em_start);
 		nr = 0;
 	}
 	if (nr)
-		__extent_readpages(tree, pagepool, nr, btrfs_get_extent,
-				&em_cached, &bio, &bio_flags, &prev_em_start);
+		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
+				&bio_flags, &prev_em_start);
 
 	if (em_cached)
 		free_extent_map(em_cached);
-- 
2.14.3

