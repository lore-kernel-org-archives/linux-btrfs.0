Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:57909 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751861AbbBWT7r (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 23 Feb 2015 14:59:47 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix off-by-one logic error in btrfs_realloc_node
Date: Mon, 23 Feb 2015 19:48:52 +0000
Message-Id: <1424720932-15388-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The end_slot variable actually matches the number of pointers in the
node and not the last slot (which is 'nritems - 1'). Therefore in order
to check that the current slot in the for loop doesn't match the last
one, the correct logic is to check if 'i' is less than 'end_slot - 1'
and not 'end_slot - 2'.

Fix this and set end_slot to be 'nritems - 1', as it's less confusing
since the variable name implies it's inclusive rather then exclusive.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9936421..6d67f32 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1645,14 +1645,14 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 
 	parent_nritems = btrfs_header_nritems(parent);
 	blocksize = root->nodesize;
-	end_slot = parent_nritems;
+	end_slot = parent_nritems - 1;
 
-	if (parent_nritems == 1)
+	if (parent_nritems <= 1)
 		return 0;
 
 	btrfs_set_lock_blocking(parent);
 
-	for (i = start_slot; i < end_slot; i++) {
+	for (i = start_slot; i <= end_slot; i++) {
 		int close = 1;
 
 		btrfs_node_key(parent, &disk_key, i);
@@ -1669,7 +1669,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			other = btrfs_node_blockptr(parent, i - 1);
 			close = close_blocks(blocknr, other, blocksize);
 		}
-		if (!close && i < end_slot - 2) {
+		if (!close && i < end_slot) {
 			other = btrfs_node_blockptr(parent, i + 1);
 			close = close_blocks(blocknr, other, blocksize);
 		}
-- 
2.1.3

