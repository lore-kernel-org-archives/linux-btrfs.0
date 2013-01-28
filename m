Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from msa102.auone-net.jp ([61.117.18.162]:41313 "EHLO
	msa102.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab3A1Lkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 06:40:36 -0500
Date: Mon, 28 Jan 2013 20:33:31 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: Check CAP_DAC_READ_SEARCH for BTRFS_IOC_INO_PATHS
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <20130128113332.3B4B76AC03A@msa102.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CAP_DAC_READ_SEARCH overrides read and search permission check on
file and directory. It seems fit for BTRFS_IOC_INO_PATHS.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5b22d45..2d6e3e1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3286,7 +3286,7 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 	struct inode_fs_paths *ipath = NULL;
 	struct btrfs_path *path;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_DAC_READ_SEARCH))
 		return -EPERM;
 
 	path = btrfs_alloc_path();
-- 
1.7.10.4

