Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41004 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbeBLPfo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:35:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFWHuh018180
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:35:43 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2g3daw85un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:35:43 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFZhsQ016884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:35:43 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFZg7I002612
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:35:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: log, when replace, is canceled by the user
Date: Mon, 12 Feb 2018 23:36:58 +0800
Message-Id: <20180212153658.19631-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For forensic investigations of issues, we would want to know
if and when the user cancels the replace.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 197be3fe307b..83eb2d32b477 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -711,6 +711,7 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	struct btrfs_device *tgt_device = NULL;
+	struct btrfs_device *src_device = NULL;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = fs_info->tree_root;
 	u64 result;
@@ -732,6 +733,7 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
 		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 		tgt_device = dev_replace->tgtdev;
+		src_device = dev_replace->srcdev;
 		dev_replace->tgtdev = NULL;
 		dev_replace->srcdev = NULL;
 		break;
@@ -749,6 +751,11 @@ static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	}
 	ret = btrfs_commit_transaction(trans);
 	WARN_ON(ret);
+
+	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s canceled",
+		   btrfs_dev_name(src_device), src_device->devid,
+		   rcu_str_deref(tgt_device->name));
+
 	if (tgt_device)
 		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 
-- 
2.15.0

