Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750961AbdFOQus (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:50:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 997C7AB9D
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 16:50:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/5] btrfs: sysfs: export the force_dev_flush flag
Date: Thu, 15 Jun 2017 18:49:32 +0200
Message-Id: <6957a4896cc64a1ff44b712bb6723ada016d76b9.1497544265.git.dsterba@suse.com>
In-Reply-To: <cover.1497544265.git.dsterba@suse.com>
References: <cover.1497544265.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add per-filesystem tunable to switch on/off the device barriers,
regardless of the actual device support. This is a debugging feature.

The path to the sysfs file is /sys/fs/btrfs/UUID/force_dev_flush,
allowed values are 0 and 1. Default is 0.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c2d5f3580b4c..197d43911936 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -487,12 +487,59 @@ static ssize_t quota_override_store(struct kobject *kobj,
 
 BTRFS_ATTR_RW(quota_override, quota_override_show, quota_override_store);
 
+static ssize_t force_dev_flush_show(struct kobject *kobj,
+				   struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	int force;
+
+	if (!fs_info)
+		return -EPERM;
+
+	force = !!(test_bit(BTRFS_FS_FORCE_DEV_FLUSH, &fs_info->flags));
+	return snprintf(buf, PAGE_SIZE, "%d\n", force);
+}
+
+static ssize_t force_dev_flush_store(struct kobject *kobj,
+				    struct kobj_attribute *a,
+				    const char *buf, size_t len)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	unsigned long force;
+	int err;
+
+	if (!fs_info)
+		return -EPERM;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	err = kstrtoul(buf, 10, &force);
+	if (err)
+		return err;
+	if (force > 1)
+		return -EINVAL;
+
+	if (force) {
+		set_bit(BTRFS_FS_FORCE_DEV_FLUSH, &fs_info->flags);
+		btrfs_info(fs_info, "Forced device flushes enabled");
+	} else {
+		clear_bit(BTRFS_FS_FORCE_DEV_FLUSH, &fs_info->flags);
+		btrfs_info(fs_info, "Forced device flushes disabled");
+	}
+
+	return len;
+}
+
+BTRFS_ATTR_RW(force_dev_flush, force_dev_flush_show, force_dev_flush_store);
+
 static const struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(label),
 	BTRFS_ATTR_PTR(nodesize),
 	BTRFS_ATTR_PTR(sectorsize),
 	BTRFS_ATTR_PTR(clone_alignment),
 	BTRFS_ATTR_PTR(quota_override),
+	BTRFS_ATTR_PTR(force_dev_flush),
 	NULL,
 };
 
-- 
2.13.0

