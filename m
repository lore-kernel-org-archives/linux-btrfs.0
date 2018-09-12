Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39221 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILQZM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:25:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id j8-v6so865658pff.6
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 04:21:07 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH 0/6] btrfs-progs: lowmem: bug fixes and inode_extref repair
Date: Wed, 12 Sep 2018 19:20:37 +0000
Message-Id: <20180912192046.5861-1-suy.fnst@cn.fujitsu.com>
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


Su Yue (6):
  btrfs-progs: adjust arguments of btrfs_lookup_inode_extref()
  btrfs-progs: make btrfs_unlink() lookup inode_extref
  btrfs-progs: lowmem check: find dir_item by di_key in check_dir_item()
  btrfs-progs: lowmem: search key of root again after check_fs_root()
    under repair
  btrfs-progs: lowmem: continue to check item in last slot while
    checking inodes
  btrfs-progs: lowmem: optimization and repair for check_inode_extref()

 check/mode-lowmem.c | 148 +++++++++++++++++++++++++++++++++++---------
 ctree.h             |   6 +-
 inode-item.c        |   6 +-
 inode.c             |  14 ++++-
 4 files changed, 139 insertions(+), 35 deletions(-)

-- 
2.18.0
