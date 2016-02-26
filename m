Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbcBZPc1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 10:32:27 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs for 4.6
Date: Fri, 26 Feb 2016 16:32:10 +0100
Message-Id: <cover.1456497735.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is my final pull request for 4.6 branches that I've been tracking. All of
them were in for-next for some time.

Summary:

* Chandan's preparatory work for subpage-blocksize
* Qu's updates to mount options (usebackuproot, nologreplay, norecovery)
* Zhao's readahead bugfixes
* Josef's updates to space handling
* from me, GFP flag updates, b-tree key space renamings
* collection of misc patches (sent out of series)
* misc cleanups

The patchset to allow device deletion by id is not part of this pull.

----------------------------------------------------------------
The following changes since commit 18558cae0272f8fd9647e69d3fec1565a7949865:

  Linux 4.5-rc4 (2016-02-14 13:05:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris

for you to fetch changes up to f5bc27c71a1b0741cb93dbec0f216b012b21d93f:

  Merge branch 'dev/control-ioctl' into for-chris-4.6 (2016-02-26 15:38:34 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      btrfs: avoid uninitialized variable warning

Byongho Lee (2):
      btrfs: simplify expression in btrfs_calc_trans_metadata_size()
      btrfs: remove redundant error check

Chandan Rajendra (12):
      Btrfs: __btrfs_buffered_write: Reserve/release extents aligned to block size
      Btrfs: Compute and look up csums based on sectorsized blocks
      Btrfs: Direct I/O read: Work on sectorsized blocks
      Btrfs: fallocate: Work with sectorsized blocks
      Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units
      Btrfs: Search for all ordered extents that could span across a page
      Btrfs: Use (eb->start, seq) as search key for tree modification log
      Btrfs: btrfs_submit_direct_hook: Handle map_length < bio vector length
      Btrfs: Limit inline extents to root->sectorsize
      Btrfs: Fix block size returned to user space
      Btrfs: Clean pte corresponding to page straddling i_size
      Btrfs: btrfs_ioctl_clone: Truncate complete page after performing clone operation

Dave Jones (1):
      btrfs: remove open-coded swap() in backref.c:__merge_refs

David Sterba (30):
      btrfs: send: use GFP_KERNEL everywhere
      btrfs: reada: use GFP_KERNEL everywhere
      btrfs: scrub: use GFP_KERNEL on the submission path
      btrfs: let callers of btrfs_alloc_root pass gfp flags
      btrfs: fallocate: use GFP_KERNEL
      btrfs: readdir: use GFP_KERNEL
      btrfs: device add and remove: use GFP_KERNEL
      btrfs: extent same: use GFP_KERNEL for page array allocations
      btrfs: switch to kcalloc in btrfs_cmp_data_prepare
      btrfs: introduce key type for persistent temporary items
      btrfs: switch balance item to the temporary item key
      btrfs: introduce key type for persistent permanent items
      btrfs: switch dev stats item to the permanent item key
      btrfs: teach print_leaf about permanent item subtypes
      btrfs: teach print_leaf about temporary item subtypes
      btrfs: use proper type for failrec in extent_state
      btrfs: remove error message from search ioctl for nonexistent tree
      btrfs: change max_inline default to 2048
      btrfs: add GET_SUPPORTED_FEATURES to the control device ioctls
      btrfs: drop unused argument in btrfs_ioctl_get_supported_features
      Merge branch 'chandan/prep-subpage-blocksize' into for-chris-4.6
      Merge branch 'dev/gfp-flags' into for-chris-4.6
      Merge branch 'dev/rename-keys' into for-chris-4.6
      Merge branch 'foreign/qu/norecovery-v7' into for-chris-4.6
      Merge branch 'foreign/zhaolei/reada' into for-chris-4.6
      Merge branch 'foreign/josef/space-updates' into for-chris-4.6
      Merge branch 'foreign/liubo/replace-lockup' into for-chris-4.6
      Merge branch 'cleanups-4.6' into for-chris-4.6
      Merge branch 'misc-4.6' into for-chris-4.6
      Merge branch 'dev/control-ioctl' into for-chris-4.6

Deepa Dinamani (1):
      btrfs: Replace CURRENT_TIME by current_fs_time()

Josef Bacik (4):
      Btrfs: change how we update the global block rsv
      Btrfs: fix truncate_space_check
      Btrfs: add transaction space reservation tracepoints
      Btrfs: check reserved when deciding to background flush

Kinglong Mee (2):
      btrfs: drop null testing before destroy functions
      btrfs: fix memory leak of fs_info in block group cache

Liu Bo (1):
      Btrfs: fix lockdep deadlock warning due to dev_replace

Qu Wenruo (3):
      btrfs: Introduce new mount option usebackuproot to replace recovery
      btrfs: Introduce new mount option to disable tree log replay
      btrfs: Introduce new mount option alias for nologreplay

Sudip Mukherjee (1):
      btrfs: fix build warning

Zhao Lei (18):
      btrfs: reada: Fix in-segment calculation for reada
      btrfs: reada: reduce additional fs_info->reada_lock in reada_find_zone
      btrfs: reada: Add missed segment checking in reada_find_zone
      btrfs: reada: Avoid many times of empty loop
      btrfs: reada: Move is_need_to_readahead contition earlier
      btrfs: reada: add all reachable mirrors into reada device list
      btrfs: reada: bypass adding extent when all zone failed
      btrfs: reada: Remove level argument in severial functions
      btrfs: reada: move reada_extent_put to place after __readahead_hook()
      btrfs: reada: Pass reada_extent into __readahead_hook directly
      btrfs: reada: Use fs_info instead of root in __readahead_hook's argument
      btrfs: reada: Jump into cleanup in direct way for __readahead_hook()
      btrfs: reada: Fix a debug code typo
      btrfs: reada: simplify dev->reada_in_flight processing
      btrfs: reada: limit max works count
      btrfs: reada: avoid undone reada extents in btrfs_reada_wait
      btrfs: reada: ignore creating reada_extent for a non-existent device
      btrfs: Continue write in case of can_not_nocow

 Documentation/filesystems/btrfs.txt    |  19 ++-
 fs/btrfs/backref.c                     |  12 +-
 fs/btrfs/ctree.c                       |  36 ++--
 fs/btrfs/ctree.h                       |  69 ++++++--
 fs/btrfs/delayed-inode.c               |   3 +-
 fs/btrfs/delayed-ref.c                 |  12 +-
 fs/btrfs/dev-replace.c                 | 132 ++++++++-------
 fs/btrfs/dev-replace.h                 |   7 +-
 fs/btrfs/disk-io.c                     |  68 ++++----
 fs/btrfs/extent-tree.c                 |  38 +++--
 fs/btrfs/extent_io.c                   |  40 ++---
 fs/btrfs/extent_io.h                   |   5 +-
 fs/btrfs/extent_map.c                  |   3 +-
 fs/btrfs/file-item.c                   |  92 ++++++----
 fs/btrfs/file.c                        | 146 +++++++++-------
 fs/btrfs/inode.c                       | 301 ++++++++++++++++++++++-----------
 fs/btrfs/ioctl.c                       |  28 ++-
 fs/btrfs/ordered-data.c                |   3 +-
 fs/btrfs/print-tree.c                  |  23 ++-
 fs/btrfs/reada.c                       | 268 ++++++++++++++---------------
 fs/btrfs/root-tree.c                   |   2 +-
 fs/btrfs/scrub.c                       |  30 ++--
 fs/btrfs/send.c                        |  36 ++--
 fs/btrfs/super.c                       |  48 +++++-
 fs/btrfs/tests/btrfs-tests.c           |   6 -
 fs/btrfs/tests/free-space-tree-tests.c |   1 +
 fs/btrfs/transaction.c                 |  13 +-
 fs/btrfs/volumes.c                     |  47 ++---
 fs/btrfs/xattr.c                       |   2 +-
 29 files changed, 881 insertions(+), 609 deletions(-)
