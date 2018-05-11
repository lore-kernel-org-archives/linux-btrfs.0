Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36047 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbeEKH4c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:32 -0400
Received: by mail-pl0-f66.google.com with SMTP id v24-v6so2846274plo.3
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:32 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 11/11] Btrfs: reserve space for O_TMPFILE orphan item deletion
Date: Fri, 11 May 2018 00:56:16 -0700
Message-Id: <b09d6b4eed91637c18c00559af62b80aeabefed7.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
In-Reply-To: <cover.1526025007.git.osandov@fb.com>
References: <cover.1526025007.git.osandov@fb.com>
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
index 1edb4148ec74..98cf08944552 100644
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

