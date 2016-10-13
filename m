Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:48532 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754324AbcJML1X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 07:27:23 -0400
From: ethanwu <ethanwu@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: ethanwu <ethanwu@synology.com>
Subject: [PATCH 1/2] btrfs-progs: check: skip keys prior to drop key in deleted subvolume correctly
Date: Thu, 13 Oct 2016 19:09:48 +0800
Message-Id: <1476356989-23131-2-git-send-email-ethanwu@synology.com>
In-Reply-To: <1476356989-23131-1-git-send-email-ethanwu@synology.com>
References: <1476356989-23131-1-git-send-email-ethanwu@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In processing deleted subvolume, we would skip keys based on subvolume
drop key. The condition only checks the keys at same level. This is not
correct. Consider the following situation of one deleted subvolume.

This is a node of subvolume root:
node 13459456000 level 3 items 9 free 484 generation 12281 owner 869
	key (256 INODE_ITEM 0) block 29986832384 (1830251) gen 12999
	key (5828 DIR_ITEM 819422210) block 30048043008 (1833987) gen 12995
	key (17069 INODE_REF 16812) block 30057644032 (1834573) gen 12996
	key (28250 DIR_ITEM 3506778047) block 30063820800 (1834950) gen 12996
	key (39436 INODE_REF 39387) block 30077894656 (1835809) gen 12997
	key (50746 XATTR_ITEM 3572018377) block 29961109504 (1828681) gen 12998
	key (61962 DIR_ITEM 1803896258) block 29960192000 (1828625) gen 12998
	key (73287 INODE_ITEM 0) block 29988372480 (1830345) gen 12999
	key (84574 XATTR_ITEM 819422210) block 29986570240 (1830235) gen 12999

Suppose the drop key is (5828 DIR_ITEM 0) and drop level is 1.
btrfs check will iterate all nodes pointed by node 13459456000.
Now consider the node 29986832384 whose first key is (256 INODE_ITEM 0):
Since the last key of this node is prior to drop key, the node is freed if
no other snapshots point to it. Although the node is freed, node 29986832384
is still pointed by node 13459456000(not cowed) in subvolume deleted case.
There's a chance that node 29986832384 could be reused.
In the origin logic to check whether to skip the node or not,
it only checks the key at the same level. Therefore, in this case,
node(block) 29986832384, which has level 2, won't be skipped and will be
added to list to be processed. Later when reading the node 29986832384,
btrfs-check finds out that transid mismatches because node 29986832384 is
already reused.
The following error would happen:
parent transid verify failed on 29986832384 wanted 12999 found XXXXX

Fix this by skipping the drop key correctly. Here's the logic:

We refer to this_node and this_key as the node and the key we are processing
right now. next_key is the key next to this_key. In the above example, if
this_key is (61962 DIR_ITEM 1803896258), next_key is (73287 INODE_ITEM 0).

If the level of this_key is:
1. the same with drop_level of drop_key, simply compare the keys (the original
   logic).

2. less than the drop key, and value of this_key
2.1. this_key >= drop_key: this node needs to be processed.
2.2. this_key < drop_key:
    The first key of its ancestor node at drop_level meets the condition:
    ancestor_key <= this_key < drop_key which.
    According to condition 1, it will be skipped, so this should not happen.

3. greater than the drop key, and the value of this_key
3.1 this_key >= drop_key:
    All keys of descendants node pointed by this_key >= this_key >= drop_key.
    This node needs to be processed
3.2 this_key < drop_key:
    If this_key is not the last key in this node, check the next_key.
    If next_key <= drop_key, then this_key < next_key <= drop_key,
    we know the node containing this_key is already freed, so skip this_node.
    Otherwise, this_key < drop_key < next_key, we know that the drop_key at
    drop_level must be this_key's descendant, so this node needs to be
    processed.

By combinging the above conditions altogether, we only needs to skip
condition 1 and condition 3.2.
condition 3.1 implies next_key > this_key >= drop_key -> next_key > drop_key,
so we get the result conditions.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 cmds-check.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 670ccd1..bf6398d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6459,9 +6459,17 @@ static int run_next_block(struct btrfs_root *root,
 			size = root->nodesize;
 			btrfs_node_key_to_cpu(buf, &key, i);
 			if (ri != NULL) {
-				if ((level == ri->drop_level)
-				    && is_dropped_key(&key, &ri->drop_key)) {
-					continue;
+				if (ri->drop_level) {
+					if (level == ri->drop_level) {
+						if (is_dropped_key(&key, &ri->drop_key))
+							continue;
+					} else if (level > ri->drop_level && i+1 < nritems) {
+						struct btrfs_key next_key;
+
+						btrfs_node_key_to_cpu(buf, &next_key, i+1);
+						if (0 >= btrfs_comp_cpu_keys(&next_key, &ri->drop_key))
+							continue;
+					}
 				}
 			}
 
-- 
1.9.1

