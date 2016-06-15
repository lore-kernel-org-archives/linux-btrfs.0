Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2559 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932456AbcFOCKQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 22:10:16 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id CBF154056401
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 10:10:02 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v11 00/13] Btrfs dedupe framework
Date: Wed, 15 Jun 2016 10:09:48 +0800
Message-Id: <20160615021001.9588-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux.git wang_dedupe_20160524

In this update, the patchset goes through another re-organization along
with other fixes to address comments from community.
1) Move on-disk backend and dedupe props out of the patchset
   Suggested by David.
   There is still some discussion on the on-disk format.
   And dedupe prop is still not 100% determined.

   So it's better to focus on the current in-memory backend only, which
   doesn't bring any on-disk format change.

   Once the framework is done, new backends and props can be added more
   easily.

2) Better enable/disable and buffered write race avoidance
   Inspired by Mark.
   Although in previous version, we didn't trigger it with our test
   case, but if we manually add delay(5s) to __btrfs_buffered_write(),
   it's possible to trigger disable and buffered write race.

   The cause is, there is a windows between __btrfs_buffered_write() and
   btrfs_dirty_pages().
   In that window, sync_filesystem() can return very quickly since there
   is no dirty page.
   During that window, dedupe disable can happen and finish, and
   buffered writer may access to the NULL pointer of dedupe info.

   Now we use sb->s_writers.rw_sem to wait all current writers and block
   further writers, then sync the fs, change dedupe status and finally
   unblock writers. (Like freeze)
   This provides clearer logical and code, and safer than previous
   method, because there is no windows before we dirty pages.

3) Fix ENOSPC problem with better solution.
   Pointed out by Josef.
   The last 2 patches from Wang fixes ENOSPC problem, in a more
   comprehensive method for delalloc metadata reservation.
   Alone with small outstanding extents improvement, to co-operate with
   tunable max extent size.

Now the whole patchset will only add in-memory backend as a whole.
No other backend nor prop.
So we can focus on the framework itself.

Next version will focus on ioctl interface modification suggested by
David.

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

Qu Wenruo (3):
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedupe: Inband in-memory only de-duplication implement
  btrfs: relocation: Enhance error handling to avoid BUG_ON

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

 fs/btrfs/Makefile           |   2 +-
 fs/btrfs/ctree.h            |  25 +-
 fs/btrfs/dedupe.c           | 710 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h           | 210 +++++++++++++
 fs/btrfs/delayed-ref.c      |  30 +-
 fs/btrfs/delayed-ref.h      |   8 +
 fs/btrfs/disk-io.c          |   4 +
 fs/btrfs/extent-tree.c      |  83 +++++-
 fs/btrfs/extent_io.c        |  63 +++-
 fs/btrfs/extent_io.h        |  15 +-
 fs/btrfs/file.c             |  26 +-
 fs/btrfs/free-space-cache.c |   5 +-
 fs/btrfs/inode-map.c        |   4 +-
 fs/btrfs/inode.c            | 434 ++++++++++++++++++++++-----
 fs/btrfs/ioctl.c            |  80 ++++-
 fs/btrfs/ordered-data.c     |  46 ++-
 fs/btrfs/ordered-data.h     |  14 +
 fs/btrfs/relocation.c       |  46 ++-
 fs/btrfs/sysfs.c            |   2 +
 include/uapi/linux/btrfs.h  |  41 +++
 20 files changed, 1701 insertions(+), 147 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c
 create mode 100644 fs/btrfs/dedupe.h

-- 
2.8.3



