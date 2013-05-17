Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25480 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3EQKvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 06:51:53 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4HAppeW011732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:52 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HApowr009282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:51 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HApobC018580
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:50 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] a structure for the disks scan for btrfs
Date: Fri, 17 May 2013 18:54:38 +0800
Message-Id: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The idea was to introduce /dev/mapper to find for btrfs disk, 
However I found first we need to congregate the disk scan
procedure at a function so it would help to consistently tune
it across the btrfs-progs. As of now both fi show and
dev scan use the disks scan they do it on their own.

So here it would congregate btrfs-disk scans at the function
scan_devs_for_btrfs, adds /dev/mapper to be used to scan
for btrfs, and updates its calling functions and few bug fixes.

Anand Jain (4):
  btrfs-progs: replace filesystem show --all-devices with -d option
  btrfs-progs: label option in btrfs filesystem show is not coded
  btrfs-progs: use /dev/mapper to find the btrfs disks
  btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments

 btrfs-find-root.c |  2 +-
 cmds-device.c     | 50 ++++++++++++++++++++++++++++----------------------
 cmds-filesystem.c | 38 ++++++++++++++++++++++++--------------
 disk-io.c         |  2 +-
 man/btrfs.8.in    | 13 +++++++------
 utils.c           | 45 +++++++++++++++++++++++++++++++++++++--------
 utils.h           |  4 ++--
 7 files changed, 100 insertions(+), 54 deletions(-)

-- 
1.8.1.227.g44fe835

