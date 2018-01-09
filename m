Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753504AbeAIOM3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:12:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EBnag140222
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:28 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2fcsj19h29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:12:28 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w09ECRcc013141
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:27 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09ECRUi027652
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:27 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND v3 0/6] preparatory work to add device forget
Date: Tue,  9 Jan 2018 22:13:08 +0800
Message-Id: <20180109141314.23795-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2->v3:
 @ 6/6:
 add btrfs_free_stale_device() fn description, suggested by Nikolay
 Fix line with longer than 80 char
 
v1->v2:
 @ 6/6:
 btrfs_device::name is null when we have missing device and
 unmounted. So we still need to check for dev->name.

We can reuse the function btrfs_free_stale_device() to add feature
to forget a scanned device or all stale devices. So this patch set
proposes following changes to it.

Anand Jain (6):
  btrfs: cleanup btrfs_free_stale_device() usage
  btrfs: no need to check for btrfs_fs_devices::seeding
  btrfs: make btrfs_free_stale_device() to delete all stales
  btrfs: make btrfs_free_stale_device() argument optional
  btrfs: make btrfs_free_stale_device() to search given path
  btrfs: cleanup to make btrfs_free_stale_device() readable

 fs/btrfs/volumes.c | 50 +++++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

-- 
2.7.0

