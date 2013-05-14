Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48720 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab3ENA7e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:34 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 20:59:33 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 07/12] VFS hot tracking: add debugfs support
Date: Tue, 14 May 2013 08:59:39 +0800
Message-Id: <1368493184-5939-8-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a directory '<dev_name>' in /sys/kernel/debug/hot_track/
for each volume that contains four files which are 'inode_stat',
'extent_stat', 'inode_spot', and 'extent_spot'.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 455 +++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |   5 +
 include/linux/hot_tracking.h |   1 +
 3 files changed, 461 insertions(+)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index af4498c..cea3675 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -17,9 +17,12 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/list_sort.h>
+#include <linux/debugfs.h>
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
+static struct dentry *hot_debugfs_root;
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
@@ -623,6 +626,444 @@ static void hot_update_worker(struct work_struct *work)
 		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
 }
 
+static void *hot_range_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(rcu)
+{
+	struct hot_info *root = seq->private;
+	struct rb_node *node_he, *node_hr;
+	struct hot_comm_item *ci_he, *ci_hr;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+	loff_t l = *pos;
+
+	rcu_read_lock();
+	node_he = rb_first(&root->hot_inode_tree);
+	while (node_he) {
+		ci_he = rb_entry(node_he, struct hot_comm_item, rb_node);
+		he = container_of(ci_he, struct hot_inode_item, hot_inode);
+		node_hr = rb_first(&he->hot_range_tree);
+		while (node_hr) {
+			if (!l--) {
+				ci_hr = rb_entry(node_hr,
+					struct hot_comm_item, rb_node);
+				hr = container_of(ci_hr,
+					struct hot_range_item, hot_range);
+				return hr;
+			}
+			node_hr = rb_next(node_hr);
+		}
+		node_he = rb_next(node_he);
+	}
+
+	return NULL;
+}
+
+static void *hot_range_seq_next(struct seq_file *seq,
+				void *v, loff_t *pos)
+{
+	struct rb_node *node_he, *node_hr;
+	struct hot_comm_item *ci_he, *ci_hr;
+	struct hot_range_item *hr_next = NULL, *hr = v;
+	struct hot_inode_item *he_next;
+
+	(*pos)++;
+	node_hr = rb_next(&hr->hot_range.rb_node);
+	if (node_hr) {
+		ci_hr = rb_entry(node_hr, struct hot_comm_item, rb_node);
+		hr_next = container_of(ci_hr, struct hot_range_item, hot_range);
+
+		return hr_next;
+	}
+
+	node_he = rb_next(&hr->hot_inode->hot_inode.rb_node);
+loop_he:
+	if (node_he) {
+		ci_he = rb_entry(node_he, struct hot_comm_item, rb_node);
+		he_next = container_of(ci_he, struct hot_inode_item, hot_inode);
+		node_hr = rb_first(&he_next->hot_range_tree);
+		if (node_hr) {
+			ci_hr = rb_entry(node_hr,
+					struct hot_comm_item, rb_node);
+			hr_next = container_of(ci_hr,
+					struct hot_range_item, hot_range);
+		} else {
+			node_he = rb_next(node_he);
+			goto loop_he;
+		}
+	}
+
+	return hr_next;
+}
+
+static void hot_range_seq_stop(struct seq_file *seq, void *v)
+	__releases(rcu)
+{
+	rcu_read_unlock();
+}
+
+static int hot_range_seq_show(struct seq_file *seq, void *v)
+{
+	struct hot_range_item *hr = v;
+	struct hot_inode_item *he = hr->hot_inode;
+	struct hot_freq_data *freq_data;
+
+	freq_data = &hr->hot_range.hot_freq_data;
+	seq_printf(seq, "inode %llu, extent %llu+%llu, " \
+			"reads %u, writes %u, temp %u, " \
+			"storage type %s\n",
+			he->i_ino, (unsigned long long)hr->start,
+			(unsigned long long)hr->len,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			(u8)hot_shift((u64)freq_data->last_temp,
+					(32 - MAP_BITS), false),
+			(hr->storage_type == 1) ? "nonrot" : "rot");
+
+	return 0;
+}
+
+static void *hot_inode_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(rcu)
+{
+	struct hot_info *root = seq->private;
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+	struct hot_inode_item *he = NULL;
+	loff_t l = *pos;
+
+	rcu_read_lock();
+	node = rb_first(&root->hot_inode_tree);
+	while (node) {
+		if (!l--) {
+			ci = rb_entry(node, struct hot_comm_item, rb_node);
+			he = container_of(ci, struct hot_inode_item, hot_inode);
+			break;
+		}
+		node = rb_next(node);
+	}
+
+	return he;
+}
+
+static void *hot_inode_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_inode_item *he_next = NULL, *he = v;
+	struct rb_node *node;
+	struct hot_comm_item *ci;
+
+	(*pos)++;
+	node = rb_next(&he->hot_inode.rb_node);
+	if (node) {
+		ci = rb_entry(node, struct hot_comm_item, rb_node);
+		he_next = container_of(ci, struct hot_inode_item, hot_inode);
+	}
+
+	return he_next;
+}
+
+static void hot_inode_seq_stop(struct seq_file *seq, void *v)
+	__releases(rcu)
+{
+	rcu_read_unlock();
+}
+
+static int hot_inode_seq_show(struct seq_file *seq, void *v)
+{
+	struct hot_inode_item *he = v;
+	struct hot_freq_data *freq_data = &he->hot_inode.hot_freq_data;
+
+	seq_printf(seq, "inode %llu, reads %u, writes %u, temp %d\n",
+		he->i_ino,
+		freq_data->nr_reads,
+		freq_data->nr_writes,
+		(u8)hot_shift((u64)freq_data->last_temp,
+				(32 - MAP_BITS), false));
+
+	return 0;
+}
+
+static struct hot_comm_item *hot_spot_seq_start(struct hot_info *root,
+					loff_t *pos, int type)
+	__acquires(rcu)
+{
+	struct hot_comm_item *ci;
+	struct list_head *track_list;
+	int i;
+
+	rcu_read_lock();
+	for (i = MAP_SIZE - 1; i >= 0; i--) {
+		track_list = seq_list_start_rcu(&root->hot_map[type][i], *pos);
+		if (track_list) {
+			ci = container_of(track_list,
+				struct hot_comm_item, track_list);
+			return ci;
+		}
+	}
+
+	return NULL;
+}
+
+static struct hot_comm_item *hot_spot_seq_next(struct hot_info *root,
+					struct hot_comm_item *ci,
+					loff_t *pos, int type)
+{
+	struct hot_comm_item *ci_next = NULL;
+	struct list_head *track_list;
+	int i;
+
+	i = (int)hot_shift(ci->hot_freq_data.last_temp,
+			(32 - MAP_BITS), false);
+
+	track_list = seq_list_next_rcu(&ci->track_list,
+				&root->hot_map[type][i], pos);
+next:
+	if (track_list)
+		ci_next = container_of(track_list,
+				struct hot_comm_item, track_list);
+	else if (--i >= 0) {
+		track_list = seq_list_next_rcu(&root->hot_map[type][i],
+					&root->hot_map[type][i], pos);
+		goto next;
+	}
+
+	return ci_next;
+}
+
+static void *hot_spot_range_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_range_item *hr = NULL;
+	struct hot_comm_item *ci;
+
+	ci =  hot_spot_seq_start(root, pos, TYPE_RANGE);
+	if (ci)
+		hr = container_of(ci, struct hot_range_item, hot_range);
+
+	return hr;
+}
+
+static void *hot_spot_range_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_range_item *hr_next = NULL, *hr = v;
+	struct hot_comm_item *ci_next;
+
+	ci_next = hot_spot_seq_next(root, &hr->hot_range, pos, TYPE_RANGE);
+	if (ci_next)
+		hr_next = container_of(ci_next,
+				struct hot_range_item, hot_range);
+
+	return hr_next;
+}
+
+static void *hot_spot_inode_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *he = NULL;
+	struct hot_comm_item *ci;
+
+	ci = hot_spot_seq_start(root, pos, TYPE_INODE);
+	if (ci)
+		he = container_of(ci, struct hot_inode_item, hot_inode);
+
+	return he;
+}
+
+static void *hot_spot_inode_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *he_next = NULL, *he = v;
+	struct hot_comm_item *ci_next;
+
+	ci_next = hot_spot_seq_next(root, &he->hot_inode, pos, TYPE_INODE);
+	if (ci_next)
+		he_next = container_of(ci_next,
+				struct hot_inode_item, hot_inode);
+
+	return he_next;
+}
+
+static const struct seq_operations hot_range_seq_ops = {
+	.start = hot_range_seq_start,
+	.next = hot_range_seq_next,
+	.stop = hot_range_seq_stop,
+	.show = hot_range_seq_show
+};
+
+static const struct seq_operations hot_inode_seq_ops = {
+	.start = hot_inode_seq_start,
+	.next = hot_inode_seq_next,
+	.stop = hot_inode_seq_stop,
+	.show = hot_inode_seq_show
+};
+
+static const struct seq_operations hot_spot_range_seq_ops = {
+	.start = hot_spot_range_seq_start,
+	.next = hot_spot_range_seq_next,
+	.stop = hot_range_seq_stop,
+	.show = hot_range_seq_show
+};
+
+static const struct seq_operations hot_spot_inode_seq_ops = {
+	.start = hot_spot_inode_seq_start,
+	.next = hot_spot_inode_seq_next,
+	.stop = hot_inode_seq_stop,
+	.show = hot_inode_seq_show
+};
+
+static int hot_range_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_range_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_inode_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_inode_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_spot_range_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_spot_range_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_spot_inode_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_spot_inode_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+/* fops to override for printing range data */
+static const struct file_operations hot_debugfs_range_fops = {
+	.open = hot_range_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+/* fops to override for printing inode data */
+static const struct file_operations hot_debugfs_inode_fops = {
+	.open = hot_inode_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+/* fops to override for printing temperature data */
+static const struct file_operations hot_debugfs_spot_range_fops = {
+	.open = hot_spot_range_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct file_operations hot_debugfs_spot_inode_fops = {
+	.open = hot_spot_inode_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct hot_debugfs hot_debugfs[] = {
+	{
+		.name = "extent_stat",
+		.fops  = &hot_debugfs_range_fops,
+	},
+	{
+		.name = "inode_stat",
+		.fops  = &hot_debugfs_inode_fops,
+	},
+	{
+		.name = "extent_spot",
+		.fops  = &hot_debugfs_spot_range_fops,
+	},
+	{
+		.name = "inode_spot",
+		.fops  = &hot_debugfs_spot_inode_fops,
+	},
+};
+
+/* initialize debugfs */
+static int hot_debugfs_init(struct super_block *sb)
+{
+	static const char hot_name[] = "hot_track";
+	struct dentry *dentry;
+	int i, ret = 0;
+
+	/* Determine if hot debufs root has existed */
+	if (!hot_debugfs_root) {
+		hot_debugfs_root = debugfs_create_dir(hot_name, NULL);
+		if (IS_ERR(hot_debugfs_root)) {
+			ret = PTR_ERR(hot_debugfs_root);
+			return ret;
+		}
+	}
+
+	/* create debugfs folder for this volume by mounted dev name */
+	sb->s_hot_root->debugfs_dentry =
+			debugfs_create_dir(sb->s_id, hot_debugfs_root);
+	if (IS_ERR(sb->s_hot_root->debugfs_dentry)) {
+		ret = PTR_ERR(sb->s_hot_root->debugfs_dentry);
+		goto root_err;
+	}
+
+	/* create debugfs hot data files */
+	for (i = 0; i < ARRAY_SIZE(hot_debugfs); i++) {
+		dentry = debugfs_create_file(hot_debugfs[i].name,
+					S_IFREG | S_IRUSR | S_IWUSR,
+					sb->s_hot_root->debugfs_dentry,
+					sb->s_hot_root,
+					hot_debugfs[i].fops);
+		if (IS_ERR(dentry)) {
+			ret = PTR_ERR(dentry);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	debugfs_remove_recursive(sb->s_hot_root->debugfs_dentry);
+
+root_err:
+	if (list_empty(&hot_debugfs_root->d_subdirs)) {
+		debugfs_remove(hot_debugfs_root);
+		hot_debugfs_root = NULL;
+	}
+
+	return ret;
+}
+
+/* remove dentries for debugsfs */
+static void hot_debugfs_exit(struct super_block *sb)
+{
+	/* remove all debugfs entries recursively from the volume root */
+	debugfs_remove_recursive(sb->s_hot_root->debugfs_dentry);
+
+	if (list_empty(&hot_debugfs_root->d_subdirs)) {
+		debugfs_remove(hot_debugfs_root);
+		hot_debugfs_root = NULL;
+	}
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -818,6 +1259,7 @@ static void hot_tree_exit(struct hot_info *root)
 int hot_track_init(struct super_block *sb)
 {
 	struct hot_info *root;
+	int ret;
 
 	root = hot_tree_init(sb);
 	if (IS_ERR(root))
@@ -825,9 +1267,21 @@ int hot_track_init(struct super_block *sb)
 
 	sb->s_hot_root = root;
 
+	ret = hot_debugfs_init(sb);
+	if (ret) {
+		printk(KERN_ERR "%s: hot_debugfs_init error: %d\n",
+				__func__, ret);
+		goto out;
+	}
+
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
 
 	return 0;
+
+out:
+	hot_tree_exit(root);
+	sb->s_hot_root = NULL;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hot_track_init);
 
@@ -840,6 +1294,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = sb->s_hot_root;
 
+	hot_debugfs_exit(sb);
 	hot_tree_exit(root);
 	sb->s_hot_root = NULL;
 	kfree(root);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 8a53c2d..fcc60ac 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -43,4 +43,9 @@
 #define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
 #define AVW_COEFF_POWER 0
 
+struct hot_debugfs {
+	const char *name;
+	const struct file_operations *fops;
+};
+
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index a78b4fc..63baae3 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -94,6 +94,7 @@ struct hot_info {
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
 	struct shrinker hot_shrink;
+	struct dentry *debugfs_dentry;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.11.7

