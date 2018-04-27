Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757538AbeD0JWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 05:22:12 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 999DFACAD
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 09:22:11 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/5] btrfs: Add assert in __btrfs_del_delalloc_inode
Date: Fri, 27 Apr 2018 12:21:52 +0300
Message-Id: <1524820914-30864-4-git-send-email-nborisov@suse.com>
In-Reply-To: <1524820914-30864-1-git-send-email-nborisov@suse.com>
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The invariant is that when nr_delalloc_inodes is 0 then the root
mustn't have any inodes on its delalloc inodes list.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 164950d96c8a..d35992b8bb5e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1754,6 +1754,7 @@ void __btrfs_del_delalloc_inode(struct btrfs_root *root,
 			  &inode->runtime_flags);
 		root->nr_delalloc_inodes--;
 		if (!root->nr_delalloc_inodes) {
+			ASSERT(list_empty(&root->delalloc_inodes));
 			spin_lock(&fs_info->delalloc_root_lock);
 			BUG_ON(list_empty(&root->delalloc_root));
 			list_del_init(&root->delalloc_root);
-- 
2.7.4

