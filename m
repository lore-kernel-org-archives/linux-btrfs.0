Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38529 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752103AbbEFKSe (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 6 May 2015 06:18:34 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, merlijn@wizzup.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix wrong mapping flags for free space inode
Date: Wed,  6 May 2015 11:17:01 +0100
Message-Id: <1430907421-6225-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were passing a flags value that differed from the intention in commit
2b108268006e ("Btrfs: don't use highmem for free space cache pages").

This caused problems in a ARM machine, leaving btrfs unusable there.

Reported-by: Merlijn Wajer <merlijn@wizzup.org>
Tested-by: Merlijn Wajer <merlijn@wizzup.org>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c0ef0b1..fc0857f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -86,7 +86,7 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 
 	mapping_set_gfp_mask(inode->i_mapping,
 			mapping_gfp_mask(inode->i_mapping) &
-			~(GFP_NOFS & ~__GFP_HIGHMEM));
+			~(__GFP_FS | __GFP_HIGHMEM));
 
 	return inode;
 }
-- 
2.1.3

