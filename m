Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61295 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaFWLBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 07:01:42 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so4015562wib.12
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 04:01:41 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 6/6 v5] Btrfs: add send_stream_version attribute to sysfs
Date: Mon, 23 Jun 2014 13:01:22 +0100
Message-Id: <1403524882-2173-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1398002847-11144-1-git-send-email-fdmanana@gmail.com>
References: <1398002847-11144-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So that applications can find out what's the highest send stream
version supported/implemented by the running kernel:

    $ cat /sys/fs/btrfs/send/stream_version
    2

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---

V1..V4: There's no v1, v2, v3 and v4. Bumped directly to v5 to make all patches
    in the series have the same version.
V5: Rebased against latest chris/integration branch.

 fs/btrfs/send.h  |  1 +
 fs/btrfs/sysfs.c | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

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
index 06ad529..9869d94 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -31,6 +31,7 @@
 #include "transaction.h"
 #include "sysfs.h"
 #include "volumes.h"
+#include "send.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
 
@@ -700,6 +701,26 @@ static int btrfs_init_debugfs(void)
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
+BTRFS_ATTR(stream_version, 0444, send_stream_version_show);
+
+static struct attribute *btrfs_send_attrs[] = {
+	BTRFS_ATTR_PTR(stream_version),
+	NULL
+};
+
+static const struct attribute_group btrfs_send_attr_group = {
+	.name = "send",
+	.attrs = btrfs_send_attrs,
+};
+
 int btrfs_init_sysfs(void)
 {
 	int ret;
@@ -716,8 +737,13 @@ int btrfs_init_sysfs(void)
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
@@ -729,6 +755,7 @@ out1:
 void btrfs_exit_sysfs(void)
 {
 	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
+	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_send_attr_group);
 	kset_unregister(btrfs_kset);
 	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
 }
-- 
1.9.1

