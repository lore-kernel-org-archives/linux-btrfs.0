Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46356 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751096AbbLaPGB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 10:06:01 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 6D496409257A
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 23:05:26 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 03/10] btrfs: reada: add all reachable mirrors into reada device list
Date: Thu, 31 Dec 2015 23:03:37 +0800
Message-ID: <4043f5016f078642cfc28ff4353399467d1ae8dd.1451574005.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
References: <cover.1451574005.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If some device is not reachable, we should bypass and continus addingb
next, instead of break on bad device.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/reada.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index dcc5b69..7733a09 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -328,7 +328,6 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	u64 length;
 	int real_stripes;
 	int nzones = 0;
-	int i;
 	unsigned long index = logical >> PAGE_CACHE_SHIFT;
 	int dev_replace_is_ongoing;
 
@@ -380,9 +379,9 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		dev = bbio->stripes[nzones].dev;
 		zone = reada_find_zone(fs_info, dev, logical, bbio);
 		if (!zone)
-			break;
+			continue;
 
-		re->zones[nzones] = zone;
+		re->zones[re->nzones++] = zone;
 		spin_lock(&zone->lock);
 		if (!zone->elems)
 			kref_get(&zone->refcnt);
@@ -392,8 +391,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		kref_put(&zone->refcnt, reada_zone_release);
 		spin_unlock(&fs_info->reada_lock);
 	}
-	re->nzones = nzones;
-	if (nzones == 0) {
+	if (re->nzones == 0) {
 		/* not a single zone found, error and out */
 		goto error;
 	}
@@ -418,8 +416,9 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	prev_dev = NULL;
 	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(
 			&fs_info->dev_replace);
-	for (i = 0; i < nzones; ++i) {
-		dev = bbio->stripes[i].dev;
+	for (nzones = 0; nzones < re->nzones; ++nzones) {
+		dev = re->zones[nzones]->device;
+
 		if (dev == prev_dev) {
 			/*
 			 * in case of DUP, just add the first zone. As both
@@ -450,8 +449,8 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 		prev_dev = dev;
 		ret = radix_tree_insert(&dev->reada_extents, index, re);
 		if (ret) {
-			while (--i >= 0) {
-				dev = bbio->stripes[i].dev;
+			while (--nzones >= 0) {
+				dev = re->zones[nzones]->device;
 				BUG_ON(dev == NULL);
 				/* ignore whether the entry was inserted */
 				radix_tree_delete(&dev->reada_extents, index);
@@ -470,10 +469,9 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	return re;
 
 error:
-	while (nzones) {
+	for (nzones = 0; nzones < re->nzones; ++nzones) {
 		struct reada_zone *zone;
 
-		--nzones;
 		zone = re->zones[nzones];
 		kref_get(&zone->refcnt);
 		spin_lock(&zone->lock);
-- 
1.8.5.1



