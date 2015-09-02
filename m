Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754062AbbIBMYP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 08:24:15 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t82CO0VF030322
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Sep 2015 20:24:00 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 2/4] btrfs-progs: Use long type to get thread's return value
Date: Wed, 2 Sep 2015 20:22:30 +0800
Message-ID: <150254cca3ab0c7a5e064ed5e90aa9416100c949.1441196519.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441196519.git.zhaolei@cn.fujitsu.com>
References: <cover.1441196519.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

pthread use void * to save return status, we can use this pointer to
save our return value, but we need keep the same length.

This patch move to use long type variable to save return value
of our thread, to avoid potentia invalid memory access.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 chunk-recover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 66a4ce6..3cb22ae 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -829,7 +829,7 @@ static int scan_devices(struct recover_control *rc)
 	struct btrfs_device *dev;
 	struct device_scan *dev_scans;
 	pthread_t *t_scans;
-	int *t_rets;
+	long *t_rets;
 	int devnr = 0;
 	int devidx = 0;
 	int cancel_from = 0;
@@ -845,7 +845,7 @@ static int scan_devices(struct recover_control *rc)
 	t_scans = (pthread_t *)malloc(sizeof(pthread_t) * devnr);
 	if (!t_scans)
 		return -ENOMEM;
-	t_rets = (int *)malloc(sizeof(int) * devnr);
+	t_rets = (long *)malloc(sizeof(long) * devnr);
 	if (!t_rets)
 		return -ENOMEM;
 
-- 
1.8.5.1

