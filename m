Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51945 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753663AbbLROMi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 09:12:38 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 252AF4092558
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Dec 2015 22:12:12 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs: Fix in-segment calculation for reada
Date: Fri, 18 Dec 2015 22:10:19 +0800
Message-ID: <d91c92e58567119e5e94cac3c7c81d90881d3f1b.1450447809.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reada_zone->end is end pos of segment:
 end = start + cache->key.offset - 1;

So we need to use "<=" in condition to judge is a pos in the
segment.

The problem happened rearly, because logical pos rarely pointed
to last 4k of a blockgroup, but we need to fix it to make code
right in logic.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 7bbd656..6fb9c37 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -265,7 +265,7 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
 	spin_unlock(&fs_info->reada_lock);
 
 	if (ret == 1) {
-		if (logical >= zone->start && logical < zone->end)
+		if (logical >= zone->start && logical <= zone->end)
 			return zone;
 		spin_lock(&fs_info->reada_lock);
 		kref_put(&zone->refcnt, reada_zone_release);
@@ -684,7 +684,7 @@ static int reada_start_machine_dev(struct btrfs_fs_info *fs_info,
 	 */
 	ret = radix_tree_gang_lookup(&dev->reada_extents, (void **)&re,
 				     dev->reada_next >> PAGE_CACHE_SHIFT, 1);
-	if (ret == 0 || re->logical >= dev->reada_curr_zone->end) {
+	if (ret == 0 || re->logical > dev->reada_curr_zone->end) {
 		ret = reada_pick_zone(dev);
 		if (!ret) {
 			spin_unlock(&fs_info->reada_lock);
-- 
1.8.5.1



