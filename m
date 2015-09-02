Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32895 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752689AbbIBJxE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 05:53:04 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t829qqbZ024400
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Sep 2015 17:52:52 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/3] btrfs-progs: use for loop for scan_devices
Date: Wed, 2 Sep 2015 17:51:23 +0800
Message-ID: <62275c5073d7bb4bb2df00b9805ceeb3ef46a422.1441187401.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441187401.git.zhaolei@cn.fujitsu.com>
References: <cover.1441187401.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

for() is more suitable than while() in this code block.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 chunk-recover.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 832b3b1..66a4ce6 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -871,8 +871,7 @@ static int scan_devices(struct recover_control *rc)
 		devidx++;
 	}
 
-	i = 0;
-	while (i < devidx) {
+	for (i = 0; i < devidx; i++) {
 		ret = pthread_join(t_scans[i], (void **)&t_rets[i]);
 		if (ret || t_rets[i]) {
 			ret = 1;
@@ -880,7 +879,6 @@ static int scan_devices(struct recover_control *rc)
 			cancel_to = devnr - 1;
 			goto out1;
 		}
-		i++;
 	}
 out1:
 	while (ret && (cancel_from <= cancel_to)) {
-- 
1.8.5.1

