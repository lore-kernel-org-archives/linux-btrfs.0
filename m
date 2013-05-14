Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:45768 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab3ENA7R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:17 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 18:59:17 -0600
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 04/12] VFS hot tracking: register one shrinker
Date: Tue, 14 May 2013 08:59:36 +0800
Message-Id: <1368493184-5939-5-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Register a shrinker to control the amount of memory that
is used in tracking hot regions. If we are throwing inodes
out of memory due to memory pressure, we most definitely are
going to need to reduce the amount of memory the tracking
code is using, even if it means losing useful information
That is, the shrinker accelerates the aging process.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 58 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |  2 ++
 2 files changed, 60 insertions(+)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 2742d9e..af4498c 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -100,6 +100,7 @@ static void hot_comm_item_unlink(struct hot_info *root,
 			list_del_rcu(&ci->track_list);
 			spin_unlock(&root->m_lock);
 
+			atomic_dec(&root->hot_map_nr);
 			hot_comm_item_put(ci);
 		}
 
@@ -517,6 +518,7 @@ static int hot_map_update(struct hot_info *root,
 		else {
 			u32 flags = ci->hot_freq_data.flags;
 
+			atomic_inc(&root->hot_map_nr);
 			hot_comm_item_get(ci);
 
 			spin_lock(&root->m_lock);
@@ -642,6 +644,55 @@ void __init hot_cache_init(void)
 }
 EXPORT_SYMBOL_GPL(hot_cache_init);
 
+static void hot_prune_map(struct hot_info *root, long nr)
+{
+	int i;
+
+	for (i = 0; i < MAP_SIZE; i++) {
+		struct hot_comm_item *ci;
+		unsigned long prev_nr;
+
+		rcu_read_lock();
+		if (list_empty(&root->hot_map[TYPE_INODE][i])) {
+			rcu_read_unlock();
+			continue;
+		}
+
+		list_for_each_entry_rcu(ci, &root->hot_map[TYPE_INODE][i],
+					track_list) {
+			prev_nr = atomic_read(&root->hot_map_nr);
+			hot_comm_item_unlink(root, ci);
+			nr -= (prev_nr - atomic_read(&root->hot_map_nr));
+			if (nr <= 0)
+				break;
+		}
+		rcu_read_unlock();
+
+		if (nr <= 0)
+			break;
+	}
+
+	return;
+}
+
+/* The shrinker callback function */
+static int hot_track_prune(struct shrinker *shrink,
+			struct shrink_control *sc)
+{
+	struct hot_info *root =
+		container_of(shrink, struct hot_info, hot_shrink);
+
+	if (sc->nr_to_scan == 0)
+		return atomic_read(&root->hot_map_nr) / 2;
+
+	if (!(sc->gfp_mask & __GFP_FS))
+		return -1;
+
+	hot_prune_map(root, sc->nr_to_scan);
+
+	return atomic_read(&root->hot_map_nr);
+}
+
 /*
  * Main function to update i/o access frequencies, and it will be called
  * from read/writepages() hooks, which are read_pages(), do_writepages(),
@@ -706,6 +757,7 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	root->hot_inode_tree = RB_ROOT;
 	spin_lock_init(&root->t_lock);
 	spin_lock_init(&root->m_lock);
+	atomic_set(&root->hot_map_nr, 0);
 
 	for (i = 0; i < MAP_SIZE; i++) {
 		for (j = 0; j < MAX_TYPES; j++)
@@ -726,6 +778,11 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	queue_delayed_work(root->update_wq, &root->update_work,
 		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
 
+	/* Register a shrinker callback */
+	root->hot_shrink.shrink = hot_track_prune;
+	root->hot_shrink.seeks = DEFAULT_SEEKS;
+	register_shrinker(&root->hot_shrink);
+
 	return root;
 }
 
@@ -737,6 +794,7 @@ static void hot_tree_exit(struct hot_info *root)
 	struct rb_node *node;
 	struct hot_comm_item *ci;
 
+	unregister_shrinker(&root->hot_shrink);
 	cancel_delayed_work_sync(&root->update_work);
 	destroy_workqueue(root->update_wq);
 
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index c32197b..a78b4fc 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -90,8 +90,10 @@ struct hot_info {
 	spinlock_t t_lock;				/* protect above tree */
 	struct list_head hot_map[MAX_TYPES][MAP_SIZE];	/* map of inode temp */
 	spinlock_t m_lock;
+	atomic_t hot_map_nr;
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
+	struct shrinker hot_shrink;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.11.7

