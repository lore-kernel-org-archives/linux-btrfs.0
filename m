Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49182 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaFCDgb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:36:31 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 0/6 v2] update sysfs per btrfs device operations
Date: Tue,  3 Jun 2014 11:35:58 +0800
Message-Id: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch set fixes the bugs which Jeff patch is fixing,
which is to update sysfs when device is added and removed.

Further, this patch set also address the following.
  - Update sysfs path when device is replaced
  - Update sysfs path when sprout is created

Also mainly this patch makes the code more modular
which will support the enhancement like in the RFC
patch 6/6 below

Thanks.

Anand Jain (6):
  btrfs: rename add_device_membership to btrfs_kobj_add_device
  btrfs: dev delete should remove sysfs entry
  btrfs: dev add should add its sysfs entry
  btrfs: dev replace should replace the sysfs entry
  btrfs: create sprout should rename fsid on the sysfs as well
  btrfs: revamp /sys/fs/btrfs/<fsid>/devices

 fs/btrfs/dev-replace.c     |   5 +++
 fs/btrfs/sysfs.c           | 103 +++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/sysfs.h           |   4 ++
 fs/btrfs/volumes.c         |  18 ++++++++
 fs/btrfs/volumes.h         |   2 +
 include/uapi/linux/btrfs.h |   1 +
 6 files changed, 125 insertions(+), 8 deletions(-)

-- 
1.8.5.3

