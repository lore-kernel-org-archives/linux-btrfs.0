Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43024 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbaDTNHg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 09:07:36 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so1879662wgg.6
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 06:07:35 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 6/6] Btrfs: add send_stream_version attribute to sysfs
Date: Sun, 20 Apr 2014 15:07:27 +0100
Message-Id: <1398002847-11144-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397659726-30615-6-git-send-email-fdmanana@gmail.com>
References: <1397659726-30615-6-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that applications can find out what's the highest send stream
version supported/implemented by the running kernel:

    $ cat /sys/fs/btrfs/send_stream_version
    2

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.h  |  1 +
 fs/btrfs/sysfs.c | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 987936c..047fd6d 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -22,6 +22,7 @@
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
 #define BTRFS_SEND_STREAM_VERSION_1 1
 #define BTRFS_SEND_STREAM_VERSION_2 2
+#define BTRFS_SEND_STREAM_VERSION_LATEST BTRFS_SEND_STREAM_VERSION_2
 
 #define BTRFS_SEND_BUF_SIZE (1024 * 64)
 #define BTRFS_SEND_READ_SIZE (1024 * 48)
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 58a1dd1..2f8fff6 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -31,6 +31,7 @@
 #include "transaction.h"
 #include "sysfs.h"
 #include "volumes.h"
+#include "send.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
 
@@ -662,6 +663,36 @@ static int btrfs_init_debugfs(void)
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
+BTRFS_ATTR(send_stream_version, 0444, send_stream_version_show);
+
+static const struct attribute *btrfs_root_attrs[] = {
+	BTRFS_ATTR_PTR(send_stream_version),
+	NULL
+};
+
+static int add_root_attrs(struct kobject *kobj)
+{
+	int error = 0;
+	int i;
+
+	for (i = 0; btrfs_root_attrs[i]; i++) {
+		const struct attribute *a = btrfs_root_attrs[i];
+
+		error = sysfs_add_file_to_group(kobj->parent, a, kobj->name);
+		if (error)
+			break;
+	}
+	return error;
+}
+
 int btrfs_init_sysfs(void)
 {
 	int ret;
@@ -678,8 +709,13 @@ int btrfs_init_sysfs(void)
 	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 	if (ret)
 		goto out2;
+	ret = add_root_attrs(&btrfs_kset->kobj);
+	if (ret)
+		goto out3;
 
 	return 0;
+out3:
+	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
 out2:
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 out1:
-- 
1.9.1

