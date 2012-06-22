Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:45778 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab2FVLAy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 07:00:54 -0400
Message-ID: <4FE45064.4090104@jan-o-sch.net>
Date: Fri, 22 Jun 2012 13:00:52 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: chris.mason@fusionio.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Deadlock in ctree.c?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While debugging my tree mod log, after several hours of successful iteration I
finally reached a dead lock. I got stacks with btrfs_next_leaf and
push_leaf_left and looked into those.

If I'm not mistaken, there is at least one deadlock situation between those two
(I'm currently thinking about a second one). Basically, the problem is that
btrfs_next_leaf has a leaf locked and wants a lock for the next (right) leaf,
while push_leaf_left has a lock on another leaf and wants a lock for the
previous (left) leaf.

Assume that we've got two roots (subvolumes), both referencing the same two
leafs in two really small trees:

          r1     r2
          |  \ /  |
          |   X   |
          |  / \  |
          l1     l2

Commented pseudo code that is meant to summarize the relevant code from ctree.c:

Thread A in push_leaf_left, path is currently r2->l2:
	btrfs_assert_tree_locked(path->nodes[1]); /* r2 */
	/* also holds a lock at path->nodes[0] -> l2 */
	left = read_node_slot(root, path->nodes[1], slot - 1); /* l1 */
	btrfs_tree_lock(left);
-> blocking to get lock on l1

Thread B in btrfs_next_leaf, path is currently r1->l1:
        path->keep_locks = 1;
	btrfs_search_slot(...); /* locks r1, l1 */
        level = 1;
        while ...
                slot = path->slots[level] + 1;
                next = read_block_for_search(... slot ...);
                btrfs_tree_read_lock(next); /* l2 */
-> blocking to get lock on l2

Any ideas on this one? Preferably hints to why I'm wrong :-)

Thanks!
-Jan
