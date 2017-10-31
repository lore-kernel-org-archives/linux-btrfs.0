Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53149 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932459AbdJaRtx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:49:53 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 05081AD88
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:49:52 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: use GFP_KERNEL in btrfs_alloc_inode
Date: Tue, 31 Oct 2017 18:48:02 +0100
Message-Id: <de02deb35812b34e84142e2c644bc5f54161b17c.1509471989.git.dsterba@suse.com>
In-Reply-To: <cover.1509471989.git.dsterba@suse.com>
References: <cover.1509471989.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This callback is called directly from VFS, no locks are held at the
allocation time.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8de8b38ee22f..9ac796f98c9e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9410,7 +9410,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	struct btrfs_inode *ei;
 	struct inode *inode;
 
-	ei = kmem_cache_alloc(btrfs_inode_cachep, GFP_NOFS);
+	ei = kmem_cache_alloc(btrfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 
-- 
2.14.0

