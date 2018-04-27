Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757469AbeD0JWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 05:22:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AB469AC64
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 09:22:10 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/5] Fix delalloc inodes leaking on btrfs unmount
Date: Fri, 27 Apr 2018 12:21:49 +0300
Message-Id: <1524820914-30864-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After investigating crashes on generic/176 it turned that the culprit in fact
is the random failure induced by generic/019. As it happens, if on unmount the 
filesystem is in BTRFS_FS_STATE_ERROR then btrfs_error_commit_super is called. 
This unveiled 2 bugs:
 1. btrfs_destroy_delalloc_inodes's implementation was completely bogus, since
 it only called btrfs_invalidate_inodes which only pruned dentries and didn't 
 do anything to free any inodes with pending delalloc bytes. Once this is fixed 
 with the use of invalide_inode_pages2 the second bug transpired. 
 2. The last call ot run_delayed_iputs is made before btrfs_cleanup_transaction
 is called. The latter in turn could queue up more delayed iputs resulting from 
 invalidates_inode_pages2. 

This series fixes the problem by first fixing btrfs_destroy_delalloc_inode to 
properly cleanup delalloc inodes and as a result cleans up the code a bit. 

I've given it a good bashing through xfstest (4 full xfstest cycles + 100 
iterations of generic/475 since it was hitting some early assertion failures,
which are fixed in the final version) so am pretty confident in the change. 

Nikolay Borisov (5):
  btrfs: Unexport btrfs_alloc_delalloc_work
  btrfs: Split btrfs_del_delalloc_inode into 2 functions
  btrfs: Add assert in __btrfs_del_delalloc_inode
  btrfs: Fix delalloc inodes invalidation during transaction abort
  btrfs: Unexport and rename btrfs_invalidate_inodes

 fs/btrfs/ctree.h   |  12 +----
 fs/btrfs/disk-io.c |  22 ++++----
 fs/btrfs/inode.c   | 152 ++++++++++++++++++++++++++++++-----------------------
 3 files changed, 99 insertions(+), 87 deletions(-)

-- 
2.7.4

