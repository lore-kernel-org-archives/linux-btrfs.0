Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17798 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752013AbaLSGPS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 01:15:18 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBJ6EpEx027650
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 14:14:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs-progs: Remove a unused function offset_to_bitmap()
Date: Fri, 19 Dec 2014 14:13:11 +0800
Message-ID: <1418969592-21278-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix the following clang warning:

free-space-cache.c:464:19: warning: unused function 'offset_to_bitmap'
[-Wunused-function]
static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
                  ^
1 warning generated.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 free-space-cache.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/free-space-cache.c b/free-space-cache.c
index 220449e..99ad420 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -461,22 +461,6 @@ static inline unsigned long bytes_to_bits(u64 bytes, u32 unit)
 	return (unsigned long)(bytes / unit);
 }
 
-static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
-				   u64 offset)
-{
-	u64 bitmap_start;
-	u64 bytes_per_bitmap;
-	u32 sectorsize = ctl->sectorsize;
-
-	bytes_per_bitmap = BITS_PER_BITMAP(sectorsize) * ctl->unit;
-	bitmap_start = offset - ctl->start;
-	bitmap_start = bitmap_start / bytes_per_bitmap;
-	bitmap_start *= bytes_per_bitmap;
-	bitmap_start += ctl->start;
-
-	return bitmap_start;
-}
-
 static int tree_insert_offset(struct rb_root *root, u64 offset,
 			      struct rb_node *node, int bitmap)
 {
-- 
2.1.3

