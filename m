From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 04/10 v2] btrfs: Add error check for add_to_page_cache_lru
Date: Mon, 24 May 2010 10:39:07 +0800
Message-ID: <4BF9E6CB.4050607@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Mike Fedyk <mfedyk@mikefedyk.com>
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
 fs/btrfs/compression.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 1d54c53..9832083 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -469,6 +469,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		page = radix_tree_lookup(&mapping->page_tree, page_index);
 		rcu_read_unlock();
 		if (page) {
+check_misses:
 			misses++;
 			if (misses > 4)
 				break;
@@ -480,10 +481,19 @@ static noinline int add_ra_bio_pages(struct inode *inode,
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
+			if (ret == -EEXIST)
+				goto check_misses;
+
+			break;
 		}
 
 		end = last_offset + PAGE_CACHE_SIZE - 1;
-- 
1.6.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


