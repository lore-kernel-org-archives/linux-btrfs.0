Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39036 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbeILRyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 13:54:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id j8-v6so972982pff.6
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 05:49:42 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH v2 0/7] btrfs-progs: lowmem: bug fixes and inode_extref repair
Date: Wed, 12 Sep 2018 20:49:17 +0000
Message-Id: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

This patchset can be fetched from my github(based on v4.17.1):
https://github.com/Damenly/btrfs-progs/tree/lowmem_extref

The patchset aims to support check and repair errors about
inode_extref in lowmem mode. 

patch[1-2] let btrfs_unlink() detect inode_extref.
patch[3] fixes a minor bug in check_dir_item due to my careless
	 long ago.
patch[4] fixes a bug about inconsistent path in check_fs_roots()
	 under repair.
patch[5] fixes a corner case about traversal of inode items.
patch[6] enable inode_extref repair support and remove unnecessary
	 checks.
patch[7] add a test image, it can verify above patches except
	 patch[3].

Changelog:
v2:
   Resend with patches in right order.	

Su Yue (7):
  btrfs-progs: adjust arguments of btrfs_lookup_inode_extref()
  btrfs-progs: make btrfs_unlink() lookup inode_extref
  btrfs-progs: lowmem check: find dir_item by di_key in check_dir_item()
  btrfs-progs: lowmem: search key of root again after check_fs_root()
    under repair
  btrfs-progs: lowmem: continue to check item in last slot while
    checking inodes
  btrfs-progs: lowmem: improve check_inode_extref()
  btrfs-progs: fsck-tests: add test case inode_extref without dir_item
    and dir_index

 check/mode-lowmem.c                           | 148 ++++++++++++++----
 ctree.h                                       |   6 +-
 inode-item.c                                  |   6 +-
 inode.c                                       |  14 +-
 .../inode_extref_without_dir_item_index.img   | Bin 0 -> 10240 bytes
 ... inode_ref_without_dir_item_and_index.img} | Bin
 6 files changed, 139 insertions(+), 35 deletions(-)
 create mode 100644 tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_index.img
 rename tests/fsck-tests/009-no-dir-item-or-index/{default_case.img => inode_ref_without_dir_item_and_index.img} (100%)

-- 
2.18.0
