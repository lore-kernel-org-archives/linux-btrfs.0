Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55017 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3ATPWr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 10:22:47 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so1448712eaa.30
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jan 2013 07:22:45 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>, idryomov@gmail.com
Subject: [PATCH 4/5] Btrfs: fix unlock order in btrfs_ioctl_rm_dev
Date: Sun, 20 Jan 2013 17:22:31 +0200
Message-Id: <1358695352-7140-5-git-send-email-idryomov@gmail.com>
In-Reply-To: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
References: <1358695352-7140-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix unlock order in btrfs_ioctl_rm_dev().

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b9a0190..9c079dd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2320,8 +2320,8 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
-	mnt_drop_write_file(file);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
+	mnt_drop_write_file(file);
 	return ret;
 }
 
-- 
1.7.9.1

