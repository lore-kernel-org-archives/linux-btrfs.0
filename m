Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37953 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751988AbdKBB4j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 21:56:39 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA21uc4B013766
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vA21ucsn023782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:38 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA21ucQZ016819
        for <linux-btrfs@vger.kernel.org>; Thu, 2 Nov 2017 01:56:38 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] Fix raid6 reconstruction bug
Date: Wed,  1 Nov 2017 18:54:01 -0600
Message-Id: <20171102005405.20420-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an attempt to fix a raid6 bug, that is, if two disks got
hotplugged at run time, reconstruction process is not able to rebuild
correct data to use even if raid6 can theoretically tolerate two disk
failure.

Patch 1 is a preparation patch, which introduces the necessary flags
and flag handling.

More details about the above bug can be found in Patch 2.

Patch 3 applies flags to raid1/10 profile.

Patch 4 fixes btrfs to show flags for each device correctly.

A test case[1] for fstests has been sent out.

[1]: fstests: btrfs: add test case for raid6 reconstruction bug
https://patchwork.kernel.org/patch/10037769/

Liu Bo (4):
  Btrfs: introduce device flags
  Btrfs: fix data corruption in raid6
  Btrfs: make raid1 and raid10 be aware of device flag In_sync
  Btrfs: change how we set In_sync

 fs/btrfs/disk-io.c | 21 ++++++++++++++++-
 fs/btrfs/raid56.c  |  3 ++-
 fs/btrfs/volumes.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/volumes.h |  8 +++++++
 4 files changed, 88 insertions(+), 12 deletions(-)

-- 
2.9.4

