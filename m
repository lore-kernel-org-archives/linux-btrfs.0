Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54187 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932463AbcIHHNe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 03:13:34 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
        by cn.fujitsu.com (Postfix) with ESMTP id 2D8DD4026B46
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Sep 2016 15:13:07 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v13 00/15] Btrfs In-band De-duplication
Date: Thu,  8 Sep 2016 15:12:49 +0800
Message-Id: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux.git wang_dedupe_20160907

This version is just another small update, rebased to David's
for-next-20160906 branch.

This updates only includes one small fix, which is exposed by recent
commits which checks space_info->bytes_may_use at umount time.
Caused by that we only free quota reserved space at hash hit, but doesn't
free space_info->bytes_may_use.

Other rebase changes are all related to recent infrastructure change,
like io_tree and quota flags change.

We ran xfstests with dedupe enabled.
While we encountered several bugs, but it's unrelated to dedupe, but
the base branch.

We'll keep digging to fix these non-dedupe bugs.

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

Qu Wenruo (5):
  btrfs: expand btrfs_set_extent_delalloc() and its friends to support
    in-band dedupe and subpage size patchset
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedupe: Inband in-memory only de-duplication implement
  btrfs: relocation: Enhance error handling to avoid BUG_ON
  btrfs: dedupe: Introduce new reconfigure ioctl

Wang Xiaoguang (10):
  btrfs: dedupe: Introduce dedupe framework and its header
  btrfs: dedupe: Introduce function to initialize dedupe info
  btrfs: dedupe: Introduce function to add hash into in-memory tree
  btrfs: dedupe: Introduce function to remove hash from in-memory tree
  btrfs: dedupe: Introduce function to search for an existing hash
  btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
  btrfs: ordered-extent: Add support for dedupe
  btrfs: dedupe: Add ioctl for inband dedupelication
  btrfs: improve inode's outstanding_extents computation
  btrfs: dedupe: fix false ENOSPC

 fs/btrfs/Makefile                |   2 +-
 fs/btrfs/ctree.h                 |  25 +-
 fs/btrfs/dedupe.c                | 820 +++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h                | 201 +++++++++-
 fs/btrfs/delayed-ref.c           |  30 +-
 fs/btrfs/delayed-ref.h           |   8 +
 fs/btrfs/disk-io.c               |   4 +
 fs/btrfs/extent-tree.c           |  82 +++-
 fs/btrfs/extent_io.c             |  65 +++-
 fs/btrfs/extent_io.h             |  17 +-
 fs/btrfs/file.c                  |  26 +-
 fs/btrfs/free-space-cache.c      |   5 +-
 fs/btrfs/inode-map.c             |   4 +-
 fs/btrfs/inode.c                 | 463 +++++++++++++++++-----
 fs/btrfs/ioctl.c                 |  93 ++++-
 fs/btrfs/ordered-data.c          |  46 ++-
 fs/btrfs/ordered-data.h          |  14 +
 fs/btrfs/relocation.c            |  46 ++-
 fs/btrfs/sysfs.c                 |   2 +
 fs/btrfs/tests/extent-io-tests.c |   6 +-
 fs/btrfs/tests/inode-tests.c     |  12 +-
 include/uapi/linux/btrfs.h       |  55 +++
 22 files changed, 1859 insertions(+), 167 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c

-- 
2.9.3



