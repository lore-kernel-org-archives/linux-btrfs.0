Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58818 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbeAaCdX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 21:33:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0V2WDlo004035
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:33:23 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fu11frtg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:33:23 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0V2SM5P015361
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:22 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0V2SMZY030332
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jan 2018 02:28:22 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] fix device orders consistency
Date: Wed, 31 Jan 2018 10:28:54 +0800
Message-Id: <20180131022856.16791-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v3->v2:
 rename device_sort() to device_cmp().
v1->v2:
 No code change. Change log updated to include the type
 of problem that this consistency would help. And
 I don't see patch 2/2 in the ML. So trying to resend.

By maintaining the device order (some) consistency it makes reproducing
the missing chunk related problems more consistent. (More fixes of this
sort is coming up).

Anand Jain (2):
  btrfs: fix device order consistency
  btrfs: fix alloc device order consistency

 fs/btrfs/volumes.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

-- 
2.7.0
