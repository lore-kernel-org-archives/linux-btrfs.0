Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932762AbeFRLKn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:10:43 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5C1EAEA4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 11:10:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs-progs: check: Fix wrong root parameter of btrfs_next_leaf call
Date: Mon, 18 Jun 2018 14:10:39 +0300
Message-Id: <1529320239-23033-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first thing that check_chunks_and_extents does is to iterate all
the root items in the root tree and link them to either the "normal_list"
or "dropping_trees" list. If a leaf has to be crossed during this
operation btrfs_next_leaf is called to do that. However, currently it's
called with a wrong argument for its 'root' parameter. Since we are
iterating the root tree the passed root should be fs_info->tree_rot,
whereas right now we are passing the local variable 'root' which is
assigned to the fs_tree. As it stands, this bug is actually benign since
the passed root is only passed to reada_for_search, where it's used to
reference the fs_info. Nevertheless the code is wrong and at the very least
misleading, so fix it by passing the correct root.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 68da994f7ae0..a4d6855dccbf 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8157,7 +8157,7 @@ static int check_chunks_and_extents(struct btrfs_fs_info *fs_info)
 		leaf = path.nodes[0];
 		slot = path.slots[0];
 		if (slot >= btrfs_header_nritems(path.nodes[0])) {
-			ret = btrfs_next_leaf(root, &path);
+			ret = btrfs_next_leaf(fs_info->tree_root, &path);
 			if (ret != 0)
 				break;
 			leaf = path.nodes[0];
-- 
2.7.4

