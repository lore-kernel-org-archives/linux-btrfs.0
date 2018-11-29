Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0A1C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3EAE2081B
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:25:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c9qkoCUh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3EAE2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbeK2UaF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 15:30:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbeK2UaF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 15:30:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAT9Octn021090
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=XIBSrcgh2OCFzjtvhJdQQRJp8gMGCtpQlIZSrZ3iHD8=;
 b=c9qkoCUhjpCf1AYiBNk+QaxLAbjBvqrDseB8fwdYOiV2WEbhPNLhpiA2BtkS0rTdJe0G
 /Hl4GTaTR2bH5zHMXFxMT5rO1scfa+AXpVMjoh9zuEK28yaFmjLPoe3xiWeZpVFfcHTV
 ifWojVEOd32gMWtUn2lSrCp25iKPgpfy2ms+EAlTA5lT1oFRXPott8XrN0UPb5Rz02dJ
 chtwEdIBs8tEjnQ/+JlOGZ5wUr4+HygtqaL2vOfxDwF2iY/dXqK56heYnI7KKPmyjaC+
 zShG3xFZtWgwsoPhwT+puaohDzqpOsNyU3twqr4cG9PA8l92vVtUX5Nf/WzYE/jzxqX4 hw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nxx2uf2c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:22 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAT9PL45021218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:21 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAT9PLJt012142
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:21 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 01:25:21 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: scrub: fix scrub_lock
Date:   Thu, 29 Nov 2018 17:25:10 +0800
Message-Id: <1543483513-16724-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9091 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=554
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811290082
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Idea was to fix the circular locking dependency warning as in patch 2/3,
and in the process also fixes the other identified cleanups patches 1/3,3/3
and they aren't dependent on 2ttch /3.

Anand Jain (3):
  btrfs: scrub: maintain the unlock order in scrub thread
  btrfs: scrub: fix circular locking dependency warning
  btrfs: add lockdep check for scrub_lock in scrub_workers_get

 fs/btrfs/scrub.c   | 22 +++++++++++-----------
 3 files changed, 13 insertions(+), 13 deletions(-)

-- 
1.8.3.1

