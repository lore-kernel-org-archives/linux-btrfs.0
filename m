Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37834 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbbHNKdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:24 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 00/23] btrfs device related patch set
Date: Fri, 14 Aug 2015 18:32:45 +0800
Message-Id: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch set includes patches which has been sent before
independently, however here they are consolidated on the
current integration 4.3.

Most of them are cleanup and preparatory work for the RFE
which are published before, viz.. addition of sys volume attributes
and introduce a method to offline device.

And except for the patch
 Btrfs: device delete by devid
provides a way to delete device using devid (assume that devid
has failed) thus fixes the issue reported by the user in the
community.

and the patch
 Btrfs: allow -o rw,degraded for single group profile
fixes an important btrfs volume availability issue


Anand Jain (22):
  Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
  Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
  Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
  Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
  Btrfs: rename super_kobj to fsid_kobj
  Btrfs: SB read failure should return EIO for __bread failure
  Btrfs: __btrfs_std_error() logic should be consistent w/out
    CONFIG_PRINTK defined
  Btrfs: device delete by devid
  Btrfs: move check for min number of devices to a function
  Btrfs: rename btrfs_dev_replace_find_srcdev()
  Btrfs: use BTRFS_ERROR_DEV_MISSING_NOT_FOUND when missing device is
    not found
  Btrfs: use btrfs_find_device_by_user_input()
  Btrfs: add btrfs_read_dev_one_super() to read one specific SB
  Btrfs: fix btrfs_scratch_superblock() with fixes from device delete
  Btrfs: use btrfs_scratch_superblock() in btrfs_rm_device()
  Btrfs: device path change must be logged
  Btrfs: kernel operation should come after user input has been verified
  Btrfs: check device_path in btrfs_find_device_by_user_input()
  Btrfs: avoid user cli usage error logging into the sys log
  Btrfs: move device close to btrfs_close_one_device
  Btrfs: fix fs logging for multi device
  Btrfs: allow -o rw,degraded for single group profile

Liu Bo (1):
  Btrfs: move kobj stuff out of dev_replace lock range

 fs/btrfs/ctree.h           |   4 +-
 fs/btrfs/dev-replace.c     |  64 +++------
 fs/btrfs/disk-io.c         |  65 ++++++---
 fs/btrfs/disk-io.h         |   2 +
 fs/btrfs/ioctl.c           |  50 ++++++-
 fs/btrfs/super.c           |  34 ++---
 fs/btrfs/sysfs.c           |  52 +++----
 fs/btrfs/sysfs.h           |   4 +-
 fs/btrfs/volumes.c         | 345 +++++++++++++++++++++------------------------
 fs/btrfs/volumes.h         |  10 +-
 include/uapi/linux/btrfs.h |   8 ++
 11 files changed, 331 insertions(+), 307 deletions(-)

-- 
2.4.1

