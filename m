Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:34921 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbdKQHO1 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 17 Nov 2017 02:14:27 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: extent-tree: Make btrfs_inode_rsv_refill function static
Date: Fri, 17 Nov 2017 15:14:19 +0800
Message-Id: <20171117071419.14197-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is no longer used outside of extent-tree.c.
Make it static.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 673ac4e01dd0..309a109069f1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5745,8 +5745,8 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
  * or return if we already have enough space.  This will also handle the resreve
  * tracepoint for the reserved amount.
  */
-int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
-			   enum btrfs_reserve_flush_enum flush)
+static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
+				  enum btrfs_reserve_flush_enum flush)
 {
 	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
-- 
2.15.0

