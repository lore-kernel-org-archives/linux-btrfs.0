Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932432AbeAIOuf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:50:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EnLAe169010
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:50:34 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fcsj19s6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:50:34 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09EjXPa014649
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:33 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09EjWvN027647
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:45:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] device_list_add() peparation to add reappearing missing device
Date: Tue,  9 Jan 2018 22:46:20 +0800
Message-Id: <20180109144625.28381-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup of device_list_add(), mainly in preparation to handle
reappearing missing device which its next reroll will be sent
separately.

Anand Jain (5):
  btrfs: move pr_info into device_list_add
  btrfs: set the total_devices in device_list_add()
  btrfs: get device pointer from device_list_add()
  btrfs: drop devid as device_list_add() arg
  btrfs: move uuid_mutex closer to exclusivity

 fs/btrfs/volumes.c | 49 +++++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

-- 
2.7.0

