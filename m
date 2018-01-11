Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753031AbeAKNqq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 08:46:46 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D2C4FAD8B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:46:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Make btrfs_inode_rsv_release static
Date: Thu, 11 Jan 2018 15:46:44 +0200
Message-Id: <1515678404-18736-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not used outside of extent-tree so there is no reason to not be
static.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b9c72c35e457..271f13bad41a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5771,7 +5771,7 @@ static int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
  * This is the same as btrfs_block_rsv_release, except that it handles the
  * tracepoint for the reservation.
  */
-void btrfs_inode_rsv_release(struct btrfs_inode *inode)
+static void btrfs_inode_rsv_release(struct btrfs_inode *inode)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
-- 
2.7.4

