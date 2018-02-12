Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbeBLPgq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:36:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFakGf066953
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:36:46 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2g3d8x06qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:36:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFWIXP009963
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:18 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFWIMA032689
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:32:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] cleanup btrfs_dev_replace_cancel()
Date: Mon, 12 Feb 2018 23:33:28 +0800
Message-Id: <20180212153331.18440-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain (3):
  btrfs: open code btrfs_dev_replace_cancel()
  btrfs: rename __btrfs_dev_replace_cancel()
  btrfs: change the return arg type for btrfs_dev_replace_cancel()

 fs/btrfs/dev-replace.c | 12 ++----------
 fs/btrfs/dev-replace.h |  3 +--
 fs/btrfs/ioctl.c       |  3 ++-
 3 files changed, 5 insertions(+), 13 deletions(-)

-- 
2.7.0

