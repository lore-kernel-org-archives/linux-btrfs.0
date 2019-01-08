Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E5F0C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 04:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DD3B2087F
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 04:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TFRedUDB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfAHEJ2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 23:09:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfAHEJ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2019 23:09:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0849RTt144640
        for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2019 04:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=uRkcYs3zEtSa/jkSVeziAhgq80kgG8D0PS6FAXwSr+g=;
 b=TFRedUDB3oJg8eb+z2q5E/umFvEB8qfz+dGgomaJPV6RpsRzAjQtnjZx9TTUltw3/iTK
 +koAvQIm3nRZswYOrDhnMDgqCXUDKSXpzh2BfCh35NOEzcd5Lcji6fPSsxIRr8BHo+mT
 4nxGd2E/N/Gzg8euuk/KTrKq6Gg3Fz8rayTWOsLGVvoNpSmt583RL2bq+GRgawvlXrnu
 oVu82a8elx0L4slNtktdHtzWyJ/nnoXa1JGFRf1UnRx4f/e2H1x+C1ZDDymAfWn6IY2J
 KdBZgagmhBclCcx5OAyP5ycgD12kP+46EHrIevt8z+9dtC+LgabTCbuDktwZ4/PdgYhU Tw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2ptm0u1862-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 04:09:27 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0849Q9g001662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2019 04:09:26 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0849QiW001616
        for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2019 04:09:26 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Jan 2019 20:09:25 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 2/2] btrfs-progs: replace: gracefully handle the exclusive operation report
Date:   Tue,  8 Jan 2019 12:09:27 +0800
Message-Id: <1546920567-11956-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1546920567-11956-1-git-send-email-anand.jain@oracle.com>
References: <1546920567-11956-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9129 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=806
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901080030
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace start fails to report the appropriate error if balance is already
running, as below,

btrfs rep start -B -f /dev/sdb /dev/sde /btrfs
ERROR: ioctl(DEV_REPLACE_START) on '/btrfs' returns error: <illegal
result value>

Fix it by checking if the return is > 0, as the kernel returns
BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS for the above cli, if the balance is
running.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 cmds-replace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/cmds-replace.c b/cmds-replace.c
index 42de4de8c031..696f24c5c6d5 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -295,6 +295,10 @@ static int cmd_replace_start(int argc, char **argv)
 			goto leave_with_error;
 		}
 
+		if (ret > 0)
+			error("ioctl(DEV_REPLACE_START) '%s': %s", path,
+			      btrfs_err_str(ret));
+
 		if (start_args.result !=
 		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT &&
 		    start_args.result !=
-- 
1.8.3.1

