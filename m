Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:49589 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaKLQkf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 11:40:35 -0500
From: Martin Kepplinger <martink@posteo.de>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] btrfs: Don't check for file->private_data on open(). It is set by the core.
Date: Wed, 12 Nov 2014 17:38:28 +0100
Message-Id: <1415810308-24243-1-git-send-email-martink@posteo.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The miscdevice core now sets file->private_data to the struct miscdevice
so don't fail when this is not NULL.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
This is a question: what does this check provide and does overwriting
file->private_data make any difference?

Is miscdevice's open() by the user not allowed here, if file->private_data
is set?

thanks!!

 fs/btrfs/ioctl.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4399f0c..066ce41 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3752,10 +3752,6 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	if (!capable(CAP_SYS_ADMIN))
 		goto out;
 
-	ret = -EINPROGRESS;
-	if (file->private_data)
-		goto out;
-
 	ret = -EROFS;
 	if (btrfs_root_readonly(root))
 		goto out;
-- 
1.7.10.4

