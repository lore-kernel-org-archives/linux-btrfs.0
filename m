Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932138AbeAJBs4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 20:48:56 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A1ks44092058
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:48:55 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2fd8su82ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:48:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0A1ms8j016092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:48:54 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0A1mse0021942
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 01:48:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 0/4] device_list_add() peparation to add reappearing missing device
Date: Wed, 10 Jan 2018 09:49:46 +0800
Message-Id: <20180110014950.9138-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

 fs/btrfs/volumes.c | 61 +++++++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

-- 
2.7.0
