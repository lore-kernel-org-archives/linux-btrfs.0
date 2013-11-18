Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38843 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3KRNNa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 08:13:30 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix bio_size_ok() for max_sectors > 0xffff
Date: Mon, 18 Nov 2013 22:13:18 +0900
Message-Id: <1384780398-25071-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The data type of max_sectors in queue settings is unsigned int.  But
this value is stored to the local variable whose type is unsigned short
in bio_size_ok().  This can cause unexpected result when max_sectors >
0xffff.

Cc: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---

This patch is only compile tested.

 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0db6370..92303f4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5394,7 +5394,7 @@ static int bio_size_ok(struct block_device *bdev, struct bio *bio,
 {
 	struct bio_vec *prev;
 	struct request_queue *q = bdev_get_queue(bdev);
-	unsigned short max_sectors = queue_max_sectors(q);
+	unsigned int max_sectors = queue_max_sectors(q);
 	struct bvec_merge_data bvm = {
 		.bi_bdev = bdev,
 		.bi_sector = sector,
-- 
1.8.3.2

