Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52219 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752055AbeC0HTm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69F1CAFE8
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/10] btrfs-progs: Remove ext_ref param from walk_down_tree
Date: Tue, 27 Mar 2018 10:19:28 +0300
Message-Id: <1522135172-8276-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no longer used so just remove it.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 29c55e202f2b..76365a214e34 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -3959,8 +3959,7 @@ static int check_leaf_items(struct btrfs_trans_handle *trans,
  */
 static int walk_down_tree(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, struct btrfs_path *path,
-			  int *level, struct node_refs *nrefs, int ext_ref,
-			  int check_all)
+			  int *level, struct node_refs *nrefs, int check_all)
 {
 	enum btrfs_tree_block_status status;
 	u64 bytenr;
@@ -4318,7 +4317,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		ret = walk_down_tree(trans, root, &path, &level, &nrefs,
-				     ext_ref, check_all);
+				     check_all);
 
 		err |= !!ret;
 
-- 
2.7.4

