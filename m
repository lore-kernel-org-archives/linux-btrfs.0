Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43852 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdK2EpT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 23:45:19 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT4jEbI027427
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAT4jECu023857
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:14 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAT4jEOG023134
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 04:45:14 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
Subject: [PATCH 0/4] define BTRFS_DEV_STATE
Date: Wed, 29 Nov 2017 12:45:32 +0800
Message-Id: <20171129044536.16260-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now device properties and states are being represented as int
variable. Patches in the ML such as device failed state needs this
cleanup as well.

Anand Jain (4):
  btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
  btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
  btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
  btrfs: cleanup device states define BTRFS_DEV_STATE_CAN_DISCARD

 fs/btrfs/dev-replace.c |   3 +-
 fs/btrfs/disk-io.c     |  23 ++++++---
 fs/btrfs/extent-tree.c |   5 +-
 fs/btrfs/extent_io.c   |   3 +-
 fs/btrfs/ioctl.c       |   2 +-
 fs/btrfs/scrub.c       |  13 +++--
 fs/btrfs/super.c       |   7 +--
 fs/btrfs/volumes.c     | 129 ++++++++++++++++++++++++++++---------------------
 fs/btrfs/volumes.h     |  10 ++--
 9 files changed, 118 insertions(+), 77 deletions(-)

-- 
2.15.0

