Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752019AbdFMJTo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:44 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 00/19] fs_info refactor part 2 (disk-io.h and volumes.h based)
Date: Tue, 13 Jun 2017 17:19:16 +0800
Message-ID: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the part 2 patchset to refactor btrfs_root usage to
btrfs_fs_info.

The most obvious advantage is to make function calls a little shorter,
and less confused.
Function calls like btrfs_alloc_data_chunk() needs caller to pass a
btrfs_root parameter, while the parameter should always be
fs_info->extent_root, grab it inside that function is much more safer
than allowing user to pass in a random root.

Another advantage is to make it easier to sync some headers with kernel.
In fact, when I'm not sure if I should convert one function, I normally
check kernel code to find the parameter of kernel equivalent.
So when we are going to sync (part of) the headers with kernel, it will
reduce the work.

Part 2 focus on the exported functions mainly in disk-io.h and
volumes.h.
Now most tree blocks/extents read/write, device scan/read, chunk
allocation/initialization functions are all using fs_info.

I'm quite sure there is a lot of remaining functions to be refactored,
but I prefer to do it step by step.

Qu Wenruo (19):
  btrfs-progs: Refactor btrfs_map_block and its variants to use
    btrfs_fs_info
  btrfs-progs: Refactor btrfs_num_copies to use btrfs_fs_info
  btrfs-progs: Refactor btrfs_next_bg and its callers to use
    btrfs_fs_info
  btrfs-progs: Refactor csum_tree_block to use btrfs_fs_info
  btrfs-progs: Refactor write_and_map_eb to use btrfs_fs_info
  btrfs-progs: Refactor write_tree_block to use btrfs_fs_info
  btrfs-progs: btrfstune: Refactor change_devices_uuid to use
    btrfs_fs_info
  btrfs-progs: Refactor read_extent_data to use btrfs_fs_info
  btrfs-progs: Refactor btrfs_find_tree_block to use btrfs_fs_info
  btrfs-progs: Refactor btrfs_readahead_tree_block to use btrfs_fs_info
  btrfs-progs: Refactor write_all_supers and its callers to use
    btrfs_fs_info
  btrfs-progs: Refactor btrfs_check_chunk_valid to use btrfs_fs_info
  btrfs-progs: Refactor btrfs_find_device to use btrfs_fs_info
  btrfs-progs: Refactor btrfs_read_sys_array/chunk_tree to use
    btrfs_fs_info
  btrfs-progs: Refactor btrfs_add_system_chunk to use btrfs_fs_info
  btrfs-progs: Refactor btrfs_chunk_readonly to use btrfs_fs_info
  btrfs-progs: Refactor btrfs_add_device() to use btrfs_fs_info
  btrfs-progs: Remove btrfs_read_super_device as there is no
    implementation
  btrfs-progs: Refactor chunk creation functions to use btrfs_fs_info

 btrfs-corrupt-block.c |   9 ++--
 btrfs-map-logical.c   |   9 ++--
 btrfs-select-super.c  |   2 +-
 btrfstune.c           |  17 ++++---
 chunk-recover.c       |  10 +++--
 cmds-check.c          |  53 ++++++++++++----------
 cmds-restore.c        |  10 ++---
 convert/main.c        |   6 +--
 ctree.c               |   7 +--
 ctree.h               |   4 +-
 disk-io.c             | 120 +++++++++++++++++++++++---------------------------
 disk-io.h             |  16 +++----
 extent-tree.c         |  59 ++++++++++++-------------
 extent_io.c           |   8 ++--
 file.c                |  15 ++++---
 find-root.c           |   4 +-
 image/main.c          |   8 ++--
 mkfs/main.c           |  34 +++++++-------
 super-recover.c       |   2 +-
 utils.c               |  11 ++---
 utils.h               |   4 +-
 volumes.c             | 109 ++++++++++++++++++++++-----------------------
 volumes.h             |  44 +++++++++---------
 23 files changed, 278 insertions(+), 283 deletions(-)

-- 
2.13.1



