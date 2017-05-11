Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35841 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753875AbdEKVSG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 17:18:06 -0400
Received: by mail-it0-f45.google.com with SMTP id o5so603630ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 14:18:05 -0700 (PDT)
Date: Thu, 11 May 2017 21:18:03 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, quwenruo@cn.fujitsu.com
Subject: [PATCH v2 2/2] btrfs: Add quota_override knob into sysfs
Message-ID: <20170511211801.GA8422@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170511211658.GA8401@ircssh-2.c.rugged-nimbus-611.internal>

This patch adds the read-write attribute quota_override into sysfs.
Any process which has cap_sys_resource can set this flag to on, and
once it is set to true, processes with cap_sys_resource can exceed
the quota.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/sysfs.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 1f157fb..c2d5f35 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -447,11 +447,52 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 
 BTRFS_ATTR(clone_alignment, btrfs_clone_alignment_show);
 
+static ssize_t quota_override_show(struct kobject *kobj,
+				   struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	int quota_override;
+
+	quota_override = test_bit(BTRFS_FS_QUOTA_OVERRIDE, &fs_info->flags);
+	return snprintf(buf, PAGE_SIZE, "%d\n", quota_override);
+}
+
+static ssize_t quota_override_store(struct kobject *kobj,
+				    struct kobj_attribute *a,
+				    const char *buf, size_t len)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	unsigned long knob;
+	int err;
+
+	if (!fs_info)
+		return -EPERM;
+
+	if (!capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+
+	err = kstrtoul(buf, 10, &knob);
+	if (err)
+		return err;
+	if (knob > 1)
+		return -EINVAL;
+
+	if (knob)
+		set_bit(BTRFS_FS_QUOTA_OVERRIDE, &fs_info->flags);
+	else
+		clear_bit(BTRFS_FS_QUOTA_OVERRIDE, &fs_info->flags);
+
+	return len;
+}
+
+BTRFS_ATTR_RW(quota_override, quota_override_show, quota_override_store);
+
 static const struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(label),
 	BTRFS_ATTR_PTR(nodesize),
 	BTRFS_ATTR_PTR(sectorsize),
 	BTRFS_ATTR_PTR(clone_alignment),
+	BTRFS_ATTR_PTR(quota_override),
 	NULL,
 };
 
-- 
2.9.3

