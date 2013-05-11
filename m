Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59517 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3EKLNK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 07:13:10 -0400
Received: by mail-ee0-f45.google.com with SMTP id l10so917527eei.4
        for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 04:13:08 -0700 (PDT)
Message-ID: <518E27BF.8000507@gmail.com>
Date: Sat, 11 May 2013 13:13:03 +0200
From: Andreas Philipp <philipp.andreas@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Marcus_L=F6vgren?= <marcuslvgrn@gmail.com>,
        Remco Hosman - Yerf IT <remco@yerf-it.nl>
CC: Andreas Philipp <philipp.andreas@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH RESEND 2/2] Correct allowed raid levels on balance.
References: <cover.1360786935.git.philipp.andreas@gmail.com>, <cover.1360786935.git.philipp.andreas@gmail.com>
In-Reply-To: <cover.1360786935.git.philipp.andreas@gmail.com>
In-Reply-To: 518E278D.6070508@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
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
@@ -3046,13 +3046,12 @@ int btrfs_balance(struct btrfs_balance_control
*bctl,
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

