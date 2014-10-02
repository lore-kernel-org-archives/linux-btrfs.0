Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbaJBQue (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:50:34 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E1D02AAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:50:32 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 11/14] btrfs: drop constant param from btrfs_release_extent_buffer_page
Date: Thu,  2 Oct 2014 18:50:32 +0200
Message-Id: <a50924e3a4d7fccb0ecfbd42a4c7ed6e56ee1765.1412264873.git.dsterba@suse.cz>
In-Reply-To: <cover.1412264871.git.dsterba@suse.cz>
References: <cover.1412264871.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers use the same value, simplify the function.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/extent_io.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 78229007f99e..638e1a5b00e2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4450,19 +4450,16 @@ int extent_buffer_under_io(struct extent_buffer *eb)
 /*
  * Helper for releasing extent buffer page.
  */
-static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
-						unsigned long start_idx)
+static void btrfs_release_extent_buffer_page(struct extent_buffer *eb)
 {
 	unsigned long index;
-	unsigned long num_pages;
 	struct page *page;
 	int mapped = !test_bit(EXTENT_BUFFER_DUMMY, &eb->bflags);
 
 	BUG_ON(extent_buffer_under_io(eb));
 
-	num_pages = num_extent_pages(eb->start, eb->len);
-	index = start_idx + num_pages;
-	if (start_idx >= index)
+	index = num_extent_pages(eb->start, eb->len);
+	if (index == 0)
 		return;
 
 	do {
@@ -4498,7 +4495,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
 			/* One for when we alloced the page */
 			page_cache_release(page);
 		}
-	} while (index != start_idx);
+	} while (index != 0);
 }
 
 /*
@@ -4506,7 +4503,7 @@ static void btrfs_release_extent_buffer_page(struct extent_buffer *eb,
  */
 static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 {
-	btrfs_release_extent_buffer_page(eb, 0);
+	btrfs_release_extent_buffer_page(eb);
 	__free_extent_buffer(eb);
 }
 
@@ -4863,7 +4860,7 @@ static int release_extent_buffer(struct extent_buffer *eb)
 		}
 
 		/* Should be safe to release our pages at this point */
-		btrfs_release_extent_buffer_page(eb, 0);
+		btrfs_release_extent_buffer_page(eb);
 		call_rcu(&eb->rcu_head, btrfs_release_extent_buffer_rcu);
 		return 1;
 	}
-- 
1.8.4.5

