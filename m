Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B06C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 10:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0AD520B1F
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 10:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xURnw+Mg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbfAaKGC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 05:06:02 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731325AbfAaKGC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 05:06:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VA4PjU012852
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=V2DM5yrcljvWClVGq1P4iR3WvzqsGWdfHJS0RNGgUTU=;
 b=xURnw+Mgny4V8l6bY++gUMibjoPsvtFA0L++kxEBHZrDP49ryD0VZ8d2eoEyKKHlr9Hj
 qxTehtEV4Okki4Ywrx1q12dqRZTV1Db8CXxJ/hOYX9a25dMrAmNSpcTEvr4aLN68Yrsx
 HjOTG7zjg24FdYi2h0te5ttN7zUoO3ij9sQugK/onH0HP+DRFYuelSJ8+jclu4tV45rJ
 pyywTwpcBJgeKkkw6E+VR2NRamzZSewS77v7Aq6q5k2s4oxQGETEffqzAwdjEaWfi2UF
 3B+lqm9yVnJuHrbZeOQqeeLjjVbYvO+keFOWAkh38ebw6pHK+xK2r5ig1MMmxDevgJyk KA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2q8eyuqmt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:01 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0VA600v030931
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:00 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0VA60QG011819
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:00 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Jan 2019 02:05:59 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 1/2] btrfs-progs: check for no result before using results
Date:   Thu, 31 Jan 2019 18:05:40 +0800
Message-Id: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9152 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=975 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901310080
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

User space understands the ioctl BTRFS_IOC_DEV_REPLACE command status
using the struct btrfs_ioctl_dev_replace_args::result, and so userspace
initializes this to BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT, so exclude
this value in checking for the error.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-replace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-replace.c b/cmds-replace.c
index b30e6c781e64..42de4de8c031 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -296,6 +296,8 @@ static int cmd_replace_start(int argc, char **argv)
 		}
 
 		if (start_args.result !=
+		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT &&
+		    start_args.result !=
 		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
 			error("ioctl(DEV_REPLACE_START) on '%s' returns error: %s",
 				path,
-- 
1.8.3.1

