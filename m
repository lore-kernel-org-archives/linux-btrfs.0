Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbaAPBZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 20:25:34 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1A1BAAC34
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 01:25:33 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: add simple debugfs interface
Date: Thu, 16 Jan 2014 02:25:29 +0100
Message-Id: <1389835529-23944-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Help during debugging to export various interesting infromation and
tunables without the need of extra mount options or ioctls.

Usage:
* declare your variable in sysfs.h, and include where you need it
* define the variable in sysfs.c and make it visible via
  debugfs_create_TYPE

Depends on CONFIG_DEBUG_FS.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ba94b277e98d..d0023196e996 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -24,6 +24,7 @@
 #include <linux/kobject.h>
 #include <linux/bug.h>
 #include <linux/genhd.h>
+#include <linux/debugfs.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -593,6 +594,12 @@ static int add_device_membership(struct btrfs_fs_info *fs_info)
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
+/* /sys/kernel/debug/btrfs */
+static struct dentry *btrfs_debugfs_root_dentry;
+
+/* Debugging tunables and exported data */
+u64 btrfs_debugfs_test;
+
 int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 {
 	int error;
@@ -636,6 +643,18 @@ failure:
 	return error;
 }
 
+static int btrfs_init_debugfs(void)
+{
+#ifdef CONFIG_DEBUG_FS
+	btrfs_debugfs_root_dentry = debugfs_create_dir("btrfs", NULL);
+	if (!btrfs_debugfs_root_dentry)
+		return -ENOMEM;
+
+	debugfs_create_u64("test", S_IRUGO | S_IWUGO, btrfs_debugfs_root_dentry,
+			&btrfs_debugfs_test);
+#endif
+}
+
 int btrfs_init_sysfs(void)
 {
 	int ret;
@@ -643,6 +662,7 @@ int btrfs_init_sysfs(void)
 	if (!btrfs_kset)
 		return -ENOMEM;
 
+	btrfs_init_debugfs();
 	init_feature_attrs();
 
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
@@ -658,5 +678,8 @@ void btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	kset_unregister(btrfs_kset);
+#ifdef CONFIG_DEBUG_FS
+	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
+#endif
 }
 
-- 
1.7.9

