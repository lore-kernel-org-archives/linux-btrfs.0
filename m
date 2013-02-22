Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32803 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3BVF3a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 00:29:30 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1M5TRLu013254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 05:29:27 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1M5TQ24005716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 05:29:26 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1M5TQ1C013759
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 23:29:26 -0600
Message-ID: <5127022B.6070200@oracle.com>
Date: Fri, 22 Feb 2013 13:29:15 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [bug]  mkfs.btrfs reports device busy for ext4 mounted disk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


setup:
  mkfs.btrfs /dev/sdb
  mkfs.ext4 /dev/sdb && mount /dev/sdb /ext4
  mkfs.btrfs /dev/sdc /dev/sdd


test case:
  mkfs.btrfs /dev/sdc /dev/sdd


problem:
  mkfs is fine, however reports the following error ..
  ---
   ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
   ERROR: unable to scan the device '/dev/sdb' - Device or resource busy
  ---


findings:
  First, since previously we have had multi-device btrfs,
  so mkfs.btrfs would trigger scan for its partner to check
  if its mounted.

  Next, since previously we had btrfs on sdb and mkfs.ext4
  does not overwrite super-block mirror 1.. so

    btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 
sb_bytenr)

  finds btrfs on sdb. So we try to register sdb with the ioctl
  BTRFS_IOC_SCAN_DEV and fail.


  unless I am missing something. wipefs (along with the below patch)
     [PATCH][v2] Btrfs: wipe all the superblock [redhat bugzilla 889888]
  seems to be only solution as of now.

  Any idea if there can be a better solution to handle stale btrfs
  and can be done with in the btrfs limits.

Thanks, Anand
