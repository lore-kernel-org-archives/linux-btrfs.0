Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34274 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbcCWSXV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 14:23:21 -0400
Received: by mail-qk0-f171.google.com with SMTP id p130so10355210qke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 11:23:20 -0700 (PDT)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com, jbacik@fb.com
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [RFC][PATCH] btrfs: allow balancing to dup with multi-device
Date: Wed, 23 Mar 2016 14:22:59 -0400
Message-Id: <1458757379-36299-1-git-send-email-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, we don't allow the user to try and rebalance to a dup profile
on a multi-device filesystem.  In most cases, this is a perfectly sensible
restriction as raid1 uses the same amount of space and provides better
protection.

However, when reshaping a multi-device filesystem down to a single device
filesystem, this requires the user to convert metadata and system chunks
to single profile before deleting devices, and then convert again to dup,
which leaves a period of time where metadata integrity is reduced.

This patch removes the single-device-only restriction from converting to
dup profile to remove this potential data integrity reduction.

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
A few years back I had sent a patch to do this to the ML, got asked to
rebase it, didn't have the time to do so then, and forgot about it as
the use case this caters to is not one that I have to deal with every day.

Recent discussion on the ML of using DUP for data on single devices,
combined with me having to preform a similar conversion on a filesystem
reminded me of this limitation, so I decided to redo the patch in a minimal
form and see what everyone's opinion of this was before going any further.
I intend to add something to warn when someone converts to dup on a
multi-device FS, but wanted to get some idea of whether the warning
should be from the kernel or userspace, and whether or not we should
require force for this or not (I'm personally indifferent on both counts).

 fs/btrfs/volumes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f9f33c..09ca950 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3682,10 +3682,8 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 		num_devices--;
 	}
 	btrfs_dev_replace_unlock(&fs_info->dev_replace, 0);
-	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
-	if (num_devices == 1)
-		allowed |= BTRFS_BLOCK_GROUP_DUP;
-	else if (num_devices > 1)
+	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE | BTRFS_BLOCK_GROUP_DUP;
+	if (num_devices > 1)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
 	if (num_devices > 2)
 		allowed |= BTRFS_BLOCK_GROUP_RAID5;
--
2.7.4

