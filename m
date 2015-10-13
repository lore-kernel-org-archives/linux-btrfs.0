Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22173 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932122AbbJMCUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 22:20:32 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9D2K1Q0012662
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 10:20:01 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 00/21] Rework btrfs qgroup reserved space framework
Date: Tue, 13 Oct 2015 10:20:06 +0800
Message-Id: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
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
Reuse the existing io_tree facilities to record which range is already
reserved for qgroup.

Although qgroup reserved space behavior is quite similar with already
existing DELALLOC flag, but since fallocate don't go through DELALLOC
flag, we introduce a new extent flag, EXTENT_QGROUP_RESERVED for our own
purpose, without interfering any existing flag.

The new API itself is quite safe, any stupid caller reserve or free a
range twice or more won't cause any problem, due to the nature of the
design.

[[PATCH STRUCTURE]]
As the patchset is a little huge, it can be spilt into different parts:
1) Accurate reserve space framework API(Patch 1 ~ 8)
   Use io_tree to implement the needed data reserve API.
   And slightly change the metadata reserve API

2) Apply needed hooks to related callers(Pathc 9 ~ 18)
   The following functions need to be converted to using new qgroup
   reserve API:
   btrfs_check_free_data_space()
   btrfs_free_reserved_data_space()
   btrfs_delalloc_reserve_space()
   btrfs_delalloc_release_space()

   And the following function need to change its behavior for accurate
   qgroup reserve space:
   btrfs_fallocate()

   Also add ftrace support for new APIs in patch 17.

3) Minor enhancement and fix(Patch 19~21)
   Avoid unneeded page truncating (Patch 19)
   Fix a deadlock due to lock io_tree with io_tree lock hold in
   set_bit_hook() (Patch 20)
   And finally, makes qgroup reserved space much more obvious for
   further debugging (Patch 21)

[[Changelog]]
v2:
  Add new handlers to avoid reserved space leaking for buffered write
  followed by a truncate:
    btrfs_invalidatepage()
    evict_inode_truncate_page()
  Add new handlers to avoid reserved space leaking for error handle
  routine:
    btrfs_free_reserved_data_space()
    btrfs_delalloc_release_space()

v3:
  Use io_tree to implement data reserve map, which hugely reduced the
  patchset size, from 1300+ lines net insert to 600+ lines net insert.
  Suggested-by: Josef Bacik<jbacik@fb.com>

Qu Wenruo (21):
  btrfs: extent_io: Introduce needed structure for recoding set/clear
    bits
  btrfs: extent_io: Introduce new function set_record_extent_bits
  btrfs: extent_io: Introduce new function clear_record_extent_bits()
  btrfs: qgroup: Introduce btrfs_qgroup_reserve_data function
  btrfs: qgroup: Introduce functions to release/free qgroup reserve data
        space
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
  btrfs: qgroup: Check if qgroup reserved space leaked

 fs/btrfs/ctree.h             |  14 ++-
 fs/btrfs/delayed-ref.c       |  29 +++++++
 fs/btrfs/delayed-ref.h       |  14 +++
 fs/btrfs/disk-io.c           |   1 +
 fs/btrfs/extent-tree.c       | 149 ++++++++++++++++++++++----------
 fs/btrfs/extent_io.c         | 121 +++++++++++++++++++-------
 fs/btrfs/extent_io.h         |  19 +++++
 fs/btrfs/file.c              | 193 +++++++++++++++++++++++++++++------------
 fs/btrfs/inode-map.c         |   6 +-
 fs/btrfs/inode.c             |  86 ++++++++++++++++---
 fs/btrfs/ioctl.c             |  10 ++-
 fs/btrfs/qgroup.c            | 199 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.h            |  31 ++++++-
 fs/btrfs/relocation.c        |   8 +-
 fs/btrfs/transaction.c       |  34 ++------
 fs/btrfs/transaction.h       |   1 -
 include/trace/events/btrfs.h | 113 ++++++++++++++++++++++++
 17 files changed, 832 insertions(+), 196 deletions(-)

-- 
2.6.1

