Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:46832 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbeEKALd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 20:11:33 -0400
Received: by mail-pl0-f68.google.com with SMTP id 59-v6so2216136plc.13
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 17:11:33 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v2 00/12] Btrfs: orphan and truncate fixes
Date: Thu, 10 May 2018 17:11:10 -0700
Message-Id: <cover.1525997057.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

This is v2 of the fixes for the orphan item early ENOSPC issue we hit at
Facebook.

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

Omar Sandoval (12):
  Btrfs: remove stale comment referencing vmtruncate()
  Btrfs: fix error handling in btrfs_truncate_inode_items()
  Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
  Btrfs: stop creating orphan items for truncate
  Btrfs: don't release reserve or decrement orphan count if orphan item
    already existed
  Btrfs: don't return ino to ino cache if inode item removal fails
  Btrfs: refactor btrfs_evict_inode() reserve refill dance
  Btrfs: fix ENOSPC caused by orphan items reservations
  Btrfs: get rid of root->orphan_block_rsv and root->orphan_lock
  Btrfs: get rid of btrfs_orphan_commit_root() and root->orphan_inodes
  Btrfs: simplify error handling in btrfs_evict_inode()
  Btrfs: reserve space for O_TMPFILE orphan item deletion

 fs/btrfs/btrfs_inode.h      |  19 +-
 fs/btrfs/ctree.h            |   8 -
 fs/btrfs/disk-io.c          |   9 -
 fs/btrfs/extent-tree.c      |  38 ---
 fs/btrfs/free-space-cache.c |   6 +-
 fs/btrfs/inode.c            | 585 +++++++++++-------------------------
 fs/btrfs/transaction.c      |   1 -
 7 files changed, 191 insertions(+), 475 deletions(-)

-- 
2.17.0

