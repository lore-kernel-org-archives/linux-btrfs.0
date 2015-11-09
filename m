Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34359 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752146AbbKIJIv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 04:08:51 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tA998AIg027735
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 17:08:10 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Check periodic.timer_fd's value before use
Date: Mon, 9 Nov 2015 17:06:53 +0800
Message-ID: <bbf60367447e680378412a801a881496aa25fe60.1447060006.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

periodic.timer_fd's value is 0 on inititlize-failed case,
if no value-checking before read(), the code will run as
read(STDIN).

This patch fixed above case.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 task-utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/task-utils.c b/task-utils.c
index a4017ff..12b0002 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -119,6 +119,9 @@ void task_period_wait(struct task_info *info)
 	if (!info)
 		return;
 
+	if (info->periodic.timer_fd == 0)
+		return;
+
 	ret = read(info->periodic.timer_fd, &missed, sizeof (missed));
 	if (ret == -1)
 		return;
-- 
1.8.5.1

