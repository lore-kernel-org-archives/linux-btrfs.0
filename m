Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46062 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753022AbeDYK7e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 06:59:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3PAuNIt010190
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:59:33 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2hftty67fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:59:33 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3PAxWNl014580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:59:32 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3PAxWXe006940
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Apr 2018 10:59:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] enhance btrfs_raid_array[]
Date: Wed, 25 Apr 2018 19:01:41 +0800
Message-Id: <20180425110144.12871-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup patches as in the individual change log.

These patches were sent independently as they aren't related as such,
but as I am updating the 1/3 the 2/3 would endup with conflict. So
here I am putting all of them together with the conflict fixed at
my end. And as such there is no change in 2/3 and 3/3 from its v1.

Anand Jain (3):
  btrfs: kill btrfs_raid_type_names[]
  btrfs: kill btrfs_raid_group[]
  btrfs: kill btrfs_raid_mindev_error[]

 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent-tree.c | 20 +------------------
 fs/btrfs/volumes.c     | 54 +++++++++++++++++++++++++++-----------------------
 fs/btrfs/volumes.h     |  7 +++++--
 4 files changed, 36 insertions(+), 47 deletions(-)

-- 
2.7.0

