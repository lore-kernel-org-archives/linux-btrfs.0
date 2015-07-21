Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54124 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbbGUEYL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 00:24:11 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6L4MKWj021615
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 12:22:20 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs: Free checksum list on scrub_extent() fail
Date: Tue, 21 Jul 2015 12:22:30 +0800
Message-ID: <30779428ff0fb63a4eb5b25905eb9b06e52266d6.1437452532.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <67a4b66d550b9e39940fbf242bbe901fc3f7671f.1437452532.git.zhaolei@cn.fujitsu.com>
References: <67a4b66d550b9e39940fbf242bbe901fc3f7671f.1437452532.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

When scrub_extent() failed, we need to free previois created
checksum list.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f8551b9..24720f6 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2923,10 +2923,12 @@ again:
 						      extent_dev, flags,
 						      generation,
 						      extent_mirror_num);
+
+			scrub_free_csums(sctx);
+
 			if (ret)
 				goto out;
 
-			scrub_free_csums(sctx);
 			if (extent_logical + extent_len <
 			    key.objectid + bytes) {
 				logic_start += map->stripe_len;
@@ -3259,10 +3261,12 @@ again:
 					   extent_physical, extent_dev, flags,
 					   generation, extent_mirror_num,
 					   extent_logical - logical + physical);
+
+			scrub_free_csums(sctx);
+
 			if (ret)
 				goto out;
 
-			scrub_free_csums(sctx);
 			if (extent_logical + extent_len <
 			    key.objectid + bytes) {
 				if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK) {
-- 
1.8.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
