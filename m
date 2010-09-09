From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: [PATCH] btrfs: Only BUG_ON when the errno is not ENOENT
Date: Thu,  9 Sep 2010 23:26:17 +0800
Message-ID: <1284045977-3704-1-git-send-email-zhu.yanhai@gmail.com>
Cc: vivian.zhang@intel.com, Zhu Yanhai <zhu.yanhai@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As Andi Kleen's commit 018db35864fd8d307066485a2753866240c3dace makes
btrfs_del_dir_entries_in_log() able to return the real errno instead of
a zero, we should only BUG_ON it when it's non-zero and not -ENOENT.

Signed-off-by: Zhu Yanhai <zhu.yanhai@gmail.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c038644..4016b1d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2651,7 +2651,7 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_del_dir_entries_in_log(trans, root, name, name_len,
 					   dir, index);
-	BUG_ON(ret);
+	BUG_ON(ret != 0 && ret != -ENOENT);
 err:
 	btrfs_free_path(path);
 	if (ret)
-- 
1.7.2.2

