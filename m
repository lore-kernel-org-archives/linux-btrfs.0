Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:53497 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3ENA7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:13 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 18:59:13 -0600
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 03/12] VFS hot tracking: add one workqueue to update hot map
Date: Tue, 14 May 2013 08:59:35 +0800
Message-Id: <1368493184-5939-4-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a workqueue per superblock and a delayed_work
to run periodic work to update map info on each superblock.
  Two arrays of map list are defined, one is for hot inode
items, and the other is for hot extent items.
  The hot items in the RB-tree will be at first distilled
into one temperature in the range [0, 255]. If it is old,
it will be not linked or aged out, otherwise then it will
be linked to its corresponding array of map list which use
the temperature as its index.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 298 ++++++++++++++++++++++++++++++++++++++++++-
 fs/hot_tracking.h            |  25 ++++
 include/linux/hot_tracking.h |   4 +
 3 files changed, 326 insertions(+), 1 deletion(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index cc899f4..2742d9e 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -29,7 +29,9 @@ static void hot_inode_item_free(struct kref *kref);
 static void hot_comm_item_init(struct hot_comm_item *ci, int type)
 {
 	kref_init(&ci->refs);
+	clear_bit(HOT_IN_LIST, &ci->delete_flag);
 	clear_bit(HOT_DELETING, &ci->delete_flag);
+	INIT_LIST_HEAD(&ci->track_list);
 	memset(&ci->hot_freq_data, 0, sizeof(struct hot_freq_data));
 	ci->hot_freq_data.avg_delta_reads = (u64) -1;
 	ci->hot_freq_data.avg_delta_writes = (u64) -1;
@@ -86,12 +88,21 @@ void hot_comm_item_put(struct hot_comm_item *ci)
 EXPORT_SYMBOL_GPL(hot_comm_item_put);
 
 /*
- * root->t_lock or he->i_lock is acquired in this function
+ * root->t_lock or he->i_lock, and root->m_lock
+ * are acquired in this function
  */
 static void hot_comm_item_unlink(struct hot_info *root,
 				struct hot_comm_item *ci)
 {
 	if (!test_and_set_bit(HOT_DELETING, &ci->delete_flag)) {
+		if (test_and_clear_bit(HOT_IN_LIST, &ci->delete_flag)) {
+			spin_lock(&root->m_lock);
+			list_del_rcu(&ci->track_list);
+			spin_unlock(&root->m_lock);
+
+			hot_comm_item_put(ci);
+		}
+
 		if (ci->hot_freq_data.flags == TYPE_RANGE) {
 			struct hot_range_item *hr = container_of(ci,
 					struct hot_range_item, hot_range);
@@ -343,6 +354,274 @@ static void hot_freq_update(struct hot_info *root,
 }
 
 /*
+ * hot_temp_calc() is responsible for distilling the six heat
+ * criteria down into a single temperature value for the data,
+ * which is an integer between 0 and HEAT_MAX_VALUE.
+ *
+ * With the six values, we first do some very rudimentary
+ * "normalizations" to each metric such that they affect the
+ * final temperature calculation exactly the right way. It's
+ * important to note that we still weren't really sure that
+ * these six adjustments were exactly right.
+ * They could definitely use more tweaking and adjustment,
+ * especially in terms of the memory footprint they consume.
+ *
+ * Next, we take the adjusted values and shift them down to
+ * a manageable size, whereafter they are weighted using the
+ * the *_COEFF_POWER values and combined to a single temperature
+ * value.
+ */
+static u32 hot_temp_calc(struct hot_comm_item *ci)
+{
+	u32 result = 0;
+	struct hot_freq_data *freq_data = &ci->hot_freq_data;
+
+	struct timespec ckt = current_kernel_time();
+	u64 cur_time = timespec_to_ns(&ckt);
+	u32 nrr_heat, nrw_heat;
+	u64 ltr_heat, ltw_heat, avr_heat, avw_heat;
+
+	nrr_heat = (u32)hot_shift((u64)freq_data->nr_reads,
+					NRR_MULTIPLIER_POWER, true);
+	nrw_heat = (u32)hot_shift((u64)freq_data->nr_writes,
+					NRW_MULTIPLIER_POWER, true);
+
+	ltr_heat =
+	hot_shift((cur_time - timespec_to_ns(&freq_data->last_read_time)),
+			LTR_DIVIDER_POWER, false);
+	ltw_heat =
+	hot_shift((cur_time - timespec_to_ns(&freq_data->last_write_time)),
+			LTW_DIVIDER_POWER, false);
+
+	avr_heat =
+	hot_shift((((u64) -1) - freq_data->avg_delta_reads),
+			AVR_DIVIDER_POWER, false);
+	avw_heat =
+	hot_shift((((u64) -1) - freq_data->avg_delta_writes),
+			AVW_DIVIDER_POWER, false);
+
+	/* ltr_heat is now guaranteed to be u32 safe */
+	if (ltr_heat >= hot_shift((u64) 1, 32, true))
+		ltr_heat = 0;
+	else
+		ltr_heat = hot_shift((u64) 1, 32, true) - ltr_heat;
+
+	/* ltw_heat is now guaranteed to be u32 safe */
+	if (ltw_heat >= hot_shift((u64) 1, 32, true))
+		ltw_heat = 0;
+	else
+		ltw_heat = hot_shift((u64) 1, 32, true) - ltw_heat;
+
+	/* avr_heat is now guaranteed to be u32 safe */
+	if (avr_heat >= hot_shift((u64) 1, 32, true))
+		avr_heat = (u32) -1;
+
+	/* avw_heat is now guaranteed to be u32 safe */
+	if (avw_heat >= hot_shift((u64) 1, 32, true))
+		avw_heat = (u32) -1;
+
+	nrr_heat = (u32)hot_shift((u64)nrr_heat,
+		(3 - NRR_COEFF_POWER), false);
+	nrw_heat = (u32)hot_shift((u64)nrw_heat,
+		(3 - NRW_COEFF_POWER), false);
+	ltr_heat = hot_shift(ltr_heat, (3 - LTR_COEFF_POWER), false);
+	ltw_heat = hot_shift(ltw_heat, (3 - LTW_COEFF_POWER), false);
+	avr_heat = hot_shift(avr_heat, (3 - AVR_COEFF_POWER), false);
+	avw_heat = hot_shift(avw_heat, (3 - AVW_COEFF_POWER), false);
+
+	result = nrr_heat + nrw_heat + (u32) ltr_heat +
+		(u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;
+
+	return result;
+}
+
+static bool hot_is_obsolete(struct hot_comm_item *ci)
+{
+	int ret = 0;
+	struct timespec ckt = current_kernel_time();
+	struct hot_freq_data *freq_data = &ci->hot_freq_data;
+	u64 last_read_ns, last_write_ns;
+	u64 cur_time = timespec_to_ns(&ckt);
+	u64 kick_ns =  HOT_AGE_INTERVAL * NSEC_PER_SEC;
+
+	last_read_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_read_time));
+	last_write_ns =
+		(cur_time - timespec_to_ns(&freq_data->last_write_time));
+
+	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
+		ret = 1;
+
+	return ret;
+}
+
+static void hot_comm_item_link_cb(struct rcu_head *head)
+{
+	struct hot_comm_item *ci = container_of(head,
+				struct hot_comm_item, c_rcu);
+	struct hot_info *root;
+	u32 cur_temp = ci->hot_freq_data.last_temp;
+
+	if (ci->hot_freq_data.flags == TYPE_RANGE) {
+		struct hot_range_item *hr = container_of(ci,
+				struct hot_range_item, hot_range);
+		root = hr->hot_inode->hot_root;
+	} else {
+		struct hot_inode_item *he = container_of(ci,
+				struct hot_inode_item, hot_inode);
+		root = he->hot_root;
+
+	}
+
+	spin_lock(&root->m_lock);
+	if (test_bit(HOT_DELETING, &ci->delete_flag)) {
+		spin_unlock(&root->m_lock);
+		return;
+	}
+	list_add_tail_rcu(&ci->track_list,
+		&root->hot_map[ci->hot_freq_data.flags][cur_temp]);
+	spin_unlock(&root->m_lock);
+}
+
+/*
+ * Calculate a new temperature and, if necessary,
+ * move the list_head corresponding to this inode or range
+ * to the proper list with the new temperature.
+ */
+static int hot_map_update(struct hot_info *root,
+			struct hot_comm_item *ci)
+{
+	u32 temp = hot_temp_calc(ci);
+	u8 cur_temp, prev_temp;
+	int flag = false;
+
+	cur_temp = (u8)hot_shift((u64)temp,
+				(32 - MAP_BITS), false);
+	prev_temp = (u8)hot_shift((u64)ci->hot_freq_data.last_temp,
+				(32 - MAP_BITS), false);
+
+	if (cur_temp != prev_temp) {
+		if (test_and_set_bit(HOT_IN_LIST, &ci->delete_flag)) {
+			spin_lock(&root->m_lock);
+			list_del_rcu(&ci->track_list);
+			spin_unlock(&root->m_lock);
+			flag = true;
+		}
+
+		ci->hot_freq_data.last_temp = temp;
+
+		if (flag)
+			call_rcu(&ci->c_rcu, hot_comm_item_link_cb);
+			if (test_bit(HOT_DELETING, &ci->delete_flag))
+				return 1;
+		else {
+			u32 flags = ci->hot_freq_data.flags;
+
+			hot_comm_item_get(ci);
+
+			spin_lock(&root->m_lock);
+			if (test_bit(HOT_DELETING, &ci->delete_flag)) {
+				spin_unlock(&root->m_lock);
+				return 1;
+			}
+			list_add_tail_rcu(&ci->track_list,
+					&root->hot_map[flags][cur_temp]);
+			spin_unlock(&root->m_lock);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Update temperatures for each range item for aging purposes.
+ * If one hot range item is old, it will be aged out.
+ */
+static void hot_range_update(struct hot_inode_item *he,
+				struct hot_info *root)
+{
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+	bool obsolete;
+
+	rcu_read_lock();
+	node = rb_first(&he->hot_range_tree);
+	while (node) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		node = rb_next(node);
+		if (test_bit(HOT_DELETING, &ci->delete_flag) ||
+			hot_map_update(root, ci)) {
+			continue;
+		}
+		obsolete = hot_is_obsolete(ci);
+		if (obsolete)
+			hot_comm_item_unlink(root, ci);
+	}
+	rcu_read_unlock();
+}
+
+/* Temperature compare function*/
+static int hot_temp_cmp(void *priv, struct list_head *a,
+				struct list_head *b)
+{
+	struct hot_comm_item *ap = container_of(a,
+			struct hot_comm_item, track_list);
+	struct hot_comm_item *bp = container_of(b,
+			struct hot_comm_item, track_list);
+
+	int diff = ap->hot_freq_data.last_temp
+			- bp->hot_freq_data.last_temp;
+	if (diff > 0)
+		return -1;
+	if (diff < 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Every sync period we update temperatures for
+ * each hot inode item and hot range item for aging
+ * purposes.
+ */
+static void hot_update_worker(struct work_struct *work)
+{
+	struct hot_info *root = container_of(to_delayed_work(work),
+					struct hot_info, update_work);
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+	struct hot_inode_item *he;
+	int i, j;
+
+	rcu_read_lock();
+	node = rb_first(&root->hot_inode_tree);
+	while (node) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		node = rb_next(node);
+		if (test_bit(HOT_DELETING, &ci->delete_flag) ||
+			hot_map_update(root, ci)) {
+			continue;
+		}
+		he = container_of(ci,
+			struct hot_inode_item, hot_inode);
+		hot_range_update(he, root);
+	}
+	rcu_read_unlock();
+
+	/* Sort temperature map info based on last temperature*/
+	for (i = 0; i < MAP_SIZE; i++) {
+		for (j = 0; j < MAX_TYPES; j++) {
+			spin_lock(&root->m_lock);
+			list_sort(NULL, &root->hot_map[j][i], hot_temp_cmp);
+			spin_unlock(&root->m_lock);
+		}
+	}
+
+	/* Instert next delayed work */
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 void __init hot_cache_init(void)
@@ -433,6 +712,20 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 			INIT_LIST_HEAD(&root->hot_map[j][i]);
 	}
 
+	root->update_wq = alloc_workqueue(
+			"hot_update_wq", WQ_NON_REENTRANT, 0);
+	if (!root->update_wq) {
+		printk(KERN_ERR "%s: Failed to create "
+				"hot update workqueue\n", __func__);
+		kfree(root);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* Initialize hot tracking wq and arm one delayed work */
+	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+
 	return root;
 }
 
@@ -444,6 +737,9 @@ static void hot_tree_exit(struct hot_info *root)
 	struct rb_node *node;
 	struct hot_comm_item *ci;
 
+	cancel_delayed_work_sync(&root->update_work);
+	destroy_workqueue(root->update_wq);
+
 	rcu_read_lock();
 	node = rb_first(&root->hot_inode_tree);
 	while (node) {
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index bb4cb16..8a53c2d 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -12,10 +12,35 @@
 #ifndef __HOT_TRACKING__
 #define __HOT_TRACKING__
 
+#include <linux/workqueue.h>
 #include <linux/hot_tracking.h>
 
+#define HOT_UPDATE_INTERVAL 150
+#define HOT_AGE_INTERVAL 300
+
 /* size of sub-file ranges */
 #define RANGE_BITS 20
 #define FREQ_POWER 4
 
+/* NRR/NRW heat unit = 2^X accesses */
+#define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
+#define NRR_COEFF_POWER 0
+#define NRW_MULTIPLIER_POWER 20 /* NRW - number of writes since mount */
+#define NRW_COEFF_POWER 0
+
+/* LTR/LTW heat unit = 2^X ns of age */
+#define LTR_DIVIDER_POWER 30 /* LTR - time elapsed since last read(ns) */
+#define LTR_COEFF_POWER 1
+#define LTW_DIVIDER_POWER 30 /* LTW - time elapsed since last write(ns) */
+#define LTW_COEFF_POWER 1
+
+/*
+ * AVR/AVW cold unit = 2^X ns of average delta
+ * AVR/AVW heat unit = HEAT_MAX_VALUE - cold unit
+ */
+#define AVR_DIVIDER_POWER 40 /* AVR - average delta between recent reads(ns) */
+#define AVR_COEFF_POWER 0
+#define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
+#define AVW_COEFF_POWER 0
+
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 3c0cf57..c32197b 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -35,6 +35,7 @@ enum {
 
 enum {
 	HOT_DELETING,
+	HOT_IN_LIST,
 };
 
 /*
@@ -60,6 +61,7 @@ struct hot_comm_item {
 	struct rb_node rb_node;			/* rbtree index */
 	unsigned long delete_flag;
 	struct rcu_head c_rcu;
+	struct list_head track_list;		/* link to *_map[] */
 };
 
 /* An item representing an inode and its access frequency */
@@ -88,6 +90,8 @@ struct hot_info {
 	spinlock_t t_lock;				/* protect above tree */
 	struct list_head hot_map[MAX_TYPES][MAP_SIZE];	/* map of inode temp */
 	spinlock_t m_lock;
+	struct workqueue_struct *update_wq;
+	struct delayed_work update_work;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.11.7

