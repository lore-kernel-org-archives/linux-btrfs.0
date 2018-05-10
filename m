Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:42675 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbeEJGV0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 02:21:26 -0400
Received: by mail-pl0-f66.google.com with SMTP id u6-v6so687396pls.9
        for <linux-btrfs@vger.kernel.org>; Wed, 09 May 2018 23:21:26 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 00/10] Btrfs: orphan and truncate fixes
Date: Wed,  9 May 2018 23:21:01 -0700
Message-Id: <cover.1525932796.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi,

At Facebook we hit an early ENOSPC issue which we tracked down to the
reservations for orphan items of deleted-but-still-open files. The
primary function of this series is to fix that bug, but I ended up
uncovering a pile of other issues in the process, most notably that the
orphan items we create for truncate are useless. Patch 1 is a cosmetic
comment fix. Patches 2 and 3 are error handling fixes in truncate. Patch
4 gets rid of the useless truncate orphan items. Patches 5 and 6 are
fixes related to orphan items. Patch 7 is a prep patch for patch 8.
Patch 8 is the ENOSPC fix. Patch 9 is a followup cleanup for patch 8,
separated out to make it easier to see the functional changes in patch
8. Patch 10 is another orphan item fix, this time for O_TMPFILE.

I've also posted an xfstest that reproduces this bug.

Thanks!

Omar Sandoval (10):
  Btrfs: remove stale comment referencing vmtruncate()
  Btrfs: fix error handling in btrfs_truncate_inode_items()
  Btrfs: don't BUG_ON() in btrfs_truncate_inode_items()
  Btrfs: stop creating orphan items for truncate
  Btrfs: don't release reserve or decrement orphan count if orphan item
    already existed
  Btrfs: don't return ino if inode item removal fails
  Btrfs: refactor btrfs_evict_inode() reserve refill dance
  Btrfs: fix ENOSPC caused by orphan items reservations
  Btrfs: get rid of unused orphan infrastructure
  Btrfs: reserve space for O_TMPFILE orphan item deletion

 fs/btrfs/btrfs_inode.h      |  19 +-
 fs/btrfs/ctree.h            |   5 -
 fs/btrfs/disk-io.c          |   8 -
 fs/btrfs/extent-tree.c      |  38 ---
 fs/btrfs/free-space-cache.c |   6 +-
 fs/btrfs/inode.c            | 519 ++++++++++++------------------------
 6 files changed, 181 insertions(+), 414 deletions(-)

-- 
2.17.0

