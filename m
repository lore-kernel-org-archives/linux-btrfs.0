Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753263AbdLDEyd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Dec 2017 23:54:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB44qKdG027729
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:32 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2ekpeuj0c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 04:54:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB44sVRl026625
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:31 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB44sVox011903
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:31 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] define BTRFS_DEV_STATE
Date: Mon,  4 Dec 2017 12:54:51 +0800
Message-Id: <20171204045456.8602-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now device properties and states are being represented as int
variable. So clean that up using bitwise operations. Also patches in
the ML such as device failed state needs this cleanup as well.

V2:
 Accepts all comments from Nikolay.
 Drops can_discard.
 Adds BTRFS_DEV_STATE_REPLACE_TGT and BTRFS_DEV_STATE_FLUSH_SENT
    patches.

Anand Jain (5):
  btrfs: cleanup device states define BTRFS_DEV_STATE_WRITEABLE
  btrfs: cleanup device states define BTRFS_DEV_STATE_IN_FS_METADATA
  btrfs: cleanup device states define BTRFS_DEV_STATE_MISSING
  btrfs: cleanup device states define BTRFS_DEV_STATE_REPLACE_TGT
  btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT

 fs/btrfs/dev-replace.c |   8 ++-
 fs/btrfs/disk-io.c     |  29 ++++++---
 fs/btrfs/extent-tree.c |   5 +-
 fs/btrfs/extent_io.c   |   3 +-
 fs/btrfs/ioctl.c       |   4 +-
 fs/btrfs/scrub.c       |  13 +++--
 fs/btrfs/super.c       |   8 ++-
 fs/btrfs/volumes.c     | 156 ++++++++++++++++++++++++++++---------------------
 fs/btrfs/volumes.h     |  11 ++--
 9 files changed, 143 insertions(+), 94 deletions(-)

-- 
2.15.0

