Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48248 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754259AbdLTExb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:31 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 00/17] btrfs-progs: lowmem check: avoid extents overwrite
Date: Wed, 20 Dec 2017 12:57:14 +0800
Message-ID: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github:
https://github.com/Damenly/btrfs-progs/tree/lowmem_repair
based on kdave/devel.

Thanks to Qu Wenruo's ideas and suggestions first.
Any suggestions about names of functions and variables are welcome.

Patch[1-3] fix minor problems of lowmem repair.

Patch[4-8] introduce two ways to avoid extents overwrite:
1) Traverse trees and exclude all metadata blocks.
It's time-inefficient for big filesystems.
2) Mark all existed chunks full, allocate new chunk for CoW.
More efficient than method 1. However, it can't not handle situation
like no space.
Lowmem repair will try method 2 first and method 1 next now.

Patch[9-17] remove parameters in lowmem repair functions. They
will try to avoid extents overwrite if necessary and start 
transactions themselves.

Those patches are mainly for lowmem repair. Original mode is not
influenced.
Since btrfs-progs v4.14, lowmem mode changed to check all tree blocks
backrefs. There are many bugs about shared backref in lowmem mode now.
If lowmem check can not work as expected, lowmem repair are useless.
I will fix lowmem check in next.

---
Changlog:
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
  btrfs-progs: lowmem check: introduce modify_block_groups_cache()
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

 cmds-check.c | 620 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 515 insertions(+), 105 deletions(-)

-- 
2.15.1



