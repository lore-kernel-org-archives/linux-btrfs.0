Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19547 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754551AbbGXNSL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 09:18:11 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6ODGI9I028009
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 21:16:18 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/5] btrfs-progs: Remove cleanup-timer code for btrfs-convert
Date: Fri, 24 Jul 2015 21:16:27 +0800
Message-ID: <e176fc7bbb88342793f2c856508fb3e444fee54e.1437743469.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
References: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
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

