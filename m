Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27164 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbBAIDK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:03:10 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 09/12] Btrfs: sysfs: let default_attrs be separate from the kset
Date: Sun,  1 Feb 2015 16:01:39 +0800
Message-Id: <1422777702-12584-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
 <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now btrfs_attrs are provided using the default_attrs through
the kset. Separate them and create the default_attrs using the
sysfs_create_files instead. By doing this we will have the
flexibility that device discovery thread could create fsid
kobject.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index f42d8fd..5208a49 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -428,7 +428,7 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 
 BTRFS_ATTR(clone_alignment, btrfs_clone_alignment_show);
 
-static struct attribute *btrfs_attrs[] = {
+static const struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(label),
 	BTRFS_ATTR_PTR(nodesize),
 	BTRFS_ATTR_PTR(sectorsize),
@@ -447,7 +447,6 @@ static void btrfs_release_super_kobj(struct kobject *kobj)
 static struct kobj_type btrfs_ktype = {
 	.sysfs_ops	= &kobj_sysfs_ops,
 	.release	= btrfs_release_super_kobj,
-	.default_attrs	= btrfs_attrs,
 };
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj)
@@ -531,6 +530,7 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	}
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
+	sysfs_remove_files(&fs_info->super_kobj, btrfs_attrs);
 	btrfs_sysfs_remove_fsid(fs_info);
 }
 
@@ -720,13 +720,17 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 		return error;
 	}
 
-	error = sysfs_create_group(&fs_info->super_kobj,
-				   &btrfs_feature_attr_group);
+	error = sysfs_create_files(&fs_info->super_kobj, btrfs_attrs);
 	if (error) {
 		btrfs_sysfs_remove_fsid(fs_info);
 		return error;
 	}
 
+	error = sysfs_create_group(&fs_info->super_kobj,
+				   &btrfs_feature_attr_group);
+	if (error)
+		goto failure;
+
 	error = addrm_unknown_feature_attrs(fs_info, true);
 	if (error)
 		goto failure;
-- 
1.9.1

