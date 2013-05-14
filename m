Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:40710 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab3ENA7r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:47 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 18:59:47 -0600
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 09/12] VFS hot tracking, procfs: add two proc interfaces
Date: Tue, 14 May 2013 08:59:41 +0800
Message-Id: <1368493184-5939-10-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add two proc interfaces hot-age-interval and hot-update-interval
under the dir /proc/sys/fs/ in order to turn HOT_AGE_INTERVAL and
HOT_UPDATE_INTERVAL into be tunable.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 12 +++++++++---
 fs/hot_tracking.h            |  3 ---
 include/linux/hot_tracking.h |  7 +++++++
 kernel/sysctl.c              | 14 ++++++++++++++
 4 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 1618f21..088e9aa 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -23,6 +23,12 @@
 
 static struct dentry *hot_debugfs_root;
 
+int sysctl_hot_age_interval __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_age_interval);
+
+int sysctl_hot_update_interval __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_update_interval);
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
@@ -446,7 +452,7 @@ static bool hot_is_obsolete(struct hot_comm_item *ci)
 	struct hot_freq_data *freq_data = &ci->hot_freq_data;
 	u64 last_read_ns, last_write_ns;
 	u64 cur_time = timespec_to_ns(&ckt);
-	u64 kick_ns =  HOT_AGE_INTERVAL * NSEC_PER_SEC;
+	u64 kick_ns =  sysctl_hot_age_interval * NSEC_PER_SEC;
 
 	last_read_ns =
 		(cur_time - timespec_to_ns(&freq_data->last_read_time));
@@ -623,7 +629,7 @@ static void hot_update_worker(struct work_struct *work)
 
 	/* Instert next delayed work */
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_interval * MSEC_PER_SEC));
 }
 
 static void *hot_range_seq_start(struct seq_file *seq, loff_t *pos)
@@ -1217,7 +1223,7 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	/* Initialize hot tracking wq and arm one delayed work */
 	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_interval * MSEC_PER_SEC));
 
 	/* Register a shrinker callback */
 	root->hot_shrink.shrink = hot_track_prune;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index fcc60ac..d1ab48b 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -15,9 +15,6 @@
 #include <linux/workqueue.h>
 #include <linux/hot_tracking.h>
 
-#define HOT_UPDATE_INTERVAL 150
-#define HOT_AGE_INTERVAL 300
-
 /* size of sub-file ranges */
 #define RANGE_BITS 20
 #define FREQ_POWER 4
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 263a15e..6de7153 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -110,6 +110,13 @@ struct hot_info {
 };
 
 /*
+ * Two variables have meanings as below:
+ * 1. time to quit keeping track of tracking data (seconds)
+ * 2. set how often to update temperatures (seconds)
+ */
+extern int sysctl_hot_age_interval, sysctl_hot_update_interval;
+
+/*
  * Hot data tracking ioctls:
  *
  * HOT_INFO - retrieve info on frequency of access
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..6ee4338 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1616,6 +1616,20 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "hot-age-interval",
+		.data		= &sysctl_hot_age_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "hot-update-interval",
+		.data		= &sysctl_hot_update_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.7.11.7

