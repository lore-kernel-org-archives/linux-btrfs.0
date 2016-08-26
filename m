Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55305 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754508AbcHZXpI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 19:45:08 -0400
Date: Fri, 26 Aug 2016 19:36:24 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160826233624.jao5mztbxhjikm7e@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.8 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

We've queued up a few different fixes in here.  These range from enospc
corners to fsync and quota fixes, and a few targeted at
error handling for corrupt metadata/fuzzing.

Liu Bo (5) commits (+60/-2):
    Btrfs: detect corruption when non-root leaf has zero item (+22/-1)
    Btrfs: add ASSERT for block group's memory leak (+5/-0)
    Btrfs: clarify do_chunk_alloc()'s return value (+9/-0)
    Btrfs: fix memory leak of reloc_root (+8/-1)
    Btrfs: check btree node's nritems (+16/-0)

Qu Wenruo (4) commits (+191/-53):
    btrfs: relocation: Fix leaking qgroups numbers on data extents (+103/-6)
    btrfs: qgroup: Fix qgroup incorrectness caused by log replay (+16/-0)
    btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent() (+71/-47)
    btrfs: backref: Fix soft lockup in __merge_refs function (+1/-0)

Wang Xiaoguang (4) commits (+161/-108):
    btrfs: use correct offset for reloc_inode in prealloc_file_extent_cluster() (+6/-4)
    btrfs: divide btrfs_update_reserved_bytes() into two functions (+57/-40)
    btrfs: update btrfs_space_info's bytes_may_use timely (+73/-63)
    btrfs: fix fsfreeze hang caused by delayed iputs deal (+25/-1)

Jeff Mahoney (3) commits (+45/-18):
    btrfs: don't create or leak aliased root while cleaning up orphans (+22/-11)
    btrfs: waiting on qgroup rescan should not always be interruptible (+13/-6)
    btrfs: properly track when rescan worker is running (+10/-1)

Filipe Manana (1) commits (+8/-4):
    Btrfs: fix lockdep warning on deadlock against an inode's log mutex

Anand Jain (1) commits (+19/-8):
    btrfs: do not background blkdev_put()

Alex Lyakas (1) commits (+1/-1):
    btrfs: flush_space: treat return value of do_chunk_alloc properly

Josef Bacik (1) commits (+1/-0):
    Btrfs: fix em leak in find_first_block_group

Total: (20) commits

 fs/btrfs/backref.c     |   1 +
 fs/btrfs/ctree.h       |   5 +-
 fs/btrfs/delayed-ref.c |   7 +-
 fs/btrfs/disk-io.c     |  56 +++++++++++++--
 fs/btrfs/disk-io.h     |   2 +
 fs/btrfs/extent-tree.c | 185 +++++++++++++++++++++++--------------------------
 fs/btrfs/extent_io.h   |   1 +
 fs/btrfs/file.c        |  28 ++++----
 fs/btrfs/inode-map.c   |   3 +-
 fs/btrfs/inode.c       |  37 +++++++---
 fs/btrfs/ioctl.c       |   2 +-
 fs/btrfs/qgroup.c      |  62 ++++++++++++++---
 fs/btrfs/qgroup.h      |  36 ++++++++--
 fs/btrfs/relocation.c  | 126 ++++++++++++++++++++++++++++++---
 fs/btrfs/root-tree.c   |  27 +++++---
 fs/btrfs/super.c       |  16 +++++
 fs/btrfs/transaction.c |   7 +-
 fs/btrfs/tree-log.c    |  21 +++++-
 fs/btrfs/tree-log.h    |   5 +-
 fs/btrfs/volumes.c     |  27 +++++---
 20 files changed, 473 insertions(+), 181 deletions(-)
