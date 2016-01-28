Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60089 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755107AbcA1HlB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 02:41:01 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 029E441896ED
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 15:39:57 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: reada: Ignore creating reada_extent for non-exist device
Date: Thu, 28 Jan 2016 15:38:37 +0800
Message-ID: <0b625fb1b1bef88f7c6c953ce8972c9aee33c9a1.1453966709.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For a non-exist device, old code bypass adding it in dev's reada
queue.

And to solve problem of unfinished waitting in raid5/6,
commit 5fbc7c59fd22 ("Btrfs: fix unfinished readahead thread for
raid5/6 degraded mounting")
adding a exception for the first strip, in short, the first
strip will always be processed whether the device exist or not.

Actually we have a better way for above request: just bypass
creation of the reada_extent for non-exist device, it will make
code simple and effective.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 12a9c9c..5b5187e 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -371,6 +371,11 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		struct reada_zone *zone;
 
 		dev = bbio->stripes[nzones].dev;
+
+		/* cannot read ahead on missing device. */
+		 if (!dev->bdev)
+			continue;
+
 		zone = reada_find_zone(fs_info, dev, logical, bbio);
 		if (!zone)
 			continue;
@@ -423,15 +428,9 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 			 */
 			continue;
 		}
-		if (!dev->bdev) {
-			/*
-			 * cannot read ahead on missing device, but for RAID5/6,
-			 * REQ_GET_READ_MIRRORS return 1. So don't skip missing
-			 * device for such case.
-			 */
-			if (nzones > 1)
-				continue;
-		}
+		if (!dev->bdev)
+			continue;
+
 		if (dev_replace_is_ongoing &&
 		    dev == fs_info->dev_replace.tgtdev) {
 			/*
-- 
1.8.5.1



