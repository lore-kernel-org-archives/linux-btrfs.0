Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52211 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752053AbeC0HTm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 03:19:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3189B048
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 07:19:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/10] btrfs-progs: Drop unused ext_ref parameter from process_one_leaf
Date: Tue, 27 Mar 2018 10:19:26 +0300
Message-Id: <1522135172-8276-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1522135172-8276-1-git-send-email-nborisov@suse.com>
References: <1522135172-8276-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's no longer used in the function so just remove it

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index e26e9bdf3bb3..34519f30a4aa 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2141,7 +2141,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
  * Returns 0   No errors found
  */
 static int process_one_leaf(struct btrfs_root *root, struct btrfs_path *path,
-			    struct node_refs *nrefs, int *level, int ext_ref)
+			    struct node_refs *nrefs, int *level)
 {
 	struct extent_buffer *cur = path->nodes[0];
 	struct btrfs_key key;
@@ -4031,7 +4031,7 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 			ret = 0;
 			if (!check_all)
 				ret = process_one_leaf(root, path, nrefs,
-						       level, ext_ref);
+						       level);
 			else
 				ret = check_leaf_items(trans, root, path,
 					       nrefs, account_file_data);
-- 
2.7.4

