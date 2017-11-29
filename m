Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59173 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752177AbdK2Tae (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 14:30:34 -0500
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.15-rc2
Date: Wed, 29 Nov 2017 20:28:28 +0100
Message-Id: <cover.1511980478.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we've collected some fixes in since the pre-merge window freeze. There's
technically only one regression fix for 4.15, but the rest seems important and
candidates for stable. No merge conflicts, please pull, thanks.

- fix missing flush bio puts in error cases (is serious, but rarely happens)

- fix reporting stat::st_blocks for buffered append writes

- fix space cache invalidation

- fix out of bound memory access when setting zlib level

- fix potential memory corruption when fsync fails in the middle

- fix crash in integrity checker

- incremetnal send fix, path mixup for certain unlink/rename combination

- pass flags to writeback so compressed writes can be throttled properly

- error handling fixes

With signed tag: for-4.15-rc2-tag

----------------------------------------------------------------
The following changes since commit d28e649a5c58b779b303c252c66ee84a0f2c3b32:

  btrfs: Fix bug for misused dev_t when lookup in dev state hash table. (2017-11-01 20:45:36 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.15-rc2

for you to fetch changes up to ea37d5998b50a72b9045ba60a132eeb20e1c4230:

  Btrfs: incremental send, fix wrong unlink path after renaming file (2017-11-28 17:15:30 +0100)

----------------------------------------------------------------
David Sterba (2):
      btrfs: add missing device::flush_bio puts
      btrfs: dev_alloc_list is not protected by RCU, use normal list_del

Filipe Manana (3):
      Btrfs: move definition of the function btrfs_find_new_delalloc_bytes
      Btrfs: fix reported number of inode blocks after buffered append writes
      Btrfs: incremental send, fix wrong unlink path after renaming file

Josef Bacik (2):
      btrfs: clear space cache inode generation always
      btrfs: fix deadlock when writing out space cache

Liu Bo (3):
      Btrfs: add write_flags for compression bio
      Btrfs: bail out gracefully rather than BUG_ON
      Btrfs: fix list_add corruption and soft lockups in fsync

Nikolay Borisov (1):
      btrfs: Fix transaction abort during failure in btrfs_rm_dev_item

Qu Wenruo (2):
      btrfs: Fix wild memory access in compression level parser
      btrfs: tree-checker: Fix false panic for sanity test

 fs/btrfs/compression.c           |   9 +--
 fs/btrfs/compression.h           |   5 +-
 fs/btrfs/ctree.h                 |   1 +
 fs/btrfs/disk-io.c               |  10 ++-
 fs/btrfs/extent-tree.c           |  14 ++---
 fs/btrfs/extent_io.c             |   2 +-
 fs/btrfs/extent_io.h             |   8 ++-
 fs/btrfs/file.c                  | 130 +++++++++++++++++++++------------------
 fs/btrfs/free-space-cache.c      |   3 +-
 fs/btrfs/inode.c                 |  34 +++++++---
 fs/btrfs/relocation.c            |   3 +-
 fs/btrfs/send.c                  | 124 +++++++++++++++++++++++++++++++------
 fs/btrfs/super.c                 |  13 +++-
 fs/btrfs/tests/extent-io-tests.c |   6 +-
 fs/btrfs/tests/inode-tests.c     |  12 ++--
 fs/btrfs/tree-checker.c          |  27 ++++++--
 fs/btrfs/tree-checker.h          |  14 ++++-
 fs/btrfs/tree-log.c              |   2 +-
 fs/btrfs/volumes.c               |  32 +++++++---
 19 files changed, 314 insertions(+), 135 deletions(-)
