From: Sergei Trofimovich <slyich@gmail.com>
Subject: [PATCH] btrfs: allow changing 'thread_pool' size at remount time
Date: Tue, 24 Apr 2012 20:26:44 +0300
Message-ID: <1335288404-11565-1-git-send-email-slyich@gmail.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
	Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Changing 'mount -oremount,thread_pool=2 /' didn't make any effect:

maximum amount of worker threads is specified in 2 places:
- in 'strict btrfs_fs_info::thread_pool_size'
- in each worker struct: 'struct btrfs_workers::max_workers'

'mount -oremount' updated only 'btrfs_fs_info::thread_pool_size'.

Fix it by pushing new maximum value to all created worker structures
as well.

Cc: Josef Bacik <josef@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
WARNING: This patch makes sense only with
WARNING:    "btrfs: fix early abort in 'remount'"
WARNING: sitting in Josef's -next branch.
 fs/btrfs/super.c |   38 +++++++++++++++++++++++++++++++++-----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2f28fc0..ed2dab9 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -435,11 +435,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_thread_pool:
 			intarg = 0;
 			match_int(&args[0], &intarg);
-			if (intarg) {
+			if (intarg)
 				info->thread_pool_size = intarg;
-				printk(KERN_INFO "btrfs: thread pool %d\n",
-				       info->thread_pool_size);
-			}
 			break;
 		case Opt_max_inline:
 			num = match_strdup(&args[0]);
@@ -1119,6 +1116,35 @@ error_fs_info:
 	return ERR_PTR(error);
 }
 
+static void btrfs_set_max_workers(struct btrfs_workers *workers, int new_limit)
+{
+	workers->max_workers = new_limit;
+}
+
+static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info, int new_pool_size, int old_pool_size)
+{
+	if (new_pool_size != old_pool_size) {
+		fs_info->thread_pool_size = new_pool_size;
+
+		printk(KERN_INFO "btrfs: resize thread pool %d -> %d\n", old_pool_size, new_pool_size);
+
+		btrfs_set_max_workers(&fs_info->generic_worker, new_pool_size);
+		btrfs_set_max_workers(&fs_info->workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->delalloc_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->submit_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->caching_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->fixup_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->endio_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->endio_meta_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->endio_meta_write_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->endio_write_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->endio_freespace_worker, new_pool_size);
+		btrfs_set_max_workers(&fs_info->delayed_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->readahead_workers, new_pool_size);
+		btrfs_set_max_workers(&fs_info->scrub_workers, new_pool_size);
+	}
+}
+
 static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
@@ -1138,6 +1164,8 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		goto restore;
 	}
 
+	btrfs_resize_thread_pool(fs_info, fs_info->thread_pool_size, old_thread_pool_size);
+
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
 
@@ -1181,7 +1209,7 @@ restore:
 	fs_info->compress_type = old_compress_type;
 	fs_info->max_inline = old_max_inline;
 	fs_info->alloc_start = old_alloc_start;
-	fs_info->thread_pool_size = old_thread_pool_size;
+	btrfs_resize_thread_pool(fs_info, old_thread_pool_size, fs_info->thread_pool_size);
 	fs_info->metadata_ratio = old_metadata_ratio;
 	return ret;
 }
-- 
1.7.8.5

