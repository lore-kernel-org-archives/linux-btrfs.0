Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43883 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754554AbbGXNSM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 09:18:12 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6ODGJBg028015
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jul 2015 21:16:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 5/5] btrfs-progs: Set info->periodic.timer_fd to 0 in init-fail
Date: Fri, 24 Jul 2015 21:16:29 +0800
Message-ID: <89a3a87651d15c1ff317aaa8d629a208512a6165.1437743469.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
References: <f664529a996a01479aa3ed14d33a1cf8d92afa8e.1437743468.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

In current code, (info->periodic.timer_fd == 0) means it is not
valid, as:
  if (info->periodic.timer_fd) {
      close(info->periodic.timer_fd);
      ...

We need set its value from -1 to 0 in create-fail case, to make
code like above works.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 task-utils.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/task-utils.c b/task-utils.c
index 768be94..58f5195 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -94,8 +94,10 @@ int task_period_start(struct task_info *info, unsigned int period_ms)
 		return -1;
 
 	info->periodic.timer_fd = timerfd_create(CLOCK_MONOTONIC, 0);
-	if (info->periodic.timer_fd == -1)
+	if (info->periodic.timer_fd == -1) {
+		info->periodic.timer_fd = 0;
 		return info->periodic.timer_fd;
+	}
 
 	info->periodic.wakeups_missed = 0;
 
-- 
1.8.5.1

