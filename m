Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:43217 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3IMPtg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 11:49:36 -0400
Received: by mail-qc0-f180.google.com with SMTP id p19so997664qcv.11
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 08:49:36 -0700 (PDT)
From: Frank Holton <fholton@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Frank Holton <fholton@gmail.com>
Subject: [PATCH] btrfs: Add btrfs: prefix to kernel log output
Date: Fri, 13 Sep 2013 11:46:50 -0400
Message-Id: <1379087210-21012-1-git-send-email-fholton@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel log entries for device label %s and device fsid %pU
are missing the btrfs: prefix. Add those here.

Signed-off-by: Frank Holton <fholton@gmail.com>
---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a057735..0431147 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -912,9 +912,9 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	if (disk_super->label[0]) {
 		if (disk_super->label[BTRFS_LABEL_SIZE - 1])
 			disk_super->label[BTRFS_LABEL_SIZE - 1] = '\0';
-		printk(KERN_INFO "device label %s ", disk_super->label);
+		printk(KERN_INFO "btrfs: device label %s ", disk_super->label);
 	} else {
-		printk(KERN_INFO "device fsid %pU ", disk_super->fsid);
+		printk(KERN_INFO "btrfs: device fsid %pU ", disk_super->fsid);
 	}
 
 	printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
-- 
1.7.9.5

