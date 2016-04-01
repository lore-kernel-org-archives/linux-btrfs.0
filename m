Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62526 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbcDAGfa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 02:35:30 -0400
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id AE8E14056401
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 14:35:13 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v10 00/21] Btrfs dedupe framework
Date: Fri,  1 Apr 2016 14:34:51 +0800
Message-Id: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux.git wang_dedupe_20160401

In this patchset, we're proud to bring a completely new storage backend:
Khala backend.

With Khala backend, all dedupe hash will be restored in the Khala,
shared with every Kalai protoss, with unlimited storage and almost zero
search latency.
A perfect backend for any Kalai protoss. "My life for Aiur!"

Unfortunately, such backend is not available for human.


OK, except the super-fancy and date-related backend, the patchset is
still a serious patchset.
In this patchset, we mostly addressed the on-disk format change comment from
Chris:
1) Reduced dedupe hash item and bytenr item.
   Now dedupe hash item structure size is reduced from 41 bytes
   (9 bytes hash_item + 32 bytes hash)
   to 29 bytes (5 bytes hash_item + 24 bytes hash)
   Without the last patch, it's even less with only 24 bytes
   (24 bytes hash only).
   And dedupe bytenr item structure size is reduced from 32 bytes (full
   hash) to 0.

2) Hide dedupe ioctls into CONFIG_BTRFS_DEBUG
   Advised by David, to make btrfs dedupe as an experimental feature for
   advanced user.
   This is used to allow this patchset to be merged while still allow us
   to change ioctl in the further.

3) Add back missing bug fix patches
   I just missed 2 bug fix patches in previous iteration.
   Adding them back.

Now patch 1~11 provide the full backward-compatible in-memory backend.
And patch 12~14 provide per-file dedupe flag feature.
Patch 15~20 provide on-disk dedupe backend with persist dedupe state for
in-memory backend.
The last patch is just preparation for possible dedupe-compress co-work.


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

Qu Wenruo (9):
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedupe: Inband in-memory only de-duplication implement
  btrfs: relocation: Enhance error handling to avoid BUG_ON
  btrfs: dedupe: Add basic tree structure for on-disk dedupe method
  btrfs: dedupe: Introduce interfaces to resume and cleanup dedupe info
  btrfs: dedupe: Add support for on-disk hash search
  btrfs: dedupe: Add support to delete hash for on-disk backend
  btrfs: dedupe: Add support for adding hash for on-disk backend
  btrfs: dedupe: Preparation for compress-dedupe co-work

Wang Xiaoguang (12):
  btrfs: dedupe: Introduce dedupe framework and its header
  btrfs: dedupe: Introduce function to initialize dedupe info
  btrfs: dedupe: Introduce function to add hash into in-memory tree
  btrfs: dedupe: Introduce function to remove hash from in-memory tree
  btrfs: dedupe: Introduce function to search for an existing hash
  btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
  btrfs: ordered-extent: Add support for dedupe
  btrfs: try more times to alloc metadata reserve space
  btrfs: dedupe: Add ioctl for inband dedupelication
  btrfs: dedupe: add an inode nodedupe flag
  btrfs: dedupe: add a property handler for online dedupe
  btrfs: dedupe: add per-file online dedupe control

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/ctree.h             |   80 ++-
 fs/btrfs/dedupe.c            | 1239 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h            |  181 ++++++
 fs/btrfs/delayed-ref.c       |   30 +-
 fs/btrfs/delayed-ref.h       |    8 +
 fs/btrfs/disk-io.c           |   35 +-
 fs/btrfs/disk-io.h           |    1 +
 fs/btrfs/extent-tree.c       |   41 +-
 fs/btrfs/inode.c             |  250 +++++++--
 fs/btrfs/ioctl.c             |   74 ++-
 fs/btrfs/ordered-data.c      |   46 +-
 fs/btrfs/ordered-data.h      |   13 +
 fs/btrfs/props.c             |   41 ++
 fs/btrfs/relocation.c        |   41 +-
 fs/btrfs/sysfs.c             |    2 +
 include/trace/events/btrfs.h |    3 +-
 include/uapi/linux/btrfs.h   |   23 +
 18 files changed, 2052 insertions(+), 58 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c
 create mode 100644 fs/btrfs/dedupe.h

-- 
2.7.4



