Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbcF3JSx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:18:53 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id EBC584043CE0
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:18:33 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V12 00/14] Btrfs in-band de-duplication
Date: Thu, 30 Jun 2016 17:18:18 +0800
Message-Id: <20160630091833.26975-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux.git wang_dedupe_20160620

And, for any one wants to test it based David's for-next-test-20160620:
https://github.com/adam900710/linux.git wang_dedupe_20160620_for_david
(Several bugs are already reported, although not dedupe bugs)

Hopes this helps David to merge both subpage sector size and dedupe
patchset to for-next branch.

In this update, the patchset goes through ioctl updates.
1) New ioctl re-configure interface
   Suggested by David.
   
   Unlike old stateless enable ioctl, new re-configure ioctl can only be
   called on dedupe-enabled fs.
   While old enable ioctl will reset any unspecified parameter to
   default value, new re-configure ioctl will only modify specified
   parameters.

   For example:
   # btrfs dedupe enable -b 64K /mnt/test
   # btrfs dedupe ebable -l 1m /mnt/test
   # btrfs dedupe status /mnt/test
   Status:			Enabled
   Hash algorithm:		SHA-256
   Backend:			In-memory
   Dedup Blocksize:		131072 <<< Reset to 128K
   Number of hash: 		[0/1048576]
   Memory usage: 		[0.00B/112.00MiB]

   While for new reconfigure ioctl interface
   # btrfs dedupe enable -b 64K /mnt/test
   # btrfs dedupe reconfigure -l 1m /mnt/test
   # btrfs dedupe status /mnt/test
   Status:			Enabled
   Hash algorithm:		SHA-256
   Backend:			In-memory
   Dedup Blocksize:		65536 <<< Still 64K
   Number of hash: 		[0/1048576] <<< Updated to 1M
   Memory usage: 		[0.00B/112.00MiB]


2) More extendable and meaningful ioctl structure.
   Now reserved member of btrfs_ioctl_dedupe_args will be set to -1.
   So unsupported fields can be detected by user tool, allowing
   reporting unsupported optional features.

   Also, even for enable/reconfig, invalid parameter of ioctl structure
   will now be marked with -1, and return to user space.
   So user tools can get more precious error report on different kernels.

3) New flag for enable ioctl
   For guys prefer stateless enable ioctl (like me), new FORCE flag is
   introduced, and with that flag set(-f parameter for btrfs-progs) the
   old stateless ioctl is back again.

   This also makes scripting easier.

Thanks,
Qu

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
  Precious error report and extendable ioctl structure.

Qu Wenruo (4):
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
 fs/btrfs/dedupe.h                | 221 +++++++++++
 fs/btrfs/delayed-ref.c           |  30 +-
 fs/btrfs/delayed-ref.h           |   8 +
 fs/btrfs/disk-io.c               |   4 +
 fs/btrfs/extent-tree.c           |  83 +++-
 fs/btrfs/extent_io.c             |  63 ++-
 fs/btrfs/extent_io.h             |  15 +-
 fs/btrfs/file.c                  |  26 +-
 fs/btrfs/free-space-cache.c      |   5 +-
 fs/btrfs/inode-map.c             |   4 +-
 fs/btrfs/inode.c                 | 440 +++++++++++++++++----
 fs/btrfs/ioctl.c                 |  93 ++++-
 fs/btrfs/ordered-data.c          |  46 ++-
 fs/btrfs/ordered-data.h          |  14 +
 fs/btrfs/relocation.c            |  46 ++-
 fs/btrfs/sysfs.c                 |   2 +
 fs/btrfs/tests/extent-io-tests.c |   6 +-
 fs/btrfs/tests/inode-tests.c     |  12 +-
 include/uapi/linux/btrfs.h       |  55 +++
 22 files changed, 1864 insertions(+), 156 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c
 create mode 100644 fs/btrfs/dedupe.h

-- 
2.9.0



