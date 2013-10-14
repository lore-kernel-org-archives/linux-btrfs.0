Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48084 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3JNPSx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 11:18:53 -0400
Received: by mail-vb0-f46.google.com with SMTP id p13so4567797vbe.33
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 08:18:53 -0700 (PDT)
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.or,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] btrfs: simplify kmalloc+copy_from_user to memdup_user
Date: Mon, 14 Oct 2013 12:14:13 -0300
Message-Id: <1381763653-18376-1-git-send-email-geyslan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use memdup_user rather than duplicating its implementation
This is a little bit restricted to reduce false positives

The semantic patch that makes this report is available
in scripts/coccinelle/api/memdup_user.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/btrfs/ioctl.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d46f60..f0e3517 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2727,15 +2727,10 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	size = sizeof(tmp) +
 		tmp.dest_count * sizeof(struct btrfs_ioctl_same_extent_info);
 
-	same = kmalloc(size, GFP_NOFS);
-	if (!same) {
-		ret = -EFAULT;
-		goto out;
-	}
+	same = memdup_user((struct btrfs_ioctl_same_args __user *)argp, size);
 
-	if (copy_from_user(same,
-			   (struct btrfs_ioctl_same_args __user *)argp, size)) {
-		ret = -EFAULT;
+	if (IS_ERR(same)) {
+		ret = PTR_ERR(same);
 		goto out;
 	}
 
-- 
1.8.4

