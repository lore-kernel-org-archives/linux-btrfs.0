Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbcBEBY7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 20:24:59 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 3443B4056404
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Feb 2016 09:24:40 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 00/19][For 4.6] Btrfs: Add inband (write time) de-duplication framework
Date: Fri,  5 Feb 2016 09:22:20 +0800
Message-Id: <1454635359-10013-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset can also be fetched from github:
https://github.com/adam900710/linux.git wang_dedup_20160205

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

3) Ioctl interface with persist dedup status
   Advised by David, now we use ioctl to enable/disable dedup.

   And we now have dedup status, recorded in the first item of dedup
   tree.
   Just like quota, once enabled, no extra ioctl is needed for next
   mount.

4) Ability to disable dedup for given dirs/files
   It works just like the compression prop method, by adding a new
   xattr.

TODO:
1) Support compression for hash miss case
   This may need to change the on-disk format for on-disk backend.

2) Add extent-by-extent comparison for faster but more conflicting algorithm
   Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
   CPU may even be a bottleneck other than IO.
   But for faster hash, it will definitely cause conflicts, so we need
   extent comparison before we introduce new dedup algorithm.

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

Qu Wenruo (7):
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedup: Inband in-memory only de-duplication implement
  btrfs: dedup: Add basic tree structure for on-disk dedup method
  btrfs: dedup: Introduce interfaces to resume and cleanup dedup info
  btrfs: dedup: Add support for on-disk hash search
  btrfs: dedup: Add support to delete hash for on-disk backend
  btrfs: dedup: Add support for adding hash for on-disk backend

Wang Xiaoguang (12):
  btrfs: dedup: Introduce dedup framework and its header
  btrfs: dedup: Introduce function to initialize dedup info
  btrfs: dedup: Introduce function to add hash into in-memory tree
  btrfs: dedup: Introduce function to remove hash from in-memory tree
  btrfs: dedup: Introduce function to search for an existing hash
  btrfs: dedup: Implement btrfs_dedup_calc_hash interface
  btrfs: ordered-extent: Add support for dedup
  btrfs: dedup: Add ioctl for inband deduplication
  btrfs: dedup: add an inode nodedup flag
  btrfs: dedup: add a property handler for online dedup
  btrfs: dedup: add per-file online dedup control
  btrfs: try more times to alloc metadata reserve space

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/ctree.h             |   73 ++-
 fs/btrfs/dedup.c             | 1145 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h             |  167 ++++++
 fs/btrfs/delayed-ref.c       |   30 +-
 fs/btrfs/delayed-ref.h       |    8 +
 fs/btrfs/disk-io.c           |   23 +-
 fs/btrfs/disk-io.h           |    1 +
 fs/btrfs/extent-tree.c       |   41 +-
 fs/btrfs/inode.c             |  183 ++++++-
 fs/btrfs/ioctl.c             |   57 ++-
 fs/btrfs/ordered-data.c      |   43 +-
 fs/btrfs/ordered-data.h      |   13 +
 fs/btrfs/props.c             |   40 ++
 fs/btrfs/sysfs.c             |    2 +
 include/trace/events/btrfs.h |    3 +-
 include/uapi/linux/btrfs.h   |   24 +
 17 files changed, 1812 insertions(+), 43 deletions(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

-- 
2.7.0



