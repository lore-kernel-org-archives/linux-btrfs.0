Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.data-modul.de ([212.184.205.171]:2603 "EHLO
	mail2.data-modul.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753206AbbIXGSS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 02:18:18 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 1/2] btrfs-progs: tasks info->id is a pthread_t and should not set to -1
Date: Thu, 24 Sep 2015 08:13:04 +0200
Message-Id: <7773bc3eb2de3b4a5be3ac1ae255331b93fe410f.1443074502.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443074502.git.silvio.fricke@gmail.com>
References: <cover.1443074502.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443074502.git.silvio.fricke@gmail.com>
References: <cover.1443012156.git.silvio.fricke@gmail.com> <cover.1443074502.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 task-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/task-utils.c b/task-utils.c
index 58f5195..a4017ff 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -51,7 +51,7 @@ int task_start(struct task_info *info)
 			     info->private_data);
 
 	if (ret)
-		info->id = -1;
+		info->id = 0;
 
 	return ret;
 }
@@ -64,7 +64,7 @@ void task_stop(struct task_info *info)
 	if (info->id > 0) {
 		pthread_cancel(info->id);
 		pthread_join(info->id, NULL);
-		info->id = -1;
+		info->id = 0;
 	}
 
 	if (info->periodic.timer_fd) {
-- 
2.5.3

