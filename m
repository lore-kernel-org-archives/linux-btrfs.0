Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33862 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750754AbbJPEv3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Oct 2015 00:51:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: [GIT PULL][4.4] Qgroup reserve rework
Date: Fri, 16 Oct 2015 10:35:38 +0800
Message-ID: <1444962938-22224-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Please consider the following git pull for 4.4 merge window.

https://github.com/adam900710/linux.git
for_chris_4.4_qgroup_reserve_rework


These pull is based on the following commit:
commit 6db4a7335dd701a0e20275440ee057d3db2a7ae3
Merge: 62fb50a ee86395
Author: Chris Mason <clm@fb.com>
Date:   Mon Oct 12 16:24:40 2015 -0700

    Merge branch 'fix/waitqueue-barriers' of
    git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into
    for-linus-4.4


This rework for qgroup reserve framework provides accurate qgroup
reserve and solves reserved space leak in old btrfs qgroup.

The test case(btrfs/099) for reserved space leak is already merged in
fstests.
The reserved space leaking bug has already existed for a long time
before the qgroup accounting rework arrived in 4.2.

We have tested the pull for 3 days based on 4.3-integration branch and
found no bug.
Although it's rebased today, the rebase shows no conflict, so I think
the pull should be quite safe.

We'll re-test it during the weekend again to ensure it's completely OK.

All the commits are the same as the v3 patchset submitted to mail list,
except the 19th patch in patchset, as it's already included in another
pull request for 4.3, so it's removed from this pull.

Thanks,
Qu

Qu Wenruo (20):
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
 fs/btrfs/file.c              | 191 +++++++++++++++++++++++++++++------------
 fs/btrfs/inode-map.c         |   6 +-
 fs/btrfs/inode.c             |  86 ++++++++++++++++---
 fs/btrfs/ioctl.c             |  10 ++-
 fs/btrfs/qgroup.c            | 199 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/qgroup.h            |  31 ++++++-
 fs/btrfs/relocation.c        |   8 +-
 fs/btrfs/transaction.c       |  34 ++------
 fs/btrfs/transaction.h       |   1 -
 include/trace/events/btrfs.h | 113 ++++++++++++++++++++++++
 17 files changed, 831 insertions(+), 195 deletions(-)

-- 
2.6.1

