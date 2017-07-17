Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751377AbdGQQYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 12:24:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64693AAB9
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jul 2017 16:23:37 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: prepare for extensions in compression options
Date: Mon, 17 Jul 2017 18:22:22 +0200
Message-Id: <20170717162222.16926-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a minimal patch intended to be backported to older kernels.
We're going to extend the string specifying the compression method and
this would fail on kernels before that change (the string is compared
exactly).

Relax the string matching only to the prefix, ie. ignoring anything that
goes after "zlib" or "lzo", regardless of th format extension we decide
to use. This applies to the mount options and properties.

That way, patched old kernels could be booted on systems already
utilizing the new compression spec.

Applicable since commit 63541927c8d11, v3.14.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/props.c | 4 ++--
 fs/btrfs/super.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 4b23ae5d0e5c..f41654f05719 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -408,9 +408,9 @@ static int prop_compression_apply(struct inode *inode,
 		return 0;
 	}
 
-	if (!strncmp("lzo", value, len))
+	if (!strncmp("lzo", value, 3))
 		type = BTRFS_COMPRESS_LZO;
-	else if (!strncmp("zlib", value, len))
+	else if (!strncmp("zlib", value, 4))
 		type = BTRFS_COMPRESS_ZLIB;
 	else
 		return -EINVAL;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 74e47794e63f..147330454c17 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -498,14 +498,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				btrfs_test_opt(info, FORCE_COMPRESS);
 			if (token == Opt_compress ||
 			    token == Opt_compress_force ||
-			    strcmp(args[0].from, "zlib") == 0) {
+			    strncmp(args[0].from, "zlib", 4) == 0) {
 				compress_type = "zlib";
 				info->compress_type = BTRFS_COMPRESS_ZLIB;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
 				btrfs_clear_opt(info->mount_opt, NODATACOW);
 				btrfs_clear_opt(info->mount_opt, NODATASUM);
 				no_compress = 0;
-			} else if (strcmp(args[0].from, "lzo") == 0) {
+			} else if (strncmp(args[0].from, "lzo", 3) == 0) {
 				compress_type = "lzo";
 				info->compress_type = BTRFS_COMPRESS_LZO;
 				btrfs_set_opt(info->mount_opt, COMPRESS);
-- 
2.13.0

