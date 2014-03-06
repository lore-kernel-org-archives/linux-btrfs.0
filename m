Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9645 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaCFFxd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:33 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rUfb009849
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 04/10] Btrfs: remove the unnecessary flush when preparing the pages
Date: Thu, 6 Mar 2014 13:54:58 +0800
Message-Id: <1394085304-32589-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- None.
---
 fs/btrfs/file.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0165b86..76b725e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1346,11 +1346,11 @@ lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
 				 start_pos, last_pos, 0, cached_state);
-		ordered = btrfs_lookup_first_ordered_extent(inode, last_pos);
+		ordered = btrfs_lookup_ordered_range(inode, start_pos,
+						     last_pos - start_pos + 1);
 		if (ordered &&
 		    ordered->file_offset + ordered->len > start_pos &&
 		    ordered->file_offset <= last_pos) {
-			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     start_pos, last_pos,
 					     cached_state, GFP_NOFS);
@@ -1358,12 +1358,9 @@ lock_and_cleanup_extent_if_need(struct inode *inode, struct page **pages,
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
 			}
-			ret = btrfs_wait_ordered_range(inode, start_pos,
-						last_pos - start_pos + 1);
-			if (ret)
-				return ret;
-			else
-				return -EAGAIN;
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
+			return -EAGAIN;
 		}
 		if (ordered)
 			btrfs_put_ordered_extent(ordered);
-- 
1.8.1.4

