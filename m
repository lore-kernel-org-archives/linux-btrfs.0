Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35961 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbeETPVV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 May 2018 11:21:21 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.17-rc6
Date: Sun, 20 May 2018 17:18:36 +0200
Message-Id: <cover.1526826466.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we've accumulated some fixes during the last week, some of them were in
the works for a longer time but there are some newer ones too. Most of
the fixes have a reproducer and fix user visible problems, also
candidates for stable kernels. They IMHO qualify for a late rc, though I
did not expect that many.

The commit date may differ from author date because I added the stable
and Fixes tags where missing. There are no merge conflicts against
current master.

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit a6aa10c70bf72fb28504cb5de5deac75da78b0f5:

  Btrfs: send, fix missing truncate for inode with prealloc extent past eof (2018-05-02 11:55:29 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.17-rc5-tag

for you to fetch changes up to 02ee654d3a04563c67bfe658a05384548b9bb105:

  btrfs: fix crash when trying to resume balance without the resume flag (2018-05-17 14:38:24 +0200)

----------------------------------------------------------------
Anand Jain (1):
      btrfs: fix crash when trying to resume balance without the resume flag

Filipe Manana (2):
      Btrfs: fix xattr loss after power failure
      Btrfs: fix duplicate extents after fsync of file with prealloc extents

Liu Bo (1):
      btrfs: fix reading stale metadata blocks after degraded raid1 mounts

Misono Tomohiro (1):
      btrfs: property: Set incompat flag if lzo/zstd compression is set

Nikolay Borisov (2):
      btrfs: Split btrfs_del_delalloc_inode into 2 functions
      btrfs: Fix delalloc inodes invalidation during transaction abort

Robbie Ko (1):
      Btrfs: send, fix invalid access to commit roots due to concurrent snapshotting

 fs/btrfs/ctree.c    |  22 ++++++--
 fs/btrfs/ctree.h    |   2 +
 fs/btrfs/disk-io.c  |  26 ++++++----
 fs/btrfs/inode.c    |  13 +++--
 fs/btrfs/props.c    |  12 +++--
 fs/btrfs/tree-log.c | 144 +++++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/volumes.c  |   9 ++++
 7 files changed, 180 insertions(+), 48 deletions(-)
