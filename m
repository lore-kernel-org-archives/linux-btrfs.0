Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25572 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3DEFxB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 01:53:01 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r355qxg2031694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:53:00 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r355qx2F000144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 05:52:59 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r355qxfo014661
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 00:52:59 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: v6: access to backup superblock
Date: Fri,  5 Apr 2013 13:54:14 +0800
Message-Id: <1365141259-10529-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <5127022B.6070200@oracle.com>
References: <5127022B.6070200@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need a mechanism to tell when to use the backup super_block.
To do this it needs a frame-work, and the patch #1 and #2 below
provides the same without change in the logic.

Its been found and posted to the list that check_mounted
needs access to the backup-sb and find-root as well. so
patch #3 provides frame work so that threads which need
the access to the backup sb can set the flag.
further,
patch#4 disables backup-sb access except for check_mounted
patch#5 provides backup-sb access to find-root

v5->v6:
	Dropped patch 
		btrfs-progs: make btrfs dev scan multi path aware
	sorry its a wrong patch, further this branch does not find
	the problem this patch was trying to address
	Added patch#5 

-----------------
v4->v5:
	Rebase with integration-20130321 and with my own changes (patch #1)
	Allow check_mounted thread-path to use backup-sb

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

Anand Jain (5):
  btrfs-progs: Introduce flag BTRFS_SCAN_REGISTER to replace run_ioctl
  btrfs-progs: Introduce flag BTRFS_SCAN_BACKUP_SB for
    btrfs_read_dev_super
  btrfs-progs: introduce passing flags to btrfs_scan_one_device
  btrfs-progs: disable using backup superblock by default
  btrfs-progs: btrfs-find-root should scan backup-sb

 cmds-device.c  |  4 ++--
 cmds-replace.c |  2 +-
 disk-io.c      | 15 ++++++++++-----
 disk-io.h      |  3 ++-
 find-root.c    |  9 ++++++---
 utils.c        | 29 +++++++++++++++++------------
 utils.h        |  8 +++++---
 volumes.c      |  6 ++++--
 volumes.h      |  2 +-
 9 files changed, 48 insertions(+), 30 deletions(-)

-- 
1.8.1.227.g44fe835

