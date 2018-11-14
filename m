Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B71C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8195D2243E
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vA3tj6ON"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8195D2243E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732956AbeKNXUV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:20:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45174 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732902AbeKNXUV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:20:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAED8rPa108814
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=b4H5AS9ED8maePG9Gi1u1IevFNxpgQWIzfi3wNDmd1g=;
 b=vA3tj6ONL7KYb+H2LoL/UsSeIQNETznKFLdtTZkLFvsO222YUvsu72gjXec0nO8IIU9m
 hAAIXidEqMW119wWfP3Ngo0dk2OtAp9u5IQvHNf+YSaSjx/qwVNwN9SAeZxDHPo7aJ9e
 W+jf49PG99JipEQJWeQX1sIQ5kAiSW+5yHqxD3qGQ3pJfc8wzXfuRJ0JoEsBdSGVSVG2
 K8R1/LVUPeUbRalTdq4UrZW4+lUzQ/QH9dGqOCSk8BuYn2i2fWKppc7wOYXrZzlGdPnX
 aQO8gSqDZkxEpsLJSzwgv/bsw/0KhjufVHgb31U42T33kWF5XEuIQrvmzIRsJDwpETBW 6w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2nr7cs3b40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:07 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDH7am025238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:07 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAEDH7UA018562
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:07 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 05:17:06 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 0/3] btrfs: balance: improve kernel logs
Date:   Wed, 14 Nov 2018 21:17:09 +0800
Message-Id: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=613
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140120
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v4->v5:
 Mainly address David review comment [1].
 [1]
  https://patchwork.kernel.org/patch/10425987/
 pls ref to individual patch 2/3 for details.

v3->v4:
 Pls ref to individual patches.

Based on misc-next.

v2->v3:
  Inspried by describe_relocation(), improves it, makes it a helper
  function and use it to log the balance operations.

Kernel logs are very important for the forensic investigations of the
issues, these patchs make balance logs easy to review.

Anand Jain (3):
  btrfs: add helper function describe_block_group()
  btrfs: balance: add args info during start and resume
  btrfs: balance: add kernel log for end or paused

 fs/btrfs/relocation.c |  30 +------
 fs/btrfs/volumes.c    | 222 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h    |   1 +
 3 files changed, 223 insertions(+), 30 deletions(-)

-- 
1.8.3.1
