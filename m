Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1112AC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9D9720652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LJQ7UFtE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfAQPcx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:32:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbfAQPcv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:32:51 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0HFSrks006928
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=YMJopSjW20ktV3lF+khPOAE4G9EFCE+odQxXCkgXTT4=;
 b=LJQ7UFtEdQiYCiQYpdUJLn0UgslLwy4mvb3BpGivF6OkhVpP958bNamUgcjQgVPfmHZJ
 oOacjyvF3VLmgq+vKlbNdycLzOY00jU85sssntK/tHSqEMsf57RUFIIXi2sdARZiRXoQ
 ZLaZ+1N6n1g32QDATNDDlX2+tm3w5fNqlkEH8FGTBJMlHfjuVFumf/aqmibFFTee2YUZ
 Dx9JODnWyTrzyMPqeo87OODhiCs/YEPYq4W8hdVFNdxRaHuwhTfMKbg+uJPTw/omA7zr
 tv6eKgg8aA+ABUIyeMI/xlv5nm0TbAFCQ9BB7DRYrtueEf3Iv5Ikfav/YlVAkJhtkehk +Q== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2pybjsgm7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:50 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWnHn016558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:50 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0HFWnpc021239
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:49 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 07:32:49 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: merge btrfs_find_device() and find_device()
Date:   Thu, 17 Jan 2019 23:32:32 +0800
Message-Id: <1547739153-6916-6-git-send-email-anand.jain@oracle.com>
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

Both btrfs_find_device() and find_device() does the same things expect
that latter function is not keen in seed device in the scan-context. So
merge them.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  4 +--
 fs/btrfs/ioctl.c       |  4 +--
 fs/btrfs/scrub.c       |  4 +--
 fs/btrfs/volumes.c     | 69 ++++++++++++++++++++++++--------------------------
 fs/btrfs/volumes.h     |  3 ++-
 5 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 6f0fe3623381..b5897becd542 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -112,10 +112,10 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
 		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices,
-							src_devid, NULL, NULL);
+							src_devid, NULL, NULL, 0);
 		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices,
 							BTRFS_DEV_REPLACE_DEVID,
-							NULL, NULL);
+							NULL, NULL, 0);
 		/*
 		 * allow 'btrfs dev replace_cancel' if src/tgt device is
 		 * missing
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd5f97aeb35c..66f2f9e229d5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1642,7 +1642,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
-	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
 	if (!device) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
@@ -3179,7 +3179,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 
 	rcu_read_lock();
 	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
-				NULL);
+				NULL, 0);
 
 	if (!dev) {
 		ret = -ENODEV;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 72044efc610a..477c585927e4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3835,7 +3835,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return PTR_ERR(sctx);
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -4012,7 +4012,7 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
 	if (dev)
 		sctx = dev->scrub_ctx;
 	if (sctx)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index be473a493a63..7f89c8b1cab1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -415,27 +415,6 @@ static struct btrfs_device *__alloc_device(void)
 	return dev;
 }
 
-/*
- * Find a device specified by @devid or @uuid in the list of @fs_devices, or
- * return NULL.
- *
- * If devid and uuid are both specified, the match must be exact, otherwise
- * only devid is used.
- */
-static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
-		u64 devid, const u8 *uuid)
-{
-	struct btrfs_device *dev;
-
-	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
-		if (dev->devid == devid &&
-		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
-			return dev;
-		}
-	}
-	return NULL;
-}
-
 static noinline struct btrfs_fs_devices *find_fsid(
 		const u8 *fsid, const u8 *metadata_fsid)
 {
@@ -990,8 +969,8 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		device = NULL;
 	} else {
 		mutex_lock(&fs_devices->device_list_mutex);
-		device = find_device(fs_devices, devid,
-				disk_super->dev_item.uuid);
+		device = btrfs_find_device(fs_devices, devid,
+					   disk_super->dev_item.uuid, NULL, 1);
 
 		/*
 		 * If this disk has been pulled into an fs devices created by
@@ -2419,10 +2398,10 @@ static struct btrfs_device *find_device_by_superblock(
 	dev_uuid = disk_super->dev_item.uuid;
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
 		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   disk_super->metadata_uuid);
+					   disk_super->metadata_uuid, 0);
 	else
 		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   disk_super->fsid);
+					   disk_super->fsid, 0);
 
 	brelse(bh);
 	if (!device)
@@ -2442,7 +2421,7 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 
 	if (devid) {
 		device = btrfs_find_device(fs_info->fs_devices, devid, NULL,
-					   NULL);
+					   NULL, 0);
 		if (!device)
 			return ERR_PTR(-ENOENT);
 		return device;
@@ -2584,7 +2563,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 				   BTRFS_FSID_SIZE);
 		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-					   fs_uuid);
+					   fs_uuid, 0);
 		BUG_ON(!device); /* Logic error */
 
 		if (device->fs_devices->seeding) {
@@ -6637,19 +6616,36 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	return BLK_STS_OK;
 }
 
+/*
+ * Find a device specified by @devid or @uuid in the list of @fs_devices, or
+ * return NULL.
+ *
+ * If devid and uuid are both specified, the match must be exact, otherwise
+ * only devid is used.
+ *
+ * By default will check seed devices as well, unless @no_seed is 1.
+ */
 struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
-				       u64 devid, u8 *uuid, u8 *fsid)
+				       u64 devid, u8 *uuid, u8 *fsid,
+				       int no_seed)
 {
 	struct btrfs_device *device;
 
 	while (fs_devices) {
 		if (!fsid ||
 		    !memcmp(fs_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
-			device = find_device(fs_devices, devid, uuid);
-			if (device)
-				return device;
+			list_for_each_entry(device, &fs_devices->devices,
+					    dev_list) {
+				if (device->devid == devid && (!uuid ||
+				    !memcmp(device->uuid, uuid,
+				    BTRFS_UUID_SIZE)))
+					return device;
+			}
 		}
-		fs_devices = fs_devices->seed;
+		if (no_seed)
+			return NULL;
+		else
+			fs_devices = fs_devices->seed;
 	}
 	return NULL;
 }
@@ -6895,7 +6891,7 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
 		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices,
-							devid, uuid, NULL);
+							devid, uuid, NULL, 0);
 		if (!map->stripes[i].dev &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
@@ -7035,7 +7031,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	}
 
 	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
-				   fs_uuid);
+				   fs_uuid, 0);
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid,
@@ -7625,7 +7621,8 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 	int i;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info->fs_devices, stats->devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, stats->devid, NULL, NULL,
+				0);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
@@ -7839,7 +7836,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Make sure no dev extent is beyond device bondary */
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, 0);
 	if (!dev) {
 		btrfs_err(fs_info, "failed to find devid %llu", devid);
 		ret = -EUCLEAN;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 46ee8eafdc92..8f71cc724015 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -435,7 +435,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
 struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
-				       u64 devid, u8 *uuid, u8 *fsid);
+				       u64 devid, u8 *uuid, u8 *fsid,
+				       int no_seed);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
-- 
1.8.3.1

