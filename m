Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90471C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F49F20856
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fLn9V8fR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfDBKH7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 06:07:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfDBKH7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 06:07:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x329hUBk123794
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:07:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=Vu4COXM4KJ0RFbT8aoF5F5OEa3gMJ+REVdxusZ27t4w=;
 b=fLn9V8fRPIxTBFEI85i1vSViK2ogeAXV8x45npoQQrrgXXP9Gtx2lwlz2ExIgH2kYD0G
 u4gXqcLJgQSY4R65Goytm+fMxHRfkp7r0uBoLsEQDKy01OW1yOJ6WxlGQJGITSBtH+Nb
 1buYCbEYPDmnYFAICFY+xBXJqiKIs5FfpOyDGpVQPZMhhALqxwt1MRSP9uNFph7kuZL9
 W5rTPXFQBcWkRjS6TEFzJZSFiTGpusP7FrnWKD9aMuNsvPVSI/uaN9/RQ7f1tWj8qn5S
 yvriva3Ll1d5L5m60ZoLeLVuB4vxyZLAcLgFObZcc3/FLFn625JpoutB6CE7RMc2BSoP ig== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2rj13q43qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 10:07:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x32A7vcD031664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:07:57 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x32A7vjl006862
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:07:57 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 03:07:56 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4 RESEND] btrfs: fix property bugs
Date:   Tue,  2 Apr 2019 18:07:37 +0800
Message-Id: <20190402100742.8355-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=877 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020070
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

