Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59956 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753760AbdLGOgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 09:36:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB7EVSDh066272
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:35:59 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2eq4ag8v0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Dec 2017 14:35:59 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB7EZwNs010203
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:35:58 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB7EZwLr008181
        for <linux-btrfs@vger.kernel.org>; Thu, 7 Dec 2017 14:35:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 0/3] Add cli and ioctl to deregister devices
Date: Thu,  7 Dec 2017 22:36:20 +0800
Message-Id: <20171207143623.26710-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add ability to deregister a or all devices. I have named this sub cmd
as deregister, but I am open to your suggestions.

Further I am using /dev/btrfs-control and struct btrfs_ioctl_vol_args
for now, just similar to other ioctls in super.c including btrfs dev
scan, if rather it makes sense to use btrfs_ioctl_vol_args_v2 I shall.
Oepn to suggestions.

Kernel:
Patch 1/3 is preparatory patch, provides helper to delete a device.
Patch 2/3 adds ioctl to delete device from the device list.
Patch 3/3 provides default feature to delete all fs_devices in the list.

btrfs-progs:
Patch 1/2 introduce 'btrfs dev deregister <device>'
Patch 2/2 make the device optional and when not provided, deregisters all
unmounted devices.

v2:
  Accepted review from Nikolay, details are in the specific patch.
  Patch 1/2 is renamed from
    [PATCH 1/2] btrfs: refactor btrfs_free_stale_device() to get device list delete
  to
    [PATCH 1/2] btrfs: add function to device list delete
v3:
  No change. Send to correct ML.
v4:
  No change. But as the ML thread may be confusing, so resend.
v5:
  Mainly adds feature to deregister all unmounted devices.
  Accepts review from David, for details ref change log.

Anand Jain (3):
  btrfs: add function to device list delete
  btrfs: introduce feature to deregister a btrfs device
  btrfs: add feature to deregister all unmounted devices

 fs/btrfs/super.c           |   9 ++++
 fs/btrfs/volumes.c         | 119 +++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |   3 ++
 include/uapi/linux/btrfs.h |   9 +++-
 4 files changed, 138 insertions(+), 2 deletions(-)

Anand Jain (2):
  btrfs-progs: add 'btrfs device unregister' cli
  btrfs-progs: add feature to deregister all devices

 cmds-device.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |  8 +++++-
 2 files changed, 89 insertions(+), 1 deletion(-)

-- 
2.7.0

