Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbcEMQhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 12:37:03 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, Filipe Manana <fdmanana@suse.com>
Subject: [GIT PULL] Btrfs fixes for 4.7
Date: Fri, 13 May 2016 17:36:40 +0100
Message-Id: <1463157400-27379-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Hi Chris,

Please consider the following changes for the merge window for 4.7.
There's an implementation for the rename exchange and rename whiteout
operations, from Dan Fuhry, which was originally in David's integration
branches and linux-next but then we agreed to move it into my branches
since I made a few fixes on top of it. Other than that, there's just the
usual set of bug fixes, in particular races between direct IO writes and
fsync and between direct IO writes and balance, which lead to data loss
and metadata corruption issues.
These were recently rebased just to add Reviewed-by tags from Josef and
Liu Bo, but otherwise unchanged and have been in testing for quite some
time here.

Thanks.

The following changes since commit 44549e8f5eea4e0a41b487b63e616cb089922b99:

  Linux 4.6-rc7 (2016-05-08 14:38:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.7

for you to fetch changes up to 5f9a8a51d8b95505d8de8b7191ae2ed8c504d4af:

  Btrfs: add semaphore to synchronize direct IO writes with fsync (2016-05-13 01:59:36 +0100)

----------------------------------------------------------------
Dan Fuhry (1):
      btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT

Filipe Manana (13):
      Btrfs: fix for incorrect directory entries after fsync log replay
      Btrfs: fix empty symlink after creating symlink and fsync parent dir
      Btrfs: don't wait for unrelated IO to finish before relocation
      Btrfs: don't do unnecessary delalloc flushes when relocating
      Btrfs: unpin log if rename operation fails
      Btrfs: pin log earlier when renaming
      Btrfs: fix inode leak on failure to setup whiteout inode in rename
      Btrfs: unpin logs if rename exchange operation fails
      Btrfs: pin logs earlier when doing a rename exchange operation
      Btrfs: fix number of transaction units for renames with whiteout
      Btrfs: fix race between fsync and direct IO writes for prealloc extents
      Btrfs: fix race between block group relocation and nocow writes
      Btrfs: add semaphore to synchronize direct IO writes with fsync

 fs/btrfs/btrfs_inode.h  |  10 +++
 fs/btrfs/ctree.h        |  27 ++++++++
 fs/btrfs/dev-replace.c  |   4 +-
 fs/btrfs/extent-tree.c  | 122 +++++++++++++++++++++++++++++++++--
 fs/btrfs/inode.c        | 464 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 fs/btrfs/ioctl.c        |   2 +-
 fs/btrfs/ordered-data.c |  26 +++++---
 fs/btrfs/ordered-data.h |   6 +-
 fs/btrfs/relocation.c   |  11 ++--
 fs/btrfs/super.c        |   2 +-
 fs/btrfs/transaction.c  |   2 +-
 fs/btrfs/tree-log.c     |  66 +++++++------------
 12 files changed, 608 insertions(+), 134 deletions(-)
-- 
2.7.0.rc3

