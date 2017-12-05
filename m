Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45400 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752719AbdLEIwe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 03:52:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB58qM9N109034
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 08:52:33 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2ekpeynyq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 08:52:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB58qWTn016520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 08:52:32 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB58qWnB024491
        for <linux-btrfs@vger.kernel.org>; Tue, 5 Dec 2017 08:52:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/2] Add cli and ioctl to ignore a scanned device
Date: Tue,  5 Dec 2017 16:52:55 +0800
Message-Id: <20171205085258.4038-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1/2 is preparatory patch to get a function to delete a device
  from the list.
Patch 2/2 adds the ioctl and feature to delete a device from the
device list.

Also includes Patch 1/1 for the btrfs-progs support.

v2:
  Accepts review from Nikolay, details are in the specific patch.
  Patch 1/2 is renamed from
    [PATCH 1/2] btrfs: refactor btrfs_free_stale_device() to get device list delete
  to
    [PATCH 1/2] btrfs: add function to device list delete
v3:
  No change. Send to correct ML.
v4:
  No change. But as the ML thread may be confusing, so resend.

Anand Jain (2):
  btrfs: add function to device list delete
  btrfs: introduce feature to ignore a btrfs device

 fs/btrfs/super.c           |  4 +++
 fs/btrfs/volumes.c         | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h         |  2 ++
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 94 insertions(+)

Anand Jain (1):
  btrfs-progs: add 'btrfs device ignore' cli

 cmds-device.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioctl.h       |  2 ++
 2 files changed, 56 insertions(+)

-- 
2.7.0

