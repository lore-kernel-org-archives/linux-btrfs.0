Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D81C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A19DA2186A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 08:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L9QtePnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfDLIDL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 04:03:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49024 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfDLIDL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 04:03:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7rinR076405
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=K48YPLSCb1pR/biJplHeY+l2WFsuUnGifME2FENhEi8=;
 b=L9QtePnDNZEb9y6XHfW+jbWDmTyaDsCMTmpC83Z/97sxTJmpIT0wmBZM81RQ6rowzYU8
 P8dZZSM5tOesB/uOgF+xkvufmNDpY7djcPPVmj2DjQR9CzPmMiEGuHD17RuKy3rSv4+i
 XRHyK9Ty3NyAL6Zy7bo1nZWa4Jpy/iVwQAnEFocjQH2oFM8jeiE2+EGtXAzxdG4larP3
 dLerb0Oh0SdOHeuDXZXp9/lpXWnEU1Imz7TzIzVq25bJyvHJeV90THWNFho89/qaSBem
 Y6r/NIpMbVpywofpycsFeA/pjnLy4nmRsVATZ8mj4DScPFP8+WiLSGaJdgBJC8F0Gtxi rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rpkhtd2aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C830fU054490
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2rph7u5aqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3C838Rf009045
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Apr 2019 08:03:08 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 01:03:07 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] cleanup property and extended attribute set
Date:   Fri, 12 Apr 2019 16:02:53 +0800
Message-Id: <20190412080259.5192-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=822
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120055
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=843 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120054
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In an attempt to stream line the property and extended attribute set here
are the few cleanup patches.

 1/6 to 3/6 are mostly non functional cleanups (except for the conversion
  to non static function in 3/6) and can be merged together.
 4/6 removes the readonly root check in btrfs_setxattr() more details in
  the change log.
 5/6 as now we have btrfs_setxattr() and btrfs_setxattr_trans() for the
  threads with transaction and without transaction respectively, so this
  patch uses them.
 6/6 as 5/6 as diverted the threads with transaction to btrfs_setxattr(),
  now btrfs_setxattr_trans() can drop the trans arg.

Anand Jain (6):
  btrfs: rename btrfs_setxattr to btrfs_setxattr_trans
  btrfs: rename do_setxattr to btrfs_setxattr
  btrfs: declare btrfs_setxattr as a non static function
  btrfs: remove redundant readonly root check in btrfs_setxattr_trans
  btrfs: split thread with trans to use btrfs_setxattr
  btrfs: cleanup btrfs_setxattr_trans drop trans arg

 fs/btrfs/acl.c   |  6 +++++-
 fs/btrfs/props.c | 25 +++++++++++++++++++------
 fs/btrfs/xattr.c | 25 ++++++++++---------------
 fs/btrfs/xattr.h |  7 ++++---
 4 files changed, 38 insertions(+), 25 deletions(-)

-- 
2.17.1

