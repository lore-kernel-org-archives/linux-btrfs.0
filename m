Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46647 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754144AbeFTRyS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 13:54:18 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: anand.jain@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 0/7] Fix locking when scanning devices
Date: Wed, 20 Jun 2018 19:51:25 +0200
Message-Id: <cover.1529516226.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes the bugs recently reported by syzbot. I've tried to
use patches from Anand [1] to fix that but in the end there were fixes
not suitable for merging to 4.18 and my final fix took a different
approach.

In short, fs_devices::opened is protected by uuid_mutex and this mutex
can be used to exclude mount and scanning to interfere.

The fstests pass and 2 syzbot reproducers reported no problems. I'd like
to push the patchset to 4.18 but not rc2 as it's too close. I'll add the
patchset to for-next soon if there are no major problems found, but
otherwise I'm open to comments.

[1]
https://patchwork.kernel.org/patch/10446779/
https://patchwork.kernel.org/patch/10437707/ 1-6

David Sterba (7):
  btrfs: restore uuid_mutex in btrfs_open_devices
  btrfs: extend critical section when scanning a new device
  btrfs: lift uuid_mutex to callers of btrfs_scan_one_device
  btrfs: lift uuid_mutex to callers of btrfs_open_devices
  btrfs: lift uuid_mutex to callers of btrfs_parse_early_options
  btrfs: reorder initialization before the mount locks uuid_mutex
  btrfs: fix mount and ioctl device scan ioctl race

 fs/btrfs/super.c   | 38 +++++++++++++++++++++++++-------------
 fs/btrfs/volumes.c | 11 ++++++-----
 2 files changed, 31 insertions(+), 18 deletions(-)

-- 
2.17.0

