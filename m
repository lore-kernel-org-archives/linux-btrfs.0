Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29165 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3E3DhI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:37:08 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4U3b4Wg029292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:05 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b5vq008716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:06 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b5Xj007088
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:05 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6 v2] btrfs-progs: a structure for the disks scan for btrfs
Date: Thu, 30 May 2013 11:40:20 +0800
Message-Id: <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
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

v1->v2:
 Rebased on top of David' integration branch origin/integration-20130524

 patch 1 to 5 (below) are made independent of the idea to have the
 /dev/mapper as one of the path to recognize the btrfs disks.
 Which means they can be installed with out having anything
 new. It just adds the framework/improves to integrated a
 /dev/mapper path, which is only done in the patch 6.
 So patch 1 to 5 are safe.
 Also in v1 I suggested that we have -d option instead of
 long option --all-devices which I have dropped that idea
 here in v2.

 Patch 6: adds a new option --mapper to the filesystem show
 and device scan which inturn will use /dev/mapper to scan
 for the btrfs.

 Example output of using the --mapper option is as below..

btrfs filesystem show --mapper
Label: none  uuid: 0a621111-ad84-4d80-842a-dd9c1c60bf51
	Total devices 2 FS bytes used 1.17MB
	devid    1 size 44.99GB used 2.04GB path /dev/mapper/mpathe
	devid    2 size 48.23GB used 2.03GB path /dev/mapper/mpathd

Label: none  uuid: bad9105f-bdc6-4626-9ba7-80bd97aebe19
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 15.00GB used 2.04GB path /dev/mapper/mpathbp1

Btrfs v0.20-rc1-350-g7731651

btrfs device scan --mapper
-----
[1118885.473298] device fsid bad9105f-bdc6-4626-9ba7-80bd97aebe19 devid 1 transid 4 /dev/mapper/mpathbp1
[1118885.474077] device fsid 0a621111-ad84-4d80-842a-dd9c1c60bf51 devid 2 transid 103 /dev/mapper/mpathd
[1118885.474133] device fsid 0a621111-ad84-4d80-842a-dd9c1c60bf51 devid 1 transid 103 /dev/mapper/mpathe
-----

Anand Jain (6):
  btrfs-progs: btrfs_scan_for_fsid doesn't need all the arguments
  btrfs-progs: label option in btrfs filesystem show is not coded
  btrfs-progs: update device scan usage
  btrfs-progs: congregate dev scan
  btrfs-progs: btrfs_scan_one_dir not to skip links when /dev/mapper is
    provided
  btrfs-progs: scan /dev/mapper in filesystem show and device scan

 btrfs-find-root.c |  2 +-
 cmds-device.c     | 19 ++++++++++---------
 cmds-filesystem.c | 16 ++++++++--------
 disk-io.c         |  2 +-
 man/btrfs.8.in    | 16 +++++++++-------
 utils.c           | 34 +++++++++++++++++++++++++++++-----
 utils.h           |  9 ++++++---
 7 files changed, 64 insertions(+), 34 deletions(-)

-- 
1.8.1.227.g44fe835

