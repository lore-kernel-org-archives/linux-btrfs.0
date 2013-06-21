Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23865 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423098Ab3FUHyF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:54:05 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7s4pY017698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:05 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s3MD018497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:04 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7s328018491
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:54:03 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/13] btrfs-progs: obtain used_bytes in BTRFS_IOC_FS_INFO ioctl
Date: Fri, 21 Jun 2013 15:58:04 +0800
Message-Id: <1371801485-14571-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>

btrfs-progs has to read fs info from the kernel to
read the latest info instead of reading it from the disks,
which generally is a stale info after certain critical
operation.

getting used_bytes parameter will help to fix
      btrfs filesystem show --kernel
to show the current info of the fs

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 ioctl.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ioctl.h b/ioctl.h
index a40a4a1..d035201 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -169,7 +169,8 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 max_id;				/* out */
 	__u64 num_devices;			/* out */
 	__u8 fsid[BTRFS_FSID_SIZE];		/* out */
-	__u64 reserved[124];			/* pad to 1k */
+	__u64 used_bytes;			/* out */
+	__u64 reserved[123];			/* pad to 1k */
 };
 
 /* balance control ioctl modes */
-- 
1.8.1.227.g44fe835

