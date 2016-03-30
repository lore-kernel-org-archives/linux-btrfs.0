Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758678AbcC3H4w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 03:56:52 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 6D98D4056406
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 15:56:14 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v9 00/19] Btrfs dedupe framework
Date: Wed, 30 Mar 2016 15:55:55 +0800
Message-Id: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux.git wang_dedupe_20160330

This March 30th patchset update mostly addresses the patchset structure
comment from David:
1) Change the patchset sequence
   Not If only apply the first 14 patches, it can provide the full
   backward compatible in-memory only dedupe backend.

   Only starts from patch 15, on-disk format will be changed.

   So patch 1~14 is going to be pushed for next merge window, while I'll
   still submit them all for review purpose.

   This also makes us have more time to further polish the ondisk format.

2) Fold small fixes into its original patch

On-disk format change comment from Chris will be addressed in next
iteration soon.

This updated version of inband de-duplication has the following features:
1) ONE unified dedup framework.
   Most of its code is hidden quietly in dedup.c and export the minimal
   interfaces for its caller.
   Reviewer and further developer would benefit from the unified
   framework.

2) TWO different back-end with different trade-off
   One is the improved version of previous Fujitsu in-memory only dedup.
   The other one is enhanced dedup implementation from Liu Bo.
   Changed its tree structure to handle bytenr -> hash search for
   deleting hash, without the hideous data backref hack.

3) Support compression with dedupe
   Now dedupe can work with compression.
   Means that, a dedupe miss case can be compressed, and dedupe hit case
   can also reuse compressed file extents.

4) Ioctl interface with persist dedup status
   Advised by David, now we use ioctl to enable/disable dedup.

   And we now have dedup status, recorded in the first item of dedup
   tree.
   Just like quota, once enabled, no extra ioctl is needed for next
   mount.

5) Ability to disable dedup for given dirs/files
   It works just like the compression prop method, by adding a new
   xattr.

TODO:
1) Add extent-by-extent comparison for faster but more conflicting algorithm
   Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
   CPU may even be a bottleneck other than IO.
   But for faster hash, it will definitely cause conflicts, so we need
   extent comparison before we introduce new dedup algorithm.

2) Misc end-user related helpers
   Like handy and easy to implement dedup rate report.
   And method to query in-memory hash size for those "non-exist" users who
   want to use 'dedup enable -l' option but didn't ever know how much
   RAM they have.

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

Qu Wenruo (8):
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedupe: Inband in-memory only de-duplication implement
  btrfs: dedupe: Add basic tree structure for on-disk dedupe method
  btrfs: dedupe: Introduce interfaces to resume and cleanup dedupe info
  btrfs: dedupe: Add support for on-disk hash search
  btrfs: dedupe: Add support to delete hash for on-disk backend
  btrfs: dedupe: Add support for adding hash for on-disk backend
  btrfs: dedupe: Preparation for compress-dedupe co-work

Wang Xiaoguang (11):
  btrfs: dedupe: Introduce dedupe framework and its header
  btrfs: dedupe: Introduce function to initialize dedupe info
  btrfs: dedupe: Introduce function to add hash into in-memory tree
  btrfs: dedupe: Introduce function to remove hash from in-memory tree
  btrfs: dedupe: Introduce function to search for an existing hash
  btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
  btrfs: ordered-extent: Add support for dedupe
  btrfs: dedupe: Add ioctl for inband dedupelication
  btrfs: dedupe: add an inode nodedupe flag
  btrfs: dedupe: add a property handler for online dedupe
  btrfs: dedupe: add per-file online dedupe control

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/ctree.h             |   78 ++-
 fs/btrfs/dedupe.c            | 1206 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h            |  181 +++++++
 fs/btrfs/delayed-ref.c       |   30 +-
 fs/btrfs/delayed-ref.h       |    8 +
 fs/btrfs/disk-io.c           |   35 +-
 fs/btrfs/disk-io.h           |    1 +
 fs/btrfs/extent-tree.c       |   18 +
 fs/btrfs/inode.c             |  250 +++++++--
 fs/btrfs/ioctl.c             |   72 ++-
 fs/btrfs/ordered-data.c      |   46 +-
 fs/btrfs/ordered-data.h      |   13 +
 fs/btrfs/props.c             |   41 ++
 fs/btrfs/relocation.c        |   19 +-
 fs/btrfs/sysfs.c             |    2 +
 include/trace/events/btrfs.h |    3 +-
 include/uapi/linux/btrfs.h   |   23 +
 18 files changed, 1977 insertions(+), 51 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c
 create mode 100644 fs/btrfs/dedupe.h

-- 
2.7.4



