Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD36C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E641620652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rsaauqH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfAQPc7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:32:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47926 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbfAQPc6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:32:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0HFSpqS006885
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=dulJLtm0+B8/l/exxaMuyqX4dqZUb+Ua48jgLtm8k5w=;
 b=rsaauqH946d631YUqfd55UxfYBlaUR25RgTplK7YDmjdjr8QRpNo/hwT8FNLNVbJi1/M
 VJqxnDyZeMqknYln1FlTaHui6Vwsx5JhLvoLLK1Wq1RONqn7P4UMDJxClAZXtyVGAzX9
 KN7FXdcKdXBGLXHnR7TYmIvYK6njaPre7bdpkqYjjgOUkc80cw3b6x1O1Nf2ts0DMn8a
 0ZfBnW/c4iOh8ud4/ynwVqfCT4xkQ6DNpmYiytEH6pr9ps16UNRbr2WG4R10KObQ7VFS
 FpVj0iA18JgcTtztTQVnMtFsJLuWnOJl16wV1rtWDvJxYME6F6dCBrhZOKAcbsqtqf8E Zg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pybjsgm83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:57 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWptR001616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:51 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWpY4015100
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:51 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 07:32:51 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: refactor btrfs_find_device() return error code
Date:   Thu, 17 Jan 2019 23:32:33 +0800
Message-Id: <1547739153-6916-7-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9138 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901170111
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Refactor btrfs_find_device() to return standard error code.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  4 ++--
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/scrub.c       | 12 ++++++++----
 fs/btrfs/volumes.c     | 32 +++++++++++++-------------------
 4 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index b5897becd542..23cef72a5a87 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -120,7 +120,7 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		 * allow 'btrfs dev replace_cancel' if src/tgt device is
 		 * missing
 		 */
-		if (!dev_replace->srcdev &&
+		if (PTR_ERR(dev_replace->srcdev) == -ENOENT &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			ret = -EIO;
 			btrfs_warn(fs_info,
@@ -129,7 +129,7 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 			   "srcdev (devid %llu) is missing, need to run 'btrfs dev scan'?",
 			   src_devid);
 		}
-		if (!dev_replace->tgtdev &&
+		if (PTR_ERR(dev_replace->tgtdev) == -ENOENT &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			ret = -EIO;
 			btrfs_warn(fs_info,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 66f2f9e229d5..71243025b324 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1643,7 +1643,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 	}
 
 	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
-	if (!device) {
+	if (PTR_ERR(device) == -ENOENT) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
 		ret = -ENODEV;
@@ -3181,7 +3181,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
 				NULL, 0);
 
-	if (!dev) {
+	if (PTR_ERR(dev) == -ENOENT) {
 		ret = -ENODEV;
 		goto out;
 	}
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 477c585927e4..c8029628282a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3836,8 +3836,9 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
-	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
-		     !is_dev_replace)) {
+	if (PTR_ERR(dev) == -ENOENT ||
+	    (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
+	    !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		ret = -ENODEV;
 		goto out_free_ctx;
@@ -4013,13 +4014,16 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
-	if (dev)
+	if (PTR_ERR(dev) != -ENOENT)
 		sctx = dev->scrub_ctx;
 	if (sctx)
 		memcpy(progress, &sctx->stat, sizeof(*progress));
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
-	return dev ? (sctx ? 0 : -ENOTCONN) : -ENODEV;
+	if (PTR_ERR(dev) == -ENOENT)
+		return -ENODEV;
+	else
+		return sctx ? 0 : -ENOTCONN;
 }
 
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7f89c8b1cab1..5a3846daabcf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -966,7 +966,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		mutex_lock(&fs_devices->device_list_mutex);
 		list_add(&fs_devices->fs_list, &fs_uuids);
 
-		device = NULL;
+		device = ERR_PTR(-ENOENT);
 	} else {
 		mutex_lock(&fs_devices->device_list_mutex);
 		device = btrfs_find_device(fs_devices, devid,
@@ -988,7 +988,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		}
 	}
 
-	if (!device) {
+	if (PTR_ERR(device) == -ENOENT) {
 		if (fs_devices->opened) {
 			mutex_unlock(&fs_devices->device_list_mutex);
 			return ERR_PTR(-EBUSY);
@@ -2404,8 +2404,6 @@ static struct btrfs_device *find_device_by_superblock(
 					   disk_super->fsid, 0);
 
 	brelse(bh);
-	if (!device)
-		device = ERR_PTR(-ENOENT);
 	blkdev_put(bdev, FMODE_READ);
 	return device;
 }
@@ -2419,13 +2417,9 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 {
 	struct btrfs_device *device;
 
-	if (devid) {
-		device = btrfs_find_device(fs_info->fs_devices, devid, NULL,
-					   NULL, 0);
-		if (!device)
-			return ERR_PTR(-ENOENT);
-		return device;
-	}
+	if (devid)
+		return btrfs_find_device(fs_info->fs_devices, devid, NULL,
+					 NULL, 0);
 
 	if (!device_path || !device_path[0])
 		return ERR_PTR(-EINVAL);
@@ -2564,7 +2558,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 				   BTRFS_FSID_SIZE);
 		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
 					   fs_uuid, 0);
-		BUG_ON(!device); /* Logic error */
+		BUG_ON(PTR_ERR(device) == -ENOENT); /* Logic error */
 
 		if (device->fs_devices->seeding) {
 			btrfs_set_device_generation(leaf, dev_item,
@@ -6643,11 +6637,11 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
 			}
 		}
 		if (no_seed)
-			return NULL;
+			return ERR_PTR(-ENOENT);
 		else
 			fs_devices = fs_devices->seed;
 	}
-	return NULL;
+	return ERR_PTR(-ENOENT);
 }
 
 static struct btrfs_device *add_missing_dev(struct btrfs_fs_devices *fs_devices,
@@ -6892,13 +6886,13 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 				   BTRFS_UUID_SIZE);
 		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices,
 							devid, uuid, NULL, 0);
-		if (!map->stripes[i].dev &&
+		if (PTR_ERR(map->stripes[i].dev) == -ENOENT &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
 			btrfs_report_missing_device(fs_info, devid, uuid, true);
 			return -ENOENT;
 		}
-		if (!map->stripes[i].dev) {
+		if (PTR_ERR(map->stripes[i].dev) == -ENOENT) {
 			map->stripes[i].dev =
 				add_missing_dev(fs_info->fs_devices, devid,
 						uuid);
@@ -7032,7 +7026,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 
 	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
 				   fs_uuid, 0);
-	if (!device) {
+	if (PTR_ERR(device) == -ENOENT) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid,
 							dev_uuid, true);
@@ -7625,7 +7619,7 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 				0);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	if (!dev) {
+	if (PTR_ERR(dev) == -ENOENT) {
 		btrfs_warn(fs_info, "get dev_stats failed, device not found");
 		return -ENODEV;
 	} else if (!dev->dev_stats_valid) {
@@ -7837,7 +7831,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 
 	/* Make sure no dev extent is beyond device bondary */
 	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
-	if (!dev) {
+	if (PTR_ERR(dev) == -ENOENT) {
 		btrfs_err(fs_info, "failed to find devid %llu", devid);
 		ret = -EUCLEAN;
 		goto out;
-- 
1.8.3.1

