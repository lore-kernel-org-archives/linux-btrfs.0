Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49346 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754696AbdGNRgm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 13:36:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DC73AAB22
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 17:36:40 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/5] btrfs: simplify btrfs_dev_replace_kthread
Date: Fri, 14 Jul 2017 19:35:27 +0200
Message-Id: <deedc2f066ddfd754cc391a9a11ca5bc722ea6c0.1500053599.git.dsterba@suse.com>
In-Reply-To: <cover.1500053599.git.dsterba@suse.com>
References: <cover.1500053599.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function prints an informative message and then continues
dev-replace. The message contains a progress percentage which is read
from the status. The status is allocated dynamically, about 2600 bytes,
just to read the single value. That's an overkill. We'll use the new
helper and drop the allocation.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 31d01eefecd0..7a93a3e1a847 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -809,25 +809,19 @@ static int btrfs_dev_replace_kthread(void *data)
 {
 	struct btrfs_fs_info *fs_info = data;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
-	struct btrfs_ioctl_dev_replace_args *status_args;
 	u64 progress;
 
-	status_args = kzalloc(sizeof(*status_args), GFP_KERNEL);
-	if (status_args) {
-		btrfs_dev_replace_status(fs_info, status_args);
-		progress = status_args->status.progress_1000;
-		kfree(status_args);
-		progress = div_u64(progress, 10);
-		btrfs_info_in_rcu(fs_info,
-			"continuing dev_replace from %s (devid %llu) to %s @%u%%",
-			dev_replace->srcdev->missing ? "<missing disk>" :
-			rcu_str_deref(dev_replace->srcdev->name),
-			dev_replace->srcdev->devid,
-			dev_replace->tgtdev ?
-			rcu_str_deref(dev_replace->tgtdev->name) :
-			"<missing target disk>",
-			(unsigned int)progress);
-	}
+	progress = btrfs_dev_replace_progress(fs_info);
+	progress = div_u64(progress, 10);
+	btrfs_info_in_rcu(fs_info,
+		"continuing dev_replace from %s (devid %llu) to %s @%u%%",
+		dev_replace->srcdev->missing ? "<missing disk>"
+			: rcu_str_deref(dev_replace->srcdev->name),
+		dev_replace->srcdev->devid,
+		dev_replace->tgtdev ? rcu_str_deref(dev_replace->tgtdev->name)
+			: "<missing target disk>",
+		(unsigned int)progress);
+
 	btrfs_dev_replace_continue_on_mount(fs_info);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 
-- 
2.13.0

