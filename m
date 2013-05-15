Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab3EOHsk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:40 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 00/17] improve the block time during the transaction commit
Date: Wed, 15 May 2013 15:48:14 +0800
Message-Id: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset improve the problem that the transaction may be blocked for a
long time when it is being committed if there is heavy I/O.

In this patchset,
- 0001-0005, 0007, 0011-0012 are random fix or code cleanup patch.
- 0006, 0008-0010 introduce per-subvolume delalloc inode list and ordered
  extent list, which can reduce the flush time when we create snapshots.
- 0013-0016 improve the block time during the transaction commit by removing
  the while loop at the beginning of the transaction commit.
- 0017 improves the readability of the code.

Miao Xie (17):
  Btrfs: fix accessing a freed tree root
  Btrfs: fix unprotected root node of the subvolume's inode rb-tree
  Btrfs: pause the space balance when remounting to R/O
  Btrfs: remove BUG_ON() in btrfs_read_fs_tree_no_radix()
  Btrfs: cleanup the similar code of the fs root read
  Btrfs: introduce grab/put functions for the root of the fs/file tree
  Btrfs: don't invoke btrfs_invalidate_inodes() in the spin lock context
  Btrfs: introduce per-subvolume delalloc inode list
  Btrfs: introduce per-subvolume ordered extent list
  Btrfs: just flush the delalloc inodes in the source tree before snapshot creation
  Btrfs: cleanup unnecessary assignment when cleaning up all the residual transaction
  Btrfs: remove the code for the impossible case in cleanup_transaction()
  Btrfs: don't wait for all the writers circularly during the transaction commit
  Btrfs: don't flush the delalloc inodes in the while loop if flushoncommit is set
  Btrfs: remove unnecessary varient ->num_joined in btrfs_transaction structure
  Btrfs: remove the time check in btrfs_commit_transaction()
  Btrfs: make the state of the transaction more readable

 fs/btrfs/ctree.h        |  55 +++++--
 fs/btrfs/dev-replace.c  |   6 +-
 fs/btrfs/disk-io.c      | 425 +++++++++++++++++++++++++++---------------------
 fs/btrfs/disk-io.h      |  32 +++-
 fs/btrfs/extent-tree.c  |  20 +--
 fs/btrfs/inode.c        | 180 ++++++++++++++------
 fs/btrfs/ioctl.c        |   6 +
 fs/btrfs/ordered-data.c | 109 +++++++++----
 fs/btrfs/ordered-data.h |   2 +
 fs/btrfs/relocation.c   |   9 +-
 fs/btrfs/root-tree.c    | 170 ++++++-------------
 fs/btrfs/super.c        |   3 +-
 fs/btrfs/transaction.c  | 271 ++++++++++++++++--------------
 fs/btrfs/transaction.h  |  49 ++++--
 fs/btrfs/tree-log.c     |   3 +-
 fs/btrfs/volumes.c      |  13 +-
 fs/btrfs/volumes.h      |   1 +
 17 files changed, 791 insertions(+), 563 deletions(-)

-- 
1.8.1.4

