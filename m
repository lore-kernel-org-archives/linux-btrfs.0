Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24133 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbbG0G3h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 02:29:37 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6R6Rhsu003807
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 14:27:43 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 3/7] btrfs-progs: Remove cleanup-timer code for btrfs-convert
Date: Mon, 27 Jul 2015 14:27:50 +0800
Message-ID: <321b85ad3c9aaeebf92ec41205aa7edcfd9194a3.1437977968.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
References: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

No need to close timer handle afain in subthread-close-callback,
it is closed by task_stop() automatically.

This patch also add a fflush() to make log output on time.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-convert.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index b89c685..7dfab7d 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -71,10 +71,8 @@ static void *print_copied_inodes(void *p)
 
 static int after_copied_inodes(void *p)
 {
-	struct task_ctx *priv = p;
-
 	printf("\n");
-	task_period_stop(priv->info);
+	fflush(stdout);
 
 	return 0;
 }
-- 
1.8.5.1

