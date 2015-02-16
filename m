Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6142 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbbBPD5k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 22:57:40 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1G3uqbR030856
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 11:56:52 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: cleanup: use for() loop in btrfs_map_bio()
Date: Mon, 16 Feb 2015 11:56:31 +0800
Message-ID: <1424058991-30196-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

for() is obviously better in these code block, and remove noused
init-value to reduce about 6 bytes binary size.

Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 50c5a87..85f2bfc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5810,8 +5810,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	u64 map_length;
 	u64 *raid_map = NULL;
 	int ret;
-	int dev_nr = 0;
-	int total_devs = 1;
+	int dev_nr;
+	int total_devs;
 	struct btrfs_bio *bbio = NULL;
 
 	length = bio->bi_iter.bi_size;
@@ -5854,11 +5854,10 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		BUG();
 	}
 
-	while (dev_nr < total_devs) {
+	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
 		if (!dev || !dev->bdev || (rw & WRITE && !dev->writeable)) {
 			bbio_error(bbio, first_bio, logical);
-			dev_nr++;
 			continue;
 		}
 
@@ -5871,7 +5870,6 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 			ret = breakup_stripe_bio(root, bbio, first_bio, dev,
 						 dev_nr, rw, async_submit);
 			BUG_ON(ret);
-			dev_nr++;
 			continue;
 		}
 
@@ -5886,7 +5884,6 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		submit_stripe_bio(root, bbio, bio,
 				  bbio->stripes[dev_nr].physical, dev_nr, rw,
 				  async_submit);
-		dev_nr++;
 	}
 	btrfs_bio_counter_dec(root->fs_info);
 	return 0;
-- 
1.8.5.1

