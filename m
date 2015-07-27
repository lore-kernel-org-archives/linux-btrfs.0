Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20601 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628AbbG0M0N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 08:26:13 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6RCOJ8k023260
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 20:24:19 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 2/7] btrfs-progs: Move close timer handle code to line after sub process exit
Date: Mon, 27 Jul 2015 20:24:27 +0800
Message-ID: <11cd6dd1c443035bd449a2a721f96f2d5f2dff93.1437999624.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1437999624.git.zhaolei@cn.fujitsu.com>
References: <cover.1437999624.git.zhaolei@cn.fujitsu.com>
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

