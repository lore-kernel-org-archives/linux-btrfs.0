Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58689 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111AbbGXNSL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 09:18:11 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6ODGJhd028012
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 21:16:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 4/5] btrfs-progs: resst info->periodic.timer_fd's value after free
Date: Fri, 24 Jul 2015 21:16:28 +0800
Message-ID: <cd3c25b55f2688b0215a413cffecd162aea555f6.1437743469.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
References: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

task_period_stop() is used to close a timer explicitly, to avoid
the timer handle closed again by task_stop(), we should reset its
value after close.

Also add value-reset for info->id for safe.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 task-utils.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/task-utils.c b/task-utils.c
index 17fd573..768be94 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -64,10 +64,13 @@ void task_stop(struct task_info *info)
 	if (info->id > 0) {
 		pthread_cancel(info->id);
 		pthread_join(info->id, NULL);
+		info->id = -1;
 	}
 
-	if (info->periodic.timer_fd)
+	if (info->periodic.timer_fd) {
 		close(info->periodic.timer_fd);
+		info->periodic.timer_fd = 0;
+	}
 
 	if (info->postfn)
 		info->postfn(info->private_data);
@@ -130,5 +133,6 @@ void task_period_stop(struct task_info *info)
 	if (info->periodic.timer_fd) {
 		timerfd_settime(info->periodic.timer_fd, 0, NULL, NULL);
 		close(info->periodic.timer_fd);
+		info->periodic.timer_fd = -1;
 	}
 }
-- 
1.8.5.1

