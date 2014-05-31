Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:54672 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbaEaXsw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:52 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so3489538wes.41
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:51 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 8/8] Btrfs: Check for compress=lz4 in mount options
Date: Sat, 31 May 2014 23:48:36 +0000
Message-Id: <1401580116-10458-9-git-send-email-philip.worrall@googlemail.com>
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Check whether the user has set compress=lz4 in the mount options
and if so set the compress method to lz4.

Signed-off-by: Philip Worrall <philip.worrall@googlemail.com>
---
 fs/btrfs/super.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d4878dd..a348734 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -506,6 +506,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				btrfs_set_fs_incompat(info, COMPRESS_LZO);
+			} else if (strcmp(args[0].from, "lz4") == 0) {
+				printk(KERN_WARNING "BTRFS: Using LZ4 compression\n");
+				compress_type = "lz4";
+				info->compress_type = BTRFS_COMPRESS_LZ4;
+				btrfs_set_opt(info->mount_opt, COMPRESS);
+				btrfs_clear_opt(info->mount_opt, NODATACOW);
+				btrfs_clear_opt(info->mount_opt, NODATASUM);
+				btrfs_set_fs_incompat(info, COMPRESS_LZ4);
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				btrfs_clear_opt(info->mount_opt, COMPRESS);
@@ -1035,8 +1043,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 	if (btrfs_test_opt(root, COMPRESS)) {
 		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
 			compress_type = "zlib";
-		else
+		else if (info->compress_type == BTRFS_COMPRESS_LZO)
 			compress_type = "lzo";
+		else
+			compress_type = "lz4";
 		if (btrfs_test_opt(root, FORCE_COMPRESS))
 			seq_printf(seq, ",compress-force=%s", compress_type);
 		else
-- 
1.9.1

