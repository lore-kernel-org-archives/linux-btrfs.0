Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754016AbeDWHyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 03:54:23 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E9D7ADCD
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 07:54:22 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/5] btrfs: Unexport btrfs_alloc_delalloc_work
Date: Mon, 23 Apr 2018 10:54:17 +0300
Message-Id: <1524470057-21969-6-git-send-email-nborisov@suse.com>
In-Reply-To: <1524470057-21969-1-git-send-email-nborisov@suse.com>
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's used only in inode.c so makes no sense to have it exported.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 91f51a80334f..e5c24d86fdfa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3170,8 +3170,6 @@ struct btrfs_delalloc_work {
 	struct btrfs_work work;
 };
 
-struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode);
-
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start,
 		u64 len, int create);
-- 
2.7.4

