Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20394 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3LSD6P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 22:58:15 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBJ3wDUp020805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 03:58:14 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBJ3wDja007408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 03:58:13 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBJ3wCUX007402
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 03:58:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: ioctls would need unique id
Date: Thu, 19 Dec 2013 12:06:32 +0800
Message-Id: <1387425992-15268-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS_IOC_SET_FEATURES and BTRFS_IOC_GET_SUPPORTED_FEATURES
conflicts with BTRFS_IOC_GET_FEATURES

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/uapi/linux/btrfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 7d7f776..0fe736e 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -634,9 +634,9 @@ struct btrfs_ioctl_fslist_args {
 					struct btrfs_ioctl_fslist_args)
 #define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
 				   struct btrfs_ioctl_feature_flags)
-#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
+#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_feature_flags[2])
-#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
+#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 59, \
 				   struct btrfs_ioctl_feature_flags[3])
 
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.7.1

