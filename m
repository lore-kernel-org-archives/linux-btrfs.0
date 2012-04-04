From: Bobby Powers <bobbypowers@gmail.com>
Subject: [PATCH] Btrfs: remove BUG_ON from get_restripe_target
Date: Wed,  4 Apr 2012 16:19:34 -0400
Message-ID: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
Cc: Bobby Powers <bobbypowers@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <ak@linux.intel.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

spin_is_locked always returns 0 on non-SMP systems, which causes btrfs
to fail the mount.  There is documentation pending as to why checking
for spin_is_locked is a bad idea:

https://lkml.org/lkml/2012/3/27/413

As this was the only location in fs/btrfs/extent-tree.c that did
lock-correctness checking in a BUG_ON, simply remove it.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
CC: Ilya Dryomov <idryomov@gmail.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Andi Kleen <ak@linux.intel.com>
CC: linux-btrfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 fs/btrfs/extent-tree.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..c98b073 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3158,9 +3158,6 @@ static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
 	u64 target = 0;
 
-	BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
-	       !spin_is_locked(&fs_info->balance_lock));
-
 	if (!bctl)
 		return 0;
 
-- 
1.7.10.rc3.3.g19a6c
