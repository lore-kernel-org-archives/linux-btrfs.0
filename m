Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45469 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313Ab3FUHyA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:54:00 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7lf7s023528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:47:42 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7rwBU004051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:53:59 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7rwFY004041
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:53:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/13] Introduce show --kernel
Date: Fri, 21 Jun 2013 15:58:00 +0800
Message-Id: <1371801485-14571-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 In an attempt to address the reviewer concern, and to
 find a suitable solution to the btrfs-progs not been
 able to in sync with the kernel changes, found a 
 solution which doesn't introduce new ioctl.
 
 Along with it comes with new set of the dependent
 patches viz 09/13 to 12/13. below.

  btrfs-progs: function to release a specific fsid from the list
  btrfs-progs: move out print in cmd_df to another function
  btrfs-progs: get string for the group profile and type
  btrfs-progs: obtain used_bytes in BTRFS_IOC_FS_INFO ioctl

Anand Jain (13):
  btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
  btrfs-progs: label option in btrfs filesystem show is not coded
  btrfs-progs: update device scan usage
  btrfs-progs: congregate dev scan
  btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
    provided
  btrfs-progs: scan /dev/mapper in filesystem show and device scan
  btrfs-progs: device delete to get errors from the kernel
  btrfs-progs: get_label_mounted to return label instead of print
  btrfs-progs: function to release a specific fsid from the list
  btrfs-progs: move out print in cmd_df to another function
  btrfs-progs: get string for the group profile and type
  btrfs-progs: obtain used_bytes in BTRFS_IOC_FS_INFO ioctl
  btrfs-progs: introduce btrfs filesystem show --kernel

 btrfs-find-root.c |   2 +-
 cmds-device.c     |  29 ++++---
 cmds-filesystem.c | 227 ++++++++++++++++++++++++++++++++++--------------------
 ctree.h           |  11 +++
 disk-io.c         |   2 +-
 ioctl.h           |  46 ++++++++++-
 man/btrfs.8.in    |  16 ++--
 utils.c           |  56 +++++++++++---
 utils.h           |  10 ++-
 volumes.c         |  48 +++++++++++-
 volumes.h         |   5 ++
 11 files changed, 331 insertions(+), 121 deletions(-)

-- 
1.8.1.227.g44fe835

