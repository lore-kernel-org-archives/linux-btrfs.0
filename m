Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754678AbeAJNVW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 08:21:22 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 05ECCADEF
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 13:21:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Finally remove userspace transaction support
Date: Wed, 10 Jan 2018 15:21:13 +0200
Message-Id: <1515590477-22878-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Userspace transaction were initially added to he benefit of Ceph, however 
in recent times it became clear that btrfs is not suitable for Ceph's workload
and has even been actively discoured. Additionaly, the userspace transaction
mechanism has always been a sort of a hack, which could easily lead to a 
deadlock unless care is taken. 

All things considered there is no point in keeping the code around. Userspace
transaction interface was deprecated in kernel version 4.14. Now it's time to 
completely remove it in 4.17. 

The first patch removes the ioctl-related code. Following patches just deal 
with unused functions/values following ioctl removal. 

Nikolay Borisov (4):
  btrfs: Remove userspace transaction ioctls
  btrfs: Remove code referencing unused TRANS_USERSPACE
  btrfs: Remove transaction handle from btrfs_file_private
  btrfs: Remove btrfs_fs_info::open_ioctl_trans

 fs/btrfs/ctree.h       |  2 --
 fs/btrfs/extent-tree.c |  3 +-
 fs/btrfs/file.c        |  2 --
 fs/btrfs/ioctl.c       | 95 --------------------------------------------------
 fs/btrfs/transaction.c | 36 +++++--------------
 fs/btrfs/transaction.h |  5 +--
 6 files changed, 11 insertions(+), 132 deletions(-)

-- 
2.7.4

