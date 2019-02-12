Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858D7C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5373C21B18
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 02:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YTt4rY8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfBLCTE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 21:19:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51050 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727265AbfBLCTE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 21:19:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1C2Iwn9033360
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=Fyd1nNg+0KubUMm7ktHAxhjJ2aaZbpi3qxZKSu7WNy0=;
 b=YTt4rY8uAo9pLBHvrm1Ta7MQI0DdYyFhsiSwWd5eb0j648u8ZuIw1l8FqCVYirOsfIt7
 1LUgVugfHsIXL6ImuvHwfT11nb+HgJWqnYJJIpoqZuO5uJRTUVhO2cbZ6pTphZDi7cq7
 2kklgoHxzSK+NB3oruFgmUgrr9uctMD/iUT+HqJf5xQuv+SBGUwYHbxLEaHRVN6YGHgQ
 lrAafLsLTmD/R+nlOiD2pvb9XyZN90vkQoetzXnHMLZaN2knlyrl5QUM4WrspGGuEdpe
 L3U/EDXAjKoDq3JjGJEOsxKz9K+b2jfqb0lugJO6xX0fYWlAdakbsC85qXn3OlyW8mYo Sw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2qhredsaex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:03 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1C2J1PS008482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:02 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1C2J1Ar012793
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 02:19:01 GMT
Received: from tpasj.localdomain (/183.90.37.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Feb 2019 18:19:01 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] Misc props.c cleanups
Date:   Tue, 12 Feb 2019 10:18:48 +0800
Message-Id: <1549937931-15339-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9164 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=904 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902120015
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v3: Merge patch 2/5 and 3/5 as in v1.
    Not included 1/5 in v1 as its already integrated in misc-next.

While adding the readmirror property found few cleanup things which
can be fixed. As these aren't part of upcoming readmirror property
I am sending these separately.

Anand Jain (3):
  btrfs: kill __btrfs_set_prop()
  btrfs: drop redundant forward declaration in props.c
  btrfs: trivial, fix c coding style

 fs/btrfs/ioctl.c |  10 +--
 fs/btrfs/props.c | 201 +++++++++++++++++++++++++------------------------------
 fs/btrfs/props.h |   6 +-
 fs/btrfs/xattr.c |   2 +-
 4 files changed, 99 insertions(+), 120 deletions(-)

-- 
1.8.3.1

