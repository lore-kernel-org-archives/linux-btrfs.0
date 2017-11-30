Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56475 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752676AbdK3QLF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 11:11:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DCCC7AE7A
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:11:03 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: show options: use helper to convert compression type string
Date: Thu, 30 Nov 2017 17:09:06 +0100
Message-Id: <77fb8b682747c5a6b286eedfec3de56758c651e3.1512058075.git.dsterba@suse.com>
In-Reply-To: <cover.1512058075.git.dsterba@suse.com>
References: <cover.1512058075.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the helper, if the COMPRESS option is set, the result is always
defined and not empty.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3d0813b17e9c..febe67a37f8a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1243,7 +1243,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 {
 	struct btrfs_fs_info *info = btrfs_sb(dentry->d_sb);
-	char *compress_type;
+	const char *compress_type;
 
 	if (btrfs_test_opt(info, DEGRADED))
 		seq_puts(seq, ",degraded");
@@ -1259,12 +1259,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
 	if (btrfs_test_opt(info, COMPRESS)) {
-		if (info->compress_type == BTRFS_COMPRESS_ZLIB)
-			compress_type = "zlib";
-		else if (info->compress_type == BTRFS_COMPRESS_LZO)
-			compress_type = "lzo";
-		else
-			compress_type = "zstd";
+		compress_type = btrfs_compress_type2str(info->compress_type);
 		if (btrfs_test_opt(info, FORCE_COMPRESS))
 			seq_printf(seq, ",compress-force=%s", compress_type);
 		else
-- 
2.15.0

