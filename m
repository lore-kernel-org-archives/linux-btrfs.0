From: bchociej@gmail.com
Subject: [RFC v2 PATCH 4/6] Btrfs: Add debugfs interface for hot data stats
Date: Thu, 12 Aug 2010 17:22:04 -0500
Message-ID: <1281651726-23501-5-git-send-email-bchociej@gmail.com>
References: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, bchociej@gmail.com, mlupfer@gmail.com,
	conscott@vt.edu
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bchociej@gmail.com>

Add a /sys/kernel/debug/btrfs_data/<device_name>/ directory for each
volume that contains two files. The first, `inode_data', contains the
heat information for inodes that have been brought into the hot data map
structures. The second, `range_data', contains similar information for
subfile ranges.

Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Signed-off-by: Conor Scott <conscott@vt.edu>
Signed-off-by: Ben Chociej <bchociej@gmail.com>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/btrfs/debugfs.c |  532 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/debugfs.h |   89 +++++++++
 2 files changed, 621 insertions(+), 0 deletions(-)
 create mode 100644 fs/btrfs/debugfs.c
 create mode 100644 fs/btrfs/debugfs.h

diff --git a/fs/btrfs/debugfs.c b/fs/btrfs/debugfs.c
new file mode 100644
index 0000000..c11c0b6
--- /dev/null
+++ b/fs/btrfs/debugfs.c
@@ -0,0 +1,532 @@
+/*
+ * fs/btrfs/debugfs.c
+ *
+ * This file contains the code to interface with the btrfs debugfs.
+ * The debugfs outputs range- and file-level access frequency
+ * statistics for each mounted volume.
+ *
+ * Copyright (C) 2010 International Business Machines Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <linux/limits.h>
+#include "ctree.h"
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
+#include "hotdata_relocate.h"
+#include "debugfs.h"
+
+static int copy_msg_to_log(struct debugfs_vol_data *data, char *msg, int len)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	uint new_log_alloc_size;
+	char *new_log;
+
+	if (len >= data->log_alloc_size - debugfs_log->len) {
+		/* Not enough room in the log buffer for the new message. */
+		/* Allocate a bigger buffer. */
+		new_log_alloc_size = data->log_alloc_size + LOG_PAGE_SIZE;
+		new_log = vmalloc(new_log_alloc_size);
+
+		if (new_log) {
+			memcpy(new_log, debugfs_log->str,
+				debugfs_log->len);
+			memset(new_log + debugfs_log->len, 0,
+				new_log_alloc_size - debugfs_log->len);
+			vfree(debugfs_log->str);
+			debugfs_log->str = new_log;
+			data->log_alloc_size = new_log_alloc_size;
+		} else {
+			WARN_ON(1);
+			if (data->log_alloc_size - debugfs_log->len) {
+				#define err_msg "No more memory!\n"
+				strlcpy(debugfs_log->str +
+					debugfs_log->len,
+					err_msg, data->log_alloc_size -
+					debugfs_log->len);
+				debugfs_log->len +=
+					min((typeof(debugfs_log->len))
+					sizeof(err_msg),
+					((typeof(debugfs_log->len))
+					data->log_alloc_size -
+					debugfs_log->len));
+			}
+			return 0;
+		}
+	}
+
+	memcpy(debugfs_log->str + debugfs_log->len,
+		data->log_work_buff, len);
+	debugfs_log->len += (unsigned long) len;
+
+	return len;
+}
+
+/* Returns the number of bytes written to the log. */
+static int debugfs_log(struct debugfs_vol_data *data, const char *fmt, ...)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	va_list args;
+	int len;
+
+	if (debugfs_log->str == NULL)
+		return -1;
+
+	spin_lock(&data->log_lock);
+
+	va_start(args, fmt);
+	len = vsnprintf(data->log_work_buff, sizeof(data->log_work_buff), fmt,
+		args);
+	va_end(args);
+
+	if (len >= sizeof(data->log_work_buff)) {
+		#define truncate_msg "The next message has been truncated.\n"
+		copy_msg_to_log(data, truncate_msg, sizeof(truncate_msg));
+	}
+
+	len = copy_msg_to_log(data, data->log_work_buff, len);
+	spin_unlock(&data->log_lock);
+
+	return len;
+}
+
+/* initialize a log corresponding to a btrfs volume */
+static int debugfs_log_init(struct debugfs_vol_data *data)
+{
+	int err = 0;
+	struct lstring *debugfs_log = data->debugfs_log;
+
+	spin_lock(&data->log_lock);
+	debugfs_log->str = vmalloc(INIT_LOG_ALLOC_SIZE);
+
+	if (debugfs_log->str) {
+		memset(debugfs_log->str, 0, INIT_LOG_ALLOC_SIZE);
+		data->log_alloc_size = INIT_LOG_ALLOC_SIZE;
+	} else {
+		err = -ENOMEM;
+	}
+
+	spin_unlock(&data->log_lock);
+	return err;
+}
+
+/* free a log corresponding to a btrfs volume */
+static void debugfs_log_exit(struct debugfs_vol_data *data)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	spin_lock(&data->log_lock);
+	vfree(debugfs_log->str);
+	debugfs_log->str = NULL;
+	debugfs_log->len = 0;
+	spin_unlock(&data->log_lock);
+}
+
+/* fops to override for printing range data */
+static const struct file_operations btrfs_debugfs_range_fops = {
+	.read	= __btrfs_debugfs_range_read,
+	.open	= __btrfs_debugfs_open,
+};
+
+/* fops to override for printing inode data */
+static const struct file_operations btrfs_debugfs_inode_fops = {
+	.read	= __btrfs_debugfs_inode_read,
+	.open	= __btrfs_debugfs_open,
+};
+
+/* initialize debugfs for btrfs at module init */
+int btrfs_init_debugfs(void)
+{
+	debugfs_root_dentry = debugfs_create_dir(DEBUGFS_ROOT_NAME, NULL);
+	/*init list of debugfs data list */
+	INIT_LIST_HEAD(&debugfs_vol_data_list);
+	/*init lock to list of debugfs data list */
+	spin_lock_init(&data_list_lock);
+	if (!debugfs_root_dentry)
+		goto debugfs_error;
+	return 0;
+
+debugfs_error:
+	return -EIO;
+}
+
+/*
+ * on each volume mount, initialize the debugfs dentries and associated
+ * structures (debugfs_vol_data and debugfs_log)
+ */
+int btrfs_init_debugfs_volume(const char *uuid, struct super_block *sb)
+{
+	struct dentry *debugfs_volume_entry = NULL;
+	struct dentry *debugfs_range_entry = NULL;
+	struct dentry *debugfs_inode_entry = NULL;
+	struct debugfs_vol_data *range_data = NULL;
+	struct debugfs_vol_data *inode_data = NULL;
+	size_t dev_name_length = strlen(uuid);
+	char dev[NAME_MAX];
+
+	if (!debugfs_root_dentry)
+		goto debugfs_error;
+
+	/* create debugfs folder for this volume by mounted dev name */
+	memcpy(dev, uuid + DEV_NAME_CHOP, dev_name_length -
+		DEV_NAME_CHOP + 1);
+	debugfs_volume_entry = debugfs_create_dir(dev, debugfs_root_dentry);
+
+	if (!debugfs_volume_entry)
+		goto debugfs_error;
+
+	/* malloc and initialize debugfs_vol_data for range_data */
+	range_data = kmalloc(sizeof(struct debugfs_vol_data),
+		GFP_KERNEL | GFP_NOFS);
+	memset(range_data, 0, sizeof(struct debugfs_vol_data));
+	range_data->debugfs_log = NULL;
+	range_data->sb = sb;
+	spin_lock_init(&range_data->log_lock);
+	range_data->log_alloc_size = 0;
+
+	/* malloc and initialize debugfs_vol_data for range_data */
+	inode_data = kmalloc(sizeof(struct debugfs_vol_data),
+		GFP_KERNEL | GFP_NOFS);
+	memset(inode_data, 0, sizeof(struct debugfs_vol_data));
+	inode_data->debugfs_log = NULL;
+	inode_data->sb = sb;
+	spin_lock_init(&inode_data->log_lock);
+	inode_data->log_alloc_size = 0;
+
+	/*
+	 * add debugfs_vol_data for inode data and range data for
+	 * volume to list
+	 */
+	range_data->de = debugfs_volume_entry;
+	inode_data->de = debugfs_volume_entry;
+	spin_lock(&data_list_lock);
+	list_add(&range_data->node, &debugfs_vol_data_list);
+	list_add(&inode_data->node, &debugfs_vol_data_list);
+	spin_unlock(&data_list_lock);
+
+	/* create debugfs range_data file */
+	debugfs_range_entry = debugfs_create_file("range_data",
+			   S_IFREG | S_IRUSR | S_IWUSR |
+			   S_IRUGO,
+			   debugfs_volume_entry,
+			   (void *) range_data,
+			   &btrfs_debugfs_range_fops);
+	if (!debugfs_range_entry)
+		goto debugfs_error;
+
+	/* create debugfs inode_data file */
+	debugfs_inode_entry = debugfs_create_file("inode_data",
+			   S_IFREG | S_IRUSR | S_IWUSR |
+			   S_IRUGO,
+			   debugfs_volume_entry,
+			   (void *) inode_data,
+			   &btrfs_debugfs_inode_fops);
+
+	if (!debugfs_inode_entry)
+		goto debugfs_error;
+
+	return 0;
+
+debugfs_error:
+
+	kfree(range_data);
+	kfree(inode_data);
+
+	return -EIO;
+}
+
+/*
+ * find volume mounted (match by superblock) and remove
+ * debugfs dentry
+ */
+void btrfs_exit_debugfs_volume(struct super_block *sb)
+{
+	struct list_head *head;
+	struct list_head *pos;
+	struct debugfs_vol_data *data;
+	spin_lock(&data_list_lock);
+	head = &debugfs_vol_data_list;
+
+	/* must clean up memory assicatied with superblock */
+	list_for_each(pos, head)
+	{
+		data = list_entry(pos, struct debugfs_vol_data, node);
+		if (data->sb == sb) {
+			list_del(pos);
+			debugfs_remove_recursive(data->de);
+			kfree(data);
+			data = NULL;
+			break;
+		}
+	}
+
+	spin_unlock(&data_list_lock);
+}
+
+/* clean up memory and remove dentries for debugsfs */
+void btrfs_exit_debugfs(void)
+{
+	/* first iterate through debugfs_vol_data_list and free memory */
+	struct list_head *head;
+	struct list_head *pos;
+	struct list_head *cur;
+	struct debugfs_vol_data *data;
+
+	spin_lock(&data_list_lock);
+	head = &debugfs_vol_data_list;
+	list_for_each_safe(pos, cur, head) {
+		data = list_entry(pos, struct debugfs_vol_data, node);
+		if (data && pos != head)
+			kfree(data);
+	}
+	spin_unlock(&data_list_lock);
+
+	/* remove all debugfs entries recursively from the root */
+	debugfs_remove_recursive(debugfs_root_dentry);
+}
+
+/* debugfs open file override from fops table */
+static int __btrfs_debugfs_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __btrfs_debugfs_range_read(struct file *file, char __user *user,
+			     size_t count, loff_t *ppos)
+{
+	int err = 0;
+	struct super_block *sb;
+	struct btrfs_root *root;
+	struct btrfs_root *fs_root;
+	struct hot_inode_item *current_hot_inode;
+	struct debugfs_vol_data *data;
+	struct lstring *debugfs_log;
+	unsigned long inode_num;
+
+	data = (struct debugfs_vol_data *) file->private_data;
+	sb = data->sb;
+	root = btrfs_sb(sb);
+	fs_root = (struct btrfs_root *) root->fs_info->fs_root;
+
+	if (!data->debugfs_log) {
+		/* initialize debugfs log corresponding to this volume*/
+		debugfs_log = kmalloc(sizeof(struct lstring),
+			GFP_KERNEL | GFP_NOFS);
+		debugfs_log->str = NULL,
+		debugfs_log->len = 0;
+		data->debugfs_log = debugfs_log;
+		debugfs_log_init(data);
+	}
+
+	if ((unsigned long) *ppos > 0) {
+		/* caller is continuing a previous read, don't walk tree */
+		if ((unsigned long) *ppos >= data->debugfs_log->len)
+			goto clean_up;
+
+		goto print_to_user;
+	}
+
+	/* walk the inode tree */
+	current_hot_inode = find_next_hot_inode(fs_root, 0);
+
+	while (current_hot_inode) {
+		/* walk ranges, print data to debugfs log */
+		__walk_range_tree(current_hot_inode, data, fs_root);
+		inode_num = current_hot_inode->i_ino;
+		free_hot_inode_item(current_hot_inode);
+		current_hot_inode = find_next_hot_inode(fs_root, inode_num+1);
+	}
+
+print_to_user:
+	if (data->debugfs_log->len) {
+		err = simple_read_from_buffer(user, count, ppos,
+				      data->debugfs_log->str,
+				      data->debugfs_log->len);
+	}
+
+	return err;
+
+clean_up:
+	/* Reader has finished the file, clean up */
+
+	debugfs_log_exit(data);
+	kfree(data->debugfs_log);
+	data->debugfs_log = NULL;
+
+	return 0;
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __btrfs_debugfs_inode_read(struct file *file, char __user *user,
+			     size_t count, loff_t *ppos)
+{
+	int err = 0;
+	struct super_block *sb;
+	struct btrfs_root *root;
+	struct btrfs_root *fs_root;
+	struct hot_inode_item *current_hot_inode;
+	struct debugfs_vol_data *data;
+	struct lstring *debugfs_log;
+	unsigned long inode_num;
+
+	data = (struct debugfs_vol_data *) file->private_data;
+	sb = data->sb;
+	root = btrfs_sb(sb);
+	fs_root = (struct btrfs_root *) root->fs_info->fs_root;
+
+	if (!data->debugfs_log) {
+		/* initialize debugfs log corresponding to this volume */
+		debugfs_log = kmalloc(sizeof(struct lstring),
+			GFP_KERNEL | GFP_NOFS);
+		debugfs_log->str = NULL,
+		debugfs_log->len = 0;
+		data->debugfs_log = debugfs_log;
+		debugfs_log_init(data);
+	}
+
+	if ((unsigned long) *ppos > 0) {
+		/* caller is continuing a previous read, don't walk tree */
+		if ((unsigned long) *ppos >= data->debugfs_log->len)
+			goto clean_up;
+
+		goto print_to_user;
+	}
+
+	/* walk the inode tree */
+	current_hot_inode = find_next_hot_inode(fs_root, 0);
+
+	while (current_hot_inode) {
+		/* walk ranges, print data to debugfs log */
+		__print_inode_freq_data(current_hot_inode, data, fs_root);
+		inode_num = current_hot_inode->i_ino;
+		free_hot_inode_item(current_hot_inode);
+		current_hot_inode = find_next_hot_inode(fs_root, inode_num+1);
+	}
+
+print_to_user:
+	if (data->debugfs_log->len) {
+		err = simple_read_from_buffer(user, count, ppos,
+				      data->debugfs_log->str,
+				      data->debugfs_log->len);
+	}
+
+	return err;
+
+clean_up:
+	/* reader has finished the file, clean up */
+	debugfs_log_exit(data);
+	kfree(data->debugfs_log);
+	data->debugfs_log = NULL;
+
+	return 0;
+}
+
+/*
+ * take the inode, find ranges associated with inode
+ * and print each range data struct
+ */
+static void __walk_range_tree(struct hot_inode_item *hot_inode,
+		       struct debugfs_vol_data *data,
+		       struct btrfs_root *fs_root)
+{
+	struct hot_range_tree *inode_range_tree;
+	struct rb_node *node;
+	struct hot_range_item *current_range;
+
+	inode_range_tree = &hot_inode->hot_range_tree;
+	read_lock(&inode_range_tree->lock);
+	node = rb_first(&inode_range_tree->map);
+
+	/* Walk the hot_range_tree for inode */
+	while (node) {
+		current_range = rb_entry(node, struct hot_range_item, rb_node);
+		__print_range_freq_data(hot_inode, current_range, data,
+			fs_root);
+		node = rb_next(node);
+	}
+	read_unlock(&inode_range_tree->lock);
+}
+
+/* Print frequency data for each range to log */
+static void __print_range_freq_data(struct hot_inode_item *hot_inode,
+			     struct hot_range_item *hot_range,
+			     struct debugfs_vol_data *data,
+			     struct btrfs_root *fs_root)
+{
+	struct btrfs_freq_data *freq_data;
+	u64 start;
+	u64 len;
+	int on_rotating;
+
+	freq_data = &hot_range->freq_data;
+
+	spin_lock(&hot_range->lock);
+	start = hot_range->start;
+	len = hot_range->len;
+	spin_unlock(&hot_range->lock);
+
+	on_rotating = btrfs_range_on_rotating(fs_root, hot_inode, start,
+						  len);
+	/* Always lock hot_inode_item first */
+	spin_lock(&hot_inode->lock);
+	spin_lock(&hot_range->lock);
+	debugfs_log(data, "inode #%lu, range start "
+			"%llu (range len %llu) reads %u, writes %u, "
+			"avg read time %llu, avg write time %llu, temp %u, "
+			"on_rotating %d\n",
+			hot_inode->i_ino,
+			hot_range->start,
+			hot_range->len,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			freq_data->avg_delta_reads,
+			freq_data->avg_delta_writes,
+			freq_data->last_temp,
+			on_rotating);
+	spin_unlock(&hot_range->lock);
+	spin_unlock(&hot_inode->lock);
+}
+
+/* Print frequency data for each freq data to log */
+static void __print_inode_freq_data(struct hot_inode_item *hot_inode,
+			     struct debugfs_vol_data *data,
+			     struct btrfs_root *fs_root)
+{
+	struct btrfs_freq_data *freq_data = &hot_inode->freq_data;
+	int on_rotating = btrfs_range_on_rotating(fs_root, hot_inode, 0,
+						  (u64)-1);
+
+	spin_lock(&hot_inode->lock);
+	debugfs_log(data, "inode #%lu, reads %u, writes %u, "
+			  "avg read time %llu, avg write time %llu, temp %u, "
+			  "on_rotating %d\n",
+			hot_inode->i_ino,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			freq_data->avg_delta_reads,
+			freq_data->avg_delta_writes,
+			freq_data->last_temp,
+			on_rotating);
+	spin_unlock(&hot_inode->lock);
+}
diff --git a/fs/btrfs/debugfs.h b/fs/btrfs/debugfs.h
new file mode 100644
index 0000000..492ff8f
--- /dev/null
+++ b/fs/btrfs/debugfs.h
@@ -0,0 +1,89 @@
+/*
+ * fs/btrfs/debugfs.h
+ *
+ * Copyright (C) 2010 International Business Machines Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __BTRFS_DEBUGFS__
+#define __BTRFS_DEBUGFS__
+
+/* size of log to vmalloc */
+#define INIT_LOG_ALLOC_SIZE (PAGE_SIZE * 10)
+#define LOG_PAGE_SIZE (PAGE_SIZE * 10)
+
+/*
+ * number of chars of device name of chop off for making debugfs folder
+ * e.g. /dev/sda -> sda
+ *
+ * TODO: use something better for this
+ */
+#define DEV_NAME_CHOP 5
+
+/* list to keep track of each mounted volumes debugfs_vol_data */
+static struct list_head debugfs_vol_data_list;
+
+/* lock for debugfs_vol_data_list */
+static spinlock_t data_list_lock;
+
+/*
+ * Name for BTRFS data in debugfs directory
+ * e.g. /sys/kernel/debug/btrfs_data
+ */
+#define DEBUGFS_ROOT_NAME "btrfs_data"
+
+/* pointer to top level debugfs dentry */
+static struct dentry *debugfs_root_dentry;
+
+/* log to output to userspace in debugfs files */
+struct lstring {
+	char		*str;
+	unsigned long	len;
+};
+
+/* debugfs_vol_data is a struct of items that is passed to the debugfs */
+struct debugfs_vol_data {
+	struct list_head node; /* protected by data_list_lock */
+	struct lstring *debugfs_log;
+	struct super_block *sb;
+	struct dentry *de;
+	spinlock_t log_lock; /* protects debugfs_log */
+	char log_work_buff[1024];
+	uint log_alloc_size;
+};
+
+static ssize_t __btrfs_debugfs_range_read(struct file *file, char __user *user,
+	size_t size, loff_t *len);
+
+static ssize_t __btrfs_debugfs_inode_read(struct file *file, char __user *user,
+	size_t size, loff_t *len);
+
+static int __btrfs_debugfs_open(struct inode *inode, struct file *file);
+
+static void __walk_range_tree(struct hot_inode_item *hot_inode,
+			struct debugfs_vol_data *data,
+			struct btrfs_root *root);
+
+static void __print_range_freq_data(struct hot_inode_item *hot_inode,
+		       struct hot_range_item *hot_range,
+		       struct debugfs_vol_data *data,
+		       struct btrfs_root *root);
+
+static void __print_inode_freq_data(struct hot_inode_item *hot_inode,
+		       struct debugfs_vol_data *data,
+		       struct btrfs_root *root);
+
+#endif
-- 
1.7.1
