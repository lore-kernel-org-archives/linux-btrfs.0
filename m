From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: stop silently switching single chunks to raid0 on balance
Date: Wed, 29 Feb 2012 22:00:26 +0200
Message-ID: <1330545626-9009-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This has been causing a lot of confusion for quite a while now and a lot
of users were surprised by this (some of them were even stuck in a
ENOSPC situation which they couldn't easily get out of).  The addition
of restriper gives users a clear choice between raid0 and drive concat
setup so there's absolutely no excuse for us to keep doing this.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 37e0a80..e0969eb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7029,7 +7029,6 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 		if (flags & (BTRFS_BLOCK_GROUP_RAID1 |
 			     BTRFS_BLOCK_GROUP_RAID10))
 			return stripped | BTRFS_BLOCK_GROUP_DUP;
-		return flags;
 	} else {
 		/* they already had raid on here, just return */
 		if (flags & stripped)
@@ -7042,9 +7041,9 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 		if (flags & BTRFS_BLOCK_GROUP_DUP)
 			return stripped | BTRFS_BLOCK_GROUP_RAID1;
 
-		/* turn single device chunks into raid0 */
-		return stripped | BTRFS_BLOCK_GROUP_RAID0;
+		/* this is drive concat, leave it alone */
 	}
+
 	return flags;
 }
 
-- 
1.7.6.3

