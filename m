Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45090 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaEZJ1e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 05:27:34 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 3/4] btrfs: dev replace should replace the sysfs entry
Date: Mon, 26 May 2014 17:30:25 +0800
Message-Id: <1401096626-13210-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when we replace the device its corresponding sysfs
entry has to be replaced as well

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9f22905..f4f8728 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -36,6 +36,7 @@
 #include "check-integrity.h"
 #include "rcu-string.h"
 #include "dev-replace.h"
+#include "sysfs.h"
 
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				       int scrub_ret);
@@ -562,6 +563,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 
+	/* replace the sysfs entry */
+	rm_device_membership(fs_info, src_device);
+	add_device_membership(fs_info, tgt_device);
+
 	btrfs_rm_dev_replace_blocked(fs_info);
 
 	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
-- 
1.7.1

