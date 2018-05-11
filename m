Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:44245 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbeEKUNu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 16:13:50 -0400
Received: by mail-pl0-f46.google.com with SMTP id e6-v6so3856445plt.11
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 13:13:49 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH v4 00/12] Btrfs: orphan and truncate fixes
Date: Fri, 11 May 2018 13:13:28 -0700
Message-Id: <cover.1526069051.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This is the fourth (and hopefully final) version of the orphan item
early ENOSPC and related fixes.

Changes since v3:

- Changed another stale comment in patch 1
- Moved BTRFS_INODE_ORPHAN_META_RESERVED flag removal to patch 10
  instead of patch 9
- Moved inode runtime flag renumbering to a separate patch (patch 11)
- Added some more reviewed-bys

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

*** BLURB HERE ***

Omar Sandoval (12):
  Btrfs: update stale comments referencing vmtruncate()
  Btrfs: fix error handling in btrfs_truncate_inode_items()
  Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
  Btrfs: stop creating orphan items for truncate
  Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
  Btrfs: delete dead code in btrfs_orphan_commit_root()
  Btrfs: don't return ino to ino cache if inode item removal fails
  Btrfs: refactor btrfs_evict_inode() reserve refill dance
  Btrfs: fix ENOSPC caused by orphan items reservations
  Btrfs: get rid of unused orphan infrastructure
  Btrfs: renumber BTRFS_INODE_ runtime flags
  Btrfs: reserve space for O_TMPFILE orphan item deletion

 fs/btrfs/btrfs_inode.h      |  18 +-
 fs/btrfs/ctree.h            |   8 -
 fs/btrfs/disk-io.c          |   9 -
 fs/btrfs/extent-tree.c      |  38 ---
 fs/btrfs/free-space-cache.c |   6 +-
 fs/btrfs/inode.c            | 580 ++++++++++--------------------------
 fs/btrfs/transaction.c      |   1 -
 7 files changed, 172 insertions(+), 488 deletions(-)

-- 
2.17.0

