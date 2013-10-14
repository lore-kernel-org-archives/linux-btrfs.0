Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:55542 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3JNPX1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 11:23:27 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] btrfs: simplify kmalloc+copy_from_user to memdup_user
Date: Mon, 14 Oct 2013 12:18:25 -0300
Message-Id: <1381763905-18803-1-git-send-email-geyslan@gmail.com>
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

