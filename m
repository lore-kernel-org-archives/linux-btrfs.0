Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52149 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab3BYOah (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 09:30:37 -0500
Received: by mail-pa0-f50.google.com with SMTP id fa11so1769596pad.9
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 06:30:36 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com
Subject: [PATCH] Btrfs: fix overhead check for qgroupid in the kernel
Date: Mon, 25 Feb 2013 22:30:32 +0800
Message-Id: <1361802632-2491-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

As we implement the strict hierarchy quota in the userspace,
it is sufficient to check this ruler in the userspace.remove
the special check for qgroup 0.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 059546a..8a31a04 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3764,11 +3764,6 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 		goto drop_write;
 	}
 
-	if (!sa->qgroupid) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-- 
1.7.11.7

