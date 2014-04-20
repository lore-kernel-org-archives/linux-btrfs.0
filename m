Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:26829 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755321AbaDTNR4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 09:17:56 -0400
Date: Sun, 20 Apr 2014 16:17:53 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fsck: fix double free memory crash
Message-ID: <20140420131751.GA5921@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix double free of memory if btrfs_open_devices fails:
*** Error in `btrfs': double free or corruption (fasttop): 0x000000000066e020 ***

Crash happened because when open failed on device inside
btrfs_open_devices it freed all memory by calling btrfs_close_devices but
inside disk-io.c we call btrfs_close_again it again.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 disk-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 19b95a7..8db0335 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1091,8 +1091,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	ret = btrfs_open_devices(fs_devices, oflags);
 	if (ret)
-		goto out_devices;
-
+		goto out;
 
 	disk_super = fs_info->super_copy;
 	if (!(flags & OPEN_CTREE_RECOVER_SUPER))
-- 
1.8.5.3

