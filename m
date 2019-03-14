Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C49C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EBE0217F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QBwi7jba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfCNFE5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 01:04:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50034 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfCNFE5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 01:04:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2E5477h103849
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=Vu4COXM4KJ0RFbT8aoF5F5OEa3gMJ+REVdxusZ27t4w=;
 b=QBwi7jbaBGEPotJEcfxLUhO6ty8KLPZWbquypNqdZriuJhUfaYja0i28fC7vcE/PZEof
 Go5eTdiwjXX1WKkQHh8aEBcUUY3HxAqTb57OnsJ2dNECvKpJzUHPAeea9c5YSQQEBiy2
 SUHMS/Va2cD2pNIvFZTEGtg/YkPj5W9jW97rAB62oGiJyQNOKluis/l45EqUlfTvbZRl
 bdzvRbTkB2k6P0KStalbhtEYQIddOqg6GRwOOtc1It7m7IJOoOGDt0glIxjlq20d2Da0
 +BQlJpAwTfBroRFJZcGm69uGVMEPGbqqO8+80Er+bmgp9dBYNpgyiT82B9Qk/bxvBNy4 dA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2r430ey830-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:56 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2E54sAM009417
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:55 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2E54sSc031171
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:54 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Mar 2019 05:04:54 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: fix property bugs
Date:   Thu, 14 Mar 2019 13:05:02 +0800
Message-Id: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9194 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=842 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903140033
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

1/4 Fixes a bug that we were applying an incomplete string zstd.
2/4 Fixes a bug that the compression property gets reset to NULL after a
    failed attempt to change the compression parameter on the object.
3/4 preparatory patch so that btrfs_set_prop_trans() can be merged with
    btrfs_set_prop() in 4/4.
4/4 Fixes a bug that we were incrementing the generation even when the
    property validation check failed.

3/4 and 4/4 are only added here.

Anand Jain (4):
  btrfs: fix zstd compression parameter
  btrfs: fix vanished compression property after failed set
  btrfs: open code btrfs_set_prop in inherit_prop
  btrfs: fix property validate fail should not increment generation

 fs/btrfs/ioctl.c | 10 +++---
 fs/btrfs/props.c | 94 ++++++++++++++++++++++++++++++--------------------------
 fs/btrfs/props.h |  4 +--
 fs/btrfs/xattr.c |  2 +-
 4 files changed, 58 insertions(+), 52 deletions(-)

-- 
1.8.3.1

