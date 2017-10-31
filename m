Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52813 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbdJaRqW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0532FAD88
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:21 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/11] Device fixes and cleanups
Date: Tue, 31 Oct 2017 18:44:31 +0100
Message-Id: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanups for device locking and documentation of the various mutexes.
Patch 1 is a bugfix that could be considered for 4.15 as we could leak bios
under some rare condition, but so far this hasn't been reported so I don't rate
is as critical.

David Sterba (11):
  btrfs: add missing device::flush_bio puts
  btrfs: rename device free rcu helper to free_device_rcu
  btrfs: introduce free_device helper
  btrfs: use free_device where opencoded
  btrfs: simplify exit paths in btrfs_init_new_device
  btrfs: document device locking
  btrfs: dev_alloc_list is not protected by RCU, use normal list_del
  btrfs: simplify btrfs_close_bdev
  btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info
  btrfs: switch to RCU for device traversal in btrfs_ioctl_fs_info
  btrfs: use non-RCU list traversal in write_all_supers callees

 fs/btrfs/disk-io.c |   9 ++--
 fs/btrfs/ioctl.c   |  15 +++---
 fs/btrfs/volumes.c | 134 ++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 114 insertions(+), 44 deletions(-)

-- 
2.14.0

