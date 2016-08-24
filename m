Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53409 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756020AbcHXNoE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 09:44:04 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs fixes, part 3
Date: Wed, 24 Aug 2016 15:42:54 +0200
Message-Id: <cover.1472045668.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this pull request contains part 2 and adds more that arrived in the meantime
(new fixes or updated versions of patches). Assorted fixes. Please pull,
thanks.

----------------------------------------------------------------
The following changes since commit 10838816547a28696ca10e038b3b32f2efec5a42:

  Merge branch 'integration-4.8' of git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux into for-linus-4.8 (2016-08-05 12:25:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.8

for you to fetch changes up to 79354fc603184885b50cf935b8b2085c2b3e0535:

  Btrfs: fix lockdep warning on deadlock against an inode's log mutex (2016-08-24 14:54:42 +0200)

----------------------------------------------------------------
Alex Lyakas (1):
      btrfs: flush_space: treat return value of do_chunk_alloc properly

Anand Jain (1):
      btrfs: do not background blkdev_put()

Filipe Manana (1):
      Btrfs: fix lockdep warning on deadlock against an inode's log mutex

Jeff Mahoney (3):
      btrfs: properly track when rescan worker is running
      btrfs: waiting on qgroup rescan should not always be interruptible
      btrfs: don't create or leak aliased root while cleaning up orphans

Josef Bacik (2):
      Btrfs: fix em leak in find_first_block_group
      Btrfs: handle pending renames with recycled inodes properly

Liu Bo (6):
      Btrfs: fix memory leak of reloc_root
      Btrfs: add ASSERT for block group's memory leak
      Btrfs: clarify do_chunk_alloc()'s return value
      Btrfs: check btree node's nritems
      Btrfs: detect corruption when non-root leaf has zero item
      Btrfs: remove BUG() in raid56

Qu Wenruo (4):
      btrfs: backref: Fix soft lockup in __merge_refs function
      btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent()
      btrfs: relocation: Fix leaking qgroups numbers on data extents
      btrfs: qgroup: Fix qgroup incorrectness caused by log replay

Wang Xiaoguang (5):
      btrfs: use correct offset for reloc_inode in prealloc_file_extent_cluster()
      btrfs: divide btrfs_update_reserved_bytes() into two functions
      btrfs: update btrfs_space_info's bytes_may_use timely
      btrfs: should block unused block groups deletion work when allocating data space
      btrfs: fix fsfreeze hang caused by delayed iputs deal

 fs/btrfs/backref.c     |   1 +
 fs/btrfs/ctree.h       |   7 +-
 fs/btrfs/delayed-ref.c |   7 +-
 fs/btrfs/disk-io.c     |  69 ++++++++++++---
 fs/btrfs/disk-io.h     |   2 +
 fs/btrfs/extent-tree.c | 227 ++++++++++++++++++++++++++-----------------------
 fs/btrfs/extent_io.h   |   1 +
 fs/btrfs/file.c        |  28 +++---
 fs/btrfs/inode-map.c   |   3 +-
 fs/btrfs/inode.c       |  37 +++++---
 fs/btrfs/ioctl.c       |   2 +-
 fs/btrfs/qgroup.c      |  62 +++++++++++---
 fs/btrfs/qgroup.h      |  36 ++++++--
 fs/btrfs/raid56.c      |   5 +-
 fs/btrfs/relocation.c  | 126 ++++++++++++++++++++++++---
 fs/btrfs/root-tree.c   |  27 ++++--
 fs/btrfs/send.c        |  36 ++++++--
 fs/btrfs/super.c       |  16 ++++
 fs/btrfs/transaction.c |   7 +-
 fs/btrfs/tree-log.c    |  21 ++++-
 fs/btrfs/tree-log.h    |   5 +-
 fs/btrfs/volumes.c     |  69 ++++++++-------
 22 files changed, 566 insertions(+), 228 deletions(-)
