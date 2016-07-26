Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbcGZOmP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 10:42:15 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs for 4.8, part 1
Date: Tue, 26 Jul 2016 16:41:57 +0200
Message-Id: <cover.1469542859.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please pull the following patches to 4.8. There are mostly small independent
fixes or cleanups. The branch is based on your current 'next' because of patch
dependencies. I don't want to start it on 4.7-rc6 as the merge conflicts would
be many and not trivial.

There are a few more patches that were sent but haven't received enough reviews
so I may send one more pull request should this change.

----------------------------------------------------------------
The following changes since commit 8b8b08cbfb9021af4b54b4175fc4c51d655aac8c:

  Btrfs: fix delalloc accounting after copy_from_user faults (2016-07-21 04:03:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.8

for you to fetch changes up to 66642832f06a4351e23cea6cf254967c227f8224:

  btrfs: btrfs_abort_transaction, drop root parameter (2016-07-26 13:54:26 +0200)

----------------------------------------------------------------
Anand Jain (2):
      btrfs: reorg btrfs_close_one_device()
      btrfs: make sure device is synced before return

Ashish Samant (1):
      btrfs: Cleanup compress_file_range()

Chandan Rajendra (1):
      Btrfs: subpage-blocksize: Rate limit scrub error message

David Sterba (2):
      btrfs: hide test-only member under ifdef
      btrfs: remove obsolete part of comment in statfs

Hans van Kranenburg (1):
      Btrfs: use the correct struct for BTRFS_IOC_LOGICAL_INO

Jeff Mahoney (14):
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

Liu Bo (10):
      Btrfs: check inconsistence between chunk and block group
      Btrfs: error out if generic_bin_search get invalid arguments
      Btrfs: fix double free of fs root
      Btrfs: fix read_node_slot to return errors
      Btrfs: cleanup BUG_ON in merge_bio
      Btrfs: fix BUG_ON in btrfs_submit_compressed_write
      Btrfs: change BUG_ON()'s to ASSERT()'s in backref_cache_cleanup()
      Btrfs: fix eb memory leak due to readpage failure
      Btrfs: fix panic in balance due to EIO
      Btrfs: fix unexpected balance crash due to BUG_ON

Nikolay Borisov (4):
      btrfs: Handle uninitialised inode eviction
      btrfs: Fix slab accounting flags
      btrfs: Add ratelimit to btrfs printing
      btrfs: Ratelimit "no csum found" info message

Salah Triki (1):
      btrfs: Replace -ENOENT by -ERANGE in btrfs_get_acl()

Wang Xiaoguang (3):
      btrfs: add missing bytes_readonly attribute file in sysfs
      btrfs: expand cow_file_range() to support in-band dedup and subpage-blocksize
      btrfs: fix free space calculation in dump_space_info()

 fs/btrfs/acl.c                         |   3 +-
 fs/btrfs/async-thread.c                |  31 +++-
 fs/btrfs/async-thread.h                |   6 +-
 fs/btrfs/backref.c                     |   4 +-
 fs/btrfs/compression.c                 |  10 +-
 fs/btrfs/ctree.c                       |  91 ++++++----
 fs/btrfs/ctree.h                       | 101 ++++++-----
 fs/btrfs/dedupe.h                      |  24 +++
 fs/btrfs/delayed-inode.c               |   4 +-
 fs/btrfs/delayed-ref.c                 |  17 +-
 fs/btrfs/dev-replace.c                 |   4 +-
 fs/btrfs/disk-io.c                     | 101 +++++------
 fs/btrfs/disk-io.h                     |   3 +-
 fs/btrfs/extent-tree.c                 | 124 ++++++++------
 fs/btrfs/extent_io.c                   |  30 +++-
 fs/btrfs/extent_map.c                  |   2 +-
 fs/btrfs/file-item.c                   |   9 +-
 fs/btrfs/file.c                        |  12 +-
 fs/btrfs/free-space-cache.c            |   8 +-
 fs/btrfs/free-space-tree.c             |  16 +-
 fs/btrfs/inode-map.c                   |  16 +-
 fs/btrfs/inode.c                       | 218 ++++++++++++------------
 fs/btrfs/ioctl.c                       |  40 ++---
 fs/btrfs/ordered-data.c                |   2 +-
 fs/btrfs/props.c                       |   6 +-
 fs/btrfs/qgroup.c                      |  25 +--
 fs/btrfs/qgroup.h                      |   9 +-
 fs/btrfs/relocation.c                  |  20 ++-
 fs/btrfs/root-tree.c                   |  10 +-
 fs/btrfs/scrub.c                       |  12 +-
 fs/btrfs/super.c                       | 218 +++++++++++-------------
 fs/btrfs/sysfs.c                       |   2 +
 fs/btrfs/tests/btrfs-tests.c           |  67 +++++++-
 fs/btrfs/tests/btrfs-tests.h           |  36 +---
 fs/btrfs/tests/extent-buffer-tests.c   |  23 ++-
 fs/btrfs/tests/free-space-tests.c      |  14 +-
 fs/btrfs/tests/free-space-tree-tests.c |  18 +-
 fs/btrfs/tests/inode-tests.c           |  46 ++---
 fs/btrfs/tests/qgroup-tests.c          |  23 +--
 fs/btrfs/transaction.c                 |  37 +++--
 fs/btrfs/transaction.h                 |   1 +
 fs/btrfs/tree-log.c                    |  22 ++-
 fs/btrfs/volumes.c                     | 138 ++++++++-------
 include/trace/events/btrfs.h           | 295 ++++++++++++++++++---------------
 include/uapi/linux/btrfs.h             |   2 +-
 45 files changed, 1074 insertions(+), 826 deletions(-)
 create mode 100644 fs/btrfs/dedupe.h
