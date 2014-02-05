Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaBEOgV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Feb 2014 09:36:21 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 72B58AAD1
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Feb 2014 14:36:20 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v4] btrfs: add simple debugfs interface
Date: Wed,  5 Feb 2014 15:36:18 +0100
Message-Id: <1391610978-29232-1-git-send-email-dsterba@suse.cz>
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
v4:
- the intel build test reported that the example variable is not declared and
should be static, acutally it should declared as the changelog suggests, fix
the code to match that and declare it in sysfs.h

v3:
- fix typo in changelog

v2:
- added missing return to btrfs_init_debugfs
- updated error handling to btrfs_init_sysfs, the cleanup
  is done in btrfs_exit_sysfs
- removed #ifdef in btrfs_exit_sysfs,

 fs/btrfs/sysfs.c |   33 +++++++++++++++++++++++++++------
 fs/btrfs/sysfs.h |    5 +++++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 782374d8fd19..b725e4574448 100644
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
@@ -636,27 +643,41 @@ failure:
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
+	return 0;
+}
+
 int btrfs_init_sysfs(void)
 {
 	int ret;
+
 	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
 	if (!btrfs_kset)
 		return -ENOMEM;
 
-	init_feature_attrs();
+	ret = btrfs_init_debugfs();
+	if (ret)
+		return ret;
 
+	init_feature_attrs();
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
-	if (ret) {
-		kset_unregister(btrfs_kset);
-		return ret;
-	}
 
-	return 0;
+	return ret;
 }
 
 void btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	kset_unregister(btrfs_kset);
+	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index f3cea3710d44..9ab576318a84 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -1,6 +1,11 @@
 #ifndef _BTRFS_SYSFS_H_
 #define _BTRFS_SYSFS_H_
 
+/*
+ * Data exported through sysfs
+ */
+extern u64 btrfs_debugfs_test;
+
 enum btrfs_feature_set {
 	FEAT_COMPAT,
 	FEAT_COMPAT_RO,
-- 
1.7.9

