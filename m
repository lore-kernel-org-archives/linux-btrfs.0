Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49761 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaHRIQd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 04:16:33 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl.fnst@cn.fujitsu.com, lists@colorremedies.com
Subject: [PATCH] make 'btrfs filesystem show' to work when seeding
Date: Sat, 16 Aug 2014 11:08:06 +0800
Message-Id: <1408158488-4316-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

yeah. btrfs filesystem show didn't work any time before as in
the test case below.

mkfs.btrfs /dev/sdb -f
btrfstune -S 1 /dev/sdb
mount /dev/sdb /btrfs
btrfs dev add /dev/sdc /btrfs
btrfs fi show <-- fails.

kindly ref to the commit log for bug and its fix details.

Anand Jain (1):
  btrfs-progs: do a separate probe for _transient_ replacing device    
    As mentioned in the kernel patch       btrfs: ioctl
    BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO miss-matched with slots

 utils.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Anand Jain (1):
  btrfs: ioctl BTRFS_IOC_FS_INFO and BTRFS_IOC_DEV_INFO miss-matched
    with slots

 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.0.0.153.g79dcccc

