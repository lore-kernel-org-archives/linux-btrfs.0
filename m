Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755779AbaEGQRS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 12:17:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E069EAC46
	for <linux-btrfs@vger.kernel.org>; Wed,  7 May 2014 16:17:17 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: export more from FS_INFO to sysfs
Date: Wed,  7 May 2014 18:17:16 +0200
Message-Id: <1399479436-17769-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Similar to the FS_INFO updates, export the basic filesystem info through
sysfs: node size, sector size and clone alignment.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/sysfs.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c5eb2143dc66..ba2a645dee07 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -396,8 +396,48 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 }
 BTRFS_ATTR_RW(label, 0644, btrfs_label_show, btrfs_label_store);
 
+static ssize_t btrfs_no_store(struct kobject *kobj,
+				 struct kobj_attribute *a,
+				 const char *buf, size_t len)
+{
+	return -EPERM;
+}
+
+static ssize_t btrfs_nodesize_show(struct kobject *kobj,
+				struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);
+}
+
+BTRFS_ATTR_RW(nodesize, 0444, btrfs_nodesize_show, btrfs_no_store);
+
+static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
+				struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->sectorsize);
+}
+
+BTRFS_ATTR_RW(sectorsize, 0444, btrfs_sectorsize_show, btrfs_no_store);
+
+static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
+				struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->sectorsize);
+}
+
+BTRFS_ATTR_RW(clone_alignment, 0444, btrfs_clone_alignment_show, btrfs_no_store);
+
 static struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(label),
+	BTRFS_ATTR_PTR(nodesize),
+	BTRFS_ATTR_PTR(sectorsize),
+	BTRFS_ATTR_PTR(clone_alignment),
 	NULL,
 };
 
-- 
1.7.9

