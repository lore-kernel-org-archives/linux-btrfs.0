Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728354AbeIGOMq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 10:12:46 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A70FCAFC8
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 09:32:39 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs: qgroup: Skip unrelated tree blocks for balance
Date: Fri,  7 Sep 2018 17:32:30 +0800
Message-Id: <20180907093235.28254-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
The base commit is v4.19-rc1 tag.

There are a lot of reports of system hang for balance on quota enabled
fs.
It's most obvious for large fs.

The hang is caused by tons of unmodified extents marked as qgroup dirty.
Such unmodified/unrelated sources include:
1) Unmodified subtree
2) Subtree drop for reloc tree
(BTW, other sources includes unmodified file extent items)

E.g.
OO = Old tree blocks from file tree
NN = New tree blocks from reloc tree

        file tree                              reloc tree
           OO (a)                                  NN (a)
          /  \                                    /  \
    (b) OO    OO (c)                        (b) NN    NN (c)
       / \   / \                               / \   / \
     OO  OO OO  OO                           OO  OO OO  NN
    (d) (e) (f) (g)                         (d) (e) (f) (g)

In above case, balance will modify nodeptr in OO(a) to point NN(b) and
NN(c), and modify NN(a) to point to OO(B) and OO(c).

Before this patch, quota will mark the whole subtree from its parent
down to the leaves as dirty.
So btrfs quota need to trace all tree block from (a) to (g).

However tree blocks (d) (e) (f) are shared between both trees, thus
there is no need to trace those 3 tree blocks.

This patchset will change how this work by only tracing modified tree
blocks in reloc tree, and their counter parts in file tree.

Nodeptr swap will happen for tree blocks (b) and (c) in both tree.

For tree block (b), in reloc tree we could find that all its
children's generation is smaller than last_snapshot, thus no need to
trace them, only need to trace NN(b), and its counter part OO(b).

For tree block (c), in reloc tree, we find its child NN(g) need
tracing, and for tree block NN(g), there is no child need to trace.

So for subtree starting at tree block NN(c), we need to trace NN(c) and
NN(g), along with its counter part OO(c) and OO(c).

With this patch, we could skip tree blocks OO(d)~OO(f) in above example,
thus reduce some some overhead caused by qgroup.

The improvement is mostly related to metadata relocation.
If there is some high level tree blocks get relocated but its children are
still unmodified, we could save a lot of time.

Even for the worst case, it should be no worse than original full
subtree marking method.

Real world case benchmark is under way.

Changelog:
v2:
  Rename "tree reloc tree" to "reloc tree".
  Add patch "Don't trace subtree if we're dropping reloc tree" into the
  patchset.
  Fix wrong btrfs_bin_search() call, which leads to unexpected ENOENT
  error for btrfs_qgroup_trace_extent_swap(). Now use dst_path->slots[]
  directly.

Qu Wenruo (5):
  btrfs: qgroup: Introduce trace event to analyse the number of dirty
    extents accounted
  btrfs: qgroup: Introduce function to trace two swaped extents
  btrfs: qgroup: Introduce function to find all new tree blocks of reloc
    tree
  btrfs: qgroup: Use generation aware subtree swap to mark dirty extents
  btrfs: qgroup: Don't trace subtree if we're dropping reloc tree

 fs/btrfs/extent-tree.c       |   8 +-
 fs/btrfs/qgroup.c            | 338 +++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h            |  10 ++
 fs/btrfs/relocation.c        |  11 +-
 include/trace/events/btrfs.h |  21 +++
 5 files changed, 379 insertions(+), 9 deletions(-)

-- 
2.18.0
