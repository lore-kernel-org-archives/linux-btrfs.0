Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56580 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758125AbaGCKUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 06:20:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s63AKjRU013551
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 18:20:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RESEND 4/9] Btrfs: fix put dio bio twice when we submit dio bio fail
Date: Thu, 3 Jul 2014 18:22:08 +0800
Message-ID: <1404382933-26672-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
References: <1404382933-26672-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The caller of btrfs_submit_direct_hook() will put the original dio bio
when btrfs_submit_direct_hook() return a error number, so we needn't
put the original bio in btrfs_submit_direct_hook().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a616fa4..15902eb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7325,10 +7325,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	map_length = orig_bio->bi_iter.bi_size;
 	ret = btrfs_map_block(root->fs_info, rw, start_sector << 9,
 			      &map_length, NULL, 0);
-	if (ret) {
-		bio_put(orig_bio);
+	if (ret)
 		return -EIO;
-	}
 
 	if (map_length >= orig_bio->bi_iter.bi_size) {
 		bio = orig_bio;
@@ -7345,6 +7343,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
 	if (!bio)
 		return -ENOMEM;
+
 	bio->bi_private = dip;
 	bio->bi_end_io = btrfs_end_dio_bio;
 	atomic_inc(&dip->pending_bios);
-- 
1.9.3

