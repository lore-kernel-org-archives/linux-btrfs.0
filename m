Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53678 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753057AbcL3BAz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 20:00:55 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Subject: [PULL REQUEST FOR NEXT PATCH 00/26] Patches from Fujitsu for next version
Date: Fri, 30 Dec 2016 09:00:36 +0800
Message-Id: <20161230010036.28099-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, please fetch the following branch for next branch:
https://github.com/adam900710/linux.git fujitsu_for_next

This branch contains most of Fujitsu unmerged patches for for-next branch.

Latest David's for-next-20161219 branch can cause kernel panic so I don't
use it as base, but v4.10-rc1.

I ran the full xfstests test cases, with both default mount options and
compress=lzo options.
Fixes are working and no new regression.

So I thing it should be good enough to act as a base for for-next branch.

This big patch set contains the following fixes:

1) Wang's fixes for compression ENOSPC
2) Qgroup reserved space fix and WARN_ON
3) Inband dedupe work

I think inband dedupe is stable enough for for-next branch, so I included them
at the tail of the patchset.

RAID56 patches will follow soon, as I am still digging the RAID56 scrub/replace
race, and I hope to submit them as a RAID56 patchset.

Qu Wenruo (14):
  btrfs: Add WARN_ON for qgroup reserved underflow
  btrfs: qgroup: Add trace point for qgroup reserved space
  btrfs: qgroup: Re-arrange tracepoint timing to co-operate with
    reserved space tracepoint
  btrfs: qgroup: Fix qgroup corruption caused by inode_cache mount
    option
  btrfs: qgroup: Add quick exit for non-fs extents
  btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
  btrfs: qgroup: Return actually freed bytes for qgroup release or free
    data
  btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered
    write and quota enable
  btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
  btrfs: qgroup: Fix qgroup reserved space underflow by only freeing
    reserved ranges
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedupe: Inband in-memory only de-duplication implement
  btrfs: relocation: Enhance error handling to avoid BUG_ON
  btrfs: dedupe: Introduce new reconfigure ioctl

Wang Xiaoguang (12):
  btrfs: improve inode's outstanding_extents computation
  btrfs: introduce type based delalloc metadata reserve
  btrfs: Introduce COMPRESS reserve type to fix false enospc for
    compression
  btrfs: dedupe: Introduce dedupe framework and its header
  btrfs: dedupe: Introduce function to initialize dedupe info
  btrfs: dedupe: Introduce function to add hash into in-memory tree
  btrfs: dedupe: Introduce function to remove hash from in-memory tree
  btrfs: dedupe: Introduce function to search for an existing hash
  btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
  btrfs: ordered-extent: Add support for dedupe
  btrfs: Introduce DEDUPE reserve type to fix false enospc for in-band
    dedupe
  btrfs: dedupe: Add ioctl for inband dedupelication

 fs/btrfs/Makefile            |   2 +-
 fs/btrfs/ctree.h             |  53 ++-
 fs/btrfs/dedupe.c            | 820 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h            | 184 +++++++++-
 fs/btrfs/delayed-ref.c       |  30 +-
 fs/btrfs/delayed-ref.h       |   8 +
 fs/btrfs/disk-io.c           |   4 +
 fs/btrfs/extent-tree.c       |  99 ++++--
 fs/btrfs/extent_io.c         |  62 +++-
 fs/btrfs/extent_io.h         |  30 +-
 fs/btrfs/file.c              |  70 ++--
 fs/btrfs/free-space-cache.c  |   6 +-
 fs/btrfs/inode-map.c         |   8 +-
 fs/btrfs/inode.c             | 568 +++++++++++++++++++++++++-----
 fs/btrfs/ioctl.c             | 106 +++++-
 fs/btrfs/ordered-data.c      |  46 ++-
 fs/btrfs/ordered-data.h      |  13 +
 fs/btrfs/qgroup.c            | 223 +++++++++---
 fs/btrfs/qgroup.h            |  14 +-
 fs/btrfs/relocation.c        |  65 +++-
 fs/btrfs/sysfs.c             |   2 +
 fs/btrfs/tests/inode-tests.c |  15 +-
 fs/btrfs/transaction.c       |  20 +-
 include/trace/events/btrfs.h |  43 +++
 include/uapi/linux/btrfs.h   |  55 +++
 25 files changed, 2270 insertions(+), 276 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c

-- 
2.11.0



