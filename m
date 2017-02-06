Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11354 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750879AbdBFFro (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:47:44 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH v2 01/12] btrfs-progs: lowmem check: Fix several bugs related to afterward search
Date: Mon, 6 Feb 2017 13:47:24 +0800
Message-ID: <20170206054735.5227-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since btrfs_search_slot() can points to the slot which is beyond the
leaves' capacity, we should pay extra attention when doing afterward
search.

While for lowmem check, several places uses afterward search:
1) Block group item used space check
2) Device item used space check
3) Data extent backref check.

In the following case for block group item check, btrfs lowmem mode
check will skip the block group and report false alert:

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
Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 37e5ff18..699753fb 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10591,6 +10591,8 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		leaf = path.nodes[0];
 		slot = path.slots[0];
 
+		if (slot >= btrfs_header_nritems(leaf))
+			goto next;
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid != objectid || key.type != BTRFS_EXTENT_DATA_KEY)
 			break;
@@ -10606,6 +10608,7 @@ static int check_extent_data_backref(struct btrfs_fs_info *fs_info,
 		    offset)
 			found_count++;
 
+next:
 		ret = btrfs_next_item(root, &path);
 		if (ret)
 			break;
@@ -10878,8 +10881,10 @@ static int check_dev_item(struct btrfs_fs_info *fs_info,
 
 	/* Iterate dev_extents to calculate the used space of a device */
 	while (1) {
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0]))
+			goto next;
 
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
 		if (key.objectid > dev_id)
 			break;
 		if (key.type != BTRFS_DEV_EXTENT_KEY || key.objectid != dev_id)
@@ -10976,6 +10981,11 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
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



