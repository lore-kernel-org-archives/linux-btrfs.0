Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33551 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaHSPd2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 11:33:28 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>
Subject: [PATCH] Btrfs: fix crash on endio of reading corrupted block
Date: Tue, 19 Aug 2014 23:33:13 +0800
Message-Id: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The crash is

------------[ cut here ]------------
kernel BUG at fs/btrfs/extent_io.c:2124!
[...]
Workqueue: btrfs-endio normal_work_helper [btrfs]
RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]

This is in fact a regression.

It is because we forgot to increase @offset properly in reading corrupted block,
so that the @offset remains, and this leads to checksum errors while reading
left blocks queued up in the same bio, and then ends up with hiting the above
BUG_ON.

Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3af4966..be41e4d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2602,6 +2602,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
 				if (err)
 					uptodate = 0;
+				offset += len;
 				continue;
 			}
 		}
-- 
1.8.1.4

