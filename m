Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:43132 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756618AbeEJGVg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 02:21:36 -0400
Received: by mail-pg0-f65.google.com with SMTP id k11-v6so498183pgo.10
        for <linux-btrfs@vger.kernel.org>; Wed, 09 May 2018 23:21:36 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 10/10] Btrfs: reserve space for O_TMPFILE orphan item deletion
Date: Wed,  9 May 2018 23:21:11 -0700
Message-Id: <35b9fda73e091d42845d5bbf34607c052da1147f.1525932796.git.osandov@fb.com>
In-Reply-To: <cover.1525932796.git.osandov@fb.com>
References: <cover.1525932796.git.osandov@fb.com>
In-Reply-To: <cover.1525932796.git.osandov@fb.com>
References: <cover.1525932796.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_link() calls btrfs_orphan_del() if it's linking an O_TMPFILE but
it doesn't reserve space to do so. Even before the removal of the
orphan_block_rsv it wasn't using it.

Fixes: ef3b9af50bfa ("Btrfs: implement inode_operations callback tmpfile")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 88b89a48b66f..2a610a8d30c4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6535,8 +6535,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
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

