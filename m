Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43355 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3JJRj7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 13:39:59 -0400
Received: by mail-ee0-f51.google.com with SMTP id c1so1330686eek.10
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 10:39:58 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH] Btrfs: don't leak ioctl args in btrfs_ioctl_dev_replace
Date: Thu, 10 Oct 2013 20:39:28 +0300
Message-Id: <1381426768-31904-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

struct btrfs_ioctl_dev_replace_args memory is leaked if replace is
requested on a read-only filesystem.  Fix it.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d46f60..17bb98e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3679,9 +3679,10 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
 
 	switch (p->cmd) {
 	case BTRFS_IOCTL_DEV_REPLACE_CMD_START:
-		if (root->fs_info->sb->s_flags & MS_RDONLY)
-			return -EROFS;
-
+		if (root->fs_info->sb->s_flags & MS_RDONLY) {
+			ret = -EROFS;
+			goto out;
+		}
 		if (atomic_xchg(
 			&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
@@ -3707,7 +3708,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
 
 	if (copy_to_user(arg, p, sizeof(*p)))
 		ret = -EFAULT;
-
+out:
 	kfree(p);
 	return ret;
 }
-- 
1.7.10.4

