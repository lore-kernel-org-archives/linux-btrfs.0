Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731154AbeGSLsA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 07:48:00 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4BEBACAA
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 11:05:20 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/7] btrfs: remove redundant member async_cow::root
Date: Thu, 19 Jul 2018 13:05:14 +0200
Message-Id: <1c08372d35f29610eed55f77ddcfbe10c8a952f5.1531996240.git.dsterba@suse.com>
In-Reply-To: <cover.1531996240.git.dsterba@suse.com>
References: <cover.1531996240.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root is only used to get fs_info out of it, but the same can be
retrieved from the inode that's in async_cow.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 564ec00c765b..36b323b27dbf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -358,7 +358,6 @@ struct async_extent {
 
 struct async_cow {
 	struct inode *inode;
-	struct btrfs_root *root;
 	struct page *locked_page;
 	u64 start;
 	u64 end;
@@ -1144,13 +1143,11 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 {
 	struct btrfs_fs_info *fs_info;
 	struct async_cow *async_cow;
-	struct btrfs_root *root;
 	unsigned long nr_pages;
 
 	async_cow = container_of(work, struct async_cow, work);
 
-	root = async_cow->root;
-	fs_info = root->fs_info;
+	fs_info = BTRFS_I(async_cow->inode)->root->fs_info;
 	nr_pages = (async_cow->end - async_cow->start + PAGE_SIZE) >>
 		PAGE_SHIFT;
 
@@ -1179,7 +1176,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_cow *async_cow;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	unsigned long nr_pages;
 	u64 cur_end;
 
@@ -1189,7 +1185,6 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		BUG_ON(!async_cow); /* -ENOMEM */
 		async_cow->inode = igrab(inode);
-		async_cow->root = root;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 		async_cow->write_flags = write_flags;
-- 
2.18.0

