Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35591 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbbGHHmc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 03:42:32 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 0/6] sysfs-part2 Add seed device representation on the sysfs
Date: Wed,  8 Jul 2015 15:32:48 +0800
Message-Id: <1436340774-10909-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the support to show seed device on the btrfs sysfs.
This is a revamped version of the previously single patch 6/6, and plus
incorporates David suggestion to add seed fsid under the 'seed' kobject.

Since this adds new patches and to bring in seed kobject it needed
quite a lot of revamp I am resetting the patch set version to 1.

Anand Jain (6):
  Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
  Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
  Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
  Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
  Btrfs: rename super_kobj to fsid_kobj
  Btrfs: sysfs: support seed devices in the sysfs layout

 fs/btrfs/ctree.h       |   4 +-
 fs/btrfs/dev-replace.c |   7 +-
 fs/btrfs/disk-io.c     |  12 ++--
 fs/btrfs/sysfs.c       | 190 +++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/sysfs.h       |  16 +++--
 fs/btrfs/volumes.c     |  26 +++----
 fs/btrfs/volumes.h     |   3 +-
 7 files changed, 188 insertions(+), 70 deletions(-)

-- 
2.4.1

