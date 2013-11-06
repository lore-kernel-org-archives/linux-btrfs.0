Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46803 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3KFJBc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 04:01:32 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rA691VOn023276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 09:01:31 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA691US1014700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 09:01:30 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rA691U4o010536
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 09:01:30 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] Btrfs: change ioctl number of BTRFS_IOC_START_SYNC to 21
Date: Wed,  6 Nov 2013 17:01:19 +0800
Message-Id: <1383728479-29037-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

24 has been assigned to both BTRFS_IOC_START_SYNC and BTRFS_IOC_SUBVOL_CREATE_V2,
and BTRFS_IOC_SUBVOL_CREATE_V2 is at least used in btrfs-progs
while BTRFS_IOC_START_SYNC is not.

21 is free according to link[1], and seems safe to be assigned to BTRFS_IOC_START_SYNC.

[1]:
https://btrfs.wiki.kernel.org/index.php/Project_ideas

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 45e6189..0f5a1af 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -552,7 +552,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
-#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
+#define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 21, __u64)
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
-- 
1.8.1.4

