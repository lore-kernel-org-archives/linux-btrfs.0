Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45526 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbeBMDwU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 22:52:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D3qKEi026899
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:52:20 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2g3q55r59r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:52:20 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1D3qJWg017058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:52:19 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1D3qJM7009723
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 03:52:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: log, when replace, is canceled by the user
Date: Tue, 13 Feb 2018 11:53:43 +0800
Message-Id: <20180213035343.18128-1-anand.jain@oracle.com>
In-Reply-To: <20180212153658.19631-1-anand.jain@oracle.com>
References: <20180212153658.19631-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For forensic investigations of issues, we would want to know
if and when the user cancels the replace.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: use btrfs_dev_name() instead of rcu_str_deref()
        as btrfs_dev_name() also provides "missing" string,
        if needed.

 fs/btrfs/dev-replace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dd717e204b5e..3b0760f7ec8a 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -703,6 +703,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	struct btrfs_device *tgt_device = NULL;
+	struct btrfs_device *src_device = NULL;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = fs_info->tree_root;
 	int result;
@@ -724,6 +725,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
 		result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 		tgt_device = dev_replace->tgtdev;
+		src_device = dev_replace->srcdev;
 		dev_replace->tgtdev = NULL;
 		dev_replace->srcdev = NULL;
 		break;
@@ -741,6 +743,11 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 	}
 	ret = btrfs_commit_transaction(trans);
 	WARN_ON(ret);
+
+	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s canceled",
+		   btrfs_dev_name(src_device), src_device->devid,
+		   btrfs_dev_name(tgt_device));
+
 	if (tgt_device)
 		btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 
-- 
2.15.0

