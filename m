Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FB7C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DADD5206BA
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BieHuU6B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbeLQDN7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 16 Dec 2018 22:13:59 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57266 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbeLQDN7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Dec 2018 22:13:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH3Dnnf156984
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=V2DM5yrcljvWClVGq1P4iR3WvzqsGWdfHJS0RNGgUTU=;
 b=BieHuU6BFxGI1ZcY2twv5qdg/yPi6MSeoQg1feSY3xKLKXX8ZFaCXd6UVIOrTNorimdk
 I9Z4jYcI56cDjJYzpmSiLD6JXN1oCVqf2QrJBsDuyEbRZNoEpeqMguKKHLYieRS+1HgY
 c4HV70TGDkIQPrPZyvh8aLNeE6j8lvwvX1YYXGPcD79J60tA16R5Gf6uod5WzFeKcJSB
 H2/yaQC8pRIckFXMuR2lsfm9xmY71/h5YzFoSJw03gjzxe0tqdkMJhYtX9cryvNpDZ1g
 IEXQhuSVorsMLUwpFeXJqwMeBoBMx6tURsjtPqoV1ZrY8UWf2rbPPlcvqeX3alnvA67c Ag== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pcq4dkrgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:13:58 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBH3DugT028551
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:13:57 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBH3Du1l006509
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:13:56 GMT
Received: from tpasj.localdomain (/157.49.189.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Dec 2018 19:13:55 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: check for no result before using results
Date:   Mon, 17 Dec 2018 11:13:55 +0800
Message-Id: <1545016436-4137-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=899
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170029
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

