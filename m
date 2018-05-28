Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:40700 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbeE1CS1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:27 -0400
Received: by mail-io0-f195.google.com with SMTP id g14-v6so12484186ioc.7
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:26 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH v2 5/6] btrfs: add send_stream_version attribute to sysfs
Date: Sun, 27 May 2018 22:14:34 -0400
Message-Id: <20180528021443.13923-6-linux@hmclauchlan.com>
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
References: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe David Borba Manana <fdmanana@gmail.com>

So that applications can find out what's the highest send stream
version supported/implemented by the running kernel:

    $ cat /sys/fs/btrfs/send/stream_version
    2

[Howard: rebased on 4.17-rc7]
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/send.h  |  1 +
 fs/btrfs/sysfs.c | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index b6e9281f171a..267674d3e954 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -12,6 +12,7 @@
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
 #define BTRFS_SEND_STREAM_VERSION_1 1
 #define BTRFS_SEND_STREAM_VERSION_2 2
+#define BTRFS_SEND_STREAM_VERSION_LATEST BTRFS_SEND_STREAM_VERSION_2
 
 #define BTRFS_SEND_BUF_SIZE SZ_64K
 #define BTRFS_SEND_READ_SIZE (48 * SZ_1K)
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4848a4318fb5..718bc927ea13 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -18,6 +18,7 @@
 #include "transaction.h"
 #include "sysfs.h"
 #include "volumes.h"
+#include "send.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
 static inline struct btrfs_fs_devices *to_fs_devs(struct kobject *kobj);
@@ -884,6 +885,26 @@ static int btrfs_init_debugfs(void)
 	return 0;
 }
 
+static ssize_t send_stream_version_show(struct kobject *kobj,
+					struct kobj_attribute *a,
+					char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			BTRFS_SEND_STREAM_VERSION_LATEST);
+}
+
+BTRFS_ATTR(, stream_version, send_stream_version_show);
+
+static struct attribute *btrfs_send_attrs[] = {
+	BTRFS_ATTR_PTR(, stream_version),
+	NULL
+};
+
+static const struct attribute_group btrfs_send_attr_group = {
+	.name = "send",
+	.attrs = btrfs_send_attrs,
+};
+
 int __init btrfs_init_sysfs(void)
 {
 	int ret;
@@ -900,8 +921,13 @@ int __init btrfs_init_sysfs(void)
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	if (ret)
 		goto out2;
+	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_send_attr_group);
+	if (ret)
+		goto out3;
 
 	return 0;
+out3:
+	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 out2:
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 out1:
@@ -913,6 +939,7 @@ int __init btrfs_init_sysfs(void)
 void __cold btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
+	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_send_attr_group);
 	kset_unregister(btrfs_kset);
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
-- 
2.17.0

