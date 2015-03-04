Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45876 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932543AbbCDSmY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 13:42:24 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t24IfSvJ016408
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Mar 2015 02:41:28 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/6] btrfs: Fix calculation of rbio->dbitmap's size calculation
Date: Thu, 5 Mar 2015 02:41:07 +0800
Message-ID: <86557aad51883ada25ace853f10d1474e8db048e.1425494151.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Current code is trying to calculate rbio->dbitmap's size to make it
align to sizeof(long), but implement haven't achived this object,
it is align to sizeof(char) instead.
This patch fixed above calculation, and use sizeof(long) instead of
fixed "8" to increate compatibility.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 4 ++--
 fs/btrfs/scrub.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5264858..0cfbfcf 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -963,8 +963,8 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 	void *p;
 
 	rbio = kzalloc(sizeof(*rbio) + num_pages * sizeof(struct page *) * 2 +
-		       DIV_ROUND_UP(stripe_npages, BITS_PER_LONG / 8),
-			GFP_NOFS);
+		       DIV_ROUND_UP(stripe_npages, BITS_PER_LONG) *
+		       sizeof(long), GFP_NOFS);
 	if (!rbio)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ec57687..1221a56 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2737,7 +2737,7 @@ out:
 
 static inline int scrub_calc_parity_bitmap_len(int nsectors)
 {
-	return DIV_ROUND_UP(nsectors, BITS_PER_LONG) * (BITS_PER_LONG / 8);
+	return DIV_ROUND_UP(nsectors, BITS_PER_LONG) * sizeof(long);
 }
 
 static void scrub_parity_get(struct scrub_parity *sparity)
-- 
1.8.5.1

