Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34264 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041569AbdDUXNI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Apr 2017 19:13:08 -0400
Received: by mail-io0-f169.google.com with SMTP id a103so136376145ioj.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Apr 2017 16:13:08 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id 62sm4714094iou.10.2017.04.21.16.13.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Apr 2017 16:13:07 -0700 (PDT)
From: Sargun Dhillon <sargun@sargun.me>
Date: Fri, 21 Apr 2017 23:13:06 +0000
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: Add quota_override knob into sysfs
Message-ID: <20170421231304.GA3787@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170421231232.GA3769@ircssh-2.c.rugged-nimbus-611.internal>

This patch adds the read-write attribute quota_override into sysfs.
Any process which has cap_sys_resource can set this flag to on, and
once it is set to true, processes with cap_sys_resource can exceed
the quota.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/sysfs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 1f157fb..c62acca 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -447,11 +447,47 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 
 BTRFS_ATTR(clone_alignment, btrfs_clone_alignment_show);
 
+static ssize_t quota_override_show(struct kobject *kobj,
+				   struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", fs_info->quota_override);
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
+	fs_info->quota_override = !!knob;
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

