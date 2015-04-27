Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28421 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbbD0HhD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 03:37:03 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, m_btrfs@ml1.co.uk
Subject: [PATCH 0/8 v2] device delete by devid
Date: Mon, 27 Apr 2015 15:34:07 +0800
Message-Id: <1430120055-10381-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1429525756-2727-2-git-send-email-anand.jain@oracle.com>
References: <1429525756-2727-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kernel patch of device delete by devid.
Now also includes possible code optimization.
Some of the codes are common between delete device and
replace device. This patch will use functions to reuse
those codes, mainly the get btrfs_device structure of
the source device, and scratch the source device at the end.

Anand Jain (8):
  Btrfs: device delete by devid
  Btrfs: move check for min number of devices to a function
  Btrfs: rename btrfs_dev_replace_find_srcdev()
  Btrfs: use BTRFS_ERROR_DEV_MISSING_NOT_FOUND when missing device is
    not found
  Btrfs: use btrfs_find_device_by_user_input()
  Btrfs: add btrfs_read_dev_one_super() to read one specific SB
  Btrfs: fix btrfs_scratch_superblock() with fixes from device delete
  Btrfs: use btrfs_scratch_superblock() in btrfs_rm_device()

 fs/btrfs/dev-replace.c     |  24 +----
 fs/btrfs/disk-io.c         |  54 ++++++----
 fs/btrfs/disk-io.h         |   2 +
 fs/btrfs/ioctl.c           |  50 ++++++++-
 fs/btrfs/volumes.c         | 257 ++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h         |   7 +-
 include/uapi/linux/btrfs.h |   8 ++
 7 files changed, 210 insertions(+), 192 deletions(-)

-- 
2.0.0.153.g79dcccc

