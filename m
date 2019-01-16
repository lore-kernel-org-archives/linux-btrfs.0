Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1925FC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 03:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D26E620866
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 03:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eGa/AGhx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfAPDNg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 22:13:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38758 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729097AbfAPDNf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 22:13:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0G35OWA110410
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=V2DM5yrcljvWClVGq1P4iR3WvzqsGWdfHJS0RNGgUTU=;
 b=eGa/AGhxYxN0HbVTM+bXZqdndsfI923x1P8OITVhiCU4ps2Td6vE0pbc3nu+NMmmYa0k
 W9XcrRfGjIeFQSUItfuG2pgoPCMBjkG6KTMrsPyt8uzSZCVeXeurlsq6qoyoFirtslX2
 UvDsa0y7XcKz1mFOEkpXLu2jtOjoZNRA0JlSBGarYP8j9+ESby+Wn+JHQy27ThbmCrOl
 7qRgGxccrDVnjR0htCkP1GXx4OoqYQPO+o/4B09gW5tcJz2qH4H8Z6q8XtcrhQeyVn5x
 5XAwj3XdLatujhRlDeFQdeB7Hj0xNeR5wKnAtV7HLVGE5N9uros0MPKuTFOu1Ob0WYvx hw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pybkcfdhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:34 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0G3DXVF020925
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:34 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0G3DXFx023127
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:33 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Jan 2019 19:13:33 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 1/2] btrfs-progs: check for no result before using results
Date:   Wed, 16 Jan 2019 11:13:25 +0800
Message-Id: <1547608406-6430-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9137 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=934
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901160022
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

