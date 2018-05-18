Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38483 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750957AbeERNMz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 09:12:55 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, josef@toxicpanda.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Document __btrfs_inc_extent_ref
Date: Fri, 18 May 2018 16:12:50 +0300
Message-Id: <1526649170-29815-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a doc-only patch which tires to deobfuscate the terra-incognita
that arguments for delayed refs are.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
Hello, 

This patch needs revieweing since I'm not entirely sure I managed to capture 
the semantics of the "parent" and "owner" arguments. Specifically, parent is 
passed "ref->parent" only if we have a shared block, however looking at the 
code where parent is passed to the add delayed tree/data refs, it seems that 
parent is set to the eb->Start only if the tree where this extent comes from is 
the data_reloc_tree, i.e the code in replace_path/replace_file_extents/do_relocation
__btrfs_cow_block.

For the "owner" argument in case of data extents it'set to the ino, for metadata
extents it's a bit trickier, what I think it always contains for such extents 
is the level of the parent block in the tree. 


If this function is documented correctly then it wil be fairly trivial to 
document btrfs_add_delayed(tree|data)_ref ones as well. 

 fs/btrfs/extent-tree.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2ce32f05812f..5a2f4a86dc71 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2207,6 +2207,35 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * __btrfs_inc_extent_ref - insert backreference for a given extent
+ *
+ * @trans:	    Handle of transaction
+ *
+ * @node:	    The delayed ref node used to get the bytenr/length for
+ *		    extent
+ *
+ * @parent:	    If this is a shared extent (BTRFS_SHARED_DATA_REF_KEY/
+ *		    BTRFS_SHARED_BLOCK_REF_KEY) then parent *may* hold the
+ *		    logical bytenr of the parent block.
+ *
+ * @root_objectid: The id of the root where this modification has originated,
+ *		    this can be either one of the well-known metadata trees or
+ *		    the subvolume id which references this extent.
+ *
+ * @owner:	    For data extents it is the inode number of the owning file.
+ *		    For metadata extents this parameter holds the level in the
+ *		    tree of the parent block.
+ *
+ * @offset:	    For metadata extents this is always 0. For data extents it
+ *		    is the fileoffset this extent belongs to.
+ *
+ * @refs_to_add    Number of references to add
+ *
+ * @extent_op      Pointer to a structure, holding information necessary when
+ *                 updating a tree block's flags
+ *
+ */
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_delayed_ref_node *node,
 				  u64 parent, u64 root_objectid,
-- 
2.7.4

