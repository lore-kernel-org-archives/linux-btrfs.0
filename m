Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18140 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab3KUNmU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 08:42:20 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rALDgChC019714
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 21:42:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs: remove the unnecessary flush when preparing the pages
Date: Thu, 21 Nov 2013 21:43:16 +0800
Message-Id: <1385041398-8521-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1385041398-8521-1-git-send-email-miaox@cn.fujitsu.com>
References: <1385041398-8521-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 82d0342..27f65e4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1286,12 +1286,11 @@ again:
 		struct btrfs_ordered_extent *ordered;
 		lock_extent_bits(&BTRFS_I(inode)->io_tree,
 				 start_pos, last_pos - 1, 0, &cached_state);
-		ordered = btrfs_lookup_first_ordered_extent(inode,
-							    last_pos - 1);
+		ordered = btrfs_lookup_ordered_range(inode, start_pos,
+						     last_pos - start_pos);
 		if (ordered &&
 		    ordered->file_offset + ordered->len > start_pos &&
 		    ordered->file_offset < last_pos) {
-			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     start_pos, last_pos - 1,
 					     &cached_state, GFP_NOFS);
@@ -1299,10 +1298,8 @@ again:
 				unlock_page(pages[i]);
 				page_cache_release(pages[i]);
 			}
-			err = btrfs_wait_ordered_range(inode, start_pos,
-						       last_pos - start_pos);
-			if (err)
-				goto fail;
+			btrfs_start_ordered_extent(inode, ordered, 1);
+			btrfs_put_ordered_extent(ordered);
 			goto again;
 		}
 		if (ordered)
-- 
1.8.3.1

