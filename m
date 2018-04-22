Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32973 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754901AbeDVPJN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Apr 2018 11:09:13 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.17-rc1
Date: Sun, 22 Apr 2018 17:06:36 +0200
Message-Id: <cover.1524409013.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the branch contains a few fixups to qgroup patches that were merged this
dev cycle, unaligned access fix, blockgroup removal corner case fix and
a small debugging output tweak.

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 5d41be6f702f19f72db816c17175caf9dbdcdfa6:

  btrfs: Only check first key for committed tree blocks (2018-04-13 16:16:15 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.17-rc1-tag

for you to fetch changes up to c0872323746e11fc79344e3738b283a8cda86654:

  btrfs: print-tree: debugging output enhancement (2018-04-20 19:18:16 +0200)

----------------------------------------------------------------
David Sterba (1):
      btrfs: fix unaligned access in readdir

Nikolay Borisov (1):
      btrfs: Fix race condition between delayed refs and blockgroup removal

Qu Wenruo (5):
      btrfs: qgroup: Commit transaction in advance to reduce early EDQUOT
      btrfs: qgroup: Use independent and accurate per inode qgroup rsv
      btrfs: delayed-inode: Remove wrong qgroup meta reservation calls
      btrfs: Fix wrong btrfs_delalloc_release_extents parameter
      btrfs: print-tree: debugging output enhancement

 fs/btrfs/ctree.h         | 25 +++++++++++++++++
 fs/btrfs/delayed-inode.c | 20 ++++++++++---
 fs/btrfs/delayed-ref.c   | 19 +++++++++----
 fs/btrfs/delayed-ref.h   |  1 +
 fs/btrfs/disk-io.c       |  1 +
 fs/btrfs/extent-tree.c   | 73 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/file.c          |  2 +-
 fs/btrfs/inode.c         | 20 +++++++------
 fs/btrfs/print-tree.c    | 25 ++++++++++-------
 fs/btrfs/print-tree.h    |  2 +-
 fs/btrfs/qgroup.c        | 43 ++++++++++++++++++++++++++--
 fs/btrfs/transaction.c   |  1 +
 fs/btrfs/transaction.h   | 14 ++++++++++
 13 files changed, 199 insertions(+), 47 deletions(-)
