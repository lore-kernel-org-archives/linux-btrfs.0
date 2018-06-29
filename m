Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932081AbeF2I4m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:42 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 67583AD67
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/14] btrfs: simplify some assignments of inode numbers
Date: Fri, 29 Jun 2018 10:56:40 +0200
Message-Id: <84f0ec5b49aa7895b61e45717270bb184dc7deb1.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are several places when the btrfs inode is converted to the
generic inode, back to btrfs and then passed to btrfs_ino. We can remove
the extra back and forth conversions.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c12b7a6e534a..a27e68405aa3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4243,9 +4243,9 @@ static void btrfs_prune_dentries(struct btrfs_root *root)
 		prev = node;
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
 
-		if (objectid < btrfs_ino(BTRFS_I(&entry->vfs_inode)))
+		if (objectid < btrfs_ino(entry))
 			node = node->rb_left;
-		else if (objectid > btrfs_ino(BTRFS_I(&entry->vfs_inode)))
+		else if (objectid > btrfs_ino(entry))
 			node = node->rb_right;
 		else
 			break;
@@ -4253,7 +4253,7 @@ static void btrfs_prune_dentries(struct btrfs_root *root)
 	if (!node) {
 		while (prev) {
 			entry = rb_entry(prev, struct btrfs_inode, rb_node);
-			if (objectid <= btrfs_ino(BTRFS_I(&entry->vfs_inode))) {
+			if (objectid <= btrfs_ino(entry)) {
 				node = prev;
 				break;
 			}
@@ -4262,7 +4262,7 @@ static void btrfs_prune_dentries(struct btrfs_root *root)
 	}
 	while (node) {
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
-		objectid = btrfs_ino(BTRFS_I(&entry->vfs_inode)) + 1;
+		objectid = btrfs_ino(entry) + 1;
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
@@ -5615,9 +5615,9 @@ static void inode_tree_add(struct inode *inode)
 		parent = *p;
 		entry = rb_entry(parent, struct btrfs_inode, rb_node);
 
-		if (ino < btrfs_ino(BTRFS_I(&entry->vfs_inode)))
+		if (ino < btrfs_ino(entry))
 			p = &parent->rb_left;
-		else if (ino > btrfs_ino(BTRFS_I(&entry->vfs_inode)))
+		else if (ino > btrfs_ino(entry))
 			p = &parent->rb_right;
 		else {
 			WARN_ON(!(entry->vfs_inode.i_state &
-- 
2.17.1

