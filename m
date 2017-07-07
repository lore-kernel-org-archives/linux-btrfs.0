Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34733 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbdGGF7f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 01:59:35 -0400
Received: by mail-pf0-f182.google.com with SMTP id q85so12019757pfq.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 22:59:35 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH] Btrfs: fix early ENOSPC due to delalloc
Date: Thu,  6 Jul 2017 22:59:27 -0700
Message-Id: <0cf8577381f6ebe99b584ca60f920c630000c343.1499407060.git.osandov@fb.com>
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
seeing when doing a btrfs receive to populate a new filesystem.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
I don't have a good reproducer for this except for the btrfs send stream
I was given by someone internally, unfortunately.

 fs/btrfs/extent-tree.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 33d979e9ea2a..83eecd33ad96 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4776,10 +4776,6 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
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
2.13.2

