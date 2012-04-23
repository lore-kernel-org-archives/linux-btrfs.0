From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not start delalloc inodes during sync
Date: Mon, 23 Apr 2012 14:34:20 -0400
Message-ID: <1335206060-8558-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_start_delalloc_inodes will just walk the list of delalloc inodes and
start writing them out, but it doesn't splice the list or anything so as
long as somebody is doing work on the box you could end up in this section
_forever_.  So just remove it, it's not needed anyway since sync will start
writeback on all inodes anyway, all we need to do is wait for ordered
extents and then we can commit the transaction.  In my horrible torture test
sync goes from taking 4 minutes to about 1.5 minutes.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ee1bb31..beeff20 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -819,7 +819,6 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_start_delalloc_inodes(root, 0);
 	btrfs_wait_ordered_extents(root, 0, 0);
 
 	trans = btrfs_start_transaction(root, 0);
-- 
1.7.7.6

