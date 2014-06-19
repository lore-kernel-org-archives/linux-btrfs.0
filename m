Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39842 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757036AbaFSCl2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 22:41:28 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J2fQEG024082
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 10:41:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 7/7] Btrfs: fix wrong error handle when the device is missing or is not writeable
Date: Thu, 19 Jun 2014 10:42:55 +0800
Message-ID: <1403145775-22641-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403145775-22641-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original bio might be submitted, so we shoud increase bi_remaining to
account for it when we deal with the error that the device is missing or
is not writeable, or we would skip the endio handle.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ca3c92..c83b242 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5359,6 +5359,15 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	return 0;
 }
 
+static inline void btrfs_end_bbio(struct btrfs_bio *bbio, struct bio *bio, int err)
+{
+	if (likely(bbio->flags & BTRFS_BIO_ORIG_BIO_SUBMITTED))
+		bio_endio_nodec(bio, err);
+	else
+		bio_endio(bio, err);
+	kfree(bbio);
+}
+
 static void btrfs_end_bio(struct bio *bio, int err)
 {
 	struct btrfs_bio *bbio = bio->bi_private;
@@ -5416,11 +5425,7 @@ static void btrfs_end_bio(struct bio *bio, int err)
 			err = 0;
 		}
 
-		if (likely(bbio->flags & BTRFS_BIO_ORIG_BIO_SUBMITTED))
-			bio_endio_nodec(bio, err);
-		else
-			bio_endio(bio, err);
-		kfree(bbio);
+		btrfs_end_bbio(bbio, bio, err);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
@@ -5583,12 +5588,15 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 {
 	atomic_inc(&bbio->error);
 	if (atomic_dec_and_test(&bbio->stripes_pending)) {
+		/* Shoud be the original bio. */
+		WARN_ON(bio != bbio->orig_bio);
+
 		bio->bi_private = bbio->private;
 		bio->bi_end_io = bbio->end_io;
 		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
 		bio->bi_iter.bi_sector = logical >> 9;
-		kfree(bbio);
-		bio_endio(bio, -EIO);
+
+		btrfs_end_bbio(bbio, bio, -EIO);
 	}
 }
 
-- 
1.9.3

