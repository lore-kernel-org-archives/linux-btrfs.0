Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31708 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753524AbbLaPHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 10:07:41 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 119AD409257F
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 23:05:27 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 04/10] btrfs: reada: bypass adding extent when all zone failed
Date: Thu, 31 Dec 2015 23:03:38 +0800
Message-ID: <ddecc87e86e0e56af34600b65cbcdddd8cd0f873.1451574005.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
References: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When failed adding all dev_zones for a reada_extent, the extent
will have no chance to be selected to run, and keep in memory
for ever.

We should bypass this extent to avoid above case.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 7733a09..ef9457e 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -330,6 +330,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	int nzones = 0;
 	unsigned long index = logical >> PAGE_CACHE_SHIFT;
 	int dev_replace_is_ongoing;
+	int have_zone = 0;
 
 	spin_lock(&fs_info->reada_lock);
 	re = radix_tree_lookup(&fs_info->reada_tree, index);
@@ -461,10 +462,14 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 			btrfs_dev_replace_unlock(&fs_info->dev_replace);
 			goto error;
 		}
+		have_zone = 1;
 	}
 	spin_unlock(&fs_info->reada_lock);
 	btrfs_dev_replace_unlock(&fs_info->dev_replace);
 
+	if (!have_zone)
+		goto error;
+
 	btrfs_put_bbio(bbio);
 	return re;
 
-- 
1.8.5.1



