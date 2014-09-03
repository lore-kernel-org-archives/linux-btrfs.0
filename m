Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60451 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932823AbaICNeu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:50 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYkUt006731
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH RFC 0/5] Scan all devices to build fs device list
Date: Wed, 3 Sep 2014 21:36:28 +0800
Message-ID: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset implements device list automatic building function. As we
know, currently we need scan the devices to build device list by a user tool
before mounting the filesystem, especially mount the filesystem after
we re-install btrfs module. It is not convenient. This patchset can improve
that problem. With this patchset, we will scan all the devices in the
system to build the device list if we find the number of the devices
is not right when we mount the filesystem. By this way, we needn't scan
the device by the user tool and reduce the mount failure probability due
to the incomplete device list.

---
Miao Xie (5):
  block: export disk_class and disk_type for btrfs
  Btrfs: don't return btrfs_fs_devices if the caller doesn't want it
  Btrfs: restructure btrfs_scan_one_device
  Btrfs: restructure btrfs_get_bdev_and_sb and pick up some code used
    later
  Btrfs: scan all the devices and build the fs device list by btrfs's
    self

 block/genhd.c         |   7 +-
 fs/btrfs/super.c      |   3 +
 fs/btrfs/volumes.c    | 227 ++++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/volumes.h    |   5 +-
 include/linux/genhd.h |   1 +
 5 files changed, 177 insertions(+), 66 deletions(-)

-- 
1.9.3

