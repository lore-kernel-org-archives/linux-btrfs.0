Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41899 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752441AbdBMJfU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:35:20 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EE8E9ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:35:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 29/29] btrfs: remove unused parameter from adjust_slots_upwards
Date: Mon, 13 Feb 2017 10:34:50 +0100
Message-Id: <3b7ce86c208631f625555daf477c7d18604db297.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/qgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6d106e623604..4ef513a392a7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1589,8 +1589,7 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
  * If we increment the root nodes slot counter past the number of
  * elements, 1 is returned to signal completion of the search.
  */
-static int adjust_slots_upwards(struct btrfs_root *root,
-				struct btrfs_path *path, int root_level)
+static int adjust_slots_upwards(struct btrfs_path *path, int root_level)
 {
 	int level = 0;
 	int nr, slot;
@@ -1731,7 +1730,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 				goto out;
 
 			/* Nonzero return here means we completed our search */
-			ret = adjust_slots_upwards(root, path, root_level);
+			ret = adjust_slots_upwards(path, root_level);
 			if (ret)
 				break;
 
-- 
2.10.1

