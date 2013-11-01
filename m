Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390Ab3KARYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Nov 2013 13:24:30 -0400
Message-Id: <20131101172241.698993094@suse.com>
Date: Fri, 01 Nov 2013 13:07:06 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 12/13] btrfs: publish fs label in sysfs
References: <20131101170654.164867629@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a writeable attribute which describes the label.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/sysfs.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/fs/btrfs/sysfs.c	2013-10-21 16:20:06.395804741 -0400
+++ b/fs/btrfs/sysfs.c	2013-10-21 16:23:57.402255196 -0400
@@ -355,6 +355,49 @@ static const struct attribute *allocatio
 	NULL,
 };
 
+static ssize_t btrfs_label_show(struct kobject *kobj,
+				struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	return snprintf(buf, PAGE_SIZE, "%s\n", fs_info->super_copy->label);
+}
+
+static ssize_t btrfs_label_store(struct kobject *kobj,
+				 struct kobj_attribute *a,
+				 const char *buf, size_t len)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = fs_info->fs_root;
+	int ret;
+
+	if (len >= BTRFS_LABEL_SIZE) {
+		pr_err("btrfs: unable to set label with more than %d bytes\n",
+		       BTRFS_LABEL_SIZE - 1);
+		return -EINVAL;
+	}
+
+	trans = btrfs_start_transaction(root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	spin_lock(&root->fs_info->super_lock);
+	strcpy(fs_info->super_copy->label, buf);
+	spin_unlock(&root->fs_info->super_lock);
+	ret = btrfs_commit_transaction(trans, root);
+
+	if (!ret)
+		return len;
+
+	return ret;
+}
+BTRFS_ATTR_RW(label, 0644, btrfs_label_show, btrfs_label_store);
+
+static struct attribute *btrfs_attrs[] = {
+	BTRFS_ATTR_PTR(label),
+	NULL,
+};
+
 static void btrfs_release_super_kobj(struct kobject *kobj)
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
@@ -364,6 +407,7 @@ static void btrfs_release_super_kobj(str
 static struct kobj_type btrfs_ktype = {
 	.sysfs_ops	= &kobj_sysfs_ops,
 	.release	= btrfs_release_super_kobj,
+	.default_attrs	= btrfs_attrs,
 };
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj)



