Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41571 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752201AbdBMJeU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:34:20 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 99144ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:34:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 08/29] btrfs: remove unused parameter from __push_leaf_left
Date: Mon, 13 Feb 2017 10:33:45 +0100
Message-Id: <5ddf638130041869bf426c8abe6aac0f2651f464.1486977712.git.dsterba@suse.com>
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
index 2283f92b5484..b98e90a3eee7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3825,8 +3825,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
  * item at 'max_slot' won't be touched.  Use (u32)-1 to make us do all the
  * items
  */
-static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
+static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 				     struct btrfs_path *path, int data_size,
 				     int empty, struct extent_buffer *left,
 				     int free_space, u32 right_nritems,
@@ -4035,7 +4034,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		goto out;
 	}
 
-	return __push_leaf_left(trans, fs_info, path, min_data_size,
+	return __push_leaf_left(fs_info, path, min_data_size,
 			       empty, left, free_space, right_nritems,
 			       max_slot);
 out:
-- 
2.10.1

