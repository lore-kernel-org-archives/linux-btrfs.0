Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37455C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D5B20652
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:32:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WKS432EP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfAQPcn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:32:43 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57402 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfAQPcn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:32:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0HFSsHn191636
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=+ppk5rgI++tSAL00s3h126yIaXv5GKNmp22f+e4T+kg=;
 b=WKS432EPB6R0frqzzpZrz4PfiH3N3H6x+5NNOWdxmYZpHfuY9y3VqtpNK6iM/dJVf6iY
 sQOMiiPVvDTVtzbndmAhdhH3SKHKOWypib7iXKmUp1/32cYZUVfWM5MBoiy3WkNlPwTo
 S3PlYq8UBCtXpx6IbfAJYmDNcoDxNLpXTZ8byBJwcw9bqYG0J+OgV+XErvMvipXyXNG4
 QDMtgFAFCQzRqw0aHf4L9CzRiBXAQPvsrgDCFzuoP1pwhqQVsEEAXMalTNnY+LcpYnU+
 uMPjY32LJ3b5vMfplpApX8mqMIYFKf4g/462d2MOLPmUrPpZahVZPPKF+qTublwYS9YT GA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pybjp0jy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0HFWgKK009384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:42 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0HFWgEi021180
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 15:32:42 GMT
Received: from tpasj.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Jan 2019 07:32:41 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs: find_device cleanups
Date:   Thu, 17 Jan 2019 23:32:27 +0800
Message-Id: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9138 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=450
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901170111
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

find_device and its helper functions are as below

 btrfs_find_device_by_devspec()
 btrfs_find_device_missing_or_by_path()
 btrfs_find_device_by_path()
 btrfs_find_device()
 find_device()

Its quite confusing and too fragmented.

In this patch-set..
 1/6 and 2/6 -- btrfs_find_device_missing_or_by_path() is collapsed into
 btrfs_find_device_by_devspec() and cleanup the surviving function.

 3/6 -- rename btrfs_find_device_by_path() to find_device_by_superblock().

 4/6 and 5/6 -- collapses find_device() into btrfs_find_device().

 6/6 refactors btrfs_find_device() to return standard error code.

Resulting in..

btrfs_find_device():
 Mainly used to get struct btrfs_device internally for a given devid
 and or uuid and also helper function for btrfs_find_device_by_devspec().

btrfs_find_device_by_devspec() and a helper function find_device_by_superblock():
 Is mainly to retrieve the struct btrfs_device of a userland given device_path.

Anand Jain (6):
  btrfs: merge btrfs_find_device_missing_or_by_path() into parent
  btrfs: cleanup btrfs_find_device_by_devspec()
  btrfs: rename btrfs_find_device_by_path()
  btrfs: refactor btrfs_find_device() take fs_devices as argument
  btrfs: merge btrfs_find_device() and find_device()
  btrfs: refactor btrfs_find_device() return error code

 fs/btrfs/dev-replace.c |  12 ++--
 fs/btrfs/ioctl.c       |   9 +--
 fs/btrfs/scrub.c       |  16 +++--
 fs/btrfs/volumes.c     | 160 +++++++++++++++++++++----------------------------
 fs/btrfs/volumes.h     |   5 +-
 5 files changed, 93 insertions(+), 109 deletions(-)

-- 
1.8.3.1

