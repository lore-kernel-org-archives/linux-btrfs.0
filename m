From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/6] Btrfs: fix unreleased path in btrfs_orphan_cleanup()
Date: Thu, 10 Nov 2011 14:27:46 +0800
Message-ID: <4EBB6EE2.4070405@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When we did stress test for the space relocation, the deadlock happened.
By debugging, We found it was caused by the carelessness that we forgot
to unlock the read lock of the extent buffers in btrfs_orphan_cleanup()
before we end the transaction handle, so the transaction commit task waited
the task, which called btrfs_orphan_cleanup(), to unlock the extent buffer,
but that task waited the commit task to end the transaction commit, and
the deadlock happened. Fix it.

Signed-ff-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c5dd958..d7cd558 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2203,6 +2203,9 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		if (ret)
 			goto out;
 	}
+	/* release the path since we're done with it */
+	btrfs_release_path(path);
+
 	root->orphan_cleanup_state = ORPHAN_CLEANUP_DONE;
 
 	if (root->orphan_block_rsv)
-- 
1.7.6.4
