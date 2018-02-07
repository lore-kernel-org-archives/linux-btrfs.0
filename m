Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56368 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754333AbeBGP4E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:04 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00A5EACED
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 00/14] Misc transaction cleanups
Date: Wed,  7 Feb 2018 17:55:36 +0200
Message-Id: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here are a bunch of transaction-related cleanups all of them present no 
functional changes. The first 2 patches could be more interesting - the first
one moves trans_release_metadata to transaction.c and makes it static and the 
second one opencodes btrfs_write_and_wait_marked_extents in its sole caller
to make the chall chain shorter. The rest of the patches just kill the 
extraneous fs_info argument since they also take either a btrfs_trans_handle or
btrfs_transaction pointer which already contain fs_info. 

The modified functions are all called from btrfs_commit_transaction. With this
series applied the only function which remain that still take fs_info and 
some type of transaction reference are: 

btrfs_finish_extent_commit
btrfs_qgroup_account_extents
btrfs_run_delayed_refs


The reason I haven't touched them is that David expressed some reservation 
about mass cleaning of functions which are more or less public interface. And 
the above 3 are such functions. David if you don't objec to converting those 3
I will keep them in mind when doing further cleanups in the transaction area. 

Nikolay Borisov (14):
  btrfs: Make btrfs_trans_release_metadata private to transaction.c
  btrfs: Open code btrfs_write_and_wait_marked_extents
  btrfs: Remove fs_info argument from btrfs_trans_release_metadata
  btrfs: Remove fs_info argument from btrfs_create_pending_block_groups
  btrfs: Don't pass fs_info arg to btrfs_start_dirty_block_groups
  btrfs: Don't pass fs_info to __btrfs_run_delayed_items
  btrfs: Don't pass fs_info to btrfs_run_delayed_items/_nr
  btrfs: Don't pass fs_info to commit_fs_roots
  btrfs: Don't pass fs_info to commit_cowonly_roots
  btrfs: Remove root argument of cleanup_transaction
  btrfs: Remove fs_info argument from switch_commit_roots
  btrfs: Remove fs_info argument from
    create_pending_snapshots/create_pending_snapshot
  btrfs: Remove fs_info argument from
    btrfs_update_commit_device_bytes_used
  btrfs: Remove fs_info argument of btrfs_write_and_wait_transaction

 fs/btrfs/ctree.h         |   8 +--
 fs/btrfs/delayed-inode.c |  14 +++--
 fs/btrfs/delayed-inode.h |   6 +--
 fs/btrfs/extent-tree.c   |  34 +++---------
 fs/btrfs/transaction.c   | 134 ++++++++++++++++++++++++++---------------------
 fs/btrfs/tree-log.c      |  12 ++---
 fs/btrfs/volumes.c       |  10 ++--
 fs/btrfs/volumes.h       |   3 +-
 8 files changed, 101 insertions(+), 120 deletions(-)

-- 
2.7.4

