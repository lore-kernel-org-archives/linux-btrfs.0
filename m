Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54898 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaBHPso (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 10:48:44 -0500
Received: by mail-pa0-f50.google.com with SMTP id kp14so4413600pab.37
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 07:48:43 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] Btrfs: skip readonly root for snapshot-aware defragment
Date: Sat,  8 Feb 2014 23:46:35 +0800
Message-Id: <1391874396-2273-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Btrfs send is assuming readonly root won't change, let's skip readonly root.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1af34d0..e8dfd83 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2239,6 +2239,11 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 		return PTR_ERR(root);
 	}
 
+	if (btrfs_root_readonly(root)) {
+		srcu_read_unlock(&fs_info->subvol_srcu, index);
+		return 0;
+	}
+
 	/* step 2: get inode */
 	key.objectid = backref->inum;
 	key.type = BTRFS_INODE_ITEM_KEY;
-- 
1.8.4

