Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752170AbdBMJeM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:12 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8DD3FABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:11 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 07/29] btrfs: remove unused parameter from __push_leaf_right
Date: Mon, 13 Feb 2017 10:33:42 +0100
Message-Id: <18a2895c6859246d061ada47912e18283d19bbb6.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unused since long ago.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4c5d7c40c8bf..2283f92b5484 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3595,8 +3595,7 @@ noinline int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
  * min slot controls the lowest index we're willing to push to the
  * right.  We'll push up to and including min_slot, but no lower
  */
-static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
-				      struct btrfs_fs_info *fs_info,
+static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
 				      struct btrfs_path *path,
 				      int data_size, int empty,
 				      struct extent_buffer *right,
@@ -3810,7 +3809,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 		return 0;
 	}
 
-	return __push_leaf_right(trans, fs_info, path, min_data_size, empty,
+	return __push_leaf_right(fs_info, path, min_data_size, empty,
 				right, free_space, left_nritems, min_slot);
 out_unlock:
 	btrfs_tree_unlock(right);
-- 
2.10.1

