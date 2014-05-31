Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49703 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbaEaXsu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:50 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so3474754wgh.31
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:49 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 6/8] Btrfs: Ensure LZ4 feature flags are set when mounting with LZ4
Date: Sat, 31 May 2014 23:48:34 +0000
Message-Id: <1401580116-10458-7-git-send-email-philip.worrall@googlemail.com>
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Philip Worrall <philip.worrall@googlemail.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d1ac7d..56bab54 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2479,7 +2479,8 @@ int open_ctree(struct super_block *sb,
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
 	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
-
+	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZ4)
+		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZ4;
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 		printk(KERN_ERR "BTRFS: has skinny extents\n");
 
-- 
1.9.1

