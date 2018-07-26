Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41052 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbeGZIFa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 04:05:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6Q6mWsJ158802
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:07 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2kbvsp1mvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:07 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6Q6o7JY010701
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:07 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6Q6o6cQ002635
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 06:50:06 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] Misc volume patch set part2
Date: Thu, 26 Jul 2018 14:53:30 +0800
Message-Id: <20180726065334.30594-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In this set:
v1->v2:
1/4 no changes.
2/4 no changes.
3/4 added new. Which shall replace the warn_on with bug_on. As the
redundency is after this check. So I decided to keep bug_on for now.
4/4 added comments that btrfs_num_devices() will get num_devices
excluding the repalce device.

Anand Jain (4):
  btrfs: drop uuid_mutex in btrfs_free_extra_devids()
  btrfs: fix race between free_stale_devices and close_fs_devices
  btrfs: bug_on for num_devices below 0
  btrfs: add helper btrfs_num_devices() to deduce num_devices

 fs/btrfs/volumes.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

-- 
2.7.0

