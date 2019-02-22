Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6F3C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA9E206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:40:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BCWgjyDj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfBVRkA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:40:00 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56600 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfBVRkA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:40:00 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOGbi194419
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=+JelUcquCOmZGpbSvizj2stF1HMnpo0L8IFaSliRgH8=;
 b=BCWgjyDjMoxCfzzHmDsiHvWBf16WMBnVVb2OsHW52CD5U7hkygEdDOm11ffrc6mZLbDR
 +UF6L63wtG7KmcZjtJthCyUvJJhGlHJ1kywA8DhKDfZzI7GoA8H+Ghwzxehk3RVofgUM
 e2K2dheNakEwxH78SeqOI6BxIeCMoUEiVQb4/m5rjLus+Nko8eYyv2hFNCRHoTj8uXES
 BinfW41RipZI6ClvrvvTwpWIB9SCv+CqIpgVjObueHpQGP3b4pFI9abCLe0LfMeAPNGa
 t9PxybYnMthF0hRg1XQBVAJGOMPamS1zg0HV5iUET19/sUix507hbmsdRIw3fxayrS5t Kw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qp81err1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:39:58 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHdvNh002135
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:39:57 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MHdvPY016067
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:39:57 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:39:56 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 00/10] Misc props.c cleanups
Date:   Sat, 23 Feb 2019 01:39:42 +0800
Message-Id: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

v4: More cleanups patch 4-10 were added. 4/10 is a generic cleanup.
    5-9/10 are cleanups to assist killing btrfs_setxattr(). And
    10/10 kills btrfs_setxattr().

v3: Merge patch 2/5 and 3/5 as in v1.
    Not included 1/5 in v1 as its already integrated in misc-next.

While adding the readmirror property found few cleanup things which
can be fixed. As these aren't part of upcoming readmirror property
I am sending these separately.

Anand Jain (10):
  btrfs: kill __btrfs_set_prop()
  btrfs: drop redundant forward declaration in props.c
  btrfs: trivial, fix c coding style
  btrfs: rename fs_info argument to fs_private
  btrfs: refactor btrfs_set_prop add btrfs_set_prop_trans
  btrfs: start transaction in btrfs_set_prop_trans
  btrfs: start transaction in btrfs_set_acl
  btrfs: start transaction in btrfs_xattr_handler_set
  btrfs: btrfs_setxattr argument trans is never NULL
  btrfs: kill btrfs_setxattr

 fs/btrfs/acl.c   |  45 ++++++++---
 fs/btrfs/ioctl.c |  10 ++-
 fs/btrfs/props.c | 232 ++++++++++++++++++++++++++++---------------------------
 fs/btrfs/props.h |   7 +-
 fs/btrfs/xattr.c |  75 ++++++++----------
 fs/btrfs/xattr.h |   5 +-
 6 files changed, 196 insertions(+), 178 deletions(-)

-- 
1.8.3.1

