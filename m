Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11543 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750711AbdAWJPJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 04:15:09 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH 1/9] btrfs-progs: lowmem check: Fix wrong block group check when search slot points to slot beyong leaf
Date: Mon, 23 Jan 2017 17:13:50 +0800
Message-ID: <20170123091359.21390-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs_search_slot() can points to the slot which is beyond the
leaves' capacity, in the following case, btrfs lowmem mode check will
skip the block group and report false alert:

leaf 29405184 items 37 free space 1273 generation 11 owner 2
...
        item 36 key (77594624 EXTENT_ITEM 2097152)
                extent refs 1 gen 8 flags DATA
                extent data backref root 5 objectid 265 offset 0 count 1
leaf 29409280 items 43 free space 670 generation 11 owner 2
        item 0 key (96468992 EXTENT_ITEM 2097152)
                extent refs 1 gen 8 flags DATA
                extent data backref root 5 objectid 274 offset 0 count 1
        item 1 key (96468992 BLOCK_GROUP_ITEM 33554432)
                block group used 2265088 chunk_objectid 256 flags DATA

When checking block group item, we will search key(96468992 0 0) to
start from the first item in the block group.

While search_slot() will point to leaf 29405184, slot 37 which is beyond
leaf capacity.

And when reading key from slot 37, uninitialized data can be read out
and cause us to exit block group item check, leading to false alert.

Fix it by checking path.slot[0] before reading out the key.

Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 1dba2985..c39392b7 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10961,6 +10961,11 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
 	/* Iterate extent tree to account used space */
 	while (1) {
 		leaf = path.nodes[0];
+
+		/* Search slot can point to the last item beyond leaf nritems */
+		if (path.slots[0] >= btrfs_header_nritems(leaf))
+			goto next;
+
 		btrfs_item_key_to_cpu(leaf, &extent_key, path.slots[0]);
 		if (extent_key.objectid >= bg_key.objectid + bg_key.offset)
 			break;
-- 
2.11.0



