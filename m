Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49792 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIYK3T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 06:29:19 -0400
Received: by mail-pa0-f53.google.com with SMTP id hz1so10482493pad.26
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 03:29:19 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] Btrfs: return failure if btrfs_dev_replace_finishing() failed
Date: Thu, 25 Sep 2014 18:28:14 +0800
Message-Id: <1411640894-5160-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

device replace could fail due to another running scrub process, but this
failure doesn't get returned to userspace.

The following steps could reproduce this issue

	mkfs -t btrfs -f /dev/sdb1 /dev/sdb2
	mount /dev/sdb1 /mnt/btrfs
	while true; do
		btrfs scrub start -B /mnt/btrfs >/dev/null 2>&1
	done &
	btrfs replace start -Bf /dev/sdb2 /dev/sdb3 /mnt/btrfs
	# if this replace succeeded, do the following and repeat until
	# you see this log in dmesg
	# BTRFS: btrfs_scrub_dev(/dev/sdb2, 2, /dev/sdb3) failed -115
	#btrfs replace start -Bf /dev/sdb3 /dev/sdb2 /mnt/btrfs

	# once you see the error log in dmesg, check return value of
	# replace
	echo $?

Also only WARN_ON if the return code is not -EINPROGRESS.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/btrfs/dev-replace.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index eea26e1..44d32ab 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -418,9 +418,11 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 			      &dev_replace->scrub_progress, 0, 1);
 
 	ret = btrfs_dev_replace_finishing(root->fs_info, ret);
-	WARN_ON(ret);
+	/* don't warn if EINPROGRESS, someone else might be running scrub */
+	if (ret != -EINPROGRESS)
+		WARN_ON(ret);
 
-	return 0;
+	return ret;
 
 leave:
 	dev_replace->srcdev = NULL;
@@ -538,7 +540,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 
-		return 0;
+		return scrub_ret;
 	}
 
 	printk_in_rcu(KERN_INFO
-- 
1.8.3.1

