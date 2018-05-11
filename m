Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:40396 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbeEKUOF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 16:14:05 -0400
Received: by mail-pl0-f68.google.com with SMTP id t12-v6so3867017plo.7
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 13:14:04 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH v4 12/12] Btrfs: reserve space for O_TMPFILE orphan item deletion
Date: Fri, 11 May 2018 13:13:40 -0700
Message-Id: <961fff4cffd719044cf5b2f93b59b40ad3e10baa.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
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
index 5499b4e8a522..fefa665e64da 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6465,8 +6465,9 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
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

