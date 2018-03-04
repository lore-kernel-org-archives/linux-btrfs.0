Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752465AbeCDJeX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 4 Mar 2018 04:34:23 -0500
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.16-rc4
Date: Sun,  4 Mar 2018 10:31:48 +0100
Message-Id: <cover.1520154785.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

please consider the follwing btrfs updates, there are bugfixes or fixes
for user visible behaviour.

No merge conflicts. Please pull, thanks.

- when NR_CPUS is large, a SRCU structure can significantly inflate size
  of the main filesystem structure that would not be possible to
  allocate by kmalloc, so the kvalloc fallback is used

- improved error handling

- fix endiannes when printing some filesystem attributes via sysfs, this
  is could happen when a filesystem is moved between different endianity
  hosts

- send fixes: the NO_HOLE mode should not send a write operation for a
  file hole

- fix log replay for for special files followed by file hardlinks

- fix log replay failure after unlink and link combination

- fix max chunk size calculation for DUP allocation

----------------------------------------------------------------
The following changes since commit fd649f10c3d21ee9d7542c609f29978bdf73ab94:

  btrfs: Fix use-after-free when cleaning up fs_devs with a single stale device (2018-02-05 17:15:14 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.16-rc3-tag

for you to fetch changes up to 1f250e929a9c9332fd6ea34da684afee73837cfe:

  Btrfs: fix log replay failure after unlink and link combination (2018-03-01 16:18:40 +0100)

----------------------------------------------------------------
Anand Jain (1):
      btrfs: use proper endianness accessors for super_copy

Filipe Manana (3):
      Btrfs: send, fix issuing write op when processing hole in no data mode
      Btrfs: fix log replay failure after linking special file and fsync
      Btrfs: fix log replay failure after unlink and link combination

Hans van Kranenburg (1):
      btrfs: alloc_chunk: fix DUP stripe size handling

Jeff Mahoney (1):
      btrfs: use kvzalloc to allocate btrfs_fs_info

Nikolay Borisov (2):
      btrfs: handle failure of add_pending_csums
      btrfs: Handle btrfs_set_extent_delalloc failure in relocate_file_extent_cluster

 fs/btrfs/ctree.h       |   7 ++-
 fs/btrfs/inode-item.c  |  44 +++++++++++--------
 fs/btrfs/inode.c       |  11 ++++-
 fs/btrfs/relocation.c  |  18 +++++++-
 fs/btrfs/send.c        |   3 ++
 fs/btrfs/super.c       |   2 +-
 fs/btrfs/sysfs.c       |   8 ++--
 fs/btrfs/transaction.c |  20 +++++----
 fs/btrfs/tree-log.c    | 114 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.c     |  11 ++---
 10 files changed, 191 insertions(+), 47 deletions(-)
