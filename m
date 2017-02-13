Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41857 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752397AbdBMJfD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:35:03 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B3BDCABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:35:01 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 23/29] btrfs: remove unused parameter from __add_inline_refs
Date: Mon, 13 Feb 2017 10:34:31 +0100
Message-Id: <1b43e704d3dc38175012931ceea4268a7affb0d5.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/backref.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index db706595e631..7699e16784d3 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -956,8 +956,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 /*
  * add all inline backrefs for bytenr to the list
  */
-static int __add_inline_refs(struct btrfs_fs_info *fs_info,
-			     struct btrfs_path *path, u64 bytenr,
+static int __add_inline_refs(struct btrfs_path *path, u64 bytenr,
 			     int *info_level, struct list_head *prefs,
 			     struct ref_root *ref_tree,
 			     u64 *total_refs, u64 inum)
@@ -1354,7 +1353,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 		if (key.objectid == bytenr &&
 		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
 		     key.type == BTRFS_METADATA_ITEM_KEY)) {
-			ret = __add_inline_refs(fs_info, path, bytenr,
+			ret = __add_inline_refs(path, bytenr,
 						&info_level, &prefs,
 						ref_tree, &total_refs,
 						inum);
-- 
2.10.1

