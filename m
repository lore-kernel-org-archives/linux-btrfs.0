Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab3FSKTq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Jun 2013 06:19:46 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5JAJhxJ030447
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2013 18:19:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup redundant code in btrfs_submit_direct()
Date: Wed, 19 Jun 2013 18:19:17 +0800
Message-Id: <1371637157-5126-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 590c274..65ae1cb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7136,7 +7136,6 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_dio_private *dip;
-	struct bio_vec *bvec = dio_bio->bi_io_vec;
 	struct bio *io_bio;
 	int skip_sum;
 	int write = rw & REQ_WRITE;
@@ -7158,16 +7157,9 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 	}
 
 	dip->private = dio_bio->bi_private;
-	io_bio->bi_private = dio_bio->bi_private;
 	dip->inode = inode;
 	dip->logical_offset = file_offset;
-
-	dip->bytes = 0;
-	do {
-		dip->bytes += bvec->bv_len;
-		bvec++;
-	} while (bvec <= (dio_bio->bi_io_vec + dio_bio->bi_vcnt - 1));
-
+	dip->bytes = dio_bio->bi_size;
 	dip->disk_bytenr = (u64)dio_bio->bi_sector << 9;
 	io_bio->bi_private = dip;
 	dip->errors = 0;
-- 
1.8.1.4

