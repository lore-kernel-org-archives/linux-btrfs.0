Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48373 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751897AbdHUJny (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 05:43:54 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7EA2ABBC
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 09:43:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/10] Unused parameter cleanup
Date: Mon, 21 Aug 2017 12:43:40 +0300
Message-Id: <1503308630-6652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Here is a series that I've been sitting on for a while. It removes unused 
parameter in various functions, no functional changes. Patch 09/10 reworks
some error handling to eliminate an if branch in __btrfs_alloc_chunk, but it's
still a minor refactoring. 

Nikolay Borisov (10):
  btrfs: Remove chunk_objectid parameter of btrfs_alloc_dev_extent
  btrfs: remove superfluous chunk_tree argument from
    btrfs_alloc_dev_extent
  btrfs: Remove unused variable
  btrfs: Remove unused parameters from various functions
  btrfs: Remove unused arguments from btrfs_changed_cb_t
  btrfs: Remove unused parameter from check_direct_IO
  btrfs: Remove unused parameter from extent_clear_unlock_delalloc
  btrfs: remove unused parameter in cow_file_range
  btrfs: Rework error handling of add_extent_mapping in
    __btrfs_alloc_chunk
  btrfs: Remove redundant argument of __link_block_group

 fs/btrfs/ctree.c       | 15 +++++----------
 fs/btrfs/ctree.h       |  4 +---
 fs/btrfs/extent-tree.c |  8 ++++----
 fs/btrfs/extent_io.c   |  3 +--
 fs/btrfs/extent_io.h   |  2 +-
 fs/btrfs/inode.c       | 47 ++++++++++++++++++-----------------------------
 fs/btrfs/send.c        | 33 ++++++++++++++-------------------
 fs/btrfs/tree-log.c    |  4 +---
 fs/btrfs/volumes.c     | 24 +++++++++++-------------
 9 files changed, 56 insertions(+), 84 deletions(-)

-- 
2.7.4

