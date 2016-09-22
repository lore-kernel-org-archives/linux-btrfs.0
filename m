Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966538AbcIVTMO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 15:12:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D9B1AABCA
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Sep 2016 19:12:12 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH] Remove already completed TODO comment
Date: Thu, 22 Sep 2016 14:12:09 -0500
Message-Id: <1474571529-5477-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Fixes: 7cf5b97650f2 ("btrfs: qgroup: Cleanup old inaccurate facilities")
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/extent-tree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 23b3b9f..a8a4931 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6112,8 +6112,6 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
  * @start: start range we are writing to
  * @len: how long the range we are writing to
  *
- * TODO: This function will finally replace old btrfs_delalloc_reserve_space()
- *
  * This will do the following things
  *
  * o reserve space in data space info for num bytes
-- 
2.6.6

