From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 04/10] btrfs: Add error check for add_to_page_cache_lru
Date: Thu, 20 May 2010 15:18:21 +0800
Message-ID: <4BF4E23D.6080405@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liubo2009@cn.fujitsu.com>

If add_to_page_cache_lru() returns -EEXIST, it indicates the page
that belongs to this page_index has been added and this readahead
action can go on to next page.

If add_to_page_cache_lru() returns -ENOMEM, it should break for
no memory left.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/compression.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1d54c53..1bd4d92 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -480,10 +480,23 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		if (!page)
 			break;
 
-		if (add_to_page_cache_lru(page, mapping, page_index,
-								GFP_NOFS)) {
+		ret = add_to_page_cache_lru(page, mapping, page_index,
+								GFP_NOFS);
+		if (ret) {
 			page_cache_release(page);
-			goto next;
+
+			/*
+			 * -EEXIST indicates the page has been added, so
+			 * it can move on to next page.
+			 */
+			if (ret == -EEXIST) {
+				misses++;
+				if (misses > 4)
+					break;
+				goto next;
+			}
+
+			break;
 		}
 
 		end = last_offset + PAGE_CACHE_SIZE - 1;
-- 
1.6.5.2

