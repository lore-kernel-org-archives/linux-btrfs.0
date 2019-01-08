Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82612C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 04:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 451D42087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 04:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G2pze1+e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfAHEJ1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 23:09:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfAHEJ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2019 23:09:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0849PDp144635
        for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2019 04:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=V2DM5yrcljvWClVGq1P4iR3WvzqsGWdfHJS0RNGgUTU=;
 b=G2pze1+ehl2yTm47cFfMuIglqT6wGuP9Ho6fvsm9HqFPcOr/btNXgSnkjqUhYS5r46zI
 DadSB/TouPJ74qdpD1KOXS28CYJWEB3FAomcJcY+9+MJHRLct+3ykkZuGF5gMZcrWK4l
 3shXG5icpFhcMTLtiYSZAltO129cxDfF2Py18NO/w79JOPg73AohcntF7OvBW/nxfKdT
 SsvRFzb2VhXtCot93T9s46HKObyeZmmqA1rQ8RGXnHLlmMgo5F9igsX0koXYVmmoSlbI
 kXs1lp9tejLJnrAFchasUevTOoSoqcIddPjDN9aMjzcMUDdlcAC5uF+0/ao5bdb0nz3Z Jg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2ptm0u1861-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 04:09:25 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0849P0F024549
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2019 04:09:25 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0849OQv001613
        for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2019 04:09:25 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Jan 2019 20:09:24 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 1/2] btrfs-progs: check for no result before using results
Date:   Tue,  8 Jan 2019 12:09:26 +0800
Message-Id: <1546920567-11956-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9129 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901080030
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

