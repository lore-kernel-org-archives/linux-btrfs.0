Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34062 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726299AbeIEK6G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 06:58:06 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DB9F6AEEA
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Sep 2018 06:29:27 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs-progs: print-tree: breadth-first tree print order
Date: Wed,  5 Sep 2018 14:29:20 +0800
Message-Id: <20180905062924.23836-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/dump_tree_enhance

The main point of this patchset is to make "btrfs ins dump-tree" to
print tree blocks in breadth-first order when level is higher than 2.

The 1st patch is just a minor cleanup, to remove some unused and
meaningless output.

The 2nd patch does a root<->fs_info cleanup, provides the basis for
later btrfs_next_sibling_tree_block().

The 3rd patch implements a new function, btrfs_next_sibling_tree_block()
to find next sibling tree block, other than leaf.

The final patch will implement BFS for btrfs_print_tree().
The BFS search itself is implemented using path along with
 path::lowest_level and btrfs_next_sibling_tree_block() to iterate all
sibling tree blocks in a level.

Since BFS order is more human-friendly for higher trees, use BFS to
replace DFS order directly.

Qu Wenruo (4):
  btrfs-progs: print-tree: Skip deprecated blockptr / nodesize output
  btrfs-progs: Replace root parameter using fs_info for
    reada_for_search()
  btrfs-progs: Introduce function to find next sibling tree block
  btrfs-progs: print-tree: Use breadth-first search for
    btrfs_print_tree()

 cmds-restore.c |   4 +-
 ctree.c        |  25 ++++++------
 ctree.h        |  19 +++++++--
 print-tree.c   | 102 +++++++++++++++++++++++++++++++++++--------------
 4 files changed, 106 insertions(+), 44 deletions(-)

-- 
2.18.0
