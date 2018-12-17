Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BEAC43612
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 15:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D477B2145D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 15:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="APHdTflM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732216AbeLQPIe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 10:08:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbeLQPI0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 10:08:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBHF5lFd092690
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=n2s3ss0sZTJS2xCjzl/rk8BxV6S8dr9S/hKeQ4l1gXQ=;
 b=APHdTflMTh76nz49Xib7g/vA50XfLHkfXCGwiUHmt4VpJ/4+xnC89+D5jIqBTIvByz/T
 lVJrTxb8Oqj6YPfbMSG9+uNzbbBDWuk4YR79AQbCXCE7HoxL5fF/LxvjHiM5lkHJZlIG
 lHYN+iZFUfUzhRnP4iMn/Z3gweOZMPgRpfmSG/dQZHhfX6DG5X66RPj1ut1YKUzRp2qu
 RHNZWZVTlOZuZKzRUyBO7mm9VqOoNn6118BaJ2rViglkbHfT5UR1XGolyAKiGOMmsjqY
 IP8Yi2bce8vjmtj4IzdkzZQDcAPaBzvhQz/0CWK0QEBsqCCddHoZE6h5Y+e1Tmd33UjG Fw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pct8qp1va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:24 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wBHF8NMU031244
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:24 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wBHF8NJc008337
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:23 GMT
Received: from tpasj.localdomain (/157.49.131.42)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Dec 2018 07:08:23 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND v12] btrfs: introduce feature to forget a btrfs device
Date:   Mon, 17 Dec 2018 23:08:20 +0800
Message-Id: <1545059302-3935-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1545059302-3935-1-git-send-email-anand.jain@oracle.com>
References: <1545059302-3935-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9110 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170134
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Support for a new command 'btrfs dev forget [dev]' is proposed here
to undo the effects of 'btrfs dev scan [dev]'. For this purpose
this patch proposes to use ioctl #5 as it was empty.
	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
the /dev/btrfs-control to forget one or all devices, (devices which are
not mounted) from the btrfs kernel.

The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
set to specify the device path. And all unmounted devices can be removed
from the kernel if no device path is provided.

Again, the devices are removed only if the relevant fsid aren't mounted.

This new cli can provide..
 . Release of unwanted btrfs_fs_devices and btrfs_devices memory if the
   device is not going to be mounted.
 . Ability to mount the device in degraded mode when one of the other
   device is corrupted like in split brain raid1.
 . Running test cases which requires btrfs.ko-reload if the rootfs
   is btrfs.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
v11->v12: fix coding style add spacing before after ":".
v1->v11: Pls ref to the cover-letter. (sorry about that).

 fs/btrfs/super.c           | 3 +++
 fs/btrfs/volumes.c         | 9 +++++++++
 fs/btrfs/volumes.h         | 1 +
 include/uapi/linux/btrfs.h | 2 ++
 4 files changed, 15 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d3c6bbc0aa3a..eba2966913ae 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2247,6 +2247,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		ret = PTR_ERR_OR_ZERO(device);
 		mutex_unlock(&uuid_mutex);
 		break;
+	case BTRFS_IOC_FORGET_DEV:
+		ret = btrfs_forget_devices(vol->name);
+		break;
 	case BTRFS_IOC_DEVICES_READY:
 		mutex_lock(&uuid_mutex);
 		device = btrfs_scan_one_device(vol->name, FMODE_READ,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8e36cbb355df..48415a9edd46 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1397,6 +1397,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	return 0;
 }
 
+int btrfs_forget_devices(const char *path)
+{
+	mutex_lock(&uuid_mutex);
+	btrfs_free_stale_devices(strlen(path) ? path : NULL, NULL);
+	mutex_unlock(&uuid_mutex);
+
+	return 0;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1d936ce282c3..a4a89d5050f5 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -414,6 +414,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 struct btrfs_device *btrfs_scan_one_device(const char *path,
 					   fmode_t flags, void *holder);
+int btrfs_forget_devices(const char *path);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_device *device,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index e0763bc4158e..c195896d478f 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -837,6 +837,8 @@ enum btrfs_err_code {
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
 				   struct btrfs_ioctl_vol_args)
+#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
+				   struct btrfs_ioctl_vol_args)
 /* trans start and trans end are dangerous, and only for
  * use by applications that know how to avoid the
  * resulting deadlocks
-- 
1.8.3.1

