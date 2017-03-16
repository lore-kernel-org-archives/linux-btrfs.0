Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33546 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750987AbdCPH7R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 03:59:17 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E812F477AE9E
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Mar 2017 15:59:06 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v14.2 00/16] Btrfs In-band De-duplication
Date: Thu, 16 Mar 2017 15:58:38 +0800
Message-ID: <20170316075854.15788-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux.git wang_dedupe_latest

This is just a normal rebase update.
Now the new base is v4.11-rc2, and the patchset no longer rely qgroup fixes.

Normal test cases from auto group exposes no regression, and ib-dedupe
group can pass without problem.

Due to recent cleanups, the rebase is a little complex than before, but some
cleanup, like count_max_extents() is quite handy for in-band dedupe.

These 3 patches are unrelated to dedupe, but the problem is the same so
we put they together into the dedupe patchset.
  btrfs: improve inode's outstanding_extents computation
  btrfs: introduce type based delalloc metadata reserve
  btrfs: Introduce COMPRESS reserve type to fix false enospc for
    compression

And sorry for the mail bombing.

Changelog:
v2:
  Totally reworked to handle multiple backends
v3:
  Fix a stupid but deadly on-disk backend bug
  Add handle for multiple hash on same bytenr corner case to fix abort
  trans error
  Increase dedup rate by enhancing delayed ref handler for both backend.
  Move dedup_add() to run_delayed_ref() time, to fix abort trans error.
  Increase dedup block size up limit to 8M.
v4:
  Add dedup prop for disabling dedup for given files/dirs.
  Merge inmem_search() and ondisk_search() into generic_search() to save
  some code
  Fix another delayed_ref related bug.
  Use the same mutex for both inmem and ondisk backend.
  Move dedup_add() back to btrfs_finish_ordered_io() to increase dedup
  rate.
v5:
  Reuse compress routine for much simpler dedup function.
  Slightly improved performance due to above modification.
  Fix race between dedup enable/disable
  Fix for false ENOSPC report
v6:
  Further enable/disable race window fix.
  Minor format change according to checkpatch.
v7:
  Fix one concurrency bug with balance.
  Slightly modify return value from -EINVAL to -EOPNOTSUPP for
  btrfs_dedup_ioctl() to allow progs to distinguish unsupported commands
  and wrong parameter.
  Rebased to integration-4.6.
v8:
  Rename 'dedup' to 'dedupe'.
  Add support to allow dedupe and compression work at the same time.
  Fix several balance related bugs. Special thanks to Satoru Takeuchi,
  who exposed most of them.
  Small dedupe hit case performance improvement.
v9:
  Re-order the patchset to completely separate pure in-memory and any
  on-disk format change.
  Fold bug fixes into its original patch.
v10:
  Adding back missing bug fix patch.
  Reduce on-disk item size.
  Hide dedupe ioctl under CONFIG_BTRFS_DEBUG.
v11:
  Remove other backend and props support to focus on the framework and
  in-memory backend. Suggested by David.
  Better disable and buffered write race protection.
  Comprehensive fix to dedupe metadata ENOSPC problem.
v12:
  Stateful 'enable' ioctl and new 'reconf' ioctl
  New FORCE flag for enable ioctl to allow stateless ioctl
  Precise error report and extendable ioctl structure.
v12.1
  Rebase to David's for-next-20160704 branch
  Add co-ordinate patch for subpage and dedupe patchset. 
v12.2
  Rebase to David's for-next-20160715 branch
  Add co-ordinate patch for other patchset.
v13
  Rebase to David's for-next-20160906 branch
  Fix a reserved space leak bug, which only frees quota reserved space
  but not space_info->byte_may_use.
v13.1
  Rebase to Chris' for-linux-4.9 branch
v14
  Use generic ENOSPC fix for both compression and dedupe.
v14.1
  Further split ENOSPC fix.
v14.2
  Rebase to v4.11-rc2.
  Co-operate with count_max_extent() to calculate num_extents.
  No longer rely on qgroup fixes.


Qu Wenruo (4):
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
 fs/btrfs/ctree.h             |  49 ++-
 fs/btrfs/dedupe.c            | 823 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h            | 184 +++++++++-
 fs/btrfs/delayed-ref.c       |  31 +-
 fs/btrfs/delayed-ref.h       |   9 +
 fs/btrfs/disk-io.c           |   4 +
 fs/btrfs/extent-tree.c       |  66 +++-
 fs/btrfs/extent_io.c         |  63 +++-
 fs/btrfs/extent_io.h         |   6 +
 fs/btrfs/file.c              |  27 +-
 fs/btrfs/free-space-cache.c  |   5 +-
 fs/btrfs/inode-map.c         |   6 +-
 fs/btrfs/inode.c             | 522 +++++++++++++++++++++++----
 fs/btrfs/ioctl.c             |  97 ++++-
 fs/btrfs/ordered-data.c      |  46 ++-
 fs/btrfs/ordered-data.h      |  13 +
 fs/btrfs/relocation.c        |  52 ++-
 fs/btrfs/sysfs.c             |   2 +
 fs/btrfs/tests/inode-tests.c |  15 +-
 include/uapi/linux/btrfs.h   |  55 +++
 21 files changed, 1931 insertions(+), 146 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c

-- 
2.12.0



