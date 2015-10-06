Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30241 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbbJFPTi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:19:38 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/7] Introduce device delete by devid
Date: Tue,  6 Oct 2015 23:19:17 +0800
Message-Id: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The operation of device replace and device delete follows same steps
upto some depths, however they don't share codes.
This set of enhancement will help device replace and device delete to
share codes.
And at the end add support to delete device using devid.

Anand Jain (7):
  Btrfs: create helper function __check_raid_min_devices()
  Btrfs: clean up and optimize __check_raid_min_device()
  Btrfs: create helper btrfs_find_device_by_user_input()
  Btrfs: make use of btrfs_find_device_by_user_input()
  Btrfs: enhance btrfs_find_device_by_user_input() to check device path
  Btrfs: make use of btrfs_scratch_superblocks() in btrfs_rm_device()
  Btrfs: Introduce device delete by devid

 fs/btrfs/dev-replace.c     |  28 +-----
 fs/btrfs/ioctl.c           |  58 +++++++++++-
 fs/btrfs/volumes.c         | 214 ++++++++++++++++++---------------------------
 fs/btrfs/volumes.h         |   5 +-
 include/uapi/linux/btrfs.h |  14 ++-
 5 files changed, 159 insertions(+), 160 deletions(-)

-- 
2.4.1

