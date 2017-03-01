Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23240 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751592AbdCADSG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:06 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CCD5747C4EBF
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:09 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 00/20] Enable lowmem repair for fs/subvolume tree
Date: Wed, 1 Mar 2017 11:13:43 +0800
Message-ID: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be feched from my github:
https://github.com/Damenly/btrfs-progs.git lowmem_repair

This patchset can repair errors found in fs tree in lowmem mode.

This patchset request includes:
1) Repair inode nbytes error.
2) Repair dir isize error.
3) Repair orpahan inode item.
4) Repair dir item/index missing/mismatch.
5) Repair inode ref missing/mismatch.
6) Repair inode item missing.
7) Repair inode nlink error.
8) Punch file extent hole.
9) Let test-fsck test cases which can be repaired in lowmem mode.

All cases have been tested except fsck-test/006 since it can't be
repaired in original mode.

Qu Wenruo (1):
  btrfs-progs: fsck-check: Allow fsck check test to repair in lowmem
    mode for certain test cases

Su Yue (19):
  btrfs-progs: cmds-check.c: supports inode nbytes fix in lowmem
  btrfs-progs: cmds-check.c: supports dir isize fix in lowmem
  btrfs-progs: cmds-check.c: inode orphan item repair
  btrfs-progs: cmds-check.c: change find_inode_ref's arg
  btrfs-progs: cmds-check.c: modify check_fs_first_inode
  btrfs-progs: cmds-check.c: change find_dir_index/item
  btrfs-progs: cmds-check.c: introduce print_inode_ref
  btrfs-progs: cmds-check.c: print_dir_item_err
  btrfs-progs: cmds-check.c: introduce count_dir_isize
  btrfs-progs: dir-item.c: modify btrfs_insert_dir_item
  btrfs-progs: inode.c: alter btrfs_add_link
  btrfs-progs: cmds-check.c: introduce __create_inode_item
  btrfs-progs: cmds-check.c: repair_inode_item_missing
  btrfs-progs: cmds-check.c: repair_fs_first_inode
  btrfs-progs: cmds-check.c: introduce repair_ternary_lowmem
  btrfs-progs: cmds-check.c: Introduce repair_dir_item
  btrfs-progs: cmds-check.c: repair inode ref
  btrfs-progs: cmds-check.c: repair nlinks lowmem
  btrfs-progs: cmds-check.c: add punch_extent_hole

 cmds-check.c                                       | 1677 +++++++++++++++-----
 convert/main.c                                     |    2 +-
 ctree.h                                            |    2 +-
 dir-item.c                                         |   13 +-
 inode.c                                            |   46 +-
 tests/common.local                                 |   14 +-
 .../fsck-tests/004-no-dir-index/.lowmem_repairable |    0
 .../009-no-dir-item-or-index/.lowmem_repairable    |    0
 .../010-no-rootdir-inode-item/.lowmem_repairable   |    0
 .../011-no-inode-item/.lowmem_repairable           |    0
 .../016-wrong-inode-nbytes/.lowmem_repairable      |    0
 .../017-missing-all-file-extent/.lowmem_repairable |    0
 12 files changed, 1363 insertions(+), 391 deletions(-)
 create mode 100644 tests/fsck-tests/004-no-dir-index/.lowmem_repairable
 create mode 100644 tests/fsck-tests/009-no-dir-item-or-index/.lowmem_repairable
 create mode 100644 tests/fsck-tests/010-no-rootdir-inode-item/.lowmem_repairable
 create mode 100644 tests/fsck-tests/011-no-inode-item/.lowmem_repairable
 create mode 100644 tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable
 create mode 100644 tests/fsck-tests/017-missing-all-file-extent/.lowmem_repairable

-- 
2.11.1



