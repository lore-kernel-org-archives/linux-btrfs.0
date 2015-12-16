Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:57146 "EHLO
	mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbbLPDI2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 22:08:28 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 18BD6AC00C6
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 11:58:00 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3051.s.css.fujitsu.com (Postfix) with SMTP id EC21ADD
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 11:57:59 +0900 (JST)
Message-Id: <201512160257.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 16 Dec 2015 11:57:38 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix output of compression message in btrfs_parse_options()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The compression message might not be correctly output.
Fix it.

[[before fix]]

# mount -o compress /dev/sdb3 /test3
[  996.874264] BTRFS info (device sdb3): disk space caching is enabled
[  996.874268] BTRFS: has skinny extents
# mount | grep /test3
/dev/sdb3 on /test3 type btrfs (rw,relatime,compress=zlib,space_cache,subvolid=5,subvol=/)

# mount -o remount,compress-force /dev/sdb3 /test3
[ 1035.075017] BTRFS info (device sdb3): force zlib compression
[ 1035.075021] BTRFS info (device sdb3): disk space caching is enabled
# mount | grep /test3
/dev/sdb3 on /test3 type btrfs (rw,relatime,compress-force=zlib,space_cache,subvolid=5,subvol=/)

# mount -o remount,compress /dev/sdb3 /test3
[ 1053.679092] BTRFS info (device sdb3): disk space caching is enabled
[root@luna compress-info]# mount | grep /test3
/dev/sdb3 on /test3 type btrfs (rw,relatime,compress=zlib,space_cache,subvolid=5,subvol=/)

[[after fix]]

# mount -o compress /dev/sdb3 /test3
[  401.021753] BTRFS info (device sdb3): use zlib compression
[  401.021758] BTRFS info (device sdb3): disk space caching is enabled
[  401.021760] BTRFS: has skinny extents
# mount | grep /test3
/dev/sdb3 on /test3 type btrfs (rw,relatime,compress=zlib,space_cache,subvolid=5,subvol=/)

# mount -o remount,compress-force /dev/sdb3 /test3
[  439.824624] BTRFS info (device sdb3): force zlib compression
[  439.824629] BTRFS info (device sdb3): disk space caching is enabled
# mount | grep /test3
/dev/sdb3 on /test3 type btrfs (rw,relatime,compress-force=zlib,space_cache,subvolid=5,subvol=/)

# mount -o remount,compress /dev/sdb3 /test3
[  459.918430] BTRFS info (device sdb3): use zlib compression
[  459.918434] BTRFS info (device sdb3): disk space caching is enabled
# mount | grep /test3
/dev/sdb3 on /test3 type btrfs (rw,relatime,compress=zlib,space_cache,subvolid=5,subvol=/)

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/disk-io.c |  2 +-
 fs/btrfs/super.c   | 21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 974be09..dcc1f15 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2709,7 +2709,7 @@ int open_ctree(struct super_block *sb,
 	 * In the long term, we'll store the compression type in the super
 	 * block, and it'll be used for per file compression control.
 	 */
-	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
+	fs_info->compress_type = BTRFS_COMPRESS_NONE;
 
 	ret = btrfs_parse_options(tree_root, options);
 	if (ret) {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 24154e4..e2e8a54 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -381,6 +381,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 	int ret = 0;
 	char *compress_type;
 	bool compress_force = false;
+	enum btrfs_compression_type saved_compress_type;
+	bool saved_compress_force;
 
 	cache_gen = btrfs_super_cache_generation(root->fs_info->super_copy);
 	if (cache_gen)
@@ -458,6 +460,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			/* Fallthrough */
 		case Opt_compress:
 		case Opt_compress_type:
+			saved_compress_type = info->compress_type;
+			saved_compress_force =
+				btrfs_test_opt(root, FORCE_COMPRESS);
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
 			    strcmp(args[0].from, "zlib") == 0) {
@@ -475,6 +480,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
+				info->compress_type = BTRFS_COMPRESS_NONE;
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 				compress_force = false;
@@ -484,14 +490,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			}
 
 			if (compress_force) {
-				btrfs_set_and_info(root, FORCE_COMPRESS,
-						   "force %s compression",
-						   compress_type);
+				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
 			} else {
-				if (!btrfs_test_opt(root, COMPRESS))
-					btrfs_info(root->fs_info,
-						   "btrfs: use %s compression",
-						   compress_type);
 				/*
 				 * If we remount from compress-force=xxx to
 				 * compress=xxx, we need clear FORCE_COMPRESS
@@ -500,6 +500,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				 */
 				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 			}
+			if (info->compress_type != saved_compress_type ||
+			    compress_force != saved_compress_force)
+				btrfs_info(root->fs_info,
+					   "%s %s compression",
+					   (compress_force) ? "force" : "use",
+					   compress_type);
+			compress_force = false;
 			break;
 		case Opt_ssd:
 			btrfs_set_and_info(root, SSD,
-- 
2.4.5

