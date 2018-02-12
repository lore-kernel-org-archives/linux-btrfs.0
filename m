Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57786 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753196AbeBLPhn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:37:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFbIY6037934
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:37:42 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2g3dd8837t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:37:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFWKs2005159
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:21 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1CFWKqJ014323
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:20 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs: rename __btrfs_dev_replace_cancel()
Date: Mon, 12 Feb 2018 23:33:30 +0800
Message-Id: <20180212153331.18440-3-anand.jain@oracle.com>
In-Reply-To: <20180212153331.18440-1-anand.jain@oracle.com>
References: <20180212153331.18440-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove __ which is for the special functions.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/dev-replace.h | 2 +-
 fs/btrfs/ioctl.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 1ce9528663a6..4d1dbc16fcd4 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -693,7 +693,7 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 	btrfs_dev_replace_unlock(dev_replace, 0);
 }
 
-u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
+u64 btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	struct btrfs_device *tgt_device = NULL;
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index d8b314ff12c1..6c3543d93e96 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -32,7 +32,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		int read_src);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
-u64 __btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
+u64 btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
 void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info);
 int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a2b7740230d9..9ff7b230eff3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4428,7 +4428,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_fs_info *fs_info,
 		ret = 0;
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL:
-		p->result = __btrfs_dev_replace_cancel(fs_info);
+		p->result = btrfs_dev_replace_cancel(fs_info);
 		ret = 0;
 		break;
 	default:
-- 
2.7.0

