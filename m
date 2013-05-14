Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55380 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800Ab3ENBAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 21:00:05 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 21:00:04 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 12/12] VFS hot tracking: add fs hot type support
Date: Tue, 14 May 2013 08:59:44 +0800
Message-Id: <1368493184-5939-13-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one ability to enable that specific FS
can register its own hot tracking functions.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 32 ++++++++++++++++++++++----------
 fs/hot_tracking.h            | 19 +++++++++++++++++++
 fs/ioctl.c                   |  2 +-
 include/linux/fs.h           |  1 +
 include/linux/hot_tracking.h | 22 +++++++++++++++++++++-
 5 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 088e9aa..4eee33c 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -51,7 +51,7 @@ static void hot_range_item_init(struct hot_range_item *hr,
 			struct hot_inode_item *he, loff_t start)
 {
 	hr->start = start;
-	hr->len = hot_shift(1, RANGE_BITS, true);
+	hr->len = hot_shift(1, he->hot_root->hot_type->range_bits, true);
 	hr->hot_inode = he;
 	hr->storage_type = -1;
 	hot_comm_item_init(&hr->hot_range, TYPE_RANGE);
@@ -259,10 +259,11 @@ struct hot_range_item
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
+	struct hot_info *root = he->hot_root;
 	struct hot_comm_item *ci;
 	struct hot_range_item *hr, *hr_new = NULL;
 
-	start = hot_shift(start, RANGE_BITS, true);
+	start = hot_shift(start, root->hot_type->range_bits, true);
 
 	/* walk tree to find insertion point */
 redo:
@@ -350,13 +351,13 @@ static void hot_freq_update(struct hot_info *root,
 
 	if (write) {
 		freq_data->nr_writes += 1;
-		hot_freq_calc(freq_data->last_write_time,
+		HOT_FREQ_CALC(root, freq_data->last_write_time,
 				cur_time,
 				&freq_data->avg_delta_writes);
 		freq_data->last_write_time = cur_time;
 	} else {
 		freq_data->nr_reads += 1;
-		hot_freq_calc(freq_data->last_read_time,
+		HOT_FREQ_CALC(root, freq_data->last_read_time,
 				cur_time,
 				&freq_data->avg_delta_reads);
 		freq_data->last_read_time = cur_time;
@@ -381,7 +382,7 @@ static void hot_freq_update(struct hot_info *root,
  * the *_COEFF_POWER values and combined to a single temperature
  * value.
  */
-u32 hot_temp_calc(struct hot_comm_item *ci)
+static u32 hot_temp_calc(struct hot_comm_item *ci)
 {
 	u32 result = 0;
 	struct hot_freq_data *freq_data = &ci->hot_freq_data;
@@ -501,7 +502,7 @@ static void hot_comm_item_link_cb(struct rcu_head *head)
 static int hot_map_update(struct hot_info *root,
 			struct hot_comm_item *ci)
 {
-	u32 temp = hot_temp_calc(ci);
+	u32 temp = HOT_TEMP_CALC(root, ci);
 	u8 cur_temp, prev_temp;
 	int flag = false;
 
@@ -564,7 +565,7 @@ static void hot_range_update(struct hot_inode_item *he,
 			hot_map_update(root, ci)) {
 			continue;
 		}
-		obsolete = hot_is_obsolete(ci);
+		obsolete = HOT_IS_OBSOLETE(root, ci);
 		if (obsolete)
 			hot_comm_item_unlink(root, ci);
 	}
@@ -1167,10 +1168,10 @@ void hot_update_freqs(struct inode *inode, loff_t start,
 	 * Align ranges on range size boundary
 	 * to prevent proliferation of range structs
 	 */
-	range_size  = hot_shift(1, RANGE_BITS, true);
+	range_size  = hot_shift(1, root->hot_type->range_bits, true);
 	end = hot_shift((start + len + range_size - 1),
-			RANGE_BITS, false);
-	cur = hot_shift(start, RANGE_BITS, false);
+			root->hot_type->range_bits, false);
+	cur = hot_shift(start, root->hot_type->range_bits, false);
 	for (; cur < end; cur++) {
 		hr = hot_range_item_lookup(he, cur, 1);
 		if (IS_ERR(hr)) {
@@ -1211,6 +1212,17 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 			INIT_LIST_HEAD(&root->hot_map[j][i]);
 	}
 
+	/* Get hot type for specific FS */
+	root->hot_type = &sb->s_type->hot_type;
+	if (!HOT_FREQ_FN_EXIST(root))
+		SET_HOT_FREQ_FN(root, hot_freq_calc);
+	if (!HOT_TEMP_FN_EXIST(root))
+		SET_HOT_TEMP_FN(root, hot_temp_calc);
+	if (!HOT_OBSOLETE_FN_EXIST(root))
+		SET_HOT_OBSOLETE_FN(root, hot_is_obsolete);
+	if (root->hot_type->range_bits == 0)
+		root->hot_type->range_bits = RANGE_BITS;
+
 	root->update_wq = alloc_workqueue(
 			"hot_update_wq", WQ_NON_REENTRANT, 0);
 	if (!root->update_wq) {
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index d1ab48b..4756fc3 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -40,6 +40,25 @@
 #define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
 #define AVW_COEFF_POWER 0
 
+#define HOT_FREQ_FN_EXIST(root) \
+	((root)->hot_type->ops.hot_freq_calc)
+#define HOT_TEMP_FN_EXIST(root) \
+	((root)->hot_type->ops.hot_temp_calc)
+#define HOT_OBSOLETE_FN_EXIST(root) \
+	((root)->hot_type->ops.hot_is_obsolete)
+
+#define HOT_FREQ_CALC(root, lt, ct, avg) \
+	((root)->hot_type->ops.hot_freq_calc(lt, ct, avg))
+#define HOT_IS_OBSOLETE(root, ci) \
+	((root)->hot_type->ops.hot_is_obsolete(ci))
+
+#define SET_HOT_FREQ_FN(root, fn) \
+	(root)->hot_type->ops.hot_freq_calc = fn
+#define SET_HOT_TEMP_FN(root, fn) \
+	(root)->hot_type->ops.hot_temp_calc = fn
+#define SET_HOT_OBSOLETE_FN(root, fn) \
+	(root)->hot_type->ops.hot_is_obsolete = fn
+
 struct hot_debugfs {
 	const char *name;
 	const struct file_operations *fops;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index f9f3497..95ec029 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -585,7 +585,7 @@ static int ioctl_heat_info(struct file *file, void __user *argp)
 		 * got a request for live temperature,
 		 * call hot_calc_temp() to recalculate
 		 */
-		heat_info.temp = hot_temp_calc(&he->hot_inode);
+		heat_info.temp = HOT_TEMP_CALC(he->hot_root, &he->hot_inode);
 	} else {
 		/* not live temperature, get it from the map list */
 		heat_info.temp = he->hot_inode.hot_freq_data.last_temp;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ee2c54f..dda3b9c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1817,6 +1817,7 @@ struct file_system_type {
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
 	void (*kill_sb) (struct super_block *);
+	struct hot_type hot_type;
 	struct module *owner;
 	struct file_system_type * next;
 	struct hlist_head fs_supers;
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 6de7153..6184296 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -97,6 +97,26 @@ struct hot_range_item {
 	int storage_type;			/* type of storage */
 };
 
+typedef void (hot_freq_calc_fn) (struct timespec old_atime,
+				struct timespec cur_time, u64 *avg);
+typedef u32 (hot_temp_calc_fn) (struct hot_comm_item *ci);
+typedef bool (hot_is_obsolete_fn) (struct hot_comm_item *ci);
+
+struct hot_func_ops {
+	hot_freq_calc_fn *hot_freq_calc;
+	hot_temp_calc_fn *hot_temp_calc;
+	hot_is_obsolete_fn *hot_is_obsolete;
+};
+
+/* identifies an hot type */
+struct hot_type {
+	u64 range_bits;
+	struct hot_func_ops ops;	/* fields provided by specific FS */
+};
+
+#define HOT_TEMP_CALC(root, ci) \
+	((root)->hot_type->ops.hot_temp_calc(ci))
+
 struct hot_info {
 	struct rb_root hot_inode_tree;
 	spinlock_t t_lock;				/* protect above tree */
@@ -105,6 +125,7 @@ struct hot_info {
 	atomic_t hot_map_nr;
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
+	struct hot_type *hot_type;
 	struct shrinker hot_shrink;
 	struct dentry *debugfs_dentry;
 };
@@ -135,7 +156,6 @@ extern struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root,
 extern struct hot_range_item *hot_range_item_lookup(struct hot_inode_item *he,
 						loff_t start, int alloc);
 extern void hot_inode_item_delete(struct inode *inode);
-extern u32 hot_temp_calc(struct hot_comm_item *ci);
 
 static inline u64 hot_shift(u64 counter, u32 bits, bool dir)
 {
-- 
1.7.11.7

