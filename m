Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43176 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752362AbeCTJ6h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 05:58:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w2K9w6hx039163
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:58:37 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2gu04tr0hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:58:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w2K9pNnf007889
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:24 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w2K9pNrM004892
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Mar 2018 09:51:23 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Preparatory to add the csum check in the scan context
Date: Tue, 20 Mar 2018 17:53:07 +0800
Message-Id: <20180320095310.6355-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anand Jain (3):
  btrfs: cleanup btrfs_check_super_csum() to check the csum_type to the
    type
  btrfs: return required error from btrfs_check_super_csum
  btrfs: refactor btrfs_check_super_csum() for scan

 fs/btrfs/disk-io.c | 50 ++++++++++++++++++++++++--------------------------
 fs/btrfs/disk-io.h |  1 +
 2 files changed, 25 insertions(+), 26 deletions(-)

-- 
2.15.0

