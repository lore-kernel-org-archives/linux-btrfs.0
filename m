Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbcFXWP1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:27 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EDD8EAD3E
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:25 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/31] btrfs: simplify use of struct btrfs_root pointers
Date: Fri, 24 Jun 2016 18:14:53 -0400
Message-Id: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

One of the common complaints I've heard from new and experienced
developers alike about the btrfs code is the ubiquity of
struct btrfs_root.  There is one for every tree on disk and it's not
always obvious which root is needed in a particular call path.  It can
be frustrating to spend time figuring out which root is required only
to discover that it's not actually used for anything other than
getting the fs-global struct btrfs_fs_info.

The patchset contains several sections.

1) The fsid trace event patchset I posted earlier; I can rebase without this
   but I'd prefer not to.

2) Converting btrfs_test_opt and friends to use an fs_info.

3) Converting tests to use an fs_info pointer whenever a root is used.

4) Moving sectorsize and nodesize to fs_info and cleaning up the
   macros used to access them.

5) General cleanups and small fixes to make the later patches easier to
   review.

6) Adding an "fs_info" convenience variable to every functiont that
   references root->fs_info more than once.  As new references appear
   in functions, more of these are added later.

7) Call functions that always overwrite their root parameter with
   an fs_info instead.

8) Call functions that are always called using the same root with
   an fs_info instead, retreiving the root internally.

9) Convert every function that accepts a root argument but only uses it
   to retreive an fs_info to accept an fs_info instead.  This is a
   recursive process as the changes percolate up.

10) Separately convert btrfs_commit_transaction and btrfs_end_transaction
    to use trans->root instead of a root parameter.  Both are always called
    with the same root that was passed to btrfs_{start,join}_transaction.

This series of patches in email format is the "squashed" version of
the full development series.  That series is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/jeffm/linux-btrfs.git

There are two branches of interest:
- btrfs-testing/root-fsinfo-cleanup-squashed contains this series
- btrfs-testing/root-fsinfo-cleanup contains the full series

The btrfs-testing/root-fsinfo-cleanup branch is easier to review if using
git as each change is discrete.  As a whole, the patchset is invasive but
should change execution minimally.  It passes and fails the same xfstests
that the unpatched kernel does across multiple runs.

Thanks,

-Jeff

---

Jeff Mahoney (31):
  btrfs: plumb fs_info into btrfs_work
  btrfs: prefix fsid to all trace events
  btrfs: btrfs_test_opt and friends should take a btrfs_fs_info
  btrfs: tests, move initialization into tests/
  btrfs: tests, require fs_info for root
  btrfs: tests, use BTRFS_FS_STATE_DUMMY_FS_INFO instead of dummy root
  btrfs: simpilify btrfs_subvol_inherit_props
  btrfs: copy_to_sk drop unused root parameter
  btrfs: cleanup, remove prototype for btrfs_find_root_ref
  btrfs: introduce BTRFS_MAX_ITEM_SIZE
  btrfs: convert nodesize macros to static inlines
  btrfs: btrfs_relocate_chunk pass extent_root to btrfs_end_transaction
  btrfs: add btrfs_trans_handle->fs_info pointer
  btrfs: btrfs_abort_transaction, drop root parameter
  btrfs: call functions that overwrite their root parameter with fs_info
  btrfs: call functions that always use the same root with fs_info
    instead
  btrfs: btrfs_init_new_device should use fs_info->dev_root
  btrfs: alloc_reserved_file_extent trace point should use extent_root
  btrfs: struct btrfsic_state->root should be an fs_info
  btrfs: struct reada_control.root -> reada_control.fs_info
  btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere
  btrfs: root->fs_info cleanup, io_ctl_init
  btrfs: pull node/sector/stripe sizes out of root and into fs_info
  btrfs: root->fs_info cleanup, btrfs_calc_{trans,trunc}_metadata_size
  btrfs: root->fs_info cleanup, lock/unlock_chunks
  btrfs: root->fs_info cleanup, update_block_group{,flags}
  btrfs: root->fs_info cleanup, add fs_info convenience variables
  btrfs: root->fs_info cleanup, access fs_info->delayed_root directly
  btrfs: take an fs_info parameter directly when the root is not used
    otherwise
  btrfs: root->fs_info cleanup, btrfs_commit_transaction already has
    root
  btrfs: root->fs_info cleanup, btrfs_end_transaction{,_throttle} use
    trans->fs_info instead of parameter

 fs/btrfs/async-thread.c                |   31 +-
 fs/btrfs/async-thread.h                |    6 +-
 fs/btrfs/backref.c                     |   12 +-
 fs/btrfs/check-integrity.c             |   41 +-
 fs/btrfs/check-integrity.h             |    5 +-
 fs/btrfs/compression.c                 |   54 +-
 fs/btrfs/ctree.c                       |  483 ++++++------
 fs/btrfs/ctree.h                       |  281 +++----
 fs/btrfs/delayed-inode.c               |  147 ++--
 fs/btrfs/delayed-inode.h               |   19 +-
 fs/btrfs/delayed-ref.c                 |    9 +-
 fs/btrfs/dev-replace.c                 |   68 +-
 fs/btrfs/dev-replace.h                 |    4 +-
 fs/btrfs/dir-item.c                    |   44 +-
 fs/btrfs/disk-io.c                     |  593 ++++++++-------
 fs/btrfs/disk-io.h                     |   27 +-
 fs/btrfs/export.c                      |   10 +-
 fs/btrfs/extent-tree.c                 | 1297 ++++++++++++++++----------------
 fs/btrfs/extent_io.c                   |   41 +-
 fs/btrfs/extent_io.h                   |    4 +-
 fs/btrfs/file-item.c                   |  164 ++--
 fs/btrfs/file.c                        |  220 +++---
 fs/btrfs/free-space-cache.c            |  116 +--
 fs/btrfs/free-space-cache.h            |    6 +-
 fs/btrfs/free-space-tree.c             |   60 +-
 fs/btrfs/inode-item.c                  |   11 +-
 fs/btrfs/inode-map.c                   |   48 +-
 fs/btrfs/inode.c                       |  834 ++++++++++----------
 fs/btrfs/ioctl.c                       |  613 ++++++++-------
 fs/btrfs/ordered-data.c                |   38 +-
 fs/btrfs/ordered-data.h                |    4 +-
 fs/btrfs/print-tree.c                  |   21 +-
 fs/btrfs/print-tree.h                  |    4 +-
 fs/btrfs/props.c                       |   11 +-
 fs/btrfs/qgroup.c                      |   60 +-
 fs/btrfs/qgroup.h                      |    9 +-
 fs/btrfs/raid56.c                      |   60 +-
 fs/btrfs/raid56.h                      |    8 +-
 fs/btrfs/reada.c                       |   36 +-
 fs/btrfs/relocation.c                  |  261 ++++---
 fs/btrfs/root-tree.c                   |   36 +-
 fs/btrfs/scrub.c                       |  177 +++--
 fs/btrfs/send.c                        |   45 +-
 fs/btrfs/super.c                       |  308 ++++----
 fs/btrfs/tests/btrfs-tests.c           |   72 +-
 fs/btrfs/tests/btrfs-tests.h           |   38 +-
 fs/btrfs/tests/extent-buffer-tests.c   |   23 +-
 fs/btrfs/tests/free-space-tests.c      |   14 +-
 fs/btrfs/tests/free-space-tree-tests.c |   18 +-
 fs/btrfs/tests/inode-tests.c           |   46 +-
 fs/btrfs/tests/qgroup-tests.c          |   23 +-
 fs/btrfs/transaction.c                 |  531 ++++++-------
 fs/btrfs/transaction.h                 |   16 +-
 fs/btrfs/tree-log.c                    |  193 ++---
 fs/btrfs/uuid-tree.c                   |   20 +-
 fs/btrfs/volumes.c                     |  813 ++++++++++----------
 fs/btrfs/volumes.h                     |   42 +-
 fs/btrfs/xattr.c                       |   21 +-
 include/trace/events/btrfs.h           |  296 ++++----
 59 files changed, 4383 insertions(+), 4109 deletions(-)

-- 
2.7.1

