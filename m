Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C6CC282D7
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D78321919
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 07:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G5bPu5G1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfBHHCz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 02:02:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfBHHCy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2019 02:02:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x186x9P6159081
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=6iD9MhYt4Wnz8T8DSTyJUae7Wrh5IVSFB+RuC1nH9u0=;
 b=G5bPu5G18uFvBQRsiIiRQIhQLk/HFikvBltDj+boG5WLZWR8xim/brzv1pIdT7KRSoGZ
 zA/0LRjLjkouMKhK0BlQfr38mpRdO4ZNEOxPuCyyAF1QbLMz2pHAkvcHcmRuKQQFSrWA
 s6q4h1d4XY+r4YH+000lsBw9vaaO6P11V+Vg88PBYBr5dOyBgrKd2tvnqwGlbL7i5ZzZ
 KSMHNVYMEKpS46/spyuzwrSzmW/xJkvVPTHMwPts/ne6PrE8x0RmhsS5ED7TL452RbG4
 DbdKEm2jg7GzwKGosHcmAl0AzhOCB79zY4E818Qn6y3X/7BLpSv5N5VysE/MGHZFKN9S dw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2qd9artxww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2019 07:02:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1872l2Z003893
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:47 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1872lJs001387
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2019 07:02:47 GMT
Received: from tpasj.sg.oracle.com (/10.186.49.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Feb 2019 23:02:47 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] Misc props.c cleanups
Date:   Fri,  8 Feb 2019 15:02:30 +0800
Message-Id: <1549609355-11053-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9160 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=843 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902080051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While adding the readmirror property found few cleanup things which
can be fixed. As these aren't part of upcoming readmirror property
I am sending these separately. Except for 1/5 rest fixes are in
props.c. 1/5 is in volume.c.

Anand Jain (5):
  btrfs: fix comment its device list mutex not volume lock
  btrfs: kill __btrfs_set_prop()
  btrfs: reorg functions to drop forward declaration
  btrfs: drop redundant forward declaration in props.c
  btrfs: trivial, fix c coding style

 fs/btrfs/ioctl.c   |  10 +--
 fs/btrfs/props.c   | 201 ++++++++++++++++++++++++-----------------------------
 fs/btrfs/props.h   |   6 +-
 fs/btrfs/volumes.c |   2 +-
 fs/btrfs/xattr.c   |   2 +-
 5 files changed, 100 insertions(+), 121 deletions(-)

-- 
1.8.3.1

