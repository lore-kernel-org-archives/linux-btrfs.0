Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33068 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752147AbdDKDZG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:25:06 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B639E47CE221
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Apr 2017 11:25:03 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] btrfs-progs: check: simple errors repair in lowmem
Date: Tue, 11 Apr 2017 11:26:26 +0800
Message-ID: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The series include following contents:

1) Repair wrong nbytes of file inode item.
   After traversal of extents in one file, we should get the actual nbytes
   of the file. If nbytes in the file inode differs from the actual value,
   set the value to actual one.
   
   The wrong nbytes of file inode case corresponds to fsck-test/016.
   
2) Repair wrong iszie of directory inode item.
   After traversal of dir_index and dir_item in one dir, we should get
   the actual isize of the dirctory. If size in the inode item differs
   from the actual value, set the value to actual one.

   New test case 'fsck-test/026' is added for the case wrong isize of
   directory inode.
   
3) Allow fsck check test to repair in lowmem mode for certain test cases
   if TEST_ENABLE_OVERRIDE=true.

Qu Wenruo (1):
  btrfs-progs: fsck-check: Allow fsck check test to repair in lowmem
    mode for certain test cases

Su Yue (4):
  btrfs-progs: check: inode nbytes fix in lowmem
  btrfs-progs: check: dir isize fix in lowmem
  btrfs-progs: check: enable lowmem repair
  btrfs-progs: fsck-check: test cases for nbytes and dir isize

 cmds-check.c                                       | 149 +++++++++++++++++++--
 tests/common.local                                 |  14 +-
 .../016-wrong-inode-nbytes/.lowmem_repairable      |   0
 .../026-wrong-dir-inode-isize/.lowmem_repairable   |   0
 .../026-wrong-dir-inode-isize/default_case.img     | Bin 0 -> 4096 bytes
 5 files changed, 153 insertions(+), 10 deletions(-)
 create mode 100644 tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable
 create mode 100644 tests/fsck-tests/026-wrong-dir-inode-isize/.lowmem_repairable
 create mode 100644 tests/fsck-tests/026-wrong-dir-inode-isize/default_case.img

-- 
2.12.0



