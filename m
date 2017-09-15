Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:44322 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdIOIrf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 04:47:35 -0400
From: peterh <peterh@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Kuanling Huang <peterh@synology.com>
Subject: [PATCH] Btrfs: send, apply asynchronous page cache readahead to enhance page read
Date: Fri, 15 Sep 2017 16:47:45 +0800
Message-Id: <1505465265-9764-1-git-send-email-peterh@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Kuanling Huang <peterh@synology.com>

By analyzing the perf on btrfs send, we found it take large
amount of cpu time on page_cache_sync_readahead. This effort
can be reduced after switching to asynchronous one. Overall
performance gain on HDD and SSD were 9 and 15 percent if
simply send a large file.

Signed-off-by: Kuanling Huang <peterh@synology.com>
---
 fs/btrfs/send.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 63a6152..7a5eb66 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4475,16 +4475,27 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 	/* initial readahead */
 	memset(&sctx->ra, 0, sizeof(struct file_ra_state));
 	file_ra_state_init(&sctx->ra, inode->i_mapping);
-	btrfs_force_ra(inode->i_mapping, &sctx->ra, NULL, index,
-		       last_index - index + 1);
 
 	while (index <= last_index) {
 		unsigned cur_len = min_t(unsigned, len,
 					 PAGE_CACHE_SIZE - pg_offset);
-		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+		page = find_lock_page(inode->i_mapping, index);
 		if (!page) {
-			ret = -ENOMEM;
-			break;
+			page_cache_sync_readahead(inode->i_mapping,
+				&sctx->ra, NULL, index,
+				last_index + 1 - index);
+
+			page = find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
+			if (!page) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
+
+		if (PageReadahead(page)) {
+			page_cache_async_readahead(inode->i_mapping,
+				&sctx->ra, NULL, page, index,
+				last_index + 1 - index);
 		}
 
 		if (!PageUptodate(page)) {
-- 
1.9.1

