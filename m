Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45308 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbeEPKBg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 06:01:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G9u8cK157412
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:36 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2hxpvctrvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:35 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4GA1Zn6024130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:35 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4GA1Ykl028898
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: add read mirror policy
Date: Wed, 16 May 2018 18:03:56 +0800
Message-Id: <20180516100359.7752-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not yet ready for the integration. As I need to introduce
-o no_read_mirror_policy instead of -o read_mirror_policy=-<devid>
to reset the policy as in 3/3. But I am sending this early so that
we can use it for btrfs/161 in the ML, and this patch-set is stable
enough for the testing.

Anand Jain (3):
  btrfs: add mount option read_mirror_policy
  btrfs: add read_mirror_policy parameter devid
  btrfs: read_mirror_policy ability to reset

 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/super.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c | 18 +++++++++++++++++-
 fs/btrfs/volumes.h |  7 +++++++
 4 files changed, 70 insertions(+), 1 deletion(-)

-- 
2.7.0

