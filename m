Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935127AbcHaPNx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 11:13:53 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 29FECC05678F
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 15:13:50 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u7VFDnPK014555
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 11:13:49 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] btrfs: remove pointless debugfs interface
Message-ID: <d6715b5b-0aa3-3032-43c6-eccd907a60b8@redhat.com>
Date: Wed, 31 Aug 2016 10:13:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A /sys/kernel/debug/btrfs/test file was added nearly
two and a half years ago, but it serves no purpose;
it stores and returns a value, but nothing in the btrfs
code uses this value in any way.  There are no other btrfs
files in this debugfs dir.

This was brought to my attention because it is world-writable;
it is the only such file under /sys/kernel/debug, and without
knowledge of its purpose, some users were alarmed by this.

Another option would be to change the perms, but given that
there is no point to it as far as I can tell, it seems best
to simply remove it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4879656..8c3ffb9 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -24,7 +24,6 @@
 #include <linux/kobject.h>
 #include <linux/bug.h>
 #include <linux/genhd.h>
-#include <linux/debugfs.h>
 
 #include "ctree.h"
 #include "disk-io.h"
@@ -728,12 +727,6 @@ int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
-/* /sys/kernel/debug/btrfs */
-static struct dentry *btrfs_debugfs_root_dentry;
-
-/* Debugging tunables and exported data */
-u64 btrfs_debugfs_test;
-
 /*
  * Can be called by the device discovery thread.
  * And parent can be specified for seed device
@@ -827,19 +820,6 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
 }
 
-static int btrfs_init_debugfs(void)
-{
-#ifdef CONFIG_DEBUG_FS
-	btrfs_debugfs_root_dentry = debugfs_create_dir("btrfs", NULL);
-	if (!btrfs_debugfs_root_dentry)
-		return -ENOMEM;
-
-	debugfs_create_u64("test", S_IRUGO | S_IWUGO, btrfs_debugfs_root_dentry,
-			&btrfs_debugfs_test);
-#endif
-	return 0;
-}
-
 int btrfs_init_sysfs(void)
 {
 	int ret;
@@ -848,28 +828,19 @@ int btrfs_init_sysfs(void)
 	if (!btrfs_kset)
 		return -ENOMEM;
 
-	ret = btrfs_init_debugfs();
-	if (ret)
-		goto out1;
-
 	init_feature_attrs();
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
-	if (ret)
-		goto out2;
+	if (ret) {
+		kset_unregister(btrfs_kset);
+		return ret;
+	}
 
 	return 0;
-out2:
-	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
-out1:
-	kset_unregister(btrfs_kset);
-
-	return ret;
 }
 
 void btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	kset_unregister(btrfs_kset);
-	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
 
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index d7da1a4..45bad52 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -1,11 +1,6 @@
 #ifndef _BTRFS_SYSFS_H_
 #define _BTRFS_SYSFS_H_
 
-/*
- * Data exported through sysfs
- */
-extern u64 btrfs_debugfs_test;
-
 enum btrfs_feature_set {
 	FEAT_COMPAT,
 	FEAT_COMPAT_RO,

