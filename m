Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726274AbeIKKgE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 06:36:04 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 812E1B08D
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 05:38:27 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/7] btrfs: qgroup: Reduce dirty extents for metadata
Date: Tue, 11 Sep 2018 13:38:11 +0800
Message-Id: <20180911053818.10191-1-wqu@suse.com>
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

With this patch, we could skip tree blocks OO(d)~OO(f) in above example,
thus reduce some some overhead caused by qgroup.

The improvement is mostly related to metadata relocation.

Also, for metadata relocation, we don't really need to trace data
extents as they're not modified at all.


[[Benchmark]]
Hardware:
	VM 4G vRAM, 8 vCPUs,
	disk is using 'unsafe' cache mode,
	backing device is SAMSUNG 850 evo SSD.
	Host has 16G ram.

Mkfs parameter:
	--nodesize 4K (To bump up tree size)

Initial subvolume contents:
	4G data copied from /usr and /lib.
	(With enough regular small files)

Snapshots:
	16 snapshots of the original subvolume.
	each snapshot has 3 random files modified.

balance parameter:
	-m

So the content should be pretty similar to a real world root fs layout.

                     | v4.19-rc1    | w/ patchset    | diff (*)
---------------------------------------------------------------
relocated extents    | 22874        | 22856          | +0.1%
qgroup dirty extents | 225251       | 140431         | -37.7%
time (sys)           | 40.161s      | 20.574s        | -48.7%
time (real)          | 42.163s      | 25.173s        | -40.3%

*: (val_new - val_old) / val_old * 100%

And the difference is becoming more and more obvious if more snapshots
are created.

If we increase the number of snapshots to 64 (4 times the number of
references, and 64 snapshots is already not recommended to use with
quota)

                     | v4.19-rc1    | w/ patchset    | diff (*)
---------------------------------------------------------------
relocated extents    | 22462        | 22467          | +0.0%
qgroup dirty extents | 314380       | 140826         | -55.2%
time (sys)           | 158.033s     | 74.292s        | -53.0%
time (real)          | 197.395s     | 90.529s        | -67.6%

For larger fs the saving should be even more obvious.

Changelog:
v2:
  Rename "tree reloc tree" to "reloc tree".
  Add patch "Don't trace subtree if we're dropping reloc tree" into the
  patchset.
  Fix wrong btrfs_bin_search() call, which leads to unexpected ENOENT
  error for btrfs_qgroup_trace_extent_swap(). Now use dst_path->slots[]
  directly.
  
v3:
  Add new patch to avoid unnecessary data extents trace for metadata
  relocation.
  Better delayed ref time root owner detection to avoid unnecessary tree
  block tracing.
  Add benchmark result for the patchset.

Qu Wenruo (7):
  btrfs: qgroup: Introduce trace event to analyse the number of dirty
    extents accounted
  btrfs: qgroup: Introduce function to trace two swaped extents
  btrfs: qgroup: Introduce function to find all new tree blocks of reloc
    tree
  btrfs: qgroup: Use generation aware subtree swap to mark dirty extents
  btrfs: qgroup: Don't trace subtree if we're dropping reloc tree
  btrfs: delayed-ref: Introduce new parameter for
    btrfs_add_delayed_tree_ref() to reduce unnecessary qgroup tracing
  btrfs: qgroup: Only trace data extents in leaves if we're relocating
    data block group

 fs/btrfs/delayed-ref.c       |   5 +-
 fs/btrfs/delayed-ref.h       |   1 +
 fs/btrfs/extent-tree.c       |  25 ++-
 fs/btrfs/qgroup.c            | 347 +++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h            |  11 ++
 fs/btrfs/relocation.c        |  15 +-
 include/trace/events/btrfs.h |  21 +++
 7 files changed, 405 insertions(+), 20 deletions(-)

-- 
2.18.0
