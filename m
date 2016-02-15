Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbcBOReB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 12:34:01 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com, anand.jain@oracle.com
Subject: [PATCH 00/15] Device delete by id
Date: Mon, 15 Feb 2016 18:33:56 +0100
Message-Id: <cover.1455556900.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this patchset extends the ioctl arugments to take an id so we can delete a
device by it. It reuses the existing structure btrfs_ioctl_vol_args_v2 and
extends it in na backward-compatible way so that we don't need to introduce
another one.

The core patchset is from Anand, I did some cleanups as I went through the
series again and made some cleanups and minor naming tweaks to the interface.

I'll add the branch to for-next and if everything goes fine I'll send a pull
request for 4.6 in a week.

Anand Jain (9):
  btrfs: create a helper function to read the disk super
  btrfs: create helper function __check_raid_min_devices()
  btrfs: clean up and optimize __check_raid_min_device()
  btrfs: create helper btrfs_find_device_by_user_input()
  btrfs: make use of btrfs_find_device_by_user_input()
  btrfs: enhance btrfs_find_device_by_user_input() to check device path
  btrfs: make use of btrfs_scratch_superblocks() in btrfs_rm_device()
  btrfs: introduce device delete by devid
  btrfs: optimize check for stale device

David Sterba (6):
  btrfs: rename __check_raid_min_devices
  btrfs: pass number of devices to btrfs_check_raid_min_devices
  btrfs: indtroduce raid-type to error-code table, for minimum device
    constraint
  btrfs: use existing device constraints table btrfs_raid_array
  btrfs: rename btrfs_find_device_by_user_input
  btrfs: rename flags for vol args v2

 fs/btrfs/dev-replace.c     |  28 +---
 fs/btrfs/ioctl.c           |  58 +++++++-
 fs/btrfs/volumes.c         | 322 ++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.h         |   7 +-
 include/uapi/linux/btrfs.h |  15 ++-
 5 files changed, 233 insertions(+), 197 deletions(-)

-- 
2.7.1

