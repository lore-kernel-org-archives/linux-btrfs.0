Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42801 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeEKH4V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:56:21 -0400
Received: by mail-pl0-f65.google.com with SMTP id u6-v6so2837970pls.9
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:56:21 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 00/11] Btrfs: orphan and truncate fixes
Date: Fri, 11 May 2018 00:56:05 -0700
Message-Id: <cover.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This is v3 of the fixes for the orphan item early ENOSPC issue we hit at
Facebook. The big change is that I now also got rid of
BTRFS_INODE_HAS_ORPHAN_ITEM (thanks, Nikolay) and shuffled the patches
around so there is less churn.

Changes since v2:

- Add patch 5 to get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
- Move patch 10 to patch 6
- Got rid of patch 5; the bug goes away in the process of removing code
  for patches 9 and 10
- Rename patch 10 batch to what it was called in v1

Changes since v1:

- Added two extra cleanups, patches 10 and 11
- Added a forgotten clear of the orphan bit in patch 8
- Reworded titles of patches 6 and 9
- Added people's reviewed-bys

Cover letter from v1:

At Facebook we hit an early ENOSPC issue which we tracked down to the
reservations for orphan items of deleted-but-still-open files. The
primary function of this series is to fix that bug, but I ended up
uncovering a pile of other issues in the process, most notably that the
orphan items we create for truncate are useless.

I've also posted an xfstest that reproduces this bug.

Thanks!

Omar Sandoval (11):
  Btrfs: remove stale comment referencing vmtruncate()
  Btrfs: fix error handling in btrfs_truncate_inode_items()
  Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
  Btrfs: stop creating orphan items for truncate
  Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
  Btrfs: delete dead code in btrfs_orphan_commit_root()
  Btrfs: don't return ino to ino cache if inode item removal fails
  Btrfs: refactor btrfs_evict_inode() reserve refill dance
  Btrfs: fix ENOSPC caused by orphan items reservations
  Btrfs: get rid of unused orphan infrastructure
  Btrfs: reserve space for O_TMPFILE orphan item deletion

 fs/btrfs/btrfs_inode.h      |  18 +-
 fs/btrfs/ctree.h            |   8 -
 fs/btrfs/disk-io.c          |   9 -
 fs/btrfs/extent-tree.c      |  38 ---
 fs/btrfs/free-space-cache.c |   6 +-
 fs/btrfs/inode.c            | 576 ++++++++++--------------------------
 fs/btrfs/transaction.c      |   1 -
 7 files changed, 170 insertions(+), 486 deletions(-)

-- 
2.17.0

