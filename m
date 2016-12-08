Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34847 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751985AbcLHNYH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 08:24:07 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs cleanups for 4.10
Date: Thu,  8 Dec 2016 14:23:57 +0100
Message-Id: <cover.1481039293.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

now that the regular patches are on the way to 4.10, it's a good time to
squeeze the cleanups before we start merging further patches. This pull request
contains the series from Jeff, the code changes are all over the map. I think
we won't find a better time to merge that so be it now.

The branch is based on my previous pull request head, and with a signed tag.

The following changes since commit 515bdc479097ec9d5f389202842345af3162f71c:

  Merge branch 'misc-4.10' into for-chris-4.10-20161130 (2016-11-30 14:02:20 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.10-20161206

for you to fetch changes up to 34441361c4f52a5f6e41d8de8e5debbeb415dbf0:

  btrfs: opencode chunk locking, remove helpers (2016-12-06 16:07:00 +0100)

----------------------------------------------------------------
David Sterba (1):
      btrfs: opencode chunk locking, remove helpers

Jeff Mahoney (19):
      btrfs: call functions that overwrite their root parameter with fs_info
      btrfs: call functions that always use the same root with fs_info instead
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
      btrfs: convert extent-tree tracepoints to use fs_info
      btrfs: simplify btrfs_wait_cache_io prototype
      btrfs: take an fs_info directly when the root is not used otherwise
      btrfs: split btrfs_wait_marked_extents into normal and tree log functions
      btrfs: remove root parameter from transaction commit/end routines

 fs/btrfs/backref.c                     |   10 +-
 fs/btrfs/check-integrity.c             |   73 +-
 fs/btrfs/check-integrity.h             |    5 +-
 fs/btrfs/compression.c                 |   54 +-
 fs/btrfs/ctree.c                       |  468 ++++++------
 fs/btrfs/ctree.h                       |  216 +++---
 fs/btrfs/delayed-inode.c               |  138 ++--
 fs/btrfs/delayed-inode.h               |   19 +-
 fs/btrfs/dev-replace.c                 |   68 +-
 fs/btrfs/dev-replace.h                 |    4 +-
 fs/btrfs/dir-item.c                    |   45 +-
 fs/btrfs/disk-io.c                     |  546 +++++++-------
 fs/btrfs/disk-io.h                     |   30 +-
 fs/btrfs/export.c                      |   10 +-
 fs/btrfs/extent-tree.c                 | 1300 ++++++++++++++++----------------
 fs/btrfs/extent_io.c                   |   63 +-
 fs/btrfs/extent_io.h                   |    8 +-
 fs/btrfs/file-item.c                   |  152 ++--
 fs/btrfs/file.c                        |  214 +++---
 fs/btrfs/free-space-cache.c            |  154 ++--
 fs/btrfs/free-space-cache.h            |   12 +-
 fs/btrfs/free-space-tree.c             |   44 +-
 fs/btrfs/inode-item.c                  |   11 +-
 fs/btrfs/inode-map.c                   |   22 +-
 fs/btrfs/inode.c                       |  765 ++++++++++---------
 fs/btrfs/ioctl.c                       |  577 +++++++-------
 fs/btrfs/ordered-data.c                |   38 +-
 fs/btrfs/ordered-data.h                |    4 +-
 fs/btrfs/print-tree.c                  |   19 +-
 fs/btrfs/print-tree.h                  |    4 +-
 fs/btrfs/props.c                       |    5 +-
 fs/btrfs/qgroup.c                      |   64 +-
 fs/btrfs/qgroup.h                      |    2 +-
 fs/btrfs/raid56.c                      |   62 +-
 fs/btrfs/raid56.h                      |    8 +-
 fs/btrfs/reada.c                       |   34 +-
 fs/btrfs/relocation.c                  |  257 ++++---
 fs/btrfs/root-tree.c                   |   28 +-
 fs/btrfs/scrub.c                       |  166 ++--
 fs/btrfs/send.c                        |   33 +-
 fs/btrfs/super.c                       |  134 ++--
 fs/btrfs/tests/btrfs-tests.c           |   13 +-
 fs/btrfs/tests/btrfs-tests.h           |    4 +-
 fs/btrfs/tests/extent-buffer-tests.c   |    7 +-
 fs/btrfs/tests/extent-io-tests.c       |    5 +-
 fs/btrfs/tests/free-space-tests.c      |   18 +-
 fs/btrfs/tests/free-space-tree-tests.c |    9 +-
 fs/btrfs/tests/inode-tests.c           |   16 +-
 fs/btrfs/tests/qgroup-tests.c          |   11 +-
 fs/btrfs/transaction.c                 |  615 +++++++--------
 fs/btrfs/transaction.h                 |   29 +-
 fs/btrfs/tree-log.c                    |  195 ++---
 fs/btrfs/uuid-tree.c                   |   23 +-
 fs/btrfs/volumes.c                     |  785 ++++++++++---------
 fs/btrfs/volumes.h                     |   45 +-
 fs/btrfs/xattr.c                       |   21 +-
 include/trace/events/btrfs.h           |   65 +-
 57 files changed, 3921 insertions(+), 3806 deletions(-)
