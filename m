Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52728 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab2FWIIG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 04:08:06 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3165053obb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 01:08:05 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH 5/5] btrfs: enable lz4/lz4hc compression
Date: Sat, 23 Jun 2012 04:05:48 -0400
Message-Id: <1340438748-348-6-git-send-email-andrew.mahone@gmail.com>
In-Reply-To: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
References: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>
---
 fs/btrfs/compression.c | 2 ++
 fs/btrfs/compression.h | 2 ++
 fs/btrfs/super.c       | 6 ------
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 86eff48..3ed7251 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -733,6 +733,8 @@ static wait_queue_head_t comp_workspace_wait[BTRFS_COMPRESS_TYPES];
 struct btrfs_compress_op *btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
+	&btrfs_lz4_compress,
+	&btrfs_lz4hc_compress,
 };
 
 void __init btrfs_init_compress(void)
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 9afb0a6..2a43913 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -79,5 +79,7 @@ struct btrfs_compress_op {
 
 extern struct btrfs_compress_op btrfs_zlib_compress;
 extern struct btrfs_compress_op btrfs_lzo_compress;
+extern struct btrfs_compress_op btrfs_lz4_compress;
+extern struct btrfs_compress_op btrfs_lz4hc_compress;
 
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5824886..af6f429 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -405,16 +405,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				compress_type = "lz4";
 				info->compress_type = BTRFS_COMPRESS_LZ4;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
-				/* remove when implemented */
-				ret = -EINVAL;
-				goto out;
 			} else if (strcmp(args[0].from, "lz4hc") == 0) {
 				compress_type = "lz4hc";
 				info->compress_type = BTRFS_COMPRESS_LZ4HC;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
-				/* remove when implemented */
-				ret = -EINVAL;
-				goto out;
 			} else if (strncmp(args[0].from, "no", 2) == 0) {
 				compress_type = "no";
 				info->compress_type = BTRFS_COMPRESS_NONE;
-- 
1.7.11

