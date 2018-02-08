Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30650 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752111AbeBHDXA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:00 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 8608F48AE763
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:22:54 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 00/18] btrfs-progs: lowmem check: avoid extents overwrite
Date: Thu, 8 Feb 2018 11:27:19 +0800
Message-ID: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github:
https://github.com/Damenly/btrfs-progs/tree/lowmem
based on unmerged patchset whose cover:
      [PATCH 0/3] btrfs-progs: Split original mode check to its own
      Author: Qu Wenruo <wqu@suse.com>
      
I'm sorry to send patches based on unmerged patch if it let you feel
uncomfortable.
I think the three patches from Qu are good enough so I send it before
my vacation.

Patch[1-3] fix minor problems of lowmem repair.

Patch[4-8] introduce two ways to avoid extents overwrite:
1) Traverse trees and exclude all metadata blocks.
   It's time-inefficient for large filesystems.
2) Mark all existed chunks full, allocate new chunk for CoW and
   records chunk start.
   If the last allocated chunk is almost full, allocated a new one.
2) is More efficient than 1). However, it can't handle situations
like no space(fsck/004).
Lowmem repair will try method 2 first and then method 1.

Patch[9-17] remove parameters @trans in functions for lowmem repair.
They try to avoid extents overwrite if necessary and start
transactions by themselves.

Patch[18] adds a test image.
Those patches are mainly for lowmem repair. Original mode is not
influenced.

---
Changlog:
v4->v3:
 - Remove global enum extents_operation to simplify
   avoid_extents_overwrite() and its cleanup.
 - Rebase after work of check split.
 
v3->v2:
 - check_btrfs_root() returns FATAL_ERROR if check_fs_first_inode()
   failed. Thanks Nikolay Borisov.
 - Add function try_to_force_cow_in_new_chunk() and global u64
   varaiable to record start of the last allocated chunk.
 - Remove unused EXTENTS_PIN in enum lowmem_extents_operation.
 
v2->v1:
 - Let @err in check_btrfs_root() record err bits but excluded
   negative values.
 - Do not delete a line of code to release path after extent item'
   insertion in repair_extent_data_item().
 - Add patch[3].
 - Force CoW in new allocated chunk to avoid extents overwrite.
 - Remove parameters @trans in check_chunks_and_extents_v2() and
   related callees.
 - Repair functions for lowmem mode call try_avoid_extents_overwrite()
   and start transactions.
   
Su Yue (18):
  btrfs-progs: lowmem check: release path in repair_extent_data_item()
  btrfs-progs: lowmem check: record returned errors after
    walk_down_tree_v2()
  btrfs-progs: lowmem check: assign @parent early in
    repair_extent_data_item()
  btrfs-progs: lowmem check: exclude extents of metadata blocks
  btrfs-progs: lowmem check: introduce mark/clear_block_groups_full()
  btrfs-progs: lowmem check: introduce try_force_cow_in_new_chunk()
  btrfs-progs: lowmem check: introduce avoid_extents_overwrite()
  btrfs-progs: lowmem check: exclude extents if init-extent-tree in
    lowmem
  btrfs-progs: lowmem check: start to remove parameters @trans in lowmem
  btrfs-progs: lowmem check: remove parameter @trans of
    delete_extent_item()
  btrfs-progs: lowmem check: remove parameter @trans of
    repair_chunk_item()
  btrfs-progs: lowmem check: remove parameter @trans of
    repair_extent_item()
  btrfs-progs: lowmem check: remove parameter @trans of
    check_leaf_items()
  btrfs-progs: lowmem check: remove parameter @trans of
    repair_tree_back_ref()
  btrfs-progs: lowmem check: remove parameter @trans of
    check_btrfs_root()
  btrfs-progs: lowmem check: introduce repair_block_accounting()
  btrfs-progs: lowmem check: end of removing parameters @trans in lowmem
  btrfs-progs: fsck-tests: add image no extent with normal device size

 check/mode-common.c                                | 100 +++-
 check/mode-common.h                                |   4 +-
 check/mode-lowmem.c                                | 560 +++++++++++++++++----
 check/mode-lowmem.h                                |   1 +
 cmds-check.c                                       |   3 +-
 .../014-no-extent-info/.lowmem_repairable          |   0
 .../fsck-tests/014-no-extent-info/no_extent.raw.xz | Bin 0 -> 28084 bytes
 .../{default_case.img => no_extent_bad_dev.img}    | Bin
 8 files changed, 561 insertions(+), 107 deletions(-)
 create mode 100644 tests/fsck-tests/014-no-extent-info/.lowmem_repairable
 create mode 100644 tests/fsck-tests/014-no-extent-info/no_extent.raw.xz
 rename tests/fsck-tests/014-no-extent-info/{default_case.img => no_extent_bad_dev.img} (100%)

-- 
2.16.1



