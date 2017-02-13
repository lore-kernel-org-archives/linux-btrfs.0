Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751887AbdBMJdv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:33:51 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2FE28ABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:33:50 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/29] Cleanup of unused parameters
Date: Mon, 13 Feb 2017 10:33:21 +0100
Message-Id: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are quite a few places where function parameters are unused and there's
no reason to keep them. The notable exceptions are callbacks that must match a
given prototype. There are several cases where the parameter has not been
removed after refactoring or other changes, but I'm more disappointed by the
numerous cases where parameters were added but never used.

I haven't measured the effects on runtime stack consumption, the estimate
savings can be counted in tens of bytes.

Found by 'make ccflags-y=-Wunused-parameter', applies on top of my current 4.11
queue.

David Sterba (29):
  btrfs: remove unused parameter from read_block_for_search
  btrfs: remove unused parameter from check_async_write
  btrfs: remove unused parameter from clean_tree_block
  btrfs: remove unused parameter from split_item
  btrfs: remove unused parameter from write_dev_supers
  btrfs: merge two superblock writing helpers
  btrfs: remove unused parameter from __push_leaf_right
  btrfs: remove unused parameter from __push_leaf_left
  btrfs: remove unused parameter from btrfs_subvolume_release_metadata
  btrfs: remove unused parameter from btrfs_prepare_extent_commit
  btrfs: remove unused parameter from btrfs_check_super_valid
  btrfs: remove unused parameter from tree_move_down
  btrfs: remove unused parameter from tree_move_next_or_upnext
  btrfs: remove unused parameter from submit_extent_page
  btrfs: remove unused parameter from update_nr_written
  btrfs: remove unused parameter from add_pending_csums
  btrfs: remove unused parameter from extent_write_cache_pages
  btrfs: remove unused parameter from btrfs_fill_super
  btrfs: remove unused parameter from __btrfs_alloc_chunk
  btrfs: remove unused parameter from init_first_rw_device
  btrfs: remove unused parameter from create_snapshot
  btrfs: remove unused parameters from scrub_setup_wr_ctx
  btrfs: remove unused parameter from __add_inline_refs
  btrfs: remove unused parameters from btrfs_cmp_data
  btrfs: remove unused parameter from clone_copy_inline_extent
  btrfs: remove unused parameter from __add_inode_ref
  btrfs: remove unused parameter from cleanup_write_cache_enospc
  btrfs: remove unused parameters from __btrfs_write_out_cache
  btrfs: remove unused parameter from adjust_slots_upwards

 fs/btrfs/backref.c          |  5 ++---
 fs/btrfs/ctree.c            | 51 ++++++++++++++++++++-------------------------
 fs/btrfs/ctree.h            |  6 ++----
 fs/btrfs/disk-io.c          | 29 +++++++++-----------------
 fs/btrfs/disk-io.h          |  6 ++----
 fs/btrfs/extent-tree.c      | 10 ++++-----
 fs/btrfs/extent_io.c        | 21 ++++++++-----------
 fs/btrfs/free-space-cache.c | 16 +++++---------
 fs/btrfs/free-space-tree.c  |  2 +-
 fs/btrfs/inode.c            |  6 ++----
 fs/btrfs/ioctl.c            | 25 +++++++++-------------
 fs/btrfs/qgroup.c           |  7 +++----
 fs/btrfs/scrub.c            | 10 +++------
 fs/btrfs/super.c            |  5 ++---
 fs/btrfs/transaction.c      |  4 ++--
 fs/btrfs/tree-log.c         | 11 +++++-----
 fs/btrfs/volumes.c          | 18 +++++++---------
 17 files changed, 92 insertions(+), 140 deletions(-)

-- 
2.10.1

