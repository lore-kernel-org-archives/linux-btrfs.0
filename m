Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:31847 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158Ab3CDR7E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 12:59:04 -0500
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp4) (RZmta 31.19 OK)
	with ESMTP id 60350dp24GoNyn for <linux-btrfs@vger.kernel.org>;
	Mon, 4 Mar 2013 18:28:38 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: allow running defrag in parallel to administrative tasks
Date: Mon,  4 Mar 2013 18:28:38 +0100
Message-Id: <1362418118-20277-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5ac00add added a testnset mutex and code that disallows
running administrative tasks in parallel. It is prevented that
the device add/delete/balance/replace/resize operations are
started in parallel. By mistake, the defragmentation operation
was included in the check for mutually exclusiveness as well.
This is fixed with this commit.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ioctl.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b908960..40631cf 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2245,13 +2245,6 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 	if (ret)
 		return ret;
 
-	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
-			1)) {
-		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
-		mnt_drop_write_file(file);
-		return -EINVAL;
-	}
-
 	if (btrfs_root_readonly(root)) {
 		ret = -EROFS;
 		goto out;
@@ -2306,7 +2299,6 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 		ret = -EINVAL;
 	}
 out:
-	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 	mnt_drop_write_file(file);
 	return ret;
 }
-- 
1.8.1.5

