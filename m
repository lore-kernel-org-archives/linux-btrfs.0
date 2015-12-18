Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51945 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbbLROMl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 09:12:41 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 1F9B34092563
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Dec 2015 22:12:13 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: Add missed segment checking in reada_find_zone
Date: Fri, 18 Dec 2015 22:10:21 +0800
Message-ID: <9df6577e7e2660fc61483b9fdf96aa51f81e8a10.1450447809.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <d91c92e58567119e5e94cac3c7c81d90881d3f1b.1450447809.git.zhaolei@cn.fujitsu.com>
References: <d91c92e58567119e5e94cac3c7c81d90881d3f1b.1450447809.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In rechecking zone-in-tree, we still need to check zone include
our logical address.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index d8116fe..c65b42f 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -303,8 +303,10 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
 		kfree(zone);
 		ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
 					     logical >> PAGE_CACHE_SHIFT, 1);
-		if (ret == 1)
+		if (ret == 1 && logical >= zone->start && logical <= zone->end)
 			kref_get(&zone->refcnt);
+		else
+			zone = NULL;
 	}
 	spin_unlock(&fs_info->reada_lock);
 
-- 
1.8.5.1



