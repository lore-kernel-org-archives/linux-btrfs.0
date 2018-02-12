Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55392 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753404AbeBLPh0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:37:26 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFbIxO037976
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:37:25 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2g3dd8837r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:37:22 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFWJoh005133
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:20 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1CFWJNY022590
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: open code btrfs_dev_replace_cancel()
Date: Mon, 12 Feb 2018 23:33:29 +0800
Message-Id: <20180212153331.18440-2-anand.jain@oracle.com>
In-Reply-To: <20180212153331.18440-1-anand.jain@oracle.com>
References: <20180212153331.18440-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_dev_replace_cancel() calls __btrfs_dev_replace_cancel() for the
actual cancel so just code it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 10 +---------
 fs/btrfs/dev-replace.h |  3 +--
 fs/btrfs/ioctl.c       |  3 ++-
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 7efbc4d1128b..1ce9528663a6 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -44,7 +44,6 @@ static void btrfs_dev_replace_update_device_in_mapping_tree(
 						struct btrfs_fs_info *fs_info,
 						struct btrfs_device *srcdev,
 						struct btrfs_device *tgtdev);
-static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
 static int btrfs_dev_replace_kthread(void *data);
 static int btrfs_dev_replace_continue_on_mount(struct btrfs_fs_info *fs_info);
 
@@ -694,14 +693,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 	btrfs_dev_replace_unlock(dev_replace, 0);
 }
 
-int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info,
-			     struct btrfs_ioctl_dev_replace_args *args)
-{
-	args->result = __btrfs_dev_replace_cancel(fs_info);
-	return 0;
-}
-
-static u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
+u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	struct btrfs_device *tgt_device = NULL;
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index f94a76844ae7..d8b314ff12c1 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -32,8 +32,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		int read_src);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
-int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info,
-			     struct btrfs_ioctl_dev_replace_args *args);
+u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
 void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info);
 int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f573cad72b7e..a2b7740230d9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4428,7 +4428,8 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 		ret = 0;
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL:
-		ret = btrfs_dev_replace_cancel(fs_info, p);
+		p->result = __btrfs_dev_replace_cancel(fs_info);
+		ret = 0;
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.7.0

