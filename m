Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:14237 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728476AbeGZDzp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 23:55:45 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 2ECCDAC01E6
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 11:41:03 +0900 (JST)
Received: from g01jpexchkw38.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 59A8BBD69A1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 11:41:02 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs: extent-tree.c: Remove unused __btrfs_free_block_rsv()
References: <cover.1532572743.git.misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <01829a36-c358-e71a-4281-be8eeb8f8302@jp.fujitsu.com>
Date: Thu, 26 Jul 2018 11:40:54 +0900
MIME-Version: 1.0
In-Reply-To: <cover.1532572743.git.misono.tomohiro@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no user of this function.

This is forgotten to get removed in commit a575ceeb1338
("Btrfs: get rid of unused orphan infrastructure").

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h       | 1 -
 fs/btrfs/extent-tree.c | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9c638931b75e..6506a3e8ccbd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2764,7 +2764,6 @@ void btrfs_init_metadata_block_rsv(struct btrfs_fs_info *fs_info,
 				   unsigned short type);
 void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_rsv *rsv);
-void __btrfs_free_block_rsv(struct btrfs_block_rsv *rsv);
 int btrfs_block_rsv_add(struct btrfs_root *root,
 			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			enum btrfs_reserve_flush_enum flush);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 16b916a33e56..240535eec2f4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5529,11 +5529,6 @@ void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
 	kfree(rsv);
 }
 
-void __btrfs_free_block_rsv(struct btrfs_block_rsv *rsv)
-{
-	kfree(rsv);
-}
-
 int btrfs_block_rsv_add(struct btrfs_root *root,
 			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			enum btrfs_reserve_flush_enum flush)
-- 
2.14.4


