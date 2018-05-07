Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:45724 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752307AbeEGImU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 04:42:20 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2 1/2] Btrfs: fiemap: pass correct bytenr when fm_extent_count is zero
Date: Mon,  7 May 2018 16:42:04 +0800
Message-Id: <1525682525-1424-2-git-send-email-robbieko@synology.com>
In-Reply-To: <1525682525-1424-1-git-send-email-robbieko@synology.com>
References: <1525682525-1424-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

[BUG]
fm_mapped_extents is not correct when fm_extent_count is 0
Like:
   # mount /dev/vdb5 /mnt/btrfs
   # dd if=/dev/zero bs=16K count=4 oflag=dsync of=/mnt/btrfs/file
   # xfs_io -c "fiemap -v" /mnt/btrfs/file
   /mnt/btrfs/file:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..127]:        25088..25215       128   0x1

When user space wants to get the number of file extents,
set fm_extent_count to 0 to run fiemap and then read fm_mapped_extents.

In the above example, fiemap will return with fm_mapped_extents set to 4,
but it should be 1 since there's only one entry in the output.

[REASON]
The problem seems to be that disko is only set if
fieinfo->fi_extents_max is set. And this member is initialized, in the
generic ioctl_fiemap function, to the value of used-passed
fm_extent_count. So when the user passes 0 then fi_extent_max is also
set to zero and this causes btrfs to not initialize disko at all.
Eventually this leads emit_fiemap_extent being called with a bogus
'phys' argument preventing proper fiemap entries merging.

[FIX]
Move the disko initialization earlier in extent_fiemap making it
independent of user-passed arguments, allowing emit_fiemap_extent to
properly handle consecutive extent entries.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
V2:
fix comments.

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

