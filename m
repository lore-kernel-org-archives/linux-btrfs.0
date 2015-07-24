Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19547 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753133AbbGXNSK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 09:18:10 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6ODGHdp028003
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 21:16:17 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/5] btrfs-progs: Move close timer handle code to line after sub process exit
Date: Fri, 24 Jul 2015 21:16:26 +0800
Message-ID: <04b5e2ecb060dd8295f11277f255639d0c1dba34.1437743469.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
References: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

The timer handle have possibility in using by sub thread,
better to close it after sub process exit.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 task-utils.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/task-utils.c b/task-utils.c
index 0390a69..17fd573 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -61,14 +61,14 @@ void task_stop(struct task_info *info)
 	if (!info)
 		return;
 
-	if (info->periodic.timer_fd)
-		close(info->periodic.timer_fd);
-
 	if (info->id > 0) {
 		pthread_cancel(info->id);
 		pthread_join(info->id, NULL);
 	}
 
+	if (info->periodic.timer_fd)
+		close(info->periodic.timer_fd);
+
 	if (info->postfn)
 		info->postfn(info->private_data);
 }
-- 
1.8.5.1

