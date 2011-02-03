From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] btrfs: cleanup error handling in btrfs_unlink_inode()
Date: Thu, 03 Feb 2011 12:16:25 +0900
Message-ID: <4D4A1E09.10901@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: Chris Mason <chris.mason@oracle.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_alloc_path() fails, btrfs_free_path() need not be called.
Therefore, it changes the branch ahead.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urNp linux-2.6.38-rc3/fs/btrfs/inode.c linux-2.6.38-rc3.test/fs/btrfs/inode.c
--- linux-2.6.38-rc3/fs/btrfs/inode.c	2011-02-01 12:05:49.000000000 +0900
+++ linux-2.6.38-rc3.test/fs/btrfs/inode.c	2011-02-03 11:25:47.000000000 +0900
@@ -2641,7 +2641,7 @@ int btrfs_unlink_inode(struct btrfs_tran
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
-		goto err;
+		goto out;
 	}
 
 	path->leave_spinning = 1;


