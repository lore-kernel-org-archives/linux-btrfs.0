Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaCRMFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 08:05:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2IC4uW8001921
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 20:04:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] Btrfs-progs: fsck: fix wrong index in pick_next_pending()
Date: Tue, 18 Mar 2014 20:02:47 +0800
Message-Id: <1395144167-775-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Though all tree blocks have same size, we'd better use right
index here.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 34f8fa6..ebdb643 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2928,7 +2928,7 @@ static int pick_next_pending(struct cache_tree *pending,
 	cache = search_cache_extent(reada, 0);
 	if (cache) {
 		bits[0].start = cache->start;
-		bits[1].size = cache->size;
+		bits[0].size = cache->size;
 		*reada_bits = 1;
 		return 1;
 	}
-- 
1.9.0

