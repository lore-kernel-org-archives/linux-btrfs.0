Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38373 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756971Ab3GVIhJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 04:37:09 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6M8a7jr026538
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 16:36:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs,raid56: fix memory leak when allocating pages for p/q stripes failed
Date: Mon, 22 Jul 2013 16:36:57 +0800
Message-Id: <1374482217-29494-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 0db856c..d0ecfbd 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1540,8 +1540,10 @@ static int full_stripe_write(struct btrfs_raid_bio *rbio)
 	int ret;
 
 	ret = alloc_rbio_parity_pages(rbio);
-	if (ret)
+	if (ret) {
+		__free_raid_bio(rbio);
 		return ret;
+	}
 
 	ret = lock_stripe_add(rbio);
 	if (ret == 0)
-- 
1.8.1.4

