Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:19921 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212Ab2K0Rjx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 12:39:53 -0500
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.5 OK) with ESMTP id g04b21oARBKUgr
	for <linux-btrfs@vger.kernel.org>;
	Tue, 27 Nov 2012 18:39:52 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix a build warning for an unused label
Date: Tue, 27 Nov 2012 18:39:50 +0100
Message-Id: <1354037991-24564-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This issue was detected by the "0-DAY kernel build testing".

fs/btrfs/volumes.c: In function 'btrfs_rm_device':
fs/btrfs/volumes.c:1505:1: warning: label 'error_close' defined but not used [-Wunused-label]

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
This patch is only for btrfs-next.

 fs/btrfs/volumes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 012eb7a..69d1388 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1541,7 +1541,6 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 error_brelse:
 	brelse(bh);
-error_close:
 	if (bdev)
 		blkdev_put(bdev, FMODE_READ | FMODE_EXCL);
 out:
-- 
1.8.0.1

