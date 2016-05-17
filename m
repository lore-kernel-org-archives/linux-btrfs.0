Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11698 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754836AbcEQJlJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:41:09 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 4652D489F960
	for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 17:41:00 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: scrub: Set bbio to NULL before calling btrfs_map_block
Date: Tue, 17 May 2016 17:37:38 +0800
Message-ID: <f8f418a78c2a31b805fb2a7cdbaa90292b4317f0.1463477847.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We usually call btrfs_put_bbio() when btrfs_map_block() failed,
btrfs_put_bbio() works right whether bbio is a valid value, or NULL.

But there is a exception, in some case, btrfs_map_block() will return
fail without touching *bbio(keeping its original value), and if bbio
was not initialized yet, invalid memory accessing will happened.

Above case is in scrub_missing_raid56_pages(), and similar case in
scrub_raid56_parity().

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4678f03..d285d76 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2179,7 +2179,7 @@ static void scrub_missing_raid56_pages(struct scrub_block *sblock)
 	struct btrfs_fs_info *fs_info = sctx->dev_root->fs_info;
 	u64 length = sblock->page_count * PAGE_SIZE;
 	u64 logical = sblock->pagev[0]->logical;
-	struct btrfs_bio *bbio;
+	struct btrfs_bio *bbio = NULL;
 	struct bio *bio;
 	struct btrfs_raid_bio *rbio;
 	int ret;
@@ -2980,6 +2980,7 @@ again:
 						       extent_len);
 
 			mapped_length = extent_len;
+			bbio = NULL;
 			ret = btrfs_map_block(fs_info, READ, extent_logical,
 					      &mapped_length, &bbio, 0);
 			if (!ret) {
-- 
1.8.5.1



