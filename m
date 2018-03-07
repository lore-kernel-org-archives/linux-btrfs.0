Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:37483 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933209AbeCGIVG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 03:21:06 -0500
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 1/2] Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero
Date: Wed,  7 Mar 2018 16:20:18 +0800
Message-Id: <1520410819-32405-2-git-send-email-robbieko@synology.com>
In-Reply-To: <1520410819-32405-1-git-send-email-robbieko@synology.com>
References: <1520410819-32405-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

 # mount /dev/vdb5 /mnt/btrfs
 # dd if=/dev/zero bs=16K count=4 oflag=dsync of=/mnt/btrfs/file
 # xfs_io -c "fiemap -v" /mnt/btrfs/file
 /mnt/btrfs/file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        25088..25215       128   0x1

Run fiemap with fm_extent_count set to 0, we'll get wrong value 4
instead of 1.

[REASON]
When fm_extent_count is 0, disko is not initialized correctly,
The value is 0 in this case, not the right bytenr.

[FIX]
Use correct disko.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/extent_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 012d638..066b6df 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4567,7 +4567,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			offset_in_extent = em_start - em->start;
 		em_end = extent_map_end(em);
 		em_len = em_end - em_start;
-		disko = 0;
+		disko = em->block_start + offset_in_extent;
 		flags = 0;

 		/*
@@ -4590,8 +4590,6 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			u64 bytenr = em->block_start -
 				(em->start - em->orig_start);

-			disko = em->block_start + offset_in_extent;
-
 			/*
 			 * As btrfs supports shared space, this information
 			 * can be exported to userspace tools via
--
1.9.1

