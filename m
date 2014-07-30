Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36557 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaG3Luo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 07:50:44 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6UBohrG005821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:44 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6UBogMG001434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:42 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s6UBof7I020173
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 11:50:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] btrfs: code optimize: BTRFS_ATTR_RW could set the mode
Date: Wed, 30 Jul 2014 20:04:09 +0800
Message-Id: <1406721850-3387-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1406721850-3387-1-git-send-email-anand.jain@oracle.com>
References: <1406721850-3387-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_ATTR_RW could set the mode and be inline with BTRFS_ATTR

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 2 +-
 fs/btrfs/sysfs.h | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 0524684..266e201 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -401,7 +401,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 
 	return ret;
 }
-BTRFS_ATTR_RW(label, 0644, btrfs_label_show, btrfs_label_store);
+BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
 
 static ssize_t btrfs_nodesize_show(struct kobject *kobj,
 				struct kobj_attribute *a, char *buf)
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 531b11e..f7dd298 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -20,12 +20,13 @@ enum btrfs_feature_set {
 	.store	= _store,						\
 }
 
-#define BTRFS_ATTR_RW(_name, _mode, _show, _store)			\
+#define BTRFS_ATTR_RW(_name, _show, _store)			\
 	static struct kobj_attribute btrfs_attr_##_name =		\
-			__INIT_KOBJ_ATTR(_name, _mode, _show, _store)
+			__INIT_KOBJ_ATTR(_name, 0644, _show, _store)
 
 #define BTRFS_ATTR(_name, _show)					\
-			BTRFS_ATTR_RW(_name, 0444, _show, NULL)
+	static struct kobj_attribute btrfs_attr_##_name =		\
+			__INIT_KOBJ_ATTR(_name, 0444, _show, NULL)
 
 #define BTRFS_ATTR_PTR(_name)    (&btrfs_attr_##_name.attr)
 
-- 
2.0.0.153.g79dcccc

