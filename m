From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: reinitialize scrub workers
Date: Fri, 10 Jun 2011 12:19:49 +0200
Message-ID: <1307701189-10297-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Scrub starts the workers each time a scrub starts and stops them after it
finished. This patch adds an initialization for the workers before each
start, otherwise the workers behave strangely.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c |    2 --
 fs/btrfs/scrub.c   |    6 +++++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a203d36..7bbbfeb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1668,8 +1668,6 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	init_waitqueue_head(&fs_info->scrub_pause_wait);
 	init_rwsem(&fs_info->scrub_super_lock);
 	fs_info->scrub_workers_refcnt = 0;
-	btrfs_init_workers(&fs_info->scrub_workers, "scrub",
-			   fs_info->thread_pool_size, &fs_info->generic_worker);
 
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d5a4108..92cac19 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1166,8 +1166,12 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_root *root)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	mutex_lock(&fs_info->scrub_lock);
-	if (fs_info->scrub_workers_refcnt == 0)
+	if (fs_info->scrub_workers_refcnt == 0) {
+		btrfs_init_workers(&fs_info->scrub_workers, "scrub",
+			   fs_info->thread_pool_size, &fs_info->generic_worker);
+		fs_info->scrub_workers.idle_thresh = 4;
 		btrfs_start_workers(&fs_info->scrub_workers, 1);
+	}
 	++fs_info->scrub_workers_refcnt;
 	mutex_unlock(&fs_info->scrub_lock);
 
-- 
1.7.3.4

