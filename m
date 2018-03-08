Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56753 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751622AbeCHOf1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 09:35:27 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 99C13AE19
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 14:35:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/22] Misc cleanups
Date: Thu,  8 Mar 2018 15:33:06 +0100
Message-Id: <cover.1520518876.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanups that have piled over the time. The "very important" unused
argument removals, some renaming and simplifications.

The effects on stack consumption are not huge, but still measurable:

ctree.c:tree_mod_log_insert_key               +16 (48 -> 64)
ctree.c:tree_mod_log_insert_move               -8 (104 -> 96)
ctree.c:insert_ptr.isra.24                     -8 (80 -> 72)
ctree.c:del_ptr.isra.25                        -8 (96 -> 88)
ctree.c:btrfs_old_root_level                   -8 (32 -> 24)
ctree.c:btrfs_set_item_key_safe                -8 (88 -> 80)
extent_io.c:submit_extent_page                -40 (112 -> 72)

David Sterba (22):
  btrfs: assume that bio_ret is always valid in submit_extent_page
  btrfs: assume that prev_em_start is always valid in __do_readpage
  btrfs: remove redundant variable in __do_readpage
  btrfs: cleanup merging conditions in submit_extent_page
  btrfs: document more parameters of submit_extent_page
  btrfs: drop fs_info parameter from tree_mod_log_set_node_key
  btrfs: drop fs_info parameter from tree_mod_log_insert_move
  btrfs: drop fs_info parameter from tree_mod_log_insert_key
  btrfs: drop fs_info parameter from tree_mod_log_free_eb
  btrfs: drop fs_info parameter from tree_mod_log_free_eb
  btrfs: drop unused fs_info parameter from tree_mod_log_eb_move
  btrfs: embed tree_mod_move structure to tree_mod_elem
  btrfs: drop fs_info parameter from __tree_mod_log_oldest_root
  btrfs: remove trivial locking wrappers of tree mod log
  btrfs: kill trivial wrapper tree_mod_log_eb_move
  btrfs: kill tree_mod_log_set_node_key helper
  btrfs: kill tree_mod_log_set_root_pointer helper
  btrfs: move allocation after simple tests in tree_mod_log_insert_key
  btrfs: separate types for submit_bio_start and submit_bio_done
  btrfs: remove unused parameters from extent_submit_bio_start_t
  btrfs: remove unused parameters from extent_submit_bio_done_t
  btrfs: rename submit callbacks and drop double underscores

 fs/btrfs/ctree.c     | 234 ++++++++++++++++++++-------------------------------
 fs/btrfs/disk-io.c   |  24 +++---
 fs/btrfs/disk-io.h   |   4 +-
 fs/btrfs/extent_io.c |  61 ++++++++------
 fs/btrfs/extent_io.h |   7 ++
 fs/btrfs/inode.c     |  30 +++----
 6 files changed, 158 insertions(+), 202 deletions(-)

-- 
2.16.2

