Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbaLLRfr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 12:35:47 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 2BD5BABC6
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 17:35:46 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PULL] [PATCH 0/9] Cleanup, remove superfluous blocksize parameter, part 2
Date: Fri, 12 Dec 2014 18:35:45 +0100
Message-Id: <cover.1418404754.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's the rest of the parameter removal, no warnings anymore and passed
xfstests. There are a few more clenaups that were required to finish the goal.

You can pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanup/blocksize-diet-part2

Based on current next branch 9627aeee3e203e30679549e4962633698a6bf87f,
top commit ce3e69847e3ec79a38421bfd3d6f554d5e481231

David Sterba (9):
  btrfs: sink blocksize parameter to readahead_tree_block
  btrfs: remove blocksize from reada_extent
  btrfs: sink blocksize parameter to reada_tree_block_flagged
  btrfs: sink blocksize parameter to btrfs_init_new_buffer
  btrfs: sink blocksize parameter to btrfs_find_create_tree_block
  btrfs: sink blocksize parameter to tree_block_processed
  btrfs: use GFP_NOFS in __alloc_extent_buffer directly
  btrfs: unify extent buffer allocation api
  btrfs: sink parameter len to alloc_extent_buffer

 fs/btrfs/ctree.c                     | 13 +++++--------
 fs/btrfs/disk-io.c                   | 17 ++++++++---------
 fs/btrfs/disk-io.h                   |  6 +++---
 fs/btrfs/extent-tree.c               | 13 ++++++-------
 fs/btrfs/extent_io.c                 | 34 ++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h                 |  7 ++++---
 fs/btrfs/reada.c                     | 15 ++++++---------
 fs/btrfs/relocation.c                | 12 ++++++------
 fs/btrfs/tests/extent-buffer-tests.c |  2 +-
 fs/btrfs/tests/inode-tests.c         |  4 ++--
 fs/btrfs/tests/qgroup-tests.c        | 23 +++++++++++------------
 fs/btrfs/tree-log.c                  |  2 +-
 fs/btrfs/volumes.c                   |  9 +++++++--
 13 files changed, 84 insertions(+), 73 deletions(-)

-- 
2.1.3

