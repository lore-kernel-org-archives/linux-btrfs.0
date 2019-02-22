Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B154DC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D03A20700
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:43:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RbuE3z14"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfBVRnx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:43:53 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53560 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbfBVRnw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:43:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOI8p195049
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=V2DM5yrcljvWClVGq1P4iR3WvzqsGWdfHJS0RNGgUTU=;
 b=RbuE3z14/tG2BFEXhrdETlMN1SjT3nSxfy8Y2KUiT/i4BPxu/M3dDdY00DgD7mFqo/Wh
 k0xlcGlSz6TbYnAaJzENa4cawyA2QIsG6Z/JrVHBeF7+H3brzz+UakeeZjWvDTb6M9PO
 ElvRjfTgNYOK4xuYSowK+eKaWoqjTf96tIF3hqOJXjanTRZLPDj955MAvTNaTurOQLa9
 qUWRSYEX0ECoYG+BjPPAlVeN7hJOSQxOwF+WOifDrNRdo7q88OjAi5tdsO1z1lmAcQ3B
 YpTFMKulh1dDdP2ym7xSqAZetpMZLq/xcI68PLNY5A/KjtyP31D0PUXTUjLmJ44AdxrW JQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qpb5s0gn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:51 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHhjn0019418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:46 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MHhjEE018381
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:45 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:43:45 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 1/2] btrfs-progs: check for no result before using results
Date:   Sat, 23 Feb 2019 01:43:38 +0800
Message-Id: <1550857419-10859-1-git-send-email-anand.jain@oracle.com>
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

