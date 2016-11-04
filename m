Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:31671 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbcKDHCt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Nov 2016 03:02:49 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH V2] btrfs: Remove some dead code
Date: Fri,  4 Nov 2016 08:02:35 +0100
Message-Id: <20161104070235.12975-1-christophe.jaillet@wanadoo.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs_iget()' can not return NULL, so this test can be removed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
V1 --> v2: fix the patch description
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

