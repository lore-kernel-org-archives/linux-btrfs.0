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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB89C43612
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 023A720652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O2Q1Vzu6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfAQPcw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:32:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40786 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbfAQPcv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:32:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0HFSpLr044620
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=liO6cvagocko53xsgDmnp7xIEEbGhs3GSY1pYQOaXB0=;
 b=O2Q1Vzu6B7oXCKfG2QlQX3LVimYhMxAu868MPU3lKK4CkpqNvc/Pf1CIDj/QHVYNq3lk
 dXjWKO7Jt1+3PpfBJKWtE46eBg+dBS6QleKLLnSY/Fad+yOyBOoLjifPK9QLTzC0xyPH
 5KuHOjGKy3leoplK7tSjETu7l7fzmr7eoICEVPCtUGCQEW+hGHmXb9KhbpQxH+ynzHix
 qgopy6cfONJEu9i1WopJqO/TTnenSdHecr+57JrveRWLubIxxRScxwialI0G8bMwjQwl
 pLsCtG+s53dqDawB8IAe8pxxWkJxfYb7NBupINSnFM2wUMTiXcaM12nyq/ipQb5qXP0S lw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pybkcrk0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:49 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWmFn005597
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:49 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0HFWmAI030881
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:48 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 07:32:48 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: refactor btrfs_find_device() take fs_devices as argument
Date:   Thu, 17 Jan 2019 23:32:31 +0800
Message-Id: <1547739153-6916-5-git-send-email-anand.jain@oracle.com>
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

btrfs_find_device() accepts fs_info as an argument and retrieves
fs_devices from fs_info.

Instead send fs_devices, so that this function can be used in non
mounted (scanned) context as well.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |  6 +++---
 fs/btrfs/ioctl.c       |  5 +++--
 fs/btrfs/scrub.c       |  4 ++--
 fs/btrfs/volumes.c     | 39 ++++++++++++++++++++-------------------
 fs/btrfs/volumes.h     |  4 ++--
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 8750c835f535..6f0fe3623381 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -111,9 +111,9 @@ int btrfs_init_dev_replace(struct btrfs_fs_info *fs_info)
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED:
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
-		dev_replace->srcdev = btrfs_find_device(fs_info, src_devid,
-							NULL, NULL);
-		dev_replace->tgtdev = btrfs_find_device(fs_info,
+		dev_replace->srcdev = btrfs_find_device(fs_info->fs_devices,
+							src_devid, NULL, NULL);
+		dev_replace->tgtdev = btrfs_find_device(fs_info->fs_devices,
 							BTRFS_DEV_REPLACE_DEVID,
 							NULL, NULL);
 		/*
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 72b2b2de6293..fd5f97aeb35c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1642,7 +1642,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 		btrfs_info(fs_info, "resizing devid %llu", devid);
 	}
 
-	device = btrfs_find_device(fs_info, devid, NULL, NULL);
+	device = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
 	if (!device) {
 		btrfs_info(fs_info, "resizer unable to find device %llu",
 			   devid);
@@ -3178,7 +3178,8 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 		s_uuid = di_args->uuid;
 
 	rcu_read_lock();
-	dev = btrfs_find_device(fs_info, di_args->devid, s_uuid, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, di_args->devid, s_uuid,
+				NULL);
 
 	if (!dev) {
 		ret = -ENODEV;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6dcd36d7b849..72044efc610a 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3835,7 +3835,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return PTR_ERR(sctx);
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -4012,7 +4012,7 @@ int btrfs_scrub_progress(struct btrfs_fs_info *fs_info, u64 devid,
 	struct scrub_ctx *sctx = NULL;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
 	if (dev)
 		sctx = dev->scrub_ctx;
 	if (sctx)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a307d76c8926..be473a493a63 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2418,11 +2418,11 @@ static struct btrfs_device *find_device_by_superblock(
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	dev_uuid = disk_super->dev_item.uuid;
 	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
-		device = btrfs_find_device(fs_info, devid, dev_uuid,
-				disk_super->metadata_uuid);
+		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+					   disk_super->metadata_uuid);
 	else
-		device = btrfs_find_device(fs_info, devid,
-				dev_uuid, disk_super->fsid);
+		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+					   disk_super->fsid);
 
 	brelse(bh);
 	if (!device)
@@ -2441,7 +2441,8 @@ struct btrfs_device *btrfs_find_device_by_devspec(
 	struct btrfs_device *device;
 
 	if (devid) {
-		device = btrfs_find_device(fs_info, devid, NULL, NULL);
+		device = btrfs_find_device(fs_info->fs_devices, devid, NULL,
+					   NULL);
 		if (!device)
 			return ERR_PTR(-ENOENT);
 		return device;
@@ -2582,7 +2583,8 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 				   BTRFS_UUID_SIZE);
 		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 				   BTRFS_FSID_SIZE);
-		device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
+		device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+					   fs_uuid);
 		BUG_ON(!device); /* Logic error */
 
 		if (device->fs_devices->seeding) {
@@ -6635,21 +6637,19 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	return BLK_STS_OK;
 }
 
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
-				       u8 *uuid, u8 *fsid)
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
+				       u64 devid, u8 *uuid, u8 *fsid)
 {
 	struct btrfs_device *device;
-	struct btrfs_fs_devices *cur_devices;
 
-	cur_devices = fs_info->fs_devices;
-	while (cur_devices) {
+	while (fs_devices) {
 		if (!fsid ||
-		    !memcmp(cur_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
-			device = find_device(cur_devices, devid, uuid);
+		    !memcmp(fs_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
+			device = find_device(fs_devices, devid, uuid);
 			if (device)
 				return device;
 		}
-		cur_devices = cur_devices->seed;
+		fs_devices = fs_devices->seed;
 	}
 	return NULL;
 }
@@ -6894,8 +6894,8 @@ static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 		read_extent_buffer(leaf, uuid, (unsigned long)
 				   btrfs_stripe_dev_uuid_nr(chunk, i),
 				   BTRFS_UUID_SIZE);
-		map->stripes[i].dev = btrfs_find_device(fs_info, devid,
-							uuid, NULL);
+		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices,
+							devid, uuid, NULL);
 		if (!map->stripes[i].dev &&
 		    !btrfs_test_opt(fs_info, DEGRADED)) {
 			free_extent_map(em);
@@ -7034,7 +7034,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 			return PTR_ERR(fs_devices);
 	}
 
-	device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
+	device = btrfs_find_device(fs_info->fs_devices, devid, dev_uuid,
+				   fs_uuid);
 	if (!device) {
 		if (!btrfs_test_opt(fs_info, DEGRADED)) {
 			btrfs_report_missing_device(fs_info, devid,
@@ -7624,7 +7625,7 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 	int i;
 
 	mutex_lock(&fs_devices->device_list_mutex);
-	dev = btrfs_find_device(fs_info, stats->devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, stats->devid, NULL, NULL);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
@@ -7838,7 +7839,7 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Make sure no dev extent is beyond device bondary */
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL);
 	if (!dev) {
 		btrfs_err(fs_info, "failed to find devid %llu", devid);
 		ret = -EUCLEAN;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 1e73257e55fb..46ee8eafdc92 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -434,8 +434,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
 		      struct btrfs_device *device, u64 new_size);
-struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
-				       u8 *uuid, u8 *fsid);
+struct btrfs_device *btrfs_find_device(struct btrfs_fs_devices *fs_devices,
+				       u64 devid, u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_balance(struct btrfs_fs_info *fs_info,
-- 
1.8.3.1

