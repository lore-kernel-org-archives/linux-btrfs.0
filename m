Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:56112 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbdLVGTA (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 22 Dec 2017 01:19:00 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 00/10] Use split qgroup rsv type
Date: Fri, 22 Dec 2017 14:18:37 +0800
Message-Id: <20171222061847.13158-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Overall]
The previous rework on qgroup reservation system put a lot of effort on
data, which works quite fine.

But it takes less focus on metadata reservation, causing some problem
like metadata reservation underflow and noisy kernel warning.

This patchset will try to address the remaining problem of metadata
reservation.

The idea of new qgroup metadata reservation is to use 2 types of
metadata reservation:
1) Per-transaction reservation
   Life span will be inside a transaction. Will be freed at transaction
   commit time.

2) Preallocated reservation
   For case where we reserve space before starting a transaction.
   Operation like dealloc and delayed-inode/item belongs to this type.

   This works similar to block_rsv, its reservation can be
   reserved/released at any timing caller like.

   The only point to notice is, if preallocated reservation is used and
   finished without problem, it should be converted to per-transaction
   type instead of just freeing.
   This is to co-operate with qgroup update at commit time.

For preallocated type, this patch will integrate them into inode_rsv
mechanism reworked by Josef, and delayed-inode/item reservation.


[Problem: Over-reserve for metadata operation]
With latest work on using more accurate and less over-estimated number
for delalloc, now for 128M limit, we can write about 123M.
(Although still worst than previous 126M, but that's due to we can free
prealloc reserved space in previous implementation)

But it can't handle metadata operation, like inode creation well.

For test case like btrfs/139, we can only create about 50+ 4M files
before hitting 1G limit.
(Double checked, there is no qgroup rsv leaking).

So there is still some room to improve the over-reserve behavior.

[Patch structure]
Patch 1~8 are mostly the same, while some of them receive some small
updates.
Patch 5 undergoes some small EDQUOT handler fix exposed by fstests.
Patch 9~10 are new patches to address the over-reserve behavior.

Changelog:
v2:
  Use independent qgroup rsv numbers other than reuse over-killed
  numbers used by block_rsv. Which greatly reduce the early EDQUOT
  problem for delalloc.

  Use transaction_kthread to do early commit in hope to free up some
  pertrans space.


Qu Wenruo (10):
  btrfs: qgroup: Split meta rsv type into meta_prealloc and
    meta_pertrans
  btrfs: qgroup: Don't use root->qgroup_meta_rsv for qgroup
  btrfs: qgroup: Introduce function to convert META_PREALLOC into
    META_PERTRANS
  btrfs: qgroup: Use separate meta reservation type for delalloc
  btrfs: delayed-inode: Use new qgroup meta rsv for delayed inode and
    item
  btrfs: qgroup: Use root->qgroup_meta_rsv_* to record qgroup meta
    reserved space
  btrfs: qgroup: Update trace events for metadata reservation
  Revert "btrfs: qgroups: Retry after commit on getting EDQUOT"
  btrfs: qgroup: Commit transaction in advance to reduce early EDQUOT
  btrfs: qgroup: Use independent and accurate per inode qgroup rsv

 fs/btrfs/ctree.h             |  33 +++++-
 fs/btrfs/delayed-inode.c     |  56 +++++++---
 fs/btrfs/disk-io.c           |   2 +-
 fs/btrfs/extent-tree.c       |  98 ++++++++++++------
 fs/btrfs/file.c              |  15 +--
 fs/btrfs/free-space-cache.c  |   2 +-
 fs/btrfs/inode-map.c         |   4 +-
 fs/btrfs/inode.c             |  27 ++---
 fs/btrfs/ioctl.c             |  10 +-
 fs/btrfs/ordered-data.c      |   2 +-
 fs/btrfs/qgroup.c            | 241 ++++++++++++++++++++++++++++++++++---------
 fs/btrfs/qgroup.h            |  76 +++++++++++++-
 fs/btrfs/relocation.c        |   9 +-
 fs/btrfs/transaction.c       |   8 +-
 include/trace/events/btrfs.h |  60 ++++++++++-
 15 files changed, 500 insertions(+), 143 deletions(-)

-- 
2.15.1

