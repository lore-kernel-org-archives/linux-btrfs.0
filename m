Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:37171 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753221Ab1KSKRw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Nov 2011 05:17:52 -0500
Received: from freie.oliva.athome.lsd.ic.unicamp.br (gw-to-emilia.oliva.athome.lsd.ic.unicamp.br [172.31.160.17] (may be forged))
	by boneca.lsd.ic.unicamp.br (8.14.5/8.14.5) with ESMTP id pAJAHoKD023564
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Nov 2011 08:17:50 -0200
Received: from livre.localdomain (livre-to-gw.oliva.athome.lsd.ic.unicamp.br [172.31.160.19])
	by freie.oliva.athome.lsd.ic.unicamp.br (8.14.4/8.14.4) with ESMTP id pAJAHosu004609
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Nov 2011 08:17:50 -0200
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
To: linux-btrfs@vger.kernel.org
Subject: report relocation failures
Date: Sat, 19 Nov 2011 08:17:48 -0200
Message-ID: <or1ut476wj.fsf@livre.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

I've had some corrupted filesystems that failed to balance and to remove
devices.  It was slightly annoying that btrfs would exit with a nonzero
status, but no information about the error was logged anywhere.  This
patch introduces some error reporting, catching the one error I was
running into: -ENOENT looking for a backref, presumably because outdated
metadata that ended up being used as if it was still live.

I ended up losing the filesystem before I could figure out what exactly
the problem was, but with this info it would hopefully not take as long
to track it down.


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0006-Btrfs-report-reason-for-failed-relocation.patch

>From 2bbc4ae372f8ca31701db8ed0cf8e15edf76311e Mon Sep 17 00:00:00 2001
From: Alexandre Oliva <lxoliva@fsfla.org>
Date: Wed, 16 Nov 2011 01:25:06 -0200
Subject: [PATCH 6/8] Btrfs: report reason for failed relocation

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


--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
