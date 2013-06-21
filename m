Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:51276 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423128Ab3FUOwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 10:52:47 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Fri, 21 Jun 2013 06:22:11 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 1E5463E4004E
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 06:21:49 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r5LCM7DY348038
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 06:22:07 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r5LCM6WE007243
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 06:22:07 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, chris.mason@fusionio.com, jbacik@fusionio.com,
        idryomov@gmail.com, Martin@lichtvoll.de,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 4/5] BTRFS hot reloc, procfs: add three proc interfaces
Date: Fri, 21 Jun 2013 20:20:59 +0800
Message-Id: <1371817260-8615-5-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1371817260-8615-1-git-send-email-zwu.kernel@gmail.com>
References: <1371817260-8615-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add three proc interfaces hot-reloc-interval, hot-reloc-threshold,
and hot-reloc-max-items under the dir /proc/sys/fs/ in order to
turn HOT_RELOC_INTERVAL, HOT_RELOC_THRESHOLD, and HOT_RELOC_MAX_ITEMS
into be tunable.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/hot_relocate.c | 26 +++++++++++++++++---------
 fs/btrfs/hot_relocate.h |  5 -----
 include/linux/btrfs.h   |  4 ++++
 kernel/sysctl.c         | 22 ++++++++++++++++++++++
 4 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/hot_relocate.c b/fs/btrfs/hot_relocate.c
index ae28b86..debf580 100644
--- a/fs/btrfs/hot_relocate.c
+++ b/fs/btrfs/hot_relocate.c
@@ -25,7 +25,7 @@
  * The relocation code below operates on the heat map lists to identify
  * hot or cold data logical file ranges that are candidates for relocation.
  * The triggering mechanism for relocation is controlled by a global heat
- * threshold integer value (HOT_RELOC_THRESHOLD). Ranges are
+ * threshold integer value (sysctl_hot_reloc_thresh). Ranges are
  * queued for relocation by the periodically executing relocate kthread,
  * which updates the global heat threshold and responds to space pressure
  * on the nonrotating disks.
@@ -53,6 +53,15 @@
  * (assuming, critically, the HOT_MOVE option is set at mount time).
  */
 
+int sysctl_hot_reloc_thresh = 150;
+EXPORT_SYMBOL_GPL(sysctl_hot_reloc_thresh);
+
+int sysctl_hot_reloc_interval __read_mostly = 120;
+EXPORT_SYMBOL_GPL(sysctl_hot_reloc_interval);
+
+int sysctl_hot_reloc_max_items __read_mostly = 250;
+EXPORT_SYMBOL_GPL(sysctl_hot_reloc_max_items);
+
 /*
  * Returns the ratio of nonrotating disks that are full.
  * If no nonrotating disk is found, returns THRESH_MAX_VALUE + 1.
@@ -103,7 +112,7 @@ static int hot_calc_nonrot_ratio(struct hot_reloc *hot_reloc)
 static int hot_update_threshold(struct hot_reloc *hot_reloc,
 				int update)
 {
-	int thresh = hot_reloc->thresh;
+	int thresh = sysctl_hot_reloc_thresh;
 	int ratio = hot_calc_nonrot_ratio(hot_reloc);
 
 	/* Sometimes update global threshold, others not */
@@ -127,7 +136,7 @@ static int hot_update_threshold(struct hot_reloc *hot_reloc,
 			thresh = 0;
 	}
 
-	hot_reloc->thresh = thresh;
+	sysctl_hot_reloc_thresh = thresh;
 	return ratio;
 }
 
@@ -215,7 +224,7 @@ static int hot_queue_extent(struct hot_reloc *hot_reloc,
 			*counter = *counter + 1;
 		}
 
-		if (*counter >= HOT_RELOC_MAX_ITEMS)
+		if (*counter >= sysctl_hot_reloc_max_items)
 			break;
 
 		if (kthread_should_stop()) {
@@ -293,7 +302,7 @@ again:
 		while (1) {
 			lock_extent(tree, page_start, page_end);
 			ordered = btrfs_lookup_ordered_extent(inode,
-							page_start);
+							      page_start);
 			unlock_extent(tree, page_start, page_end);
 			if (!ordered)
 				break;
@@ -559,7 +568,7 @@ void hot_do_relocate(struct hot_reloc *hot_reloc)
 
 	run++;
 	ratio = hot_update_threshold(hot_reloc, !(run % 15));
-	thresh = hot_reloc->thresh;
+	thresh = sysctl_hot_reloc_thresh;
 
 	INIT_LIST_HEAD(&hot_reloc->hot_relocq[TYPE_NONROT]);
 
@@ -569,7 +578,7 @@ void hot_do_relocate(struct hot_reloc *hot_reloc)
 	if (count_to_hot == 0)
 		return;
 
-	count_to_cold = HOT_RELOC_MAX_ITEMS;
+	count_to_cold = sysctl_hot_reloc_max_items;
 
 	/* Don't move cold data to HDD unless there's space pressure */
 	if (ratio < HIGH_WATER_LEVEL)
@@ -653,7 +662,7 @@ static int hot_relocate_kthread(void *arg)
 	unsigned long delay;
 
 	do {
-		delay = HZ * HOT_RELOC_INTERVAL;
+		delay = HZ * sysctl_hot_reloc_interval;
 		if (mutex_trylock(&hot_reloc->hot_reloc_mutex)) {
 			hot_do_relocate(hot_reloc);
 			mutex_unlock(&hot_reloc->hot_reloc_mutex);
@@ -685,7 +694,6 @@ int hot_relocate_init(struct btrfs_fs_info *fs_info)
 
 	fs_info->hot_reloc = hot_reloc;
 	hot_reloc->fs_info = fs_info;
-	hot_reloc->thresh = HOT_RELOC_THRESHOLD;
 	for (i = 0; i < MAX_RELOC_TYPES; i++)
 		INIT_LIST_HEAD(&hot_reloc->hot_relocq[i]);
 	mutex_init(&hot_reloc->hot_reloc_mutex);
diff --git a/fs/btrfs/hot_relocate.h b/fs/btrfs/hot_relocate.h
index 1b1cfb5..94defe6 100644
--- a/fs/btrfs/hot_relocate.h
+++ b/fs/btrfs/hot_relocate.h
@@ -18,10 +18,6 @@
 #include "btrfs_inode.h"
 #include "volumes.h"
 
-#define HOT_RELOC_INTERVAL  120
-#define HOT_RELOC_THRESHOLD 150
-#define HOT_RELOC_MAX_ITEMS 250
-
 #define HEAT_MAX_VALUE    (MAP_SIZE - 1)
 #define HIGH_WATER_LEVEL  75 /* when to raise the threshold */
 #define LOW_WATER_LEVEL   50 /* when to lower the threshold */
@@ -32,7 +28,6 @@
 struct hot_reloc {
 	struct btrfs_fs_info *fs_info;
 	struct list_head hot_relocq[MAX_RELOC_TYPES];
-	int thresh;
 	struct task_struct *hot_reloc_kthread;
 	struct mutex hot_reloc_mutex;
 };
diff --git a/include/linux/btrfs.h b/include/linux/btrfs.h
index 22d7991..a713514 100644
--- a/include/linux/btrfs.h
+++ b/include/linux/btrfs.h
@@ -3,4 +3,8 @@
 
 #include <uapi/linux/btrfs.h>
 
+extern int sysctl_hot_reloc_thresh;
+extern int sysctl_hot_reloc_interval;
+extern int sysctl_hot_reloc_max_items;
+
 #endif /* _LINUX_BTRFS_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 753585d..7050086 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -62,6 +62,7 @@
 #include <linux/capability.h>
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
+#include <linux/btrfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -1637,6 +1638,27 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "hot-reloc-thresh",
+		.data		= &sysctl_hot_reloc_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "hot-reloc-interval",
+		.data		= &sysctl_hot_reloc_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "hot-reloc-max-items",
+		.data		= &sysctl_hot_reloc_max_items,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.7.11.7

