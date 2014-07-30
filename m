Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32066 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaG3Lum (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 07:50:42 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6UBofxR020277
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:41 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6UBoedb001391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:41 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6UBod9W024299
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: code optimize: BTRFS_ATTR could handle the mode
Date: Wed, 30 Jul 2014 20:04:08 +0800
Message-Id: <1406721850-3387-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1406721850-3387-1-git-send-email-anand.jain@oracle.com>
References: <1406721850-3387-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All that uses BTRFS_ATTR want mode to be set at 0444 so just do
it at the define.  And few spacing alignments.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 14 +++++++-------
 fs/btrfs/sysfs.h | 11 +++++++----
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 404ad66..0524684 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -242,7 +242,7 @@ static ssize_t global_rsv_size_show(struct kobject *kobj,
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	return btrfs_show_u64(&block_rsv->size, &block_rsv->lock, buf);
 }
-BTRFS_ATTR(global_rsv_size, 0444, global_rsv_size_show);
+BTRFS_ATTR(global_rsv_size, global_rsv_size_show);
 
 static ssize_t global_rsv_reserved_show(struct kobject *kobj,
 					struct kobj_attribute *a, char *buf)
@@ -251,7 +251,7 @@ static ssize_t global_rsv_reserved_show(struct kobject *kobj,
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	return btrfs_show_u64(&block_rsv->reserved, &block_rsv->lock, buf);
 }
-BTRFS_ATTR(global_rsv_reserved, 0444, global_rsv_reserved_show);
+BTRFS_ATTR(global_rsv_reserved, global_rsv_reserved_show);
 
 #define to_space_info(_kobj) container_of(_kobj, struct btrfs_space_info, kobj)
 #define to_raid_kobj(_kobj) container_of(_kobj, struct raid_kobject, kobj)
@@ -306,7 +306,7 @@ static ssize_t btrfs_space_info_show_##field(struct kobject *kobj,	\
 	struct btrfs_space_info *sinfo = to_space_info(kobj);		\
 	return btrfs_show_u64(&sinfo->field, &sinfo->lock, buf);	\
 }									\
-BTRFS_ATTR(field, 0444, btrfs_space_info_show_##field)
+BTRFS_ATTR(field, btrfs_space_info_show_##field)
 
 static ssize_t btrfs_space_info_show_total_bytes_pinned(struct kobject *kobj,
 						       struct kobj_attribute *a,
@@ -325,7 +325,7 @@ SPACE_INFO_ATTR(bytes_reserved);
 SPACE_INFO_ATTR(bytes_may_use);
 SPACE_INFO_ATTR(disk_used);
 SPACE_INFO_ATTR(disk_total);
-BTRFS_ATTR(total_bytes_pinned, 0444, btrfs_space_info_show_total_bytes_pinned);
+BTRFS_ATTR(total_bytes_pinned, btrfs_space_info_show_total_bytes_pinned);
 
 static struct attribute *space_info_attrs[] = {
 	BTRFS_ATTR_PTR(flags),
@@ -411,7 +411,7 @@ static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);
 }
 
-BTRFS_ATTR(nodesize, 0444, btrfs_nodesize_show);
+BTRFS_ATTR(nodesize, btrfs_nodesize_show);
 
 static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
@@ -421,7 +421,7 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->sectorsize);
 }
 
-BTRFS_ATTR(sectorsize, 0444, btrfs_sectorsize_show);
+BTRFS_ATTR(sectorsize, btrfs_sectorsize_show);
 
 static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
@@ -431,7 +431,7 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->sectorsize);
 }
 
-BTRFS_ATTR(clone_alignment, 0444, btrfs_clone_alignment_show);
+BTRFS_ATTR(clone_alignment, btrfs_clone_alignment_show);
 
 static struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(label),
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index ac46df3..531b11e 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -21,15 +21,18 @@ enum btrfs_feature_set {
 }
 
 #define BTRFS_ATTR_RW(_name, _mode, _show, _store)			\
-static struct kobj_attribute btrfs_attr_##_name =			\
+	static struct kobj_attribute btrfs_attr_##_name =		\
 			__INIT_KOBJ_ATTR(_name, _mode, _show, _store)
-#define BTRFS_ATTR(_name, _mode, _show)					\
-	BTRFS_ATTR_RW(_name, _mode, _show, NULL)
+
+#define BTRFS_ATTR(_name, _show)					\
+			BTRFS_ATTR_RW(_name, 0444, _show, NULL)
+
 #define BTRFS_ATTR_PTR(_name)    (&btrfs_attr_##_name.attr)
 
 #define BTRFS_RAID_ATTR(_name, _show)					\
-static struct kobj_attribute btrfs_raid_attr_##_name =			\
+	static struct kobj_attribute btrfs_raid_attr_##_name =		\
 			__INIT_KOBJ_ATTR(_name, 0444, _show, NULL)
+
 #define BTRFS_RAID_ATTR_PTR(_name)    (&btrfs_raid_attr_##_name.attr)
 
 
-- 
2.0.0.153.g79dcccc

