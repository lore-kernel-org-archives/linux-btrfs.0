Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8912 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751760AbbLaPIF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 10:08:05 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 8979241887E9
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 23:05:30 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 10/10] btrfs: reada: Fix a debug code typo
Date: Thu, 31 Dec 2015 23:03:44 +0800
Message-ID: <eb2ab2b2bd917d28e0b3e1af4b0f89a48e9e91ac.1451574005.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
References: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove one copy of loop to fix the typo of iterate zones.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 902f899..53ee7b1 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -898,14 +898,9 @@ static void dump_devs(struct btrfs_fs_info *fs_info, int all)
 			printk(KERN_CONT " zone %llu-%llu devs",
 				re->zones[i]->start,
 				re->zones[i]->end);
-			for (i = 0; i < re->nzones; ++i) {
-				printk(KERN_CONT " zone %llu-%llu devs",
-					re->zones[i]->start,
-					re->zones[i]->end);
-				for (j = 0; j < re->zones[i]->ndevs; ++j) {
-					printk(KERN_CONT " %lld",
-						re->zones[i]->devs[j]->devid);
-				}
+			for (j = 0; j < re->zones[i]->ndevs; ++j) {
+				printk(KERN_CONT " %lld",
+				       re->zones[i]->devs[j]->devid);
 			}
 		}
 		printk(KERN_CONT "\n");
-- 
1.8.5.1



