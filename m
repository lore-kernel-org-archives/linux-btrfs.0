Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23613 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaGYMa2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 08:30:28 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PCURWE010797
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:28 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PCUQi5010970
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:27 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PCUQvs008611
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jul 2014 12:30:26 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH not for integration] btrfs-devlist: dumps btrfs_device and btrfs_fs_devices from kernel
Date: Fri, 25 Jul 2014 20:33:50 +0800
Message-Id: <1406291632-29582-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This would dump the following info:

fs_address dev_address dev_root_addr root_fsid
fsid name uuid (seed_fsid@seed_addr sprout_fsid@sprout_addr) 
	(fs_num_devices fs_open_devices fs_rw_devices fs_missing_devices fs_total_devices) fs_total_rw_bytes fs_num_can_discard
	devid gen total_bytes disk_total_bytes bytes_used type io_align io_width sector_size fmode 
	not_fs_Mounted|not_fs_Seeding|not_fs_Rotating
	not_Writable|not_MD|not_Missing|not_Discard|not_Replace_tgt|not_Run_pending|not_Nobarriers|not_Stat_valid|not_Bdev


Applies on Chris integration branch now

Anand Jain (1):
  btrfs: introduce BTRFS_IOC_GET_DEVS

 fs/btrfs/super.c           |  86 +++++++++++++++++++++++++++
 fs/btrfs/volumes.c         | 145 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |   3 +
 include/uapi/linux/btrfs.h |  53 ++++++++++++++++-
 4 files changed, 286 insertions(+), 1 deletion(-)

Anand Jain (1):
  btrfs-progs: introduce btrfs-devlist

 .gitignore      |   1 +
 Makefile        |   4 +-
 btrfs-devlist.c | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h         |  52 +++++++++++
 4 files changed, 323 insertions(+), 2 deletions(-)
 create mode 100644 btrfs-devlist.c
-- 
2.0.0.153.g79dcccc

