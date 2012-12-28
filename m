Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32440 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2L1JgL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 04:36:11 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Slava Barinov <rayslava@gmail.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] Btrfs: reset path lock state to zero
Date: Fri, 28 Dec 2012 17:33:19 +0800
Message-Id: <1356687199-7198-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forgot to reset the path lock state to zero after we unlock the path block,
and this can lead to the ASSERT checker in tree unlock API.

Reported-by: Slava Barinov <rayslava@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 521e9d4..a71d457 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6788,11 +6788,13 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 						       &wc->flags[level]);
 			if (ret < 0) {
 				btrfs_tree_unlock_rw(eb, path->locks[level]);
+				path->locks[level] = 0;
 				return ret;
 			}
 			BUG_ON(wc->refs[level] == 0);
 			if (wc->refs[level] == 1) {
 				btrfs_tree_unlock_rw(eb, path->locks[level]);
+				path->locks[level] = 0;
 				return 1;
 			}
 		}
-- 
1.7.7.6

