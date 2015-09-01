Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47175 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbbIAHYP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 03:24:15 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t817O3lO021446
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 15:24:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 00/14] Qgroup reserved space fixing framework
Date: Tue, 1 Sep 2015 15:21:57 +0800
Message-ID: <1441092131-14088-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

!!!!!!WARNING START!!!!!!
These patch is just a WIP patchset, although it fixed a qgroup reserved
space leaking bug in normal COW case, it still lacks fix for other
corner case, like NODATACOW or prealloc case, and a lot of old
facilities are not cleaned up yet.

The reason to send the WIP patchset is to check if the patchset has some
deep structure bug, to avoid another rework after the whole patchset is
finished
!!!!!!WARNING END!!!!!!

Although we have already reworked btrfs qgroup accounting part in
v4.2-rc1, but qgroup reserve part still has a problem of leaking
reserved space.

[[BUG]]
One of the most common case to trigger the bug is the following method:
1) Enable quota
2) Limit excl of qgroup 5 to 16M
3) Write [0,2M) of a file inside subvol 5 10 times without sync

EQUOT will be triggered at about the 8th write.

[[CAUSE]]
The problem is caused by the fact that qgroup will reserve space even
the data space is already reserved.

In above reproducer, even time we buffered write [0,2M) qgroup will
reserve 2M space, but in fact, at the 1st time, we have already reserved
2M and from then on, we don't need to reserved any data space as we are
only writing [0,2M).

Also, the reserved space will only be freed *ONCE* when its backref is
run at commit_transaction() time.

That's causing the reserved space leaking.

[[FIX]]
The fix is not a simple one, as currently btrfs_qgroup_reserve() follow
the very bad btrfs space allocating principle:
  Allocate as much as you needed, even it's not fully used.

So in the patchset, we introduce a lot of facilities:
1) Per inode data rsv map
   Record which range of a file has already been reserved.
   Dirty range will be released when the range is written into disk.
   And for any request to reserve space on already reserved range, just
   skip it to avoid 

2) Delayed ref head qgroup members
   After a range of data is written into disk, we can't keep the dirty
   range in data rsv map or just release reserved space.

   If we keep dirty range in data rsv map, next write will consider
   there is no need to reserve space, but new write will be cowed, and
   cause another extent to take qgroup space.
   So if keep dirty range, it'll cause qgroup accounting to exceed
   limit.

   On the other hand, if just release and free the reserved space, we
   can still exceed the limit by allowing over-reserve.

   So here, we must only release the range, but keep the reserved space
   recorded in other place.
   With the new qgroup accounting framework, only delayed_ref_head is
   safe and will be run at the same time as btrfs qgroup accounting.

3) New delalloc_reserve_space/check_data_free_space facilities to
   support accurate reserve space.
   Unlike old implement, which consider it enough by only using
   num_bytes.
   New facilities all need a exact range [start, start + len) to reserve
   space.

More detailed info can be found in each commit message and source
commend.

Qu Wenruo (14):
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
  btrfs: extent-tree: Add new verions of btrfs_check_data_free_space
  btrfs: Use new check_data_free_space for buffered write

 fs/btrfs/btrfs_inode.h |   6 +
 fs/btrfs/ctree.h       |   5 +
 fs/btrfs/delayed-ref.c |  29 +++
 fs/btrfs/delayed-ref.h |  14 ++
 fs/btrfs/disk-io.c     |   1 +
 fs/btrfs/extent-tree.c |  68 +++--
 fs/btrfs/file.c        |  22 +-
 fs/btrfs/inode.c       |  20 ++
 fs/btrfs/qgroup.c      | 658 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.h      |  21 +-
 fs/btrfs/transaction.c |  34 +--
 fs/btrfs/transaction.h |   1 -
 12 files changed, 820 insertions(+), 59 deletions(-)

-- 
2.5.1

