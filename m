Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754442AbdLFDjp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 22:39:45 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB63awuT025341
        for <linux-btrfs@vger.kernel.org>; Wed, 6 Dec 2017 03:39:44 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2enc2g52j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Dec 2017 03:39:44 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB63dhh0032130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 6 Dec 2017 03:39:44 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB63dhp1009309
        for <linux-btrfs@vger.kernel.org>; Wed, 6 Dec 2017 03:39:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: put btrfs_ioctl_vol_args_v2 related defines together
Date: Wed,  6 Dec 2017 11:40:10 +0800
Message-Id: <20171206034010.29699-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just a code spatial rearrangement, no functional change.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/uapi/linux/btrfs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index ce615b75e855..adf0b088d9a0 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -33,8 +33,12 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
-#define BTRFS_DEVICE_PATH_NAME_MAX 1024
+#define BTRFS_DEVICE_PATH_NAME_MAX	1024
+#define BTRFS_SUBVOL_NAME_MAX 		4039
 
+#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
+#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 #define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
 
 #define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
@@ -101,11 +105,7 @@ struct btrfs_ioctl_qgroup_limit_args {
  * - BTRFS_IOC_SUBVOL_GETFLAGS
  * - BTRFS_IOC_SUBVOL_SETFLAGS
  */
-#define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
-#define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
-#define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 
-#define BTRFS_SUBVOL_NAME_MAX 4039
 struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
-- 
2.15.0

