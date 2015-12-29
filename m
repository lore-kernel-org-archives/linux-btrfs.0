Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52918 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753259AbbL2ICV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 03:02:21 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id A8F7E40427CD
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 16:01:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 00/14][For 4.6] Btrfs: Add inband (write time) de-duplication framework
Date: Tue, 29 Dec 2015 16:01:09 +0800
Message-ID: <1451376083-30474-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This updated version of inband de-duplication has the following features:
1) ONE unified dedup framework.
   Most of its code is hidden quietly in dedup.c and export the minimal
   interfaces for its caller.
   Reviewer and further developer would benefit from the unified
   framework.

2) TWO different back-end with different trade-off
   One is the improved version of previous Fujitsu in-memory only dedup.
   The other one is enhanced dedup implement from Liu Bo.
   Changed of its tree structure to handle bytenr -> hash search for
   deleting hash, without the hideous data backref hack.

3) Ioctl interface with persist dedup status
   Advised by David, now we use ioctl to enable/disable dedup.
   Further we will add per-file/dir dedup disable command in that ioctl.

   And we now have dedup status, recorded in the first item of dedup
   tree.
   Just like quota, once enabled, no extra ioctl is needed for next
   mount.

Although the patchset is tagged as V2, not too much codes are from V1
patchset, most of the patchset is reworked, so no changelog this time.

TODO:
1) Better delayed_ref related solution
   Find a better solution to handle hideous delayed_ref related problems.
   Even we use a lot of codes trying to resolve the problem, it still can't
   pass generic/068.

2) Per-file ioctl to disbale dedup
   Just like compression setting per file

3) Support compression for hash miss case
   It will go though non-compress routine, not compressing it even we can.
   This may need to change the on-disk format for on-disk backend.

4) More on-disk backend test.
   Personally speaking, I'm not a fan of on-disk backend.
   And not so many test is done for on-disk backend.
   I'd better test it more and double check the hash on disk.
   On-disk hash format may *CHANGE*.

Qu Wenruo (5):
  btrfs: dedup: Add basic tree structure for on-disk dedup method
  btrfs: dedup: Introduce interfaces to resume and cleanup dedup info
  btrfs: dedup: Add support for on-disk hash search
  btrfs: dedup: Add support for adding hash for on-disk backend
  btrfs: dedup: Add support to delete hash for on-disk backend

Wang Xiaoguang (9):
  btrfs: dedup: Introduce dedup framework and its header
  btrfs: dedup: Introduce function to initialize dedup info
  btrfs: dedup: Introduce function to add hash into in-memory tree
  btrfs: dedup: Introduce function to remove hash from in-memory tree
  btrfs: dedup: Introduce function to search for an existing hash
  btrfs: dedup: Implement btrfs_dedup_calc_hash interface
  btrfs: ordered-extent: Add support for dedup
  btrfs: dedup: Inband in-memory only de-duplication implement
  btrfs: dedup: Add ioctl for inband deduplication

 fs/btrfs/Makefile            |   2 +-
 fs/btrfs/ctree.h             |  71 +++-
 fs/btrfs/dedup.c             | 945 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h             | 160 ++++++++
 fs/btrfs/disk-io.c           |  28 +-
 fs/btrfs/disk-io.h           |   1 +
 fs/btrfs/extent-tree.c       |   7 +
 fs/btrfs/extent_io.c         |  30 +-
 fs/btrfs/extent_io.h         |  15 +
 fs/btrfs/inode.c             | 299 +++++++++++++-
 fs/btrfs/ioctl.c             |  63 +++
 fs/btrfs/ordered-data.c      |  33 +-
 fs/btrfs/ordered-data.h      |  13 +
 include/trace/events/btrfs.h |   3 +-
 include/uapi/linux/btrfs.h   |  23 ++
 15 files changed, 1661 insertions(+), 32 deletions(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

-- 
2.6.4



