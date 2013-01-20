Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59803 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ATPWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 10:22:41 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so2432295eek.24
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 07:22:40 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH 2/5] Btrfs: fix "mutually exclusive op is running" error code
Date: Sun, 20 Jan 2013 17:22:29 +0200
Message-Id: <1358695352-7140-3-git-send-email-idryomov@gmail.com>
In-Reply-To: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
References: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error code that is returned in response to starting a mutually
exclusive operation when there is one already running got silently
changed from EINVAL to EINPROGRESS by 5ac00add.  Returning EINPROGRESS
to, say, add_dev, when rm_dev is running is misleading.  Furthermore,
the operation itself may want to use EINPROGRESS for other purposes.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab82636..3aebb28 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1337,7 +1337,7 @@ static noinline int btrfs_ioctl_resize(struct file *file,
 			1)) {
 		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
 		mnt_drop_write_file(file);
-		return -EINPROGRESS;
+		return -EINVAL;
 	}
 
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -2193,7 +2193,7 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
 		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-		return -EINPROGRESS;
+		return -EINVAL;
 	}
 	ret = mnt_want_write_file(file);
 	if (ret) {
@@ -2267,7 +2267,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
 		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-		return -EINPROGRESS;
+		return -EINVAL;
 	}
 
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -2304,7 +2304,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 			1)) {
 		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
 		mnt_drop_write_file(file);
-		return -EINPROGRESS;
+		return -EINVAL;
 	}
 
 	mutex_lock(&root->fs_info->volume_mutex);
-- 
1.7.9.1

