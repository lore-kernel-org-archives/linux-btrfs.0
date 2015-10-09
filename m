Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [59.151.112.132] ([59.151.112.132]:47522 "EHLO
	heian.cn.fujitsu.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756312AbbJICNz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Oct 2015 22:13:55 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t992D0i8022434
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Oct 2015 10:13:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 00/23] Rework btrfs qgroup reserved space framework
Date: Fri, 9 Oct 2015 10:11:22 +0800
Message-ID: <1444356684-30162-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In previous rework of qgroup, we succeeded in fixing qgroup accounting
part, making the rfer/excl numbers accurate.

But that's just part of qgroup work, another part of qgroup still has
quite a lot problem, that's qgroup reserve space part which will lead to
EQUOT even we are far from the limit.

[[BUG]]
The easiest way to trigger the bug is,
1) Enable quota
2) Limit excl of qgroup 5 to 16M
3) Write [0,2M) of a file inside subvol 5 10 times without sync

EQUOT will be triggered at about the 8th write.
But after remount, we can still write until about 15M.

[[CAUSE]]
The problem is caused by the fact that qgroup will reserve space even
the data space is already reserved.

In above reproducer, each time we buffered write [0,2M) qgroup will
reserve 2M space, but in fact, at the 1st time, we have already reserved
2M and from then on, we don't need to reserved any data space as we are
only writing [0,2M).

Also, the reserved space will only be freed *ONCE* when its backref is
run at commit_transaction() time.

That's causing the reserved space leaking.

[[FIX]]
The fix is not a simple one, as currently btrfs_qgroup_reserve() will
allocate whatever caller asked for.

So for accurate qgroup reserve, we introduce a completely new framework
for data and metadata.
1) Per-inode data reserve map
   Now, each inode will have a data reserve map, recording which range
   of data is already reserved.
   If we are writing a range which is already reserved, we won't need to
   reserve space again.

   Also, for the fact that qgroup is only accounted at commit_trans(),
   for data commit into disc and its metadata is also inserted into
   current tree, we should free the data reserved range, but still keep
   the reserved space until commit_trans().

   So delayed_ref_head will have new members to record how much space is
   reserved and free them at commit_trans() time.

2) Per-root metadata reserve counter
   For metadata(tree block), it's impossible to know  how much space it
   will use exactly in advance.
   And due to the new qgroup accounting framework, the old
   free-at-end-trans may lead to exceeding limit.

   So we record how much metadata space is reserved for each root, and
   free them at commit_trans() time.
   This method is not perfect, but thanks to the compared small size of
   metadata, it should be quite good.

The new API itself is quite safe, any stupid caller reserve or free a
range twice or more won't cause any problem, due to the nature of the
design.

[[PATCH STRUCTURE]]
As the patchset is a little huge, it can be spilt into different parts:
1) Accurate reserve space framework API(Patch 1 ~ 13)
   Implement the mergeable reserved space map and per transaction
   metadata reserve.
   Main part of the patchset, we need to merge/split and calculate how
   many bytes we really need to reserve/free.

2) Apply needed hooks to related callers(Pathc 14 ~ 22)
   The following functions need to be converted to using new qgroup
   reserve API:
   btrfs_check_free_data_space()
   btrfs_free_reserved_data_space()
   btrfs_delalloc_reserve_space()
   btrfs_delalloc_release_space()

   And the following function need to change its behavior for accurate
   qgroup reserve space:
   btrfs_fallocate()

3) Minor fix (Patch 23)
   Fix a lockdep warning where clear_bit_hook() calls
   btrfs_qgroup_free_data() but it won't really decrease qgroup reserve
   space, as it's already handle before it.

   So add a new function btrfs_free_reserved_data_space_noquota() for
   it.

Changelog:
v2:
  Add new handlers to avoid reserved space leaking for buffered write
  followed by a truncate:
    btrfs_invalidatepage()
    evict_inode_truncate_page()
  Add new handlers to avoid reserved space leaking for error handle
  routine:
    btrfs_free_reserved_data_space()
    btrfs_delalloc_release_space()

Qu Wenruo (23):
  btrfs: qgroup: New function declaration for new reserve implement
  btrfs: qgroup: Implement data_rsv_map init/free functions
  btrfs: qgroup: Introduce new function to search most left reserve
    range
  btrfs: qgroup: Introduce function to insert non-overlap reserve range
  btrfs: qgroup: Introduce function to reserve data range per inode
  btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function
  btrfs: qgroup: Introduce function to release reserved range
  btrfs: qgroup: Introduce function to release/free reserved data range
  btrfs: delayed_ref: Add new function to record reserved space into
    delayed ref
  btrfs: delayed_ref: release and free qgroup reserved at proper timing
  btrfs: qgroup: Introduce new functions to reserve/free metadata
  btrfs: qgroup: Use new metadata reservation.
  btrfs: extent-tree: Add new version of btrfs_check_data_free_space and
        btrfs_free_reserved_data_space.
  btrfs: extent-tree: Switch to new check_data_free_space and    
    free_reserved_data_space
  btrfs: extent-tree: Add new version of    
    btrfs_delalloc_reserve/release_space
  btrfs: extent-tree: Switch to new delalloc space reserve and release
  btrfs: qgroup: Cleanup old inaccurate facilities
  btrfs: qgroup: Add handler for NOCOW and inline
  btrfs: Add handler for invalidate page
  btrfs: qgroup: Add new trace point for qgroup data reserve
  btrfs: fallocate: Add support to accurate qgroup reserve
  btrfs: Avoid truncate tailing page if fallocate range doesn't exceed
    inode size
  btrfs: qgroup: Avoid calling btrfs_free_reserved_data_space in
    clear_bit_hook

 fs/btrfs/btrfs_inode.h       |   6 +
 fs/btrfs/ctree.h             |  14 +-
 fs/btrfs/delayed-ref.c       |  29 ++
 fs/btrfs/delayed-ref.h       |  14 +
 fs/btrfs/disk-io.c           |   1 +
 fs/btrfs/extent-tree.c       | 149 ++++++---
 fs/btrfs/file.c              | 191 ++++++++----
 fs/btrfs/inode-map.c         |   6 +-
 fs/btrfs/inode.c             |  95 +++++-
 fs/btrfs/ioctl.c             |  10 +-
 fs/btrfs/qgroup.c            | 705 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.h            |  35 ++-
 fs/btrfs/relocation.c        |   8 +-
 fs/btrfs/transaction.c       |  34 +--
 fs/btrfs/transaction.h       |   1 -
 include/trace/events/btrfs.h | 113 +++++++
 16 files changed, 1244 insertions(+), 167 deletions(-)

-- 
2.6.1

