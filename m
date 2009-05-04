From: Li Hong <lihong.hi@gmail.com>
Subject: [PATCH] btrfs: remove the improper comment for btrfs_ioctl_resize()
Date: Mon, 4 May 2009 01:05:28 -0400
Message-ID: <3a3680030905032205u2c3490e8r62e66c48aff97fee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In Li Zefan's commit dae7b665cf6d6e6e733f1c9c16cf55547dd37e33,
a combination call of kmalloc() and copy_from_user() is replaced by
memdup_user(). So btrfs_ioctl_resize() doesn't use GFP_NOFS any more.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 fs/btrfs/ioctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5e94ea6..2624b53 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -437,10 +437,6 @@ out_unlock:
 	return 0;
 }

-/*
- * Called inside transaction, so use GFP_NOFS
- */
-
 static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 {
 	u64 new_size;
-- 
1.6.2.1
