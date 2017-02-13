Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41881 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752424AbdBMJfL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:35:11 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF369ABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:35:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 26/29] btrfs: remove unused parameter from __add_inode_ref
Date: Mon, 13 Feb 2017 10:34:41 +0100
Message-Id: <6ab7d2d469a0a929ce89feaf9bd8938dd3c1754f.1486977712.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unused since the helper has been split, eb used in the caller.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 62dd138018b5..3806853cde08 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -994,7 +994,6 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *log_root,
 				  struct btrfs_inode *dir,
 				  struct btrfs_inode *inode,
-				  struct extent_buffer *eb,
 				  u64 inode_objectid, u64 parent_objectid,
 				  u64 ref_index, char *name, int namelen,
 				  int *search_done)
@@ -1310,7 +1309,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			if (!search_done) {
 				ret = __add_inode_ref(trans, root, path, log,
 						      BTRFS_I(dir),
-						      BTRFS_I(inode), eb,
+						      BTRFS_I(inode),
 						      inode_objectid,
 						      parent_objectid,
 						      ref_index, name, namelen,
-- 
2.10.1

