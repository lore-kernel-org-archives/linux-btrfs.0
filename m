Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465Ab3CNDFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 23:05:25 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2E35OXt015648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 03:05:24 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2E35NpB007258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 03:05:23 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2E35NFe002518
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 22:05:23 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3 v4] flags to access backup SB
Date: Thu, 14 Mar 2013 11:05:54 +0800
Message-Id: <1363230357-7438-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
References: <1362756300-30212-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need a mechanism to tell when to use the backup super_block.
To do this it needs a frame-work, and the patch #1 and #2 below
provides the same without change in the logic. The last patch
uses the framework to fix the bug(s).

v3->v4:
	Fixed some warnings introduced by patch #3 below,
	sorry my mistake.

v2->v3:
        Accepts David and Eric review, which would result in disabled
          access to backup-superblock by default.
        Dropped the patch
                [PATCH 3/3] btrfs-progs: use BTRFS_SCAN_BACKUP_SB flag in btrfs_scan_one_device
        Introduced a new patch
                [PATCH 3/3] btrfs-progs: disable using backup superblock by default

v1->v2:
        Accepts Eric and Zach review.
        Separates fix into 3 patches for easy logical understanding

Anand Jain (3):
  btrfs-progs: Introduce flag BTRFS_SCAN_REGISTER to replace run_ioctl
  btrfs-progs: Introduce flag BTRFS_SCAN_BACKUP_SB for
    btrfs_read_dev_super
  btrfs-progs: disable using backup superblock by default

 btrfsctl.c    |  2 +-
 cmds-device.c |  4 ++--
 disk-io.c     | 13 +++++++++----
 disk-io.h     |  3 ++-
 find-root.c   |  6 ++++--
 utils.c       | 17 +++++++++--------
 utils.h       |  8 +++++---
 volumes.c     |  4 +++-
 8 files changed, 35 insertions(+), 22 deletions(-)

-- 
1.8.1.227.g44fe835

