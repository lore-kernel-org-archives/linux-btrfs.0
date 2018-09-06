Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729735AbeIFTNc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 15:13:32 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 4.19-rc2
Date: Thu,  6 Sep 2018 16:37:18 +0200
Message-Id: <cover.1536241480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

there are a few more fixes that were sent after the 1st pull request
cut and postponed after the merge window settles down.

* fix for improper fsync after hardlink
* fix for a corruption during file deduplication
* use after free fixes
* RCU warning fix
* fix for buffered write to nodatacow file

There are no merge conflicts. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 39379faaad79e3cf403a6904a08676b7850043ae:

  btrfs: revert fs_devices state on error of btrfs_init_new_device (2018-08-06 13:13:04 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.19-rc2-tag

for you to fetch changes up to b6fdfbff078975c53383fc146a2a54985eab6b6d:

  btrfs: Fix suspicious RCU usage warning in btrfs_debug_in_rcu (2018-08-24 14:09:43 +0200)

----------------------------------------------------------------
Anand Jain (1):
      btrfs: btrfs_shrink_device should call commit transaction at the end

Dan Carpenter (1):
      btrfs: use after free in btrfs_quota_enable

Filipe Manana (2):
      Btrfs: sync log after logging new name
      Btrfs: fix data corruption when deduplicating between different files

Lu Fengqi (1):
      btrfs: fix qgroup_free wrong num_bytes in btrfs_subvolume_reserve_metadata

Misono Tomohiro (1):
      btrfs: Fix suspicious RCU usage warning in btrfs_debug_in_rcu

Robbie Ko (1):
      Btrfs: fix unexpected failure of nocow buffered writes after snapshotting when low on space

 fs/btrfs/ctree.h       |  12 ++++-
 fs/btrfs/disk-io.c     |   1 +
 fs/btrfs/extent-tree.c |  17 ++++---
 fs/btrfs/inode.c       | 117 +++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/ioctl.c       |  35 +++++++++++++++
 fs/btrfs/qgroup.c      |   5 +--
 fs/btrfs/tree-log.c    |  48 +++++++++++++++++---
 fs/btrfs/tree-log.h    |  10 ++++-
 fs/btrfs/volumes.c     |   7 ++-
 9 files changed, 197 insertions(+), 55 deletions(-)
