Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35283 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaBTVPn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 16:15:43 -0500
Received: by mail-wi0-f178.google.com with SMTP id cc10so152073wib.5
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 13:15:42 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: correctly determine if blocks are shared in btrfs_compare_trees
Date: Thu, 20 Feb 2014 21:15:25 +0000
Message-Id: <1392930925-5348-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just comparing the pointers (logical disk addresses) of the btree nodes is
not completely bullet proof, we have to check if their generation numbers
match too.

It is guaranteed that a COW operation will result in a block with a different
logical disk address than the original block's address, but over time we can
reuse that former logical disk address.

For example, creating a 2Gb filesystem on a loop device, and having a script
running in a loop always updating the access timestamp of a file, resulted in
the same logical disk address being reused for the same fs btree block in about
only 4 minutes.

This could make us skip entire subtrees when doing an incremental send (which
is currently the only user of btrfs_compare_trees). However the odds of getting
2 blocks at the same tree level, with the same logical disk address, equal first
slot keys and different generations, should hopefully be very low.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ctree.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cbd3a7d..88d1b1e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5376,6 +5376,8 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	int advance_right;
 	u64 left_blockptr;
 	u64 right_blockptr;
+	u64 left_gen;
+	u64 right_gen;
 	u64 left_start_ctransid;
 	u64 right_start_ctransid;
 	u64 ctransid;
@@ -5640,7 +5642,14 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 				right_blockptr = btrfs_node_blockptr(
 						right_path->nodes[right_level],
 						right_path->slots[right_level]);
-				if (left_blockptr == right_blockptr) {
+				left_gen = btrfs_node_ptr_generation(
+						left_path->nodes[left_level],
+						left_path->slots[left_level]);
+				right_gen = btrfs_node_ptr_generation(
+						right_path->nodes[right_level],
+						right_path->slots[right_level]);
+				if (left_blockptr == right_blockptr &&
+				    left_gen == right_gen) {
 					/*
 					 * As we're on a shared block, don't
 					 * allow to go deeper.
-- 
1.7.9.5

