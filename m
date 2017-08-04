Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752081AbdHDUZS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Aug 2017 16:25:18 -0400
To: stable@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Subject: please include 17024ad0a0fd ("Btrfs: fix early ENOSPC due to
 delalloc") to 4.12 stable
Message-ID: <0992c84e-1ac5-2a89-65aa-c283bbd08f44@suse.com>
Date: Fri, 4 Aug 2017 23:25:14 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------7694D617FFA49253B48DFDE9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------7694D617FFA49253B48DFDE9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

I'd like to aforementioned patch to be applied to stable 4.9/4.12. The
attached backport applies cleanly to both of them.

--------------7694D617FFA49253B48DFDE9
Content-Type: text/x-patch;
 name="0001-Btrfs-fix-early-ENOSPC-due-to-delalloc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Btrfs-fix-early-ENOSPC-due-to-delalloc.patch"

>From 278e5d0839f4ecc6d7bfb7a95cb735b9034e8315 Mon Sep 17 00:00:00 2001
From: Omar Sandoval <osandov@fb.com>
Date: Thu, 20 Jul 2017 15:10:35 -0700
Subject: [PATCH] Btrfs: fix early ENOSPC due to delalloc

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
Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a8d6ad4042b7..adb285a93753 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4813,10 +4813,6 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		else
 			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
-		if (can_overcommit(root, space_info, orig, flush)) {
-			spin_unlock(&space_info->lock);
-			break;
-		}
 		if (list_empty(&space_info->tickets) &&
 		    list_empty(&space_info->priority_tickets)) {
 			spin_unlock(&space_info->lock);
-- 
2.7.4


--------------7694D617FFA49253B48DFDE9--
