Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50903 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750737AbdLMHiR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 02:38:17 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 704EEACA1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 07:38:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Improve btrfs_search_slot description
Date: Wed, 13 Dec 2017 09:38:14 +0200
Message-Id: <1513150694-6145-1-git-send-email-nborisov@suse.com>
In-Reply-To: <20171212191401.GV3553@twin.jikos.cz>
References: <20171212191401.GV3553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 880f4f693263..7e6511dfe73a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2654,17 +2654,29 @@ int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *path,
 }
 
 /*
- * look for key in the tree.  path is filled in with nodes along the way
- * if key is found, we return zero and you can find the item in the leaf
- * level of the path (level 0)
+ * btrfs_search_slot - look for a key in a tree and perform necessary
+ * modifications to preserve tree invariants.
  *
- * If the key isn't found, the path points to the slot where it should
- * be inserted, and 1 is returned.  If there are other errors during the
- * search a negative error number is returned.
+ * @trans:	Handle of transaction, used when modifying the tree
+ * @p:		Holds all btree nodes along the search path
+ * @root:	The root node of the tree
+ * @key:	The key we are looking for
+ * @ins_len:	Indicates purpose of search, for inserts it is 1, for
+ *		deletions it's -1. 0 for plain searches
+ * @cow:	boolean should CoW operations be performed. Must always be 1
+ *		when modifying the tree.
  *
- * if ins_len > 0, nodes and leaves will be split as we walk down the
- * tree.  if ins_len < 0, nodes will be merged as we walk down the tree (if
- * possible)
+ * If @ins_len > 0, nodes and leaves will be split as we walk down the tree.
+ * If @ins_len < 0, nodes will be merged as we walk down the tree (if possible)
+ *
+ * If @key is found, 0 is returned and you can find the item in the leaf level
+ * of the path (level 0)
+ *
+ * If @key isn't found, 1 is returned and the leaf level of the path (level 0)
+ * points to the slot where it should be inserted
+ *
+ * If an error is encountered while searching the tree a negative error number
+ * is returned
  */
 int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key, struct btrfs_path *p,
-- 
2.7.4

