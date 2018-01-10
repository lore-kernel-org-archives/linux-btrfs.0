Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42964 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbeAJFQP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 00:16:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A5CDhA000812
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:16:15 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2fd8jn0fx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:16:14 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5GETX004917
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:16:14 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5GDrW020115
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:16:13 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/4] device_list_add() peparation to add reappearing missing device
Date: Wed, 10 Jan 2018 13:16:20 +0800
Message-Id: <20180110051624.3813-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Apply on top of my patchset
   [PATCH v4 0/6] preparatory work to add device forget
 for conflict free apply. They don't actually depend on
 each other though).

v2->v3:
 Fix device_list_add() fn description which was still referring to the
 previous return values.

v1->v2:
 Drop patch 5/5 for uuid_mutex optimize. That was wrong. Thanks Josef.
 In patch 3/5 make btrfs_device * as return.

Cleanup of device_list_add(), mainly in preparation to handle
reappearing missing device which its next reroll will be sent
separately.

Anand Jain (4):
  btrfs: move pr_info into device_list_add
  btrfs: set the total_devices in device_list_add()
  btrfs: get device pointer from device_list_add()
  btrfs: drop devid as device_list_add() arg

 fs/btrfs/volumes.c | 63 +++++++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 36 deletions(-)

-- 
2.7.0

>From 84319f498ffcdca9bbb63fec680872d15392bf98 Mon Sep 17 00:00:00 2001
From: Anand Jain <anand.jain@oracle.com>
Date: Wed, 10 Jan 2018 09:40:38 +0800

Anand Jain (4):
  btrfs: move pr_info into device_list_add
  btrfs: set the total_devices in device_list_add()
  btrfs: get device pointer from device_list_add()
  btrfs: drop devid as device_list_add() arg

 fs/btrfs/volumes.c | 61 +++++++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

-- 
2.7.0
