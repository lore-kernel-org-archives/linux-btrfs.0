From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] Btrfs: remove lock assert from get_restripe_target()
Date: Mon,  9 Apr 2012 18:27:13 +0300
Message-ID: <1333985233-2804-1-git-send-email-idryomov@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	idryomov@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This fixes a regression introduced by fc67c450.  spin_is_locked() always
returns 0 on UP kernels, which caused assert in get_restripe_target() to
be fired on every call from btrfs_reduce_alloc_profile() on UP systems.
Remove it completely for now, it's not clear if it's going to be needed
in future.

Reported-by: Bobby Powers <bobbypowers@gmail.com>
Reported-by: Mitch Harder <mitch.harder@sabayonlinux.org>
Tested-by: Mitch Harder <mitch.harder@sabayonlinux.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/extent-tree.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a844204..8db0884 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3152,15 +3152,14 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 /*
  * returns target flags in extended format or 0 if restripe for this
  * chunk_type is not in progress
+ *
+ * should be called with either volume_mutex or balance_lock held
  */
 static u64 get_restripe_target(struct btrfs_fs_info *fs_info, u64 flags)
 {
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
 	u64 target = 0;
 
-	BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
-	       !spin_is_locked(&fs_info->balance_lock));
-
 	if (!bctl)
 		return 0;
 
-- 
1.7.9.1

