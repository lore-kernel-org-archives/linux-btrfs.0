From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: reserve sufficient space for ioctl clone
Date: Tue,  9 Aug 2011 10:46:37 -0700
Message-ID: <1312911997-5075-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fix a crash/BUG_ON in the clone ioctl due to insufficient reservation. We
need to reserve space for:

 - adjusting the old extent (possibly splitting it)
 - adding the new extent
 - updating the inode

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a3c4751..f038d4a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2320,7 +2320,12 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			else
 				new_key.offset = destoff;
 
-			trans = btrfs_start_transaction(root, 1);
+			/*
+			 * 1 - adjusting old extent (we may have to split it)
+			 * 1 - add new extent
+			 * 1 - inode update
+			 */
+			trans = btrfs_start_transaction(root, 3);
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
 				goto out;
-- 
1.7.0

