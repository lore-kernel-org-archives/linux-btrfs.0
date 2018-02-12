Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56510 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753196AbeBLPhb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:37:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFbJdx037988
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:37:31 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2g3dd8837x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:37:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFWMoO005203
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:22 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1CFWLUc014329
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:22 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: btrfs_dev_replace_cancel() can return int
Date: Mon, 12 Feb 2018 23:33:31 +0800
Message-Id: <20180212153331.18440-4-anand.jain@oracle.com>
In-Reply-To: <20180212153331.18440-1-anand.jain@oracle.com>
References: <20180212153331.18440-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current u64 return from btrfs_dev_replace_cancel() was probably done
to match the btrfs_ioctl_dev_replace_args::result. However as our
actual return value fits in int, and it further gets typecast to u64,
so just return int.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 4 ++--
 fs/btrfs/dev-replace.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 4d1dbc16fcd4..a428d528220f 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -693,13 +693,13 @@ void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 	btrfs_dev_replace_unlock(dev_replace, 0);
 }
 
-u64 btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
+int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	struct btrfs_device *tgt_device = NULL;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = fs_info->tree_root;
-	u64 result;
+	int result;
 	int ret;
 
 	if (sb_rdonly(fs_info->sb))
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 6c3543d93e96..389de365b0db 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -32,7 +32,7 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		int read_src);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
-u64 btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
+int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
 void btrfs_dev_replace_suspend_for_unmount(struct btrfs_fs_info *fs_info);
 int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace);
-- 
2.7.0

