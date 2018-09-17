Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63019 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728212AbeIQMsP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 08:48:15 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id A494C4B6EC66
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 15:21:58 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 0/7] btrfs-progs: lowmem: bug fixes and inode_extref repair
Date: Mon, 17 Sep 2018 15:28:45 +0800
Message-ID: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github:
https://github.com/Damenly/btrfs-progs/tree/lowmem_extref
based on kdave/devel whose HEAD is:
commit 4f20c27ab33aab3efffe13cdae1b8837c821d0d7 (kdave/devel)
Author: Nikolay Borisov <nborisov@suse.com>
Date:   Fri Jun 15 07:13:50 2018 +0000
btrfs-progs: tests: test for FST corruption detection/repair

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
v3:
   Handle fatal errors instead of BUG_ON() in patch[4, 6].
   	  Thanks, Qu Wenruo and Nikolay Borisov.
   Change comments and move declarations in patch[3]. Pointed by Qu Wenruo.
   Handle corner case mentioned in patch[5] in walk_up_tree() not
   	  process_one_leaf().
   Test image are only with inode_extref now.  Suggested by Qu Wenruo.
v2:
   Resend with patches in right order.
   
Su Yue (7):
  btrfs-progs: adjust arguments of btrfs_lookup_inode_extref()
  btrfs-progs: make btrfs_unlink() lookup inode_extref
  btrfs-progs: lowmem check: find dir_item by di_key in check_dir_item()
  btrfs-progs: lowmem: search key of root again after check_fs_root()
    after repair
  btrfs-progs: lowmem: do missing check of last item after
    check_inode_item()
  btrfs-progs: lowmem: optimization and repair for check_inode_extref()
  btrfs-progs: fsck-tests: add test case inode_extref without dir_item
    and dir_index

 check/mode-lowmem.c                           | 206 ++++++++++++++----
 ctree.h                                       |   9 +-
 inode-item.c                                  |   9 +-
 inode.c                                       |  14 +-
 ...node_extref_without_dir_item_and_index.img | Bin 0 -> 4096 bytes
 ... inode_ref_without_dir_item_and_index.img} | Bin
 6 files changed, 188 insertions(+), 50 deletions(-)
 create mode 100644 tests/fsck-tests/009-no-dir-item-or-index/inode_extref_without_dir_item_and_index.img
 rename tests/fsck-tests/009-no-dir-item-or-index/{default_case.img => inode_ref_without_dir_item_and_index.img} (100%)

-- 
2.17.1
