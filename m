Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43279 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeAESBf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 13:01:35 -0500
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.15-rc7
Date: Fri,  5 Jan 2018 18:59:17 +0100
Message-Id: <cover.1515172578.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we have two more fixes for 4.15, aimed for stable. The leak fix is
obvious, the second patch fixes a bug revealed by the refcount API, when
it behaves differently than previous atomic_t and reports refs going
from 0 to 1 in one case.

No merge conflicts. Please pull, thanks.

The following changes since commit c8bcbfbd239ed60a6562964b58034ac8a25f4c31:

  btrfs: Fix possible off-by-one in btrfs_search_path_in_tree (2017-12-07 00:35:15 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.15-rc7-tag

for you to fetch changes up to ec35e48b286959991cdbb886f1bdeda4575c80b4:

  btrfs: fix refcount_t usage when deleting btrfs_delayed_nodes (2018-01-02 18:00:14 +0100)

----------------------------------------------------------------
Chris Mason (1):
      btrfs: fix refcount_t usage when deleting btrfs_delayed_nodes

Nikolay Borisov (1):
      btrfs: Fix flush bio leak

 fs/btrfs/delayed-inode.c | 45 ++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.c       |  1 -
 2 files changed, 34 insertions(+), 12 deletions(-)
