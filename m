Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51210 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725933AbeHAEUm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 00:20:42 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7EB8ACD7
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 02:37:26 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/6] btrfs: Enhanced validation check for fuzzed images
Date: Wed,  1 Aug 2018 10:37:15 +0800
Message-Id: <20180801023721.32143-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The branch can be fetched from the following git repo:
https://github.com/adam900710/linux/tree/tree_checker_enhance

It's based on v4.18-rc1, with 3 patches already merged into misc-next.

This patchset introduced the following enhanced validation check:
1) chunk/block group/dev extent cross check
   Unlike extent tree, such cross check can be implemented pretty easy
   with minimal mount time impact.
   Now the kernel could do chunk/bg/dev extent check as good as btrfs
   check.

2) Locking test to avoid possible deadlock due to extent tree corruption
   Unfortunately, for extent tree we can't do really much cross check.
   Instead we use the selftest from btrfs_tree_lock() to detect and
   avoid deadlock caused by corrupted extent tree.

The 3rd patch "btrfs: Remove unused function btrfs_account_dev_extents_size()"
has also been merged into misc-next.

changelog:
v2:
  Added reviewed-by tags from Gu and Nikolay.
  Address comment from David for the 4th patch
  Address comment from Gu for the 2nd patch.

Qu Wenruo (6):
  btrfs: Check each block group has corresponding chunk at mount time
  btrfs: Verify every chunk has corresponding block group at mount time
  btrfs: Remove unused function btrfs_account_dev_extents_size()
  btrfs: Introduce mount time chunk <-> dev extent mapping check
  btrfs: Exit gracefully when failed to add chunk map
  btrfs: locking: Allow btrfs_tree_lock() to return error to avoid
    deadlock

 fs/btrfs/ctree.c           |  57 ++++++--
 fs/btrfs/disk-io.c         |   7 +
 fs/btrfs/extent-tree.c     | 114 +++++++++++++--
 fs/btrfs/extent_io.c       |   8 +-
 fs/btrfs/free-space-tree.c |   4 +-
 fs/btrfs/locking.c         |  13 +-
 fs/btrfs/locking.h         |   2 +-
 fs/btrfs/qgroup.c          |   4 +-
 fs/btrfs/relocation.c      |  13 +-
 fs/btrfs/tree-log.c        |  14 +-
 fs/btrfs/volumes.c         | 276 +++++++++++++++++++++++++------------
 fs/btrfs/volumes.h         |   4 +-
 12 files changed, 397 insertions(+), 119 deletions(-)

-- 
2.18.0

