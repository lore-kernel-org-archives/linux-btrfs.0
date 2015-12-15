Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35966 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965019AbbLOLMb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 06:12:31 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 5FB16409255D
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 19:11:44 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs: Small cleanup for get index_srcdev loop
Date: Tue, 15 Dec 2015 19:09:51 +0800
Message-ID: <b5e99a0e984d0107c79a080d85bce79d31555048.1450177455.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
References: <cover.1450177455.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1: Adjust condition in loop to make less TAB
2: Move btrfs_put_bbio()'s line for combine, and makes logic clean.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4ee429b..367e8ec 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5368,35 +5368,33 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		 * target drive.
 		 */
 		for (i = 0; i < tmp_num_stripes; i++) {
-			if (tmp_bbio->stripes[i].dev->devid == srcdev_devid) {
-				/*
-				 * In case of DUP, in order to keep it
-				 * simple, only add the mirror with the
-				 * lowest physical address
-				 */
-				if (found &&
-				    physical_of_found <=
-				     tmp_bbio->stripes[i].physical)
-					continue;
-				index_srcdev = i;
-				found = 1;
-				physical_of_found =
-					tmp_bbio->stripes[i].physical;
-			}
+			if (tmp_bbio->stripes[i].dev->devid != srcdev_devid)
+				continue;
+
+			/*
+			 * In case of DUP, in order to keep it simple, only add
+			 * the mirror with the lowest physical address
+			 */
+			if (found &&
+			    physical_of_found <= tmp_bbio->stripes[i].physical)
+				continue;
+
+			index_srcdev = i;
+			found = 1;
+			physical_of_found = tmp_bbio->stripes[i].physical;
 		}
 
-		if (found) {
-			mirror_num = index_srcdev + 1;
-			patch_the_first_stripe_for_dev_replace = 1;
-			physical_to_patch_in_first_stripe = physical_of_found;
-		} else {
+		btrfs_put_bbio(tmp_bbio);
+
+		if (!found) {
 			WARN_ON(1);
 			ret = -EIO;
-			btrfs_put_bbio(tmp_bbio);
 			goto out;
 		}
 
-		btrfs_put_bbio(tmp_bbio);
+		mirror_num = index_srcdev + 1;
+		patch_the_first_stripe_for_dev_replace = 1;
+		physical_to_patch_in_first_stripe = physical_of_found;
 	} else if (mirror_num > map->num_stripes) {
 		mirror_num = 0;
 	}
-- 
1.8.5.1



