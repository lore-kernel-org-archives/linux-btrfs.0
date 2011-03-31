From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: fix /proc/mounts info.
Date: Thu, 31 Mar 2011 09:44:29 +0900
Message-ID: <201103310044.AA00012@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Some mount options are not displayed by /proc/mounts.
This patch displays the option such as compress_type by /proc/mounts.

Ex.
  [before]
    $ mount | grep sdc2
    /dev/sdc2 on /test12 type btrfs (rw,space_cache,compress=lzo)
    $ cat /proc/mounts | grep sdc2
    /dev/sdc2 /test12 btrfs rw,relatime,compress 0 0

  [after]
    $ mount | grep sdc2
    /dev/sdc2 on /test12 type btrfs (rw,space_cache,compress=lzo)
    $ cat /proc/mounts | grep sdc2
    /dev/sdc2 /test12 btrfs rw,relatime,compress=lzo,space_cache 0 0

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/super.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -urNp linux-2.6.39-rc1/fs/btrfs/super.c linux-2.6.39-rc1.new/fs/btrfs/super.c
--- linux-2.6.39-rc1/fs/btrfs/super.c	2011-03-30 04:09:47.000000000 +0900
+++ linux-2.6.39-rc1.new/fs/btrfs/super.c	2011-03-31 09:16:55.000000000 +0900
@@ -644,6 +644,7 @@ static int btrfs_show_options(struct seq
 {
 	struct btrfs_root *root = btrfs_sb(vfs->mnt_sb);
 	struct btrfs_fs_info *info = root->fs_info;
+	char *compress_type;
 
 	if (btrfs_test_opt(root, DEGRADED))
 		seq_puts(seq, ",degraded");
@@ -662,8 +663,16 @@ static int btrfs_show_options(struct seq
 	if (info->thread_pool_size !=  min_t(unsigned long,
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
-	if (btrfs_test_opt(root, COMPRESS))
-		seq_puts(seq, ",compress");
+	if (btrfs_test_opt(root, COMPRESS)) {
+		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
+			compress_type = "zlib";
+		else
+			compress_type = "lzo";
+		if (btrfs_test_opt(root, FORCE_COMPRESS))
+			seq_printf(seq, ",compress-force=%s", compress_type);
+		else
+			seq_printf(seq, ",compress=%s", compress_type);
+	}
 	if (btrfs_test_opt(root, NOSSD))
 		seq_puts(seq, ",nossd");
 	if (btrfs_test_opt(root, SSD_SPREAD))
@@ -678,6 +687,12 @@ static int btrfs_show_options(struct seq
 		seq_puts(seq, ",discard");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
+	if (btrfs_test_opt(root, SPACE_CACHE))
+		seq_puts(seq, ",space_cache");
+	if (btrfs_test_opt(root, CLEAR_CACHE))
+		seq_puts(seq, ",clear_cache");
+	if (btrfs_test_opt(root, USER_SUBVOL_RM_ALLOWED))
+		seq_puts(seq, ",user_subvol_rm_allowed");
 	return 0;
 }
 

