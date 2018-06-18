Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33639 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933079AbeFRL7c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:59:32 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF085ADCD
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 11:59:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs: Document __btrfs_inc_extent_ref
Date: Mon, 18 Jun 2018 14:59:25 +0300
Message-Id: <1529323166-29931-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1529323166-29931-1-git-send-email-nborisov@suse.com>
References: <1529323166-29931-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a doc-only patch which tires to deobfuscate the terra-incognita
that arguments for delayed refs are.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 59645ced6fbc..39d0652bf3f3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2207,6 +2207,40 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * __btrfs_inc_extent_ref - insert backreference for a given extent
+ *
+ * @trans:	    Handle of transaction
+ *
+ * @node:	    The delayed ref node used to get the bytenr/length for
+ *		    extent whose references are incremented.
+ *
+ * @parent:	    If this is a shared extent (BTRFS_SHARED_DATA_REF_KEY/
+ *		    BTRFS_SHARED_BLOCK_REF_KEY) then it holds the logical
+ *		    bytenr of the parent block. Since new extents are always
+ *		    created with indirect references, this will only be the case
+ *		    when relocating a shared extent. In that case, root_objectid
+ *		    will be BTRFS_TREE_RELOC_OBJECTID. Otheriwse, parent must
+ *		    be 0
+ *
+ * @root_objectid:  The id of the root where this modification has originated,
+ *		    this can be either one of the well-known metadata trees or
+ *		    the subvolume id which references this extent.
+ *
+ * @owner:	    For data extents it is the inode number of the owning file.
+ *		    For metadata extents this parameter holds the level in the
+ *		    tree of the extent.
+ *
+ * @offset:	    For metadata extents the offset is ignored and is currently
+ *		    always passed as 0. For data extents it is the fileoffset
+ *		    this extent belongs to.
+ *
+ * @refs_to_add     Number of references to add
+ *
+ * @extent_op       Pointer to a structure, holding information necessary when
+ *                  updating a tree block's flags
+ *
+ */
 static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_delayed_ref_node *node,
 				  u64 parent, u64 root_objectid,
-- 
2.7.4

