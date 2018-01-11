Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16872 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754014AbeAKHax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:30:53 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 3E53548AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:30:53 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 00/17] btrfs-progs: lowmem check: avoid extents overwrite
Date: Thu, 11 Jan 2018 15:34:54 +0800
Message-ID: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github:
https://github.com/Damenly/btrfs-progs/tree/lowmem
based on kdave/devel.

Thanks to Qu Wenruo's ideas and suggestions first.

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

Those patches are mainly for lowmem repair. Original mode is not
influenced.

---
Changlog:
v2->v3:
 - check_btrfs_root() returns FATAL_ERROR if check_fs_first_inode()
   failed. Thanks Nikolay Borisov.
 - Add function try_to_force_cow_in_new_chunk() and global u64
   varaiable to record start of the last allocated chunk.
 - Remove unused EXTENTS_PIN in enum lowmem_extents_operation.
 
v1->v2:
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
   
Su Yue (17):
  btrfs-progs: lowmem check: release path in repair_extent_data_item()
  btrfs-progs: lowmem check: record returned errors after
    walk_down_tree_v2()
  btrfs-progs: lowmem check: assign @parent early in
    repair_extent_data_item()
  btrfs-progs: lowmem check: exclude extents of metadata blocks
  btrfs-progs: lowmem check: introduce mark/clear_block_groups_full()
  btrfs-progs: lowmem check: introduce force_cow_in_new_chunk()
  btrfs-progs: lowmem check: introduce try_avoid_extents_overwrite()
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

 cmds-check.c | 710 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 604 insertions(+), 106 deletions(-)

-- 
2.15.1



