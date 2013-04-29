Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:49076 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab3D2SJe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 14:09:34 -0400
From: henrikno@gmail.com
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Nordvik <henrikno@gmail.com>
Subject: [PATCH] Btrfs: fix check on same raid type flag twice
Date: Mon, 29 Apr 2013 20:09:23 +0200
Message-Id: <1367258963-27134-1-git-send-email-henrikno@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Henrik Nordvik <henrikno@gmail.com>

Code checked for raid 5 flag in two else-if branches, so code would never be reached. Probably a copy-paste bug.

Signed-off-by: Henrik Nordvik <henrikno@gmail.com>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d19a0a..19a327d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3141,7 +3141,7 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
 					    BTRFS_BLOCK_GROUP_RAID10)) {
 						num_tolerated_disk_barrier_failures = 1;
 					} else if (flags &
-						   BTRFS_BLOCK_GROUP_RAID5) {
+						   BTRFS_BLOCK_GROUP_RAID6) {
 						num_tolerated_disk_barrier_failures = 2;
 					}
 				}
-- 
1.8.1.2

