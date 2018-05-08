Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15459 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933099AbeEHIY0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:26 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 00/16] btrfs-progs: lowmem: avoid extents overwrite
Date: Tue, 8 May 2018 16:29:56 +0800
Message-ID: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github:
https://github.com/Damenly/btrfs-progs/tree/lowmem_v5

Patch[1] is added for code shared.

Patch[2-6] introduce two ways to avoid extents overwrite:
1) Traverse trees and exclude all metadata blocks.
   It's time-inefficient for large filesystems.
2) Mark all existed chunks full, allocate new chunk for CoW and
   records chunk start.
   If the last allocated chunk is almost full, allocated a new one.
   
Method 2 is More efficient than 1. However, it can't handle situations
like no space(fsck-tests/004).
Lowmem repair will try method 2 first and then method 1.

Patch[7-15] remove parameters @trans in functions in lowmem repair.
They try to avoid extents overwrite if necessary and start
transactions by themselves.

Patch[16] adds a test image for new chunks allocation.
Excluding extents can be tested by existed image in fsck-tests/014.

Those patches are mainly for lowmem repair. Original mode is not
influenced.

---
Changlog:
v5->v4:
 - Rebase to devel. Bases commit 9c6d390217b8 ("btrfs-progs: check:
   	  Distingusih csum checking output for --check-data-csum")
 - Change changelogs and fix typos.
 - Rename subjects from "* lowmem check: *" to "* lowmem: *".

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
   
Su Yue (16):
  btrfs-progs: check: move pin_down_tree_blocks to mode-common.c
  btrfs-progs: lowmem: exclude extents of metadata blocks
  btrfs-progs: lowmem: introduce mark/clear_block_groups_full()
  btrfs-progs: lowmem: introduce try_force_cow_in_new_chunk()
  btrfs-progs: lowmem: introduce avoid_extents_overwrite()
  btrfs-progs: lowmem: exclude extents if init-extent-tree in lowmem
  btrfs-progs: lowmem: start to remove parameters @trans in lowmem
  btrfs-progs: lowmem: remove parameter @trans of delete_extent_item()
  btrfs-progs: lowmem: remove parameter @trans of repair_chunk_item()
  btrfs-progs: lowmem: remove parameter @trans of repair_extent_item()
  btrfs-progs: lowmem: remove parameter @trans of check_leaf_items()
  btrfs-progs: lowmem: remove parameter @trans of repair_tree_back_ref()
  btrfs-progs: lowmem: remove parameter @trans of check_btrfs_root()
  btrfs-progs: lowmem: introduce repair_block_accounting()
  btrfs-progs: lowmem: end of removing parameters @trans in lowmem
  btrfs-progs: fsck-tests: add image no extent with normal device size

 check/main.c                                  | 118 +---
 check/mode-common.c                           | 141 +++++
 check/mode-common.h                           |   3 +
 check/mode-lowmem.c                           | 539 +++++++++++++++---
 .../014-no-extent-info/.lowmem_repairable     |   0
 .../014-no-extent-info/no_extent.raw.xz       | Bin 0 -> 28084 bytes
 ...default_case.img => no_extent_bad_dev.img} | Bin
 7 files changed, 627 insertions(+), 174 deletions(-)
 create mode 100644 tests/fsck-tests/014-no-extent-info/.lowmem_repairable
 create mode 100644 tests/fsck-tests/014-no-extent-info/no_extent.raw.xz
 rename tests/fsck-tests/014-no-extent-info/{default_case.img => no_extent_bad_dev.img} (100%)

-- 
2.17.0



