Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59995 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750954AbdLISAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Dec 2017 13:00:35 -0500
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 4.15-rc3
Date: Sat,  9 Dec 2017 18:58:30 +0100
Message-Id: <cover.1512840351.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this update contains a few fixes (error handling, quota leak, FUA vs
nobarrier mount option).  There's one one worth mentioning separately -
an off-by-one fix that leads to overwriting first byte of an adjacent
page with 0, out of bounds of the memory allocated by an ioctl.  This is
under a privileged part of the ioctl, can be triggerd in some subvolume
layouts.

After the last tags and branches mess [1], let me note that the pull url
is pointed to the signed tag. There are no merge conflics. Please pull,
thanks.

[1] https://lkml.org/lkml/2017/11/29/952


The following changes since commit ea37d5998b50a72b9045ba60a132eeb20e1c4230:

  Btrfs: incremental send, fix wrong unlink path after renaming file (2017-11-28 17:15:30 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-4.15-rc3-tag

for you to fetch changes up to c8bcbfbd239ed60a6562964b58034ac8a25f4c31:

  btrfs: Fix possible off-by-one in btrfs_search_path_in_tree (2017-12-07 00:35:15 +0100)

----------------------------------------------------------------
Jeff Mahoney (2):
      btrfs: handle errors while updating refcounts in update_ref_for_cow
      btrfs: fix missing error return in btrfs_drop_snapshot

Justin Maggard (1):
      btrfs: Fix quota reservation leak on preallocated files

Nikolay Borisov (1):
      btrfs: Fix possible off-by-one in btrfs_search_path_in_tree

Omar Sandoval (1):
      Btrfs: disable FUA if mounted with nobarrier

 fs/btrfs/ctree.c       | 18 ++++++++++++------
 fs/btrfs/disk-io.c     | 12 +++++-------
 fs/btrfs/extent-tree.c |  1 +
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/ioctl.c       |  2 +-
 5 files changed, 21 insertions(+), 14 deletions(-)
