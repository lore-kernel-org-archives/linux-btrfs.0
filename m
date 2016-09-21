Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12097 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753214AbcIUDQd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 00/14] Btrfsck low memory mode with fs/subvol tree check
Date: Wed, 21 Sep 2016 11:15:50 +0800
Message-Id: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The branch can be fetched from my github:
https://github.com/adam900710/btrfs-progs/tree/lowmem_fs_tree

Already merged lowmem mode fsck only works for extent/chunk tree check.
And for fs tree, it's still using original mode codes.

This makes btrfs check still eat tons of memory for large fs.

Now the new lowmem mode code will also cover fs tree now, to make
lowmem mode be really low-memory usage mode.

And the whole patchset goes through the whole fsck test cases, except
the following case:

006: There is a bug in root item repair code, causing backref error.
     However old fsck has another bug to overwrite extent tree error,
     so old fsck will only report error but still return 0.

     That's an unrelated btrfsck repair bug, which I'll address it later.

015: Just wrong test cases. It's not a normal check-repair-check one.
     So the check after repair will still report error.
     Better to put it to fuzz test cases.

Further plan for lowmem mode is:
1) Add support for --repair
   A lot of work again.

2) Separate original and lowmem mode codes into different files
   300+K single source is really too large.
   Better separate them into a dir and multiple files

3) Avoid using find_all_parents() in traversal function
   In lowmmem mode, we are using find_all_parents() function to ensure
   only the root with smallest objectid to check the leaf, so we can
   save some IO.

   However find_all_parents() is still a quite time consuming function, so
   we'd better avoid calling that function.

Lu Fengqi (12):
  btrfs-progs: move btrfs_extref_hash() to hash.h
  btrfs-progs: check: introduce function to find dir_item
  btrfs-progs: check: introduce function to check inode_ref
  btrfs-progs: check: introduce function to check inode_extref
  btrfs-progs: check: introduce function to find inode_ref
  btrfs-progs: check: introduce a function to check dir_item
  btrfs-progs: check: introduce function to check file extent
  btrfs-progs: check: introduce function to check inode item
  btrfs-progs: check: introduce function to check fs root
  btrfs-progs: check: introduce function to check root ref
  btrfs-progs: check: introduce low_memory mode fs_tree check
  btrfs-progs: check: fix the return value bug of cmd_check()

Qu Wenruo (1):
  btrfs-progs: check: Enhance leaf traversal function to handle missing
    inode item

Wang Xiaoguang (1):
  btrfs-progs: check: skip shared node or leaf check for low_memory mode

 cmds-check.c | 1763 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
 hash.h       |   10 +
 inode-item.c |    8 +-
 3 files changed, 1600 insertions(+), 181 deletions(-)

-- 
2.10.0



