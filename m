Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC640C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD7320652
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dYuEo47/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AD7320652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbeJXM6V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 08:58:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbeJXM6U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 08:58:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9O4TAUS003127
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 04:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=qQJm3BQwRyc+IMEkQ/E9SUMDb6fdbZLlSIRQx0lWmW8=;
 b=dYuEo47/ulcMpYnpHmyIkOaFwm1qmRBB6Iu1gCPeX99y7aObsfqdwBAG2v4j4BSCZ4Xd
 5xSY0PWwyLcM4LT0d6+sGNArvwzq5z5s9SO8gF2A+Wq0CBPhQprNwjBBN11crUvCKlTT
 eOXCcezFYE0F9EuWWzh5j70PRMy5mW0j72rOnuzJLzor0crQxa3xbryjc/ZeZQdAxqHa
 hCdG2p4hwA0G8OAE7dRXeNgPjRztvxchUxm3V0TBHiDsjxZVBUWdLnG3OAaWkUoJh2jU
 /EXVGUFZuhxdA7Ht9xdnYnTXYBfiHGrz7XWh3SIJ4R4rhQIy1w9M+NCfQRtJhljeISeI ow== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n7usu93q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 04:31:57 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9O4VuUN009191
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 04:31:56 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9O4VtkX027700
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 04:31:56 GMT
Received: from tpasj.oracle.com (/192.188.170.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Oct 2018 21:31:55 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: introduce feature to forget a btrfs device
Date:   Wed, 24 Oct 2018 12:31:40 +0800
Message-Id: <1540355502-22489-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1540355502-22489-1-git-send-email-anand.jain@oracle.com>
References: <1540355502-22489-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9055 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810240039
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
---
 fs/btrfs/super.c           | 3 +++
 fs/btrfs/volumes.c         | 9 +++++++++
 fs/btrfs/volumes.h         | 1 +
 include/uapi/linux/btrfs.h | 2 ++
 4 files changed, 15 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 345c64d810d4..f99db6899004 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2246,6 +2246,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
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
index f435d397019e..e1365a122657 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
 	return 0;
 }
 
+int btrfs_forget_devices(const char *path)
+{
+	mutex_lock(&uuid_mutex);
+	btrfs_free_stale_devices(strlen(path) ? path:NULL, NULL);
+	mutex_unlock(&uuid_mutex);
+
+	return 0;
+}
+
 /*
  * Look for a btrfs signature on a device. This may be called out of the mount path
  * and we are not allowed to call set_blocksize during the scan. The superblock
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index aefce895e994..180297d04938 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -406,6 +406,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       fmode_t flags, void *holder);
 struct btrfs_device *btrfs_scan_one_device(const char *path,
 					   fmode_t flags, void *holder);
+int btrfs_forget_devices(const char *path);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_device *device,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..b1be7f828cb4 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -836,6 +836,8 @@ enum btrfs_err_code {
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

