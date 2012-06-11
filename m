Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:20214 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2FKJK7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 05:10:59 -0400
Message-ID: <4FD5B61B.1040000@huawei.com>
Date: Mon, 11 Jun 2012 17:10:51 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix incompat flags setting
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's a bug, but it happens to work, as BTRFS_COMPRESS_LZO == 2, which
has only one bit set.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/btrfs/disk-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7ae51de..fe82070 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2118,7 +2118,7 @@ int open_ctree(struct super_block *sb,
 
 	features = btrfs_super_incompat_flags(disk_super);
 	features |= BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF;
-	if (tree_root->fs_info->compress_type & BTRFS_COMPRESS_LZO)
+	if (tree_root->fs_info->compress_type == BTRFS_COMPRESS_LZO)
 		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
 
 	/*
-- 
1.7.9.7
