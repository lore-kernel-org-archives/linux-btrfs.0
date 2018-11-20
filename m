Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268C8C04EBC
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2D9B2145D
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WjNceBVG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2D9B2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbeKTSlN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 13:41:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbeKTSlN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 13:41:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAK845CO021700
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=1dPXruGBS9Rr8jv52BsbuHfoIc621kEmwp9g9Ida5Uk=;
 b=WjNceBVGzWkrZPxZYctof8HsRgt1zaiujLdg2KkFbXfaWlC8vVuewggggpTO/3XWGDom
 +u2OiY6fMpBntOVBfCW6pFuB439JGDmQSv5lZmh9tIa9MdqohKRZEcrM9X671ubXHGKj
 +iUpsK1jiNybbU1JxG/treWknYiQxCS7oPLSCtFAfIQmqAJ8XNB9SxvBaMV6284TZQj2
 lCadCBN5BwLFCoE6+uMJSWXr8QQQET8pZ6E5UMHj/SMhQtZfVST0X90jEfpr14uABs9n
 0ofJGaZJ4qHow0C19YDZUv9NrxlYU6Yspu5+0X55TcfXzm9VtdFlF40CBhS+6dPJU28y SA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2ntbmqj9g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:22 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAK8DLiq020511
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:22 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAK8DLIZ026605
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:21 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 00:13:21 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v6 0/3] btrfs: balance: improve kernel logs
Date:   Tue, 20 Nov 2018 16:12:54 +0800
Message-Id: <1542701577-24586-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=542
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v5->v6:
 Mostly the defines non functional changes.
 Use goto instead of return in middle of the define.
 Pls ref individual patches 1/3 and 2/3 for more info.

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
 fs/btrfs/volumes.c    | 216 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h    |   1 +
 3 files changed, 217 insertions(+), 30 deletions(-)

-- 
1.8.3.1
