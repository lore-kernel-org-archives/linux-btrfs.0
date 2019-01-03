Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B7DC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66CA120883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rNJApL6s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfACIBu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:01:50 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40770 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfACIBu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 03:01:50 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x037wtLZ120720
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Jan 2019 08:01:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=NI7J3Fm+KJRLn5sSM1rrzCs57DGQbg3hpYfJziC+Ruk=;
 b=rNJApL6sc0Z/X6FTDIpvf483iN47020nMG1xaN9+yPSuVP02Cqfgabp3V694RMlhCMx/
 XB7sVvpJq5jpYSuXSMlR4eHuc2FHsJxdT62j/3n2TBlizF8VH1VrhXeEKoCdtpzrCTKK
 5kUOF0I26c7e8YG+iPeY9+bFEftMy7TLoSZFlV+QJsyAw7i6p+6tLSVv+1FpkMECiVvv
 NZre8nzmpWLTCJyARiDwPzsXZOIVl7+ejHnIzo1kQf+2F5YQWDKEfE4blODXMjQPxLtf
 YLIzZhSBMUjNl5VqWv8sDcvYbgK3/1FvEFUvq6+XfO30wVcetQxSK0rR0yIGxizTA/OG yg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jr5n5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jan 2019 08:01:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0381lL2001408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Jan 2019 08:01:47 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0381lQh025495
        for <linux-btrfs@vger.kernel.org>; Thu, 3 Jan 2019 08:01:47 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 00:01:47 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v13] btrfs: introduce feature to forget a btrfs device
Date:   Thu,  3 Jan 2019 16:01:37 +0800
Message-Id: <1546502498-28070-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1546502498-28070-1-git-send-email-anand.jain@oracle.com>
References: <1546502498-28070-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9124 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901030072
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
v12->v13:  
  btrfs.ko returns error on failing to find the given device.
  For no argument (btrfs device scan --forget) if there is
  no device to forget then it shall just return success.
v11->v12: fix coding style add spacing before after ":".
v1->v11: Pls ref to the cover-letter. (sorry about that).

 fs/btrfs/super.c           |  3 +++
 fs/btrfs/volumes.c         | 55 +++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h         |  1 +
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 33cc9aba9c94..a4e8beec0fc5 100644
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
index 2576b1a379c9..2ab42bfe5d3c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -734,6 +734,19 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+static bool device_path_matched(const char *path, struct btrfs_device *device)
+{
+	int found;
+
+	rcu_read_lock();
+	found = strcmp(rcu_str_deref(device->name), path);
+	rcu_read_unlock();
+
+	if (!found)
+		return true;
+	return false;
+}
+
 /*
  *  Search and remove all stale (devices which are not mounted) devices.
  *  When both inputs are NULL, it will search and release all stale devices.
@@ -742,44 +755,47 @@ static void pending_bios_fn(struct btrfs_work *work)
  *  skip_dev:	Optional. Will skip this device when searching for the stale
  *		devices.
  */
-static void btrfs_free_stale_devices(const char *path,
+static int btrfs_free_stale_devices(const char *path,
 				     struct btrfs_device *skip_device)
 {
 	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
 	struct btrfs_device *device, *tmp_device;
+	int ret;
+
+	if (path)
+		ret = -ENXIO;
+	else
+		ret = 0;
 
 	list_for_each_entry_safe(fs_devices, tmp_fs_devices, &fs_uuids, fs_list) {
+
 		mutex_lock(&fs_devices->device_list_mutex);
-		if (fs_devices->opened) {
-			mutex_unlock(&fs_devices->device_list_mutex);
-			continue;
-		}
 
 		list_for_each_entry_safe(device, tmp_device,
 					 &fs_devices->devices, dev_list) {
-			int not_found = 0;
 
 			if (skip_device && skip_device == device)
 				continue;
 			if (path && !device->name)
 				continue;
-
-			rcu_read_lock();
-			if (path)
-				not_found = strcmp(rcu_str_deref(device->name),
-						   path);
-			rcu_read_unlock();
-			if (not_found)
+			if (path && !device_path_matched(path, device))
 				continue;
+			if (fs_devices->opened) {
+				if (path)
+					ret = -EBUSY;
+				break;
+			}
 
 			/* delete the stale device */
 			fs_devices->num_devices--;
 			list_del(&device->dev_list);
 			btrfs_free_device(device);
 
+			ret = 0;
 			if (fs_devices->num_devices == 0)
 				break;
 		}
+
 		mutex_unlock(&fs_devices->device_list_mutex);
 		if (fs_devices->num_devices == 0) {
 			btrfs_sysfs_remove_fsid(fs_devices);
@@ -787,6 +803,8 @@ static void btrfs_free_stale_devices(const char *path,
 			free_fs_devices(fs_devices);
 		}
 	}
+
+	return ret;
 }
 
 static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
@@ -1451,6 +1469,17 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	return 0;
 }
 
+int btrfs_forget_devices(const char *path)
+{
+	int ret;
+
+	mutex_lock(&uuid_mutex);
+	ret = btrfs_free_stale_devices(strlen(path) ? path : NULL, NULL);
+	mutex_unlock(&uuid_mutex);
+
+	return ret;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ed806649a473..1e73257e55fb 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -416,6 +416,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
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

