Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18312 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3EMLLD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 07:11:03 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4DBB1J3012918
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 11:11:02 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4DBB08m016520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 11:11:01 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4DBB08v028314
	for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 11:11:00 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove useless copy in quota_ctl
Date: Mon, 13 May 2013 19:10:44 +0800
Message-Id: <1368443444-14190-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to copy it back to user side as it remains unchanged.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0de4a2f..c189189 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3719,9 +3719,6 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		break;
 	}
 
-	if (copy_to_user(arg, sa, sizeof(*sa)))
-		ret = -EFAULT;
-
 	err = btrfs_commit_transaction(trans, root->fs_info->tree_root);
 	if (err && !ret)
 		ret = err;
-- 
1.7.7.6

