Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46823 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbeEKALq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 20:11:46 -0400
Received: by mail-pg0-f68.google.com with SMTP id z4-v6so1641268pgu.13
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 17:11:46 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 12/12] Btrfs: reserve space for O_TMPFILE orphan item deletion
Date: Thu, 10 May 2018 17:11:22 -0700
Message-Id: <a8cdbcadf9cb7213764995fdf99135e5492d418f.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
In-Reply-To: <cover.1525997057.git.osandov@fb.com>
References: <cover.1525997057.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_link() calls btrfs_orphan_del() if it's linking an O_TMPFILE but
it doesn't reserve space to do so. Even before the removal of the
orphan_block_rsv it wasn't using it.

Fixes: ef3b9af50bfa ("Btrfs: implement inode_operations callback tmpfile")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b28d5f251661..a23962105d8b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6491,8 +6491,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	 * 2 items for inode and inode ref
 	 * 2 items for dir items
 	 * 1 item for parent inode
+	 * 1 item for orphan item deletion if O_TMPFILE
 	 */
-	trans = btrfs_start_transaction(root, 5);
+	trans = btrfs_start_transaction(root, inode->i_nlink ? 5 : 6);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
 		trans = NULL;
-- 
2.17.0

