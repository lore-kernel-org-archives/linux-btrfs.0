Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51044 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3CHPYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2013 10:24:42 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r28FOeKv019461
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:24:41 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r28FOew3008902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 15:24:40 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r28FOeHF012815
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 09:24:40 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3 v2] flags to access backup SB
Date: Fri,  8 Mar 2013 23:24:57 +0800
Message-Id: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The bug as seen in the last patch below,
indicates that we need a mechanisum to tell when to use
the backup super_block. To do this it needs a frame-work,
and the patch #1 and #2 below provides the same without
change in the logic. The last patch uses the framework to
fix the bug.

v1->v2:
	Accepts Eric and Zach review.
        Seprates fix into 3 patches for easy logical understanding

Anand Jain (3):
  btrfs-progs: Introduce flag BTRFS_SCAN_REGISTER to replace run_ioctl
  btrfs-progs: Introduce flag BTRFS_SCAN_BACKUP_SB for
    btrfs_read_dev_super
  btrfs-progs: use BTRFS_SCAN_BACKUP_SB flag in btrfs_scan_one_device

 btrfsctl.c        |  2 +-
 cmds-device.c     |  5 +++--
 cmds-filesystem.c |  2 +-
 cmds-replace.c    |  3 ++-
 disk-io.c         | 16 +++++++++++-----
 disk-io.h         |  3 ++-
 find-root.c       |  9 ++++++---
 utils.c           | 26 +++++++++++++++-----------
 utils.h           |  8 +++++---
 volumes.c         |  6 ++++--
 volumes.h         |  2 +-
 11 files changed, 51 insertions(+), 31 deletions(-)

-- 
1.8.1.191.g414c78c

