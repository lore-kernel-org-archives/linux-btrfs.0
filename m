Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29364 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbbJIRtP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Oct 2015 13:49:15 -0400
Message-ID: <5617FDF8.3050909@oracle.com>
Date: Sat, 10 Oct 2015 01:48:40 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs device related fixes to support new features and
 bug fixes
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi David,

  Please consider the following fixes for your integration. These patches
  provide bug fixes, framework changes to support new features, and 3
  new features. They are mainly related to the device management like
  delete device by devid, introduce sysfs for device and pool, and fix
  the fs logging for multiple devices. All these patches has been sent
  to the mailing list as individual patches before.

      https://github.com/asj/btrfs-devel.git for-dave4

  (please note, the change log and subject line for some of the patches
  may contain minor updates).

  Anand Jain (16):
   btrfs: Pass the error code to the btrfs_std_error and log ret
   btrfs: Create a helper function to read the disk super
   btrfs: Maintain consistency in logging to help debugging
   btrfs: Device path change must be logged
   btrfs: Add missing brelse when superblock checksum fails
   btrfs: sysfs: Support seed devices in the sysfs layout
   btrfs: Create a framework to create pool attributes
   btrfs: Create helper function __check_raid_min_devices()
   btrfs: Clean up and optimize __check_raid_min_device()
   btrfs: Create helper btrfs_find_device_by_user_input()
   btrfs: Make use of btrfs_find_device_by_user_input()
   btrfs: Enhance btrfs_find_device_by_user_input() to check device path
   btrfs: Make use of btrfs_scratch_superblocks() in btrfs_rm_device()
   btrfs: Introduce device delete by devid
   btrfs: Introduce device pool sysfs attributes
   btrfs: Fix fs logging for multi device

  fs/btrfs/dev-replace.c     |  41 +--
  fs/btrfs/disk-io.c         |  23 +-
  fs/btrfs/ioctl.c           |  65 ++++-
  fs/btrfs/super.c           |   4 +-
  fs/btrfs/sysfs.c           | 624 
++++++++++++++++++++++++++++++++++++++++++++-
  fs/btrfs/sysfs.h           |  21 +-
  fs/btrfs/volumes.c         | 385 ++++++++++++++--------------
  fs/btrfs/volumes.h         |  16 +-
  include/uapi/linux/btrfs.h |  14 +-
  9 files changed, 937 insertions(+), 256 deletions(-)
