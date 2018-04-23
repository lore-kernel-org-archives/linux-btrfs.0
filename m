Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50881 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754016AbeDWHyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 03:54:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 04D2CADCD
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 07:54:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/5] Remove delay_iput parameter when running delalloc work
Date: Mon, 23 Apr 2018 10:54:12 +0300
Message-Id: <1524470057-21969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While trying to make sense of the lifecycle of delayed iputs it became apparent
that the delay_iput parameter of btrfs_start_delalloc_roots/
btrfs_start_delalloc_inodes is always set to 0. (Patch 1 contains historical 
information of why this parameter was needed and when it became obsolete). Now
that the code has changed sufficiently it's no longer required to have it so
this series gradually removes it. 

Nikolay Borisov (5):
  btrfs: Remove delayed_iput parameter of btrfs_start_delalloc_roots
  btrfs: Remove delayed_iput parameter from btrfs_start_delalloc_inodes
  btrfs: Remove delay_iput parameter from __start_delalloc_inodes
  btrfs: Remove delayed_iput member from btrfs_delalloc_work
  btrfs: Unexport btrfs_alloc_delalloc_work

 fs/btrfs/ctree.h       |  9 ++-------
 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/extent-tree.c |  4 ++--
 fs/btrfs/inode.c       | 28 +++++++++-------------------
 fs/btrfs/ioctl.c       |  4 ++--
 5 files changed, 16 insertions(+), 31 deletions(-)

-- 
2.7.4

