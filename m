Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:19085 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbeEPIGy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 04:06:54 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 21E54AC0095
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 17:06:48 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 47C913287DE
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 17:06:47 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/2] btrfs: sysfs: Add entry which shows rmdir(2) can work for subvolume
Date: Wed, 16 May 2018 17:09:27 +0900
Message-ID: <2eb3880232f74bb884a269264058e6d5f5337ffc.1526457206.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Deletion of a subvolume by rmdir(2) has become allowed by the
'commit cd2decf640b1 ("btrfs: Allow rmdir(2) to delete an empty
subvolume")'.

It is a kind of new feature and this commits add a sysfs entry
  /sys/fs/btrfs/static_features/rmdir_subvol
to indicate the availability of feature so that a user program
(e.g. xfstests) can detect it.

Note that new sysfs directory "static_features" is created since a entry
in /sys/fs/btrfs/features depends on feature bits of superblock (in other
words, they may be different between each fs) and is not suitable to hold
the features which only depend on kernel version. New attribute_group
"btrfs_static_feature_attr_group" is created for this purpose.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/sysfs.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 217d401fe8ae..35b3ac567899 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -210,12 +210,32 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	NULL
 };
 
+/* Features which depend on feature bits and may differ between each fs */
 static const struct attribute_group btrfs_feature_attr_group = {
 	.name = "features",
 	.is_visible = btrfs_feature_visible,
 	.attrs = btrfs_supported_feature_attrs,
 };
 
+static ssize_t rmdir_subvol_show(struct kobject *kobj,
+				 struct kobj_attribute *ka, char *buf)
+{
+	/* No meaning for the value */
+	return snprintf(buf, PAGE_SIZE, "0\n");
+}
+BTRFS_ATTR(static_feature, rmdir_subvol, rmdir_subvol_show);
+
+static struct attribute *btrfs_supported_static_feature_attrs[] = {
+	BTRFS_ATTR_PTR(static_feature, rmdir_subvol),
+	NULL
+};
+
+/* Features which only depend on kernel version */
+static const struct attribute_group btrfs_static_feature_attr_group = {
+	.name = "static_features",
+	.attrs = btrfs_supported_static_feature_attrs,
+};
+
 static ssize_t btrfs_show_u64(u64 *value_ptr, spinlock_t *lock, char *buf)
 {
 	u64 val;
@@ -901,8 +921,15 @@ int __init btrfs_init_sysfs(void)
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	if (ret)
 		goto out2;
+	ret = sysfs_create_group(&btrfs_kset->kobj,
+				 &btrfs_static_feature_attr_group);
+	if (ret)
+		goto out3;
 
 	return 0;
+
+out3:
+	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 out2:
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 out1:
@@ -914,6 +941,8 @@ int __init btrfs_init_sysfs(void)
 void __cold btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
+	sysfs_remove_group(&btrfs_kset->kobj,
+			   &btrfs_static_feature_attr_group);
 	kset_unregister(btrfs_kset);
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
-- 
2.14.3


