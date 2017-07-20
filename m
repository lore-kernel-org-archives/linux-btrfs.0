Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33945 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965416AbdGTWKn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 18:10:43 -0400
Received: by mail-pg0-f41.google.com with SMTP id 123so20254443pgj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 15:10:43 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: [PATCH RESEND] Btrfs: fix early ENOSPC due to delalloc
Date: Thu, 20 Jul 2017 15:10:35 -0700
Message-Id: <33ac56aa74691de6109709168939cfe9f56cbd70.1500588286.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

If a lot of metadata is reserved for outstanding delayed allocations, we
rely on shrink_delalloc() to reclaim metadata space in order to fulfill
reservation tickets. However, shrink_delalloc() has a shortcut where if
it determines that space can be overcommitted, it will stop early. This
made sense before the ticketed enospc system, but now it means that
shrink_delalloc() will often not reclaim enough space to fulfill any
tickets, leading to an early ENOSPC. (Reservation tickets don't care
about being able to overcommit, they need every byte accounted for.)

Fix it by getting rid of the shortcut so that shrink_delalloc() reclaims
all of the metadata it is supposed to. This fixes early ENOSPCs we were
seeing when doing a btrfs receive to populate a new filesystem, as well
as early ENOSPCs Christoph saw when doing a big cp -r onto Btrfs.

Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc infrastructure")
Tested-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: stable@vger.kernel.org
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Resending with the fixes tag, Cc: stable, Christoph's tested-by, and
some info about how Christoph hit the same issue. Nikolay also said it
helped slightly with some of his ENOSPC problems. Based on v4.13-rc1.
Can we get this in 4.13 and applied to stable?

 fs/btrfs/extent-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 375f8c728d91..5ef0cf399667 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4825,10 +4825,6 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 		else
 			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
-		if (can_overcommit(fs_info, space_info, orig, flush, false)) {
-			spin_unlock(&space_info->lock);
-			break;
-		}
 		if (list_empty(&space_info->tickets) &&
 		    list_empty(&space_info->priority_tickets)) {
 			spin_unlock(&space_info->lock);
-- 
2.13.3

