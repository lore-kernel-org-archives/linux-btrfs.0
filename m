Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39842 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757036AbaFSClY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 22:41:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J2fMbY024072
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:41:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/7] Btrfs: use bio_endio_nodec instead of open code
Date: Thu, 19 Jun 2014 10:42:53 +0800
Message-ID: <1403145775-22641-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 19c298a..31f9036 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5399,12 +5399,6 @@ static void btrfs_end_bio(struct bio *bio, int err)
 			bio = bbio->orig_bio;
 		}
 
- 		/*
-		 * We have original bio now. So increment bi_remaining to
-		 * account for it in endio
-		 */
-		atomic_inc(&bio->bi_remaining);
-
 		bio->bi_private = bbio->private;
 		bio->bi_end_io = bbio->end_io;
 		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
@@ -5422,8 +5416,7 @@ static void btrfs_end_bio(struct bio *bio, int err)
 			err = 0;
 		}
 		kfree(bbio);
-
-		bio_endio(bio, err);
+		bio_endio_nodec(bio, err);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
-- 
1.9.3

