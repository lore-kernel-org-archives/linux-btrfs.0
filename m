From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH] btrfs: Fix block generation verification race
Date: Mon, 03 May 2010 10:11:34 +0800
Message-ID: <4BDE30D6.9000602@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After the path is released, the generation number got from block
pointer is no long valid. The race may cause disk corruption, because
verify_parent_transid() calls clear_extent_buffer_uptodate() when
generation numbers mismatch.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---
diff -urp 1/fs/btrfs/ctree.c 2/fs/btrfs/ctree.c
--- 1/fs/btrfs/ctree.c	2010-04-14 14:49:56.342950744 +0800
+++ 2/fs/btrfs/ctree.c	2010-05-03 09:44:24.426642447 +0800
@@ -1589,7 +1589,7 @@ read_block_for_search(struct btrfs_trans
 	btrfs_release_path(NULL, p);
 
 	ret = -EAGAIN;
-	tmp = read_tree_block(root, blocknr, blocksize, gen);
+	tmp = read_tree_block(root, blocknr, blocksize, 0);
 	if (tmp) {
 		/*
 		 * If the read above didn't mark this buffer up to date,
