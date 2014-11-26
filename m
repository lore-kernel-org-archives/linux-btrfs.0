Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51513 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751142AbaKZCpZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 21:45:25 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQ2j63D012893
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 10:45:06 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: remove dead condition for btrfs_map_block
Date: Wed, 26 Nov 2014 10:43:40 +0800
Message-ID: <1416969821-2729-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The @search_cache_extent() only returns the next cache_extent or NULL,
it will never return the previous cache_extent.
So just remove the dead condition for previous cache_extent handle.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/volumes.c b/volumes.c
index 5b007fc..a1fd162 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1320,7 +1320,7 @@ again:
 		kfree(multi);
 		return -ENOENT;
 	}
-	if (ce->start > logical || ce->start + ce->size < logical) {
+	if (ce->start > logical) {
 		kfree(multi);
 		return -ENOENT;
 	}
-- 
1.8.1.4

