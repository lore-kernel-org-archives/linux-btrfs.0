Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C13C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DAE120851
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qmgpeHwH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfCAEfC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45116 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfCAEfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214Y6CR006547
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=antftkLjoAQ/v7QpCSluqc5M45OxNx3+I9Gw35s4GyE=;
 b=qmgpeHwH2swbCf1LKvETLUnKbG24Z6MTFusowGV/cmSVL1ft/sWVxvYGgPbNlJPonV5w
 vxmMJJu5qj/RkOj6S8tUJyWeqy2mtFx5FSZ9LB5YtSbFkiZhpereY0vYQHVA5DFj/oY7
 o+FacNR+jKsPCPi4tp76NNDqqQkFqdV1+kUiMaTZ1XnJABWMgPsx/8DmFlV6YatqKj8l
 qOQjcmtRPVmEQIY5KynJ/a8Yeg3NqWSun+13HPUHNIbhdQzvb6lhQhiqSOvB4WKBqzwy
 OnudqMsCc4UetlI6dpyn437u7U5XwADg/Y+mSsRv7IFYqeq9bCqS9bxWv7h6c972lGOE LA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qtxts53pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:00 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x214YxHG006643
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:34:59 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x214YwvV023392
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:34:58 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:34:58 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 0/9] Misc props.c cleanups
Date:   Fri,  1 Mar 2019 12:34:46 +0800
Message-Id: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903010029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v5: drops patch
    [PATCH v4 03/10] btrfs: trivial, fix c coding style
    Chanegs are mainly to use BUG_ON instead of ASSERT as in the 
     original code in patches 5-7/9. Fix ASSERT in 8/9. And add
     a rename in 9/9. Each individual patches as the details of
     the changes.

v4: More cleanups patch 4-10 were added. 4/10 is a generic cleanup.
    5-9/10 are cleanups to assist killing btrfs_setxattr(). And
    10/10 kills btrfs_setxattr().

v3: Merge patch 2/5 and 3/5 as in v1.
    Not included 1/5 in v1 as its already integrated in misc-next.

While adding the readmirror property found few cleanup things which
can be fixed. As these aren't part of upcoming readmirror property
I am sending these separately.

Anand Jain (9):
  btrfs: kill __btrfs_set_prop()
  btrfs: drop redundant forward declaration in props.c
  btrfs: rename fs_info argument to fs_private
  btrfs: refactor btrfs_set_prop add btrfs_set_prop_trans
  btrfs: start transaction in btrfs_set_prop_trans
  btrfs: start transaction in btrfs_set_acl
  btrfs: start transaction in btrfs_xattr_handler_set
  btrfs: btrfs_setxattr argument trans is never NULL
  btrfs: kill btrfs_setxattr

 fs/btrfs/acl.c   |  43 ++++++++---
 fs/btrfs/ioctl.c |  10 ++-
 fs/btrfs/props.c | 221 +++++++++++++++++++++++++++++--------------------------
 fs/btrfs/props.h |   7 +-
 fs/btrfs/xattr.c |  76 +++++++++----------
 fs/btrfs/xattr.h |   5 +-
 6 files changed, 194 insertions(+), 168 deletions(-)

-- 
1.8.3.1

