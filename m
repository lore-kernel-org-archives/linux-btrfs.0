Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:8498 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab2JOS2s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 14:28:48 -0400
From: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs: send correct rdev and mode in btrfs-send
Date: Mon, 15 Oct 2012 20:28:46 +0200
Message-Id: <1350325726-6306-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When sending a device file, the stream was missing the mode. Also the
rdev was encoded wrongly.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/send.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c7beb54..57933e8 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2430,7 +2430,8 @@ verbose_printk("btrfs: send_create_inode %llu\n", ino);
 		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH_LINK, p);
 	} else if (S_ISCHR(mode) || S_ISBLK(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
-		TLV_PUT_U64(sctx, BTRFS_SEND_A_RDEV, rdev);
+		TLV_PUT_U64(sctx, BTRFS_SEND_A_RDEV, new_encode_dev(rdev));
+		TLV_PUT_U64(sctx, BTRFS_SEND_A_MODE, mode);
 	}
 
 	ret = send_cmd(sctx);
-- 
1.7.3.4

