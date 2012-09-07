Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:63103 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab2IGWBN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Sep 2012 18:01:13 -0400
From: Arne Jansen <sensille@gmx.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: philipp.andreas@gmail.com
Subject: [PATCH] Btrfs: btrfs_qgroup_inherit wrongly returns an error
Date: Sat,  8 Sep 2012 00:01:10 +0200
Message-Id: <1347055270-12090-1-git-send-email-sensille@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When using the V1-version of the snap/subvol creation ioctl
btrfs_qgroup_inherit wrongly returns an error because no inherit parameter
is given. Fix the return value.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/qgroup.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 38b42e7..090405d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1383,10 +1383,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		qgroup_dirty(fs_info, srcgroup);
 	}
 
-	if (!inherit) {
-		ret = -EINVAL;
+	if (!inherit)
 		goto unlock;
-	}
 
 	i_qgroups = (u64 *)(inherit + 1);
 	for (i = 0; i < inherit->num_qgroups; ++i) {
-- 
1.7.3.4

