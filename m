Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751048AbeAVWtj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 17:49:39 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0MMlDOd068367
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:39 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2fnrmu8408-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:38 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0MMnb0c001749
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0MMnb7l025037
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jan 2018 22:49:37 GMT
MIME-Version: 1.0
Message-ID: <20180122224937.3458-1-anand.jain@oracle.com>
Date: Mon, 22 Jan 2018 14:49:35 -0800 (PST)
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] fix device orders consistency
Content-Type: text/plain; charset=ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

 Could you pls consider this for 4.16 ?

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

