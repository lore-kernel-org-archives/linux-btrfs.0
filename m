Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41910 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbcBMCB5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:01:57 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH resend 00/13] misc patches plus Introduce device delete by devid
Date: Sat, 13 Feb 2016 10:01:27 +0800
Message-Id: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

 These patches are based on top of your for-next.

Patch 1-5 are miscellaneous fixes which were sent before as independent
patch, they aren't related to the patch set 'Introduce device delete by
devid' but they are included here as the patch apply may fail without
them.

Patch 6-12 are related to 'Introduce device delete by devid'

Patch 13 is device related which is good to be integrated. Earlier
it was withdrawn wrongly after seeing some stale device in a test
environment. But later it was found that this patch wasn't the reason
for the stale devices and this fix is good.

Thanks, Anand

Anand Jain (13):
  btrfs: pass the error code to the btrfs_std_error and log ret
  btrfs: create a helper function to read the disk super
  btrfs: maintain consistency in logging to help debugging
  btrfs: device path change must be logged
  Btrfs: fix fs logging for multi device
  btrfs: create helper function __check_raid_min_devices()
  btrfs: clean up and optimize __check_raid_min_device()
  btrfs: create helper btrfs_find_device_by_user_input()
  btrfs: make use of btrfs_find_device_by_user_input()
  btrfs: enhance btrfs_find_device_by_user_input() to check device path
  btrfs: make use of btrfs_scratch_superblocks() in btrfs_rm_device()
  btrfs: introduce device delete by devid
  btrfs: optimize check for stale device

 fs/btrfs/dev-replace.c     |  28 +---
 fs/btrfs/ioctl.c           |  65 +++++++++-
 fs/btrfs/super.c           |   4 +-
 fs/btrfs/volumes.c         | 316 ++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h         |   5 +-
 include/uapi/linux/btrfs.h |  14 +-
 6 files changed, 226 insertions(+), 206 deletions(-)

-- 
2.7.0

