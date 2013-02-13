Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:40874 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3BMU7q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 15:59:46 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so655266eaa.9
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 12:59:45 -0800 (PST)
From: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 2/2] Correct allowed raid levels on balance.
Date: Wed, 13 Feb 2013 21:59:24 +0100
Message-Id: <bca12b9b526a45e705a19ccb08418990bb767707.1360786936.git.philipp.andreas@gmail.com>
In-Reply-To: <cover.1360786935.git.philipp.andreas@gmail.com>
References: <cover.1360786935.git.philipp.andreas@gmail.com>
In-Reply-To: <cover.1360786935.git.philipp.andreas@gmail.com>
References: <cover.1360786935.git.philipp.andreas@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Raid5 with 3 devices is well defined while the old logic allowed
raid5 only with a minimum of 4 devices when converting the block group
profile via btrfs balance. Creating a raid5 with just three devices
using mkfs.btrfs worked always as expected. This is now fixed and the
whole logic is rewritten.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 fs/btrfs/volumes.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8818dc3..6885165 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3046,13 +3046,12 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	allowed = BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 	if (num_devices == 1)
 		allowed |= BTRFS_BLOCK_GROUP_DUP;
-	else if (num_devices < 4)
+	if (num_devices > 1)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
-	else
-		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1 |
-				BTRFS_BLOCK_GROUP_RAID10 |
-				BTRFS_BLOCK_GROUP_RAID5 |
-				BTRFS_BLOCK_GROUP_RAID6);
+	if (num_devices > 2)
+		allowed |= BTRFS_BLOCK_GROUP_RAID5;
+	if (num_devices > 3)
+		allowed |= (BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_RAID6);
 
 	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->data.target, 1) ||
-- 
1.7.12.4

