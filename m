Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:60382 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1168562AbcKAK0k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 06:26:40 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] btrfs: Remove some dead code
Date: Tue,  1 Nov 2016 11:26:06 +0100
Message-Id: <20161101102606.27006-1-christophe.jaillet@wanadoo.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs_iget()' can not return an error pointer, so this test can be
removed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 fs/btrfs/free-space-cache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e4b48f377d3a..afd8b0c10acd 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -75,8 +75,6 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	btrfs_release_path(path);
 
 	inode = btrfs_iget(root->fs_info->sb, &location, root, NULL);
-	if (!inode)
-		return ERR_PTR(-ENOENT);
 	if (IS_ERR(inode))
 		return inode;
 	if (is_bad_inode(inode)) {
-- 
2.9.3

