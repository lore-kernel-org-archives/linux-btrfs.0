Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:27685 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbeEQF1Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 01:27:16 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id F0B83AC0219
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2018 14:27:08 +0900 (JST)
Subject: [PATCH v3 2/2] btrfs: sysfs: Add entry which shows rmdir(2) can work
 for subvolume
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
 <2eb3880232f74bb884a269264058e6d5f5337ffc.1526457206.git.misono.tomohiro@jp.fujitsu.com>
 <20180516151914.GD6649@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <20e797cb-2f49-3248-768e-57afe175bad4@jp.fujitsu.com>
Date: Thu, 17 May 2018 14:24:51 +0900
MIME-Version: 1.0
In-Reply-To: <20180516151914.GD6649@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Deletion of a subvolume by rmdir(2) has become allowed by the
'commit cd2decf640b1 ("btrfs: Allow rmdir(2) to delete an empty
subvolume")'.

It is a kind of new feature and this commits add a sysfs entry
  /sys/fs/btrfs/features/rmdir_subvol
to indicate the availability of the feature so that a user program
(e.g. xfstests) can detect it.

Prior to this commit, all entry in /sys/fs/btrfs/features is a feature
which depends on feature bits of superblock (i.e. each feature affects
on-disk format) and managed by attribute_group "btrfs_feature_attr_group".
For each fs, entries in /sys/fs/btrfs/UUID/features indicate which
features are enabled (or can be changed online) for the fs.

However, rmdir_subvol feature only depends on kernel modules. Therefore
new attribute_group "btrfs_static_feature_attr_group" is introduced and
sysfs_merge_group() is used to share /sys/fs/btrfs/features directory.
Features in "btrfs_static_feature_attr_group" won't be listed in each
/sys/fs/btrfs/UUID/features.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
Hi David,

Sorry for the misunderstanding.
How about this version which uses /sys/fs/btrfs/features
while using different attribute_group for static features.

Thanks,

 fs/btrfs/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 217d401fe8ae..ae6003b34c76 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -210,12 +210,40 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	NULL
 };
 
+/*
+ * Features which depend on feature bits and may differ between each fs.
+ * /sys/fs/btrfs/features lists all capable features of this kernel
+ * while /sys/fs/btrfs/UUID/features shows features of the fs which are
+ * enabled or can be changed online
+ */
 static const struct attribute_group btrfs_feature_attr_group = {
 	.name = "features",
 	.is_visible = btrfs_feature_visible,
 	.attrs = btrfs_supported_feature_attrs,
 };
 
+static ssize_t rmdir_subvol_show(struct kobject *kobj,
+				 struct kobj_attribute *ka, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0\n");
+}
+BTRFS_ATTR(static_feature, rmdir_subvol, rmdir_subvol_show);
+
+static struct attribute *btrfs_supported_static_feature_attrs[] = {
+	BTRFS_ATTR_PTR(static_feature, rmdir_subvol),
+	NULL
+};
+
+/*
+ * Features which only depend on a kernel version.
+ * These are listed in /sys/fs/btrfs/features along with
+ * btrfs_feature_attr_group
+ */
+static const struct attribute_group btrfs_static_feature_attr_group = {
+	.name = "features",
+	.attrs = btrfs_supported_static_feature_attrs,
+};
+
 static ssize_t btrfs_show_u64(u64 *value_ptr, spinlock_t *lock, char *buf)
 {
 	u64 val;
@@ -901,8 +929,15 @@ int __init btrfs_init_sysfs(void)
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	if (ret)
 		goto out2;
+	ret = sysfs_merge_group(&btrfs_kset->kobj,
+				&btrfs_static_feature_attr_group);
+	if (ret)
+		goto out3;
 
 	return 0;
+
+out3:
+	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 out2:
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 out1:
@@ -913,6 +948,8 @@ int __init btrfs_init_sysfs(void)
 
 void __cold btrfs_exit_sysfs(void)
 {
+	sysfs_unmerge_group(&btrfs_kset->kobj,
+			    &btrfs_static_feature_attr_group);
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	kset_unregister(btrfs_kset);
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
-- 
2.14.3

