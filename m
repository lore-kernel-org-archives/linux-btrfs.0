Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933440AbeE1QNr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:47 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B974FAE15
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:13:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/11] Summer argument cleanup
Date: Mon, 28 May 2018 09:36:39 +0300
Message-Id: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Here is yet another series removing a bunch of extraneous argument. The series 
constitutes no functional changes. Some of the function actually have a kernel 
counterpart (btrfs_lookup_extent_info/clean_tree_block). However the former's 
userspace signature differs and the patch in this series makes it identical to 
the kernel one. 

Nikolay Borisov (11):
  btrfs-progs: check: Remove root argument from delete_extent_records
  btrfs-progs: check: Remove root parameter from
    btrfs_fix_block_accounting
  btrfs-progs: check: Remove root parameter from del_pending_extents
  btrfs-progs: check: Remove root argument from finish_current_insert
  btrfs-progs: check: Make update_pinned_extents take btrfs_fs_info
  btrfs-progs: Remove unused argument from clean_tree_block
  btrfs-progs: check: Remove unused root argument from
    btrfs_extent_post_op
  btrfs-progs: Change btrfs_root to btrfs_fs_info argument in
    btrfs_lookup_extent_info
  btrfs-progs: Remove root argument from btrfs_set_block_flags
  btrfs-progs: Remove root argument from write_one_cache_group
  btrfs-progs: Remove fs_info argument from write_ctree_super

 check/main.c        |  31 +++++++-------
 check/mode-lowmem.c |   6 +--
 ctree.c             |  17 ++++----
 ctree.h             |  13 +++---
 disk-io.c           |   9 ++--
 disk-io.h           |   6 +--
 extent-tree.c       | 121 ++++++++++++++++++++++++----------------------------
 free-space-tree.c   |   2 +-
 transaction.c       |   2 +-
 9 files changed, 96 insertions(+), 111 deletions(-)

-- 
2.7.4

