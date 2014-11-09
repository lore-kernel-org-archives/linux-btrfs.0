Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33977 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaKIWRJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Nov 2014 17:17:09 -0500
Received: by mail-wi0-f182.google.com with SMTP id d1so8772838wiv.9
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Nov 2014 14:17:07 -0800 (PST)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 1/2] btrfs-progs: add task-utils
Date: Sun,  9 Nov 2014 23:16:55 +0100
Message-Id: <ffe2360627753d1ed45a04e5099dff20741d4b4a.1415571118.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1415549388.git.silvio.fricke@gmail.com>
References: <cover.1415549388.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1415549388.git.silvio.fricke@gmail.com>
References: <cover.1415549388.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 task-util.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 task-util.h |  33 +++++++++++++++++
 2 files changed, 154 insertions(+)
 create mode 100644 task-util.c
 create mode 100644 task-util.h

diff --git a/task-util.c b/task-util.c
new file mode 100644
index 0000000..9268df7
--- /dev/null
+++ b/task-util.c
@@ -0,0 +1,121 @@
+
+#include <pthread.h>
+#include <sys/timerfd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include "task-util.h"
+
+struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
+			    void *thread_private)
+{
+	struct task_info *info = calloc(1, sizeof(struct task_info));
+
+	if (!info)
+		return NULL;
+
+	info->private_data = thread_private;
+	info->threadfn = threadfn;
+	info->postfn = postfn;
+
+	return info;
+}
+
+int task_start(struct task_info *info)
+{
+	int ret;
+
+	if (!info)
+		return -1;
+
+	if (!info->threadfn)
+		return -1;
+
+	ret = pthread_create(&info->id, NULL, info->threadfn,
+			     info->private_data);
+
+	if (ret == 0)
+		pthread_detach(info->id);
+	else
+		info->id = -1;
+
+	return ret;
+}
+
+void task_stop(struct task_info *info)
+{
+	if (!info)
+		return;
+
+	if (info->periodic.timer_fd)
+		close(info->periodic.timer_fd);
+
+	if (info->id > 0)
+		pthread_cancel(info->id);
+
+	if (info->postfn)
+		info->postfn(info->private_data);
+}
+
+void task_deinit(struct task_info *info)
+{
+	if (!info)
+		return;
+
+	free(info);
+}
+
+int task_period_start(struct task_info *info, unsigned int period_ms)
+{
+	unsigned int ns;
+	unsigned int sec;
+	struct itimerspec itval;
+
+	if (!info)
+		return -1;
+
+	info->periodic.timer_fd = timerfd_create(CLOCK_MONOTONIC, 0);
+	if (info->periodic.timer_fd == -1)
+		return info->periodic.timer_fd;
+
+	info->periodic.wakeups_missed = 0;
+
+	sec = period_ms/1000;
+	ns = (period_ms - (sec * 1000)) * 1000;
+	itval.it_interval.tv_sec = sec;
+	itval.it_interval.tv_nsec = ns;
+	itval.it_value.tv_sec = sec;
+	itval.it_value.tv_nsec = ns;
+
+	return timerfd_settime(info->periodic.timer_fd, 0, &itval, NULL);
+};
+
+void task_period_wait(struct task_info *info)
+{
+	unsigned long long missed;
+	int ret;
+
+	if (!info)
+		return;
+
+	ret = read(info->periodic.timer_fd, &missed, sizeof (missed));
+	if (ret == -1) {
+		perror ("read timer");
+		return;
+	}
+
+	if (missed > 0)
+		info->periodic.wakeups_missed += (missed - 1);
+}
+
+void task_period_stop(struct task_info *info)
+{
+	if (!info)
+		return;
+
+	if (info->periodic.timer_fd) {
+		timerfd_settime(info->periodic.timer_fd, 0, NULL, NULL);
+		close(info->periodic.timer_fd);
+	}
+}
diff --git a/task-util.h b/task-util.h
new file mode 100644
index 0000000..95f7b5b
--- /dev/null
+++ b/task-util.h
@@ -0,0 +1,33 @@
+
+#ifndef __PROGRESS_
+#define __PROGRESS_
+
+#include <pthread.h>
+
+struct periodic_info {
+	int timer_fd;
+	unsigned long long wakeups_missed;
+};
+
+struct task_info {
+	struct periodic_info periodic;
+	pthread_t id;
+	void *private_data;
+	void *(*threadfn)(void *);
+	int (*postfn)(void *);
+};
+
+/* task life cycle */
+struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
+			    void *thread_private);
+int task_start(struct task_info *info);
+void task_stop(struct task_info *info);
+void task_deinit(struct task_info *info);
+
+/* periodic life cycle */
+int task_period_start(struct task_info *info, unsigned int period_ms);
+void task_period_wait(struct task_info *info);
+void task_period_stop(struct task_info *info);
+
+#endif /* __PROGRESS_ */
+
-- 
2.1.2

