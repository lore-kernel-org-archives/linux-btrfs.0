Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49701 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab3LSEAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 23:00:42 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rBJ40fMk024845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 04:00:42 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBJ40dD8023905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 04:00:40 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rBJ40dpe023899
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 04:00:39 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: sync-up with newly introduced ioctl number
Date: Thu, 19 Dec 2013 12:08:56 +0800
Message-Id: <1387426136-15326-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

for now the manual sync up of new ioctls introduced in the btrfs
kernel. For which there wasn't any btrfs-progs patch.
however we might have better idea for the long run.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 ioctl.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 29575d8..cd90afe 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -623,6 +623,12 @@ struct btrfs_ioctl_clone_range_args {
 				  struct btrfs_ioctl_dedup_args)
 #define BTRFS_IOC_GET_FSLIST _IOWR(BTRFS_IOCTL_MAGIC, 56, \
 					struct btrfs_ioctl_fslist_args)
+#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
+				   struct btrfs_ioctl_feature_flags)
+#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 58, \
+				   struct btrfs_ioctl_feature_flags[2])
+#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 59, \
+				   struct btrfs_ioctl_feature_flags[3])
 #ifdef __cplusplus
 }
 #endif
-- 
1.7.1

