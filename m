Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60958 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751887AbcANGAG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 01:00:06 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id F20994189172
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 13:59:35 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 00/14][For 4.6] Btrfs: Add inband (write time) de-duplication framework
Date: Thu, 14 Jan 2016 13:57:16 +0800
Message-ID: <1452751054-2365-1-git-send-email-quwenruo@cn.fujitsu.com>
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
   The other one is enhanced dedup implementation from Liu Bo.
   Changed its tree structure to handle bytenr -> hash search for
   deleting hash, without the hideous data backref hack.

3) Ioctl interface with persist dedup status
   Advised by David, now we use ioctl to enable/disable dedup.
   Further we will add per-file/dir dedup disable command in that ioctl.

   And we now have dedup status, recorded in the first item of dedup
   tree.
   Just like quota, once enabled, no extra ioctl is needed for next
   mount.

4) Ability to disable dedup for given dirs/files
   It works just like the compression prop method, by adding a new
   xattr.

For stability, we have run xfstests with *DEDUP ENABLED*, and except
some ENOSPC test case which will take life long to fill,
dedup are all OK and caused nothing wrong.

TODO:
1) Support compression for hash miss case
   It will go though non-compress routine, no compressing it even we can.
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

Qu Wenruo (6):
  btrfs: delayed-ref: Add support for atomic increasing extent ref
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
  btrfs: dedup: Inband in-memory only de-duplication implement
  btrfs: dedup: Add ioctl for inband deduplication
  btrfs: dedup: add an inode nodedup flag
  btrfs: dedup: add a property handler for online dedup
  btrfs: dedup: add per-file online dedup control

 fs/btrfs/Makefile            |   2 +-
 fs/btrfs/ctree.h             |  76 +++-
 fs/btrfs/dedup.c             | 957 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h             | 154 +++++++
 fs/btrfs/delayed-ref.c       |  25 +-
 fs/btrfs/delayed-ref.h       |   2 +-
 fs/btrfs/disk-io.c           |  28 +-
 fs/btrfs/disk-io.h           |   1 +
 fs/btrfs/extent-tree.c       |  40 +-
 fs/btrfs/extent_io.c         |  30 +-
 fs/btrfs/extent_io.h         |  15 +
 fs/btrfs/inode.c             | 314 +++++++++++++-
 fs/btrfs/ioctl.c             |  69 +++-
 fs/btrfs/ordered-data.c      |  33 +-
 fs/btrfs/ordered-data.h      |  13 +
 fs/btrfs/props.c             |  40 ++
 include/trace/events/btrfs.h |   3 +-
 include/uapi/linux/btrfs.h   |  23 ++
 18 files changed, 1779 insertions(+), 46 deletions(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

-- 
2.7.0



