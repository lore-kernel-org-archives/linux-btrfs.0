Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57949 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbeC0Sur (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 14:50:47 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7831AACAD
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Mar 2018 18:50:46 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/6] Btrfs lockdep and locking cleanups
Date: Tue, 27 Mar 2018 20:48:20 +0200
Message-Id: <cover.1522176187.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few cleanups related to lockdep and locking. The btrfs_show_devname is
a functional change, uses the same mechanism as btrfs_ioctl_dev_info or
btrfs_ioctl_fs_info so that's not a new thing.

David Sterba (6):
  btrfs: use lockdep_assert_held for spinlocks
  btrfs: use lockdep_assert_held for mutexes
  btrfs: update barrier in should_cow_block
  btrfs: use RCU in btrfs_show_devname for device list traversal
  btrfs: remove stale comments about fs_mutex
  btrfs: split dev-replace locking helpers for read and write

 fs/btrfs/acl.c         |  8 -----
 fs/btrfs/ctree.c       |  4 +--
 fs/btrfs/delayed-ref.c |  6 ++--
 fs/btrfs/dev-replace.c | 98 +++++++++++++++++++++++++-------------------------
 fs/btrfs/dev-replace.h |  6 ++--
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/qgroup.c      |  2 +-
 fs/btrfs/reada.c       | 10 +++---
 fs/btrfs/scrub.c       | 18 +++++-----
 fs/btrfs/super.c       | 15 +++++---
 fs/btrfs/volumes.c     | 28 +++++++--------
 11 files changed, 98 insertions(+), 99 deletions(-)

-- 
2.16.2

