Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:45733 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754919Ab1K1TdB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Nov 2011 14:33:01 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pASJWbdm020810
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:37 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pASJWZqB012417
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:35 -0200
Received: from livre.localdomain (aoliva@localhost.localdomain [127.0.0.1])
	by livre.localdomain (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id pASJWYxG020364
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2011 17:32:34 -0200
Received: (from aoliva@localhost)
	by livre.localdomain (8.14.3/8.14.3/Submit) id pASJWY1R020363
	for linux-btrfs@vger.kernel.org; Mon, 28 Nov 2011 17:32:34 -0200
Message-Id: <ebde7569c6750d67ec1f4bcf057ed20bc3996400.1322507825.git.oliva@lsd.ic.unicamp.br>
In-Reply-To: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
References: <cover.1322507825.git.oliva@lsd.ic.unicamp.br>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Wed, 16 Nov 2011 01:25:06 -0200
Subject: [PATCH 10/20] Btrfs: report reason for failed relocation
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs filesystem balance sometimes fails on corrupted filesystems, but
without any information that explains what the failure was to help
track down the problem.  This patch adds logging for nearly all error
conditions that may cause relocation to fail.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/relocation.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index dff29d5..15a2270 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2496,6 +2496,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 		if (!upper->eb) {
 			ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 			if (ret < 0) {
+				printk(KERN_INFO "btrfs: searching slot %llu failed: %i\n", key->objectid, -ret);
 				err = ret;
 				break;
 			}
@@ -2543,6 +2544,7 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 			btrfs_tree_unlock(eb);
 			free_extent_buffer(eb);
 			if (ret < 0) {
+				printk(KERN_INFO "btrfs: cow slot failed: %i\n", -ret);
 				err = ret;
 				goto next;
 			}
@@ -2730,6 +2732,7 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 	BUG_ON(node->processed);
 	root = select_one_root(trans, node);
 	if (root == ERR_PTR(-ENOENT)) {
+		printk(KERN_INFO "btrfs: could not find a root to update\n");
 		update_processed_blocks(rc, node);
 		goto out;
 	}
@@ -2756,6 +2759,8 @@ static int relocate_tree_block(struct btrfs_trans_handle *trans,
 			btrfs_release_path(path);
 			if (ret > 0)
 				ret = 0;
+			if (ret < 0)
+				printk(KERN_INFO "btrfs: failed to search slot %llu: %i\n", key->objectid, -ret);
 		}
 		if (!ret)
 			update_processed_blocks(rc, node);
@@ -2813,12 +2818,14 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 					  block->level, block->bytenr);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
+			printk(KERN_INFO "btrfs: failed to build backref tree for key %llu byte %llu: %i\n", block->key.objectid, block->bytenr, -err);
 			goto out;
 		}
 
 		ret = relocate_tree_block(trans, rc, node, &block->key,
 					  path);
 		if (ret < 0) {
+			printk(KERN_INFO "btrfs: failed to relocate tree block: %i\n", -ret);
 			if (ret != -EAGAIN || rb_node == rb_first(blocks))
 				err = ret;
 			goto out;
@@ -3770,6 +3777,7 @@ restart:
 			ret = relocate_tree_blocks(trans, rc, &blocks);
 			if (ret < 0) {
 				if (ret != -EAGAIN) {
+					printk(KERN_INFO "btrfs: failed to relocate blocks for key %llu: %i\n", key.objectid, -ret);
 					err = ret;
 					break;
 				}
-- 
1.7.4.4

