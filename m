Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbcAGOpQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jan 2016 09:45:16 -0500
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs: misc fixes for 4.5
Date: Thu,  7 Jan 2016 15:42:53 +0100
Message-Id: <cover.1452177548.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

here's a collection of patches from the mailinglist that do not appear in the
integratin-4.5 branch. There are fixes or misc changes and improvements.

Please consider for 4.5. Thanks.

----------------------------------------------------------------
The following changes since commit 4ef7675344d687a0ef5b0d7c0cee12da005870c0:

  Linux 4.4-rc6 (2015-12-20 16:06:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git misc-for-4.5

for you to fetch changes up to ee592d07716139ef7c3ea8049936cbc3aafbc533:

  Btrfs: Check metadata redundancy on balance (2016-01-07 15:20:56 +0100)

----------------------------------------------------------------
Anand Jain (1):
      Btrfs: add missing brelse when superblock checksum fails

David Sterba (17):
      btrfs: put delayed item hook into inode
      btrfs: better packing of btrfs_delayed_extent_op
      btrfs: handle invalid num_stripes in sys_array
      btrfs: verbose error when we find an unexpected item in sys_array
      btrfs: drop duplicate prefix from scrub workqueues
      btrfs: don't use slab cache for struct btrfs_delalloc_work
      btrfs tests: replace whole ops structure for free space tests
      btrfs: constify remaining structs with function pointers
      btrfs: constify static arrays
      btrfs: cleanup, use enum values for btrfs_path reada
      btrfs: use smaller type for btrfs_path reada
      btrfs: use smaller type for btrfs_path lowest_level
      btrfs: use smaller type for btrfs_path locks
      btrfs: do an allocation earlier during snapshot creation
      btrfs: allocate root item at snapshot ioctl time
      btrfs: preallocate path for snapshot creation at ioctl time
      btrfs: statfs: report zero available if metadata are exhausted

Josef Bacik (1):
      Btrfs: igrab inode in writepage

Sam Tygier (1):
      Btrfs: Check metadata redundancy on balance

Zhao Lei (1):
      btrfs: Support convert to -d dup for btrfs-convert

 fs/btrfs/btrfs_inode.h            |   4 ++
 fs/btrfs/ctree.c                  |   9 ++--
 fs/btrfs/ctree.h                  |   9 ++--
 fs/btrfs/delayed-ref.c            |   4 +-
 fs/btrfs/delayed-ref.h            |   8 +--
 fs/btrfs/disk-io.c                |   1 +
 fs/btrfs/extent-tree.c            |  27 +++++-----
 fs/btrfs/extent-tree.h            |   0
 fs/btrfs/file-item.c              |   4 +-
 fs/btrfs/free-space-cache.c       |   2 +-
 fs/btrfs/free-space-cache.h       |   2 +-
 fs/btrfs/inode-map.c              |   6 +--
 fs/btrfs/inode.c                  | 101 ++++++++++++++++++--------------------
 fs/btrfs/ioctl.c                  |  35 ++++++++-----
 fs/btrfs/relocation.c             |  12 ++---
 fs/btrfs/scrub.c                  |  12 ++---
 fs/btrfs/super.c                  |  26 +++++++++-
 fs/btrfs/tests/free-space-tests.c |  14 +++---
 fs/btrfs/transaction.c            |  18 +++----
 fs/btrfs/transaction.h            |   2 +
 fs/btrfs/volumes.c                |  32 +++++++-----
 fs/btrfs/xattr.c                  |   2 +-
 22 files changed, 186 insertions(+), 144 deletions(-)
 delete mode 100644 fs/btrfs/extent-tree.h
