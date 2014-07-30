Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32067 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaG3Lum (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 07:50:42 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6UBoexV020258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:41 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6UBoe1J024302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:40 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s6UBocA1020101
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: use BTRFS_ATTR instead of btrfs_no_store()
Date: Wed, 30 Jul 2014 20:04:07 +0800
Message-Id: <1406721850-3387-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

we have BTRFS_ATTR define to create sysfs RO file, use that.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d9c3ec6..404ad66 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -403,13 +403,6 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 }
 BTRFS_ATTR_RW(label, 0644, btrfs_label_show, btrfs_label_store);
 
-static ssize_t btrfs_no_store(struct kobject *kobj,
-				 struct kobj_attribute *a,
-				 const char *buf, size_t len)
-{
-	return -EPERM;
-}
-
 static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
 {
@@ -418,7 +411,7 @@ static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->nodesize);
 }
 
-BTRFS_ATTR_RW(nodesize, 0444, btrfs_nodesize_show, btrfs_no_store);
+BTRFS_ATTR(nodesize, 0444, btrfs_nodesize_show);
 
 static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
@@ -428,7 +421,7 @@ static ssize_t btrfs_sectorsize_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->sectorsize);
 }
 
-BTRFS_ATTR_RW(sectorsize, 0444, btrfs_sectorsize_show, btrfs_no_store);
+BTRFS_ATTR(sectorsize, 0444, btrfs_sectorsize_show);
 
 static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
@@ -438,7 +431,7 @@ static ssize_t btrfs_clone_alignment_show(struct kobject *kobj,
 	return snprintf(buf, PAGE_SIZE, "%u\n", fs_info->super_copy->sectorsize);
 }
 
-BTRFS_ATTR_RW(clone_alignment, 0444, btrfs_clone_alignment_show, btrfs_no_store);
+BTRFS_ATTR(clone_alignment, 0444, btrfs_clone_alignment_show);
 
 static struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(label),
-- 
2.0.0.153.g79dcccc

