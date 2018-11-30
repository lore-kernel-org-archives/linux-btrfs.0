Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56131C04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 05:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A60D20863
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 05:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fbcteoHX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A60D20863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbeK3QXz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 11:23:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeK3QXz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 11:23:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAU5E7bB120926
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=bXNzU5A/N8n2spAY0/jT7fJCosRQpeJO7sA5fprdH8c=;
 b=fbcteoHX4Tf9OkZa5x40m8aptP4IU3kYwMyemk4xohQ5wAeOUWSMmPkM8QN+XdyJB+bx
 K1LwSlSiveeEPcW3Ab7M8EIAXI332/p5WRBvSpfz4ucFvJ0GyQw9rb4JFIR92TGbX4Qe
 YpfPEbjm5C1VQHJM1qcz4VP+4s7eichzbCFIECofAyEr9LJaADGhG7Mju+3HNjCl67LF
 xxom8ytSS9vbuB08g4lJNcrxQ5C8OrFu+yDXVQsE9WBs1wD7Xc/Qe65A2LSl+wWkmecR
 KCiZKmC1I7Zcnl2pAZ5u8erpuHMR5sRiBS5syTo/xVGus6QtUaRnrjTHJQ747t3MVm7u nw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nxxkquykr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:49 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAU5FnZI000626
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:49 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAU5FmFK029594
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 05:15:49 GMT
Received: from tpasj.localdomain (/202.156.140.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 21:15:48 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] btrfs: scrub: fix scrub_lock
Date:   Fri, 30 Nov 2018 13:15:22 +0800
Message-Id: <1543554924-17397-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9092 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=369
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811300043
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v3: Drops the patch [1]from this set.
    [1]
    btrfs: scrub: maintain the unlock order in scrub thread

Fixes the circular locking dependency warning as in patch 1/2,
and patch 2/2 adds lockdep_assert_held() to scrub_workers_get().

Anand Jain (2):
  btrfs: scrub: fix circular locking dependency warning
  btrfs: add lockdep check for scrub_lock in scrub_workers_get

 fs/btrfs/scrub.c   | 22 +++++++++++-----------
 3 files changed, 13 insertions(+), 13 deletions(-)

-- 
1.8.3.1

