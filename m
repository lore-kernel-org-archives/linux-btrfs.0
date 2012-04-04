From: Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] Btrfs: allow mount -o remount,compress=no
Date: Wed,  4 Apr 2012 21:46:17 +0200
Message-ID: <1333568777-16986-1-git-send-email-arnd@arndnet.de>
Cc: Arnd Hannemann <arnd@arndnet.de>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs allows to turn on compression on a mounted and used filesystem
by issuing mount -o remount,compress=lzo.
This patch allows to turn compression off again
while the filesystem is mounted.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 fs/btrfs/super.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8d5d380..f1fb6c0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -394,15 +394,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			    strcmp(args[0].from, "zlib") == 0) {
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
 			} else if (strcmp(args[0].from, "lzo") == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+			} else if (strncmp(args[0].from, "no", 2) == 0) {
+				compress_type = "no";
+				info->compress_type = BTRFS_COMPRESS_NONE;
+				btrfs_clear_opt(info->mount_opt, COMPRESS);
 			} else {
 				ret = -EINVAL;
 				goto out;
 			}
 
-			btrfs_set_opt(info->mount_opt, COMPRESS);
 			if (compress_force) {
 				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
 				pr_info("btrfs: force %s compression\n",
-- 
1.7.9.1
