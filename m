Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934693AbeEJMpB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:45:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B671AAEC7
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 12:44:59 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/17] Freespace tree big fs_info cleanup
Date: Thu, 10 May 2018 15:44:39 +0300
Message-Id: <1525956296-32118-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a series which cleans _all_ freespace tree functions from a redundant
fs_info argument since they already take either a transaction or a 
block_group_cache structure. Both of those structures contain a reference to 
fs info and can be used instead of an additional parameter. This is needed 
since I will be pulling some of the freespace tree code into btrfs-progs in 
implementing check/rebuild functionality for the freespace tree. So better have
this sooner rather than later. 

This series should bring no functional changes but just in case it passed the 
btrfs' selftests as well as a full xfstest run. 

Nikolay Borisov (17):
  btrfs: Make btrfs_init_dummy_trans initialize trans' fs_info field
  btrfs: Remove fs_info argument from add_block_group_free_space
  btrfs: Remove fs_info argument from __add_block_group_free_space
  btrfs: Remove fs_info argument from __add_to_free_space_tree
  btrfs: Remove fs_info parameter from add_new_free_space_info
  btrfs: Remove fs_info argument from add_new_free_space
  btrfs: Remove fs_info parameter from remove_block_group_free_space
  btrfs: Remove fs_info argument from convert_free_space_to_bitmaps
  btrfs: Remove fs_info parameter from convert_free_space_to_extents
  btrfs: Remove fs_info argument from update_free_space_extent_count
  btrfs: Remove fs_info argument from modify_free_space_bitmap
  btrfs: Remove fs_info argument from add_free_space_extent
  btrfs: Remove fs_info argument from remove_free_space_extent
  btrfs: Remove fs_info argument from __remove_from_free_space_tree
  btrfs: Remove fs_info argument from remove_from_free_space_tree
  btrfs: Remove fs_info argument from add_to_free_space_tree
  btrfs: Remove fs_info argument from populate_free_space_tree

 fs/btrfs/ctree.h                       |   2 +-
 fs/btrfs/extent-tree.c                 |  25 ++++---
 fs/btrfs/free-space-tree.c             | 115 ++++++++++++++-------------------
 fs/btrfs/free-space-tree.h             |   8 ---
 fs/btrfs/tests/btrfs-tests.c           |   4 +-
 fs/btrfs/tests/btrfs-tests.h           |   3 +-
 fs/btrfs/tests/free-space-tree-tests.c |  55 ++++++++--------
 fs/btrfs/tests/qgroup-tests.c          |  12 ++--
 8 files changed, 99 insertions(+), 125 deletions(-)

-- 
2.7.4

