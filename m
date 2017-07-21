Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34743 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754231AbdGUR3N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 13:29:13 -0400
Received: by mail-qt0-f194.google.com with SMTP id o3so3120247qto.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 10:29:13 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 1/3] btrfs: don't allow trans ioctl on a directory
Date: Fri, 21 Jul 2017 13:29:07 -0400
Message-Id: <1500658149-20410-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We need to use file->private_data for readdir on directories, so just
don't allow user space transactions on directories.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bedeec6..ddb3811 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3968,6 +3968,9 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	struct btrfs_trans_handle *trans;
 	int ret;
 
+	if (S_ISDIR(inode->i_mode))
+		return -EINVAL;
+
 	ret = -EPERM;
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
-- 
2.7.4

