Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43524 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754382AbeDWJcY (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 23 Apr 2018 05:32:24 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Fix wrong first_key parameter in replace_path
Date: Mon, 23 Apr 2018 17:32:04 +0800
Message-Id: <20180423093204.20943-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 581c1760415c ("btrfs: Validate child tree block's level and first
key") introduced new @first_key parameter for read_tree_block(), however
caller in replace_path() is parasing wrong key to read_tree_block().

It should use parameter @first_key other than @key.

Normally it won't expose problem as @key is normally initialzied to the
same value of @first_key we expect.
However in relocation recovery case, @key can be set to (0, 0, 0), and
since no valid key in relocation tree can be (0, 0, 0), it will cause
read_tree_block() to return -EUCLEAN and interrupt relocation recovery.

Fix it by setting @first_key correctly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/relocation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 00b7d3231821..b041b945a7ae 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1841,7 +1841,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 		old_bytenr = btrfs_node_blockptr(parent, slot);
 		blocksize = fs_info->nodesize;
 		old_ptr_gen = btrfs_node_ptr_generation(parent, slot);
-		btrfs_node_key_to_cpu(parent, &key, slot);
+		btrfs_node_key_to_cpu(parent, &first_key, slot);
 
 		if (level <= max_level) {
 			eb = path->nodes[level];
-- 
2.17.0

