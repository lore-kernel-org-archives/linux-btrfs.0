Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50626 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2ITOnE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 10:43:04 -0400
Received: by eekc1 with SMTP id c1so975672eek.19
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 07:43:01 -0700 (PDT)
From: Andrei Popa <andrei.popa@i-neo.ro>
To: linux-btrfs@vger.kernel.org
Cc: Andrei Popa <andrei.popa@i-neo.ro>
Subject: [PATCH] Btrfs: make compress and nodatacow mount options mutually exclusive
Date: Thu, 20 Sep 2012 17:42:11 +0300
Message-Id: <1348152131-24198-1-git-send-email-andrei.popa@i-neo.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a filesystem is mounted with compression and then remounted by adding nodatacow,
the compression is disabled but the compress flag is still visible.
Also, if a filesystem is mounted with nodatacow and then remounted with compression,
nodatacow flag is still present but it's not active.
This patch:
- removes compress flags and notifies that the compression has been disabled if the
  filesystem is mounted with nodatacow
- removes nodatacow and nodatasum flags if mounted with compress.

Signed-off-by: Andrei Popa <andrei.popa@i-neo.ro>
---
 fs/btrfs/super.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 073c236..6c72832 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -382,7 +382,15 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_nodatacow:
-			printk(KERN_INFO "btrfs: setting nodatacow\n");
+			if (!btrfs_test_opt(root, COMPRESS) ||
+				!btrfs_test_opt(root, FORCE_COMPRESS)) {
+					printk(KERN_INFO "btrfs: setting nodatacow, compression disabled\n");
+			} else {
+				printk(KERN_INFO "btrfs: setting nodatacow\n");
+			}
+			info->compress_type = BTRFS_COMPRESS_NONE;
+			btrfs_clear_opt(info->mount_opt, COMPRESS);
+			btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
 			btrfs_set_opt(info->mount_opt, NODATACOW);
 			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
@@ -397,10 +405,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_clear_opt(info->mount_opt, NODATACOW);
+				btrfs_clear_opt(info->mount_opt, NODATASUM);
 			} else if (strcmp(args[0].from, "lzo") == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_clear_opt(info->mount_opt, NODATACOW);
+				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
-- 
1.7.8.6

