Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54403 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751920AbdI2PIC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 11:08:02 -0400
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.14-rc3
Date: Fri, 29 Sep 2017 17:06:23 +0200
Message-Id: <cover.1506696049.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we've collected a bunch of isolated fixes, for crashes, user-visible behaviour
or missing bits from other subsystem cleanups from the past.  The overall
number is not small but I was not able to make it significantly smaller. Most
of the patches are supposed to go to stable. There are no merge conflicts.
Please pull, thanks.

The following changes since commit db95c876c568cef951fbbd4c0118cb5386e4bb99:

  btrfs: submit superblock io with REQ_META and REQ_PRIO (2017-08-22 13:22:05 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.14-rc3

for you to fetch changes up to 8c6c592831a09a28428448e68fb08c6bbb8b9b8b:

  btrfs: log csums for all modified extents (2017-09-26 14:54:16 +0200)

----------------------------------------------------------------
Josef Bacik (1):
      btrfs: log csums for all modified extents

Liu Bo (7):
      Btrfs: use the new helper wbc_to_write_flags
      Btrfs: do not reset bio->bi_ops while writing bio
      Btrfs: do not backup tree roots when fsync
      Btrfs: use btrfs_op instead of bio_op in __btrfs_map_block
      Btrfs: fix kernel oops while reading compressed data
      Btrfs: skip checksum when reading compressed data if some IO have failed
      Btrfs: fix unexpected result when dio reading corrupted blocks

Misono, Tomohiro (1):
      btrfs: remove BTRFS_FS_QUOTA_DISABLING flag

Naohiro Aota (4):
      btrfs: clear ordered flag on cleaning up ordered extents
      btrfs: finish ordered extent cleaning if no progress is found
      btrfs: fix NULL pointer dereference from free_reloc_roots()
      btrfs: propagate error to btrfs_cmp_data_prepare caller

Omar Sandoval (1):
      Btrfs: fix incorrect {node,sector}size endianness from BTRFS_IOC_FS_INFO

Sargun Dhillon (1):
      btrfs: Report error on removing qgroup if del_qgroup_item fails

Tsutomu Itoh (1):
      Btrfs: send: fix error number for unknown inode types

satoru takeuchi (1):
      btrfs: prevent to set invalid default subvolid

 fs/btrfs/compression.c | 18 +++++++++++++++++-
 fs/btrfs/ctree.h       |  1 -
 fs/btrfs/disk-io.c     |  9 ++++++++-
 fs/btrfs/extent_io.c   |  8 ++------
 fs/btrfs/inode.c       | 27 ++++++++++++++++++++++-----
 fs/btrfs/ioctl.c       | 12 ++++++++----
 fs/btrfs/qgroup.c      |  6 ++----
 fs/btrfs/relocation.c  |  2 +-
 fs/btrfs/send.c        |  2 +-
 fs/btrfs/tree-log.c    | 12 ++++++++++--
 fs/btrfs/volumes.c     |  2 +-
 11 files changed, 72 insertions(+), 27 deletions(-)
