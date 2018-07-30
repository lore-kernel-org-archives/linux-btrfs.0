Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbeG3Hux (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 03:50:53 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B7768AE1F
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2018 06:17:27 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/1] btrfs: Tree lock return value enhancement to avoid deadlock on crafted image
Date: Mon, 30 Jul 2018 14:17:22 +0800
Message-Id: <20180730061723.13290-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch along with all submitted patches for fuzzed image can be found
at the following repo:
https://github.com/adam900710/linux/tree/tree_checker_enhance

Although fuzzed images are not really possible to happen in real world,
it's still a pretty possible Deny of Service to attack the kernel, so we
still need to address such problems.

Instead of previous failed attempt to use cached eb to determine if
we're allocating new tree blocks on already used tree block, this time
we allow btrfs_tree_lock() to return error number to inform callers
there is something wrong so we can exit a little more gracefully.

This branch should address the 2nd wave of fuzzed images reported by Xu
Wen.

Please note, since extent tree corruption is the worst scenario, we
still keep kernel to WARN() on such problem.
But at least for that fuzzed image we can switched to RO other than
deadlock the kernel.

Qu Wenruo (1):
  btrfs: locking: Allow btrfs_tree_lock() to return error to avoid
    deadlock

 fs/btrfs/ctree.c           | 57 +++++++++++++++++++++++++++++++-------
 fs/btrfs/extent-tree.c     | 28 +++++++++++++++----
 fs/btrfs/extent_io.c       |  8 ++++--
 fs/btrfs/free-space-tree.c |  4 ++-
 fs/btrfs/locking.c         | 12 ++++++--
 fs/btrfs/locking.h         |  2 +-
 fs/btrfs/qgroup.c          |  4 ++-
 fs/btrfs/relocation.c      | 13 +++++++--
 fs/btrfs/tree-log.c        | 14 ++++++++--
 9 files changed, 114 insertions(+), 28 deletions(-)

-- 
2.18.0

