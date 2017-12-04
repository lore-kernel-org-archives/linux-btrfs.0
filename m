Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58660 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751156AbdLDXnY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 18:43:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB4NgMlb021426
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:24 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2enc4r8qt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 23:43:23 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB4NhNu5025704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB4NhMGu031376
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 23:43:22 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] Btrfs: loop retry on raid6 read failures
Date: Mon,  4 Dec 2017 15:40:34 -0700
Message-Id: <20171204224037.7556-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1 is a simple cleanup.
Patch 2 fixes a bug in raid56 rbio merging code.
Patch 3 fixes a bug in raid6 reconstruction process which can end up
read failure when it can rebuild up good data.

Liu Bo (3):
  Btrfs: remove redundant check in rbio_can_merge
  Btrfs: do not merge rbios if their fail stripe index are not identical
  Btrfs: make raid6 rebuild retry more

 fs/btrfs/raid56.c  | 33 +++++++++++++++++++++++++--------
 fs/btrfs/volumes.c |  9 ++++++++-
 2 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.9.4

