Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10067 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531AbaF1Ldc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:32 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXPHk021007
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/12] Btrfs: fix put dio bio twice when we submit dio bio fail
Date: Sat, 28 Jun 2014 19:34:51 +0800
Message-ID: <1403955302-22396-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
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
index 3668048..a3f102f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7294,10 +7294,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
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
@@ -7314,6 +7312,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	bio = btrfs_dio_bio_alloc(orig_bio->bi_bdev, start_sector, GFP_NOFS);
 	if (!bio)
 		return -ENOMEM;
+
 	bio->bi_private = dip;
 	bio->bi_end_io = btrfs_end_dio_bio;
 	atomic_inc(&dip->pending_bios);
-- 
1.9.3

