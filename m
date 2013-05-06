Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:42311 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab3EFIxS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 04:53:18 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 6 May 2013 02:53:18 -0600
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 344FEC9001D
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 04:53:16 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r468rG9138797542
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 04:53:16 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r468rFCc004933
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 05:53:16 -0300
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com, chris.mason@fusionio.com, idryomov@gmail.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 4/5] procfs: add three proc interfaces
Date: Mon,  6 May 2013 16:53:37 +0800
Message-Id: <1367830418-26865-5-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
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
 fs/btrfs/hot_relocate.h |  4 ----
 include/linux/btrfs.h   |  4 ++++
 kernel/sysctl.c         | 22 ++++++++++++++++++++++
 4 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/hot_relocate.c b/fs/btrfs/hot_relocate.c
index 683e154..aa8c9f0 100644
--- a/fs/btrfs/hot_relocate.c
+++ b/fs/btrfs/hot_relocate.c
@@ -25,7 +25,7 @@
  * The relocation code below operates on the heat map lists to identify
  * hot or cold data logical file ranges that are candidates for relocation.
  * The triggering mechanism for relocation is controlled by a global heat
- * threshold integer value (HOT_RELOC_THRESHOLD). Ranges are
+ * threshold integer value (sysctl_hot_reloc_threshold). Ranges are
  * queued for relocation by the periodically executing relocate kthread,
  * which updates the global heat threshold and responds to space pressure
  * on the SSDs.
@@ -52,6 +52,15 @@
  * (assuming, critically, the HOT_MOVE option is set at mount time).
  */
 
+int sysctl_hot_reloc_threshold = 150;
+EXPORT_SYMBOL_GPL(sysctl_hot_reloc_threshold);
+
+int sysctl_hot_reloc_interval __read_mostly = 120;
+EXPORT_SYMBOL_GPL(sysctl_hot_reloc_interval);
+
+int sysctl_hot_reloc_max_items __read_mostly = 250;
+EXPORT_SYMBOL_GPL(sysctl_hot_reloc_max_items);
+
 static void hot_set_extent_bits(struct extent_io_tree *tree, u64 start,
 		u64 end, struct extent_state **cached_state,
 		gfp_t mask, int storage_type, int flag)
@@ -165,7 +174,7 @@ static int hot_calc_ssd_ratio(struct hot_reloc *hot_reloc)
 static int hot_update_threshold(struct hot_reloc *hot_reloc,
 				int update)
 {
-	int thresh = hot_reloc->thresh;
+	int thresh = sysctl_hot_reloc_threshold;
 	int ratio = hot_calc_ssd_ratio(hot_reloc);
 
 	/* Sometimes update global threshold, others not */
@@ -189,7 +198,7 @@ static int hot_update_threshold(struct hot_reloc *hot_reloc,
 			thresh = 0;
 	}
 
-	hot_reloc->thresh = thresh;
+	sysctl_hot_reloc_threshold = thresh;
 	return ratio;
 }
 
@@ -280,7 +289,7 @@ static int hot_queue_extent(struct hot_reloc *hot_reloc,
 		hot_comm_item_put(ci);
 		spin_unlock(&he->i_lock);
 
-		if (*counter >= HOT_RELOC_MAX_ITEMS)
+		if (*counter >= sysctl_hot_reloc_max_items)
 			break;
 
 		if (kthread_should_stop()) {
@@ -361,7 +370,7 @@ again:
 		while (1) {
 			lock_extent(tree, page_start, page_end);
 			ordered = btrfs_lookup_ordered_extent(inode,
-							page_start);
+							      page_start);
 			unlock_extent(tree, page_start, page_end);
 			if (!ordered)
 				break;
@@ -642,7 +651,7 @@ void hot_do_relocate(struct hot_reloc *hot_reloc)
 
 	run++;
 	ratio = hot_update_threshold(hot_reloc, !(run % 15));
-	thresh = hot_reloc->thresh;
+	thresh = sysctl_hot_reloc_threshold;
 
 	INIT_LIST_HEAD(&hot_reloc->hot_relocq[TYPE_NONROT]);
 
@@ -652,7 +661,7 @@ void hot_do_relocate(struct hot_reloc *hot_reloc)
 	if (count_to_hot == 0)
 		return;
 
-	count_to_cold = HOT_RELOC_MAX_ITEMS;
+	count_to_cold = sysctl_hot_reloc_max_items;
 
 	/* Don't move cold data to HDD unless there's space pressure */
 	if (ratio < HIGH_WATER_LEVEL)
@@ -734,7 +743,7 @@ static int hot_relocate_kthread(void *arg)
 	unsigned long delay;
 
 	do {
-		delay = HZ * HOT_RELOC_INTERVAL;
+		delay = HZ * sysctl_hot_reloc_interval;
 		if (mutex_trylock(&hot_reloc->hot_reloc_mutex)) {
 			hot_do_relocate(hot_reloc);
 			mutex_unlock(&hot_reloc->hot_reloc_mutex);
@@ -766,7 +775,6 @@ int hot_relocate_init(struct btrfs_fs_info *fs_info)
 
 	fs_info->hot_reloc = hot_reloc;
 	hot_reloc->fs_info = fs_info;
-	hot_reloc->thresh = HOT_RELOC_THRESHOLD;
 	for (i = 0; i < MAX_RELOC_TYPES; i++)
 		INIT_LIST_HEAD(&hot_reloc->hot_relocq[i]);
 	mutex_init(&hot_reloc->hot_reloc_mutex);
diff --git a/fs/btrfs/hot_relocate.h b/fs/btrfs/hot_relocate.h
index 077d9b3..ca30944 100644
--- a/fs/btrfs/hot_relocate.h
+++ b/fs/btrfs/hot_relocate.h
@@ -24,9 +24,6 @@ enum {
 	MAX_RELOC_TYPES
 };
 
-#define HOT_RELOC_INTERVAL  120
-#define HOT_RELOC_THRESHOLD 150
-#define HOT_RELOC_MAX_ITEMS 250
 
 #define HEAT_MAX_VALUE    (MAP_SIZE - 1)
 #define HIGH_WATER_LEVEL  75 /* when to raise the threshold */
@@ -38,7 +35,6 @@ enum {
 struct hot_reloc {
 	struct btrfs_fs_info *fs_info;
 	struct list_head hot_relocq[MAX_RELOC_TYPES];
-	int thresh;
 	struct task_struct *hot_reloc_kthread;
 	struct mutex hot_reloc_mutex;
 };
diff --git a/include/linux/btrfs.h b/include/linux/btrfs.h
index 22d7991..7179819 100644
--- a/include/linux/btrfs.h
+++ b/include/linux/btrfs.h
@@ -3,4 +3,8 @@
 
 #include <uapi/linux/btrfs.h>
 
+extern int sysctl_hot_reloc_threshold;
+extern int sysctl_hot_reloc_interval;
+extern int sysctl_hot_reloc_max_items;
+
 #endif /* _LINUX_BTRFS_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11e4a3d..c1db57e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -62,6 +62,7 @@
 #include <linux/capability.h>
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
+#include <linux/btrfs.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -1617,6 +1618,27 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "hot-reloc-threshold",
+		.data		= &sysctl_hot_reloc_threshold,
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

