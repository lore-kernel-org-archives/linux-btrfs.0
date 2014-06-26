Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6366 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753169AbaFZC6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 22:58:31 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5Q2wTJE027093
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Jun 2014 10:58:29 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/6] btrfs-progs: cleanup unnecessary free if malloc fails in btrfs-image
Date: Thu, 26 Jun 2014 10:53:03 +0800
Message-ID: <1403751186-31559-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1403751186-31559-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't bother free the buffer if the malloc failed.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfs-image.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index 7131001..2d482c3 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1631,7 +1631,7 @@ static void *restore_worker(void *data)
 		if (!mdres->error)
 			mdres->error = -ENOMEM;
 		pthread_mutex_unlock(&mdres->mutex);
-		goto out;
+		pthread_exit(NULL);
 	}
 
 	while (1) {
-- 
1.8.1.4

