Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF01C10F00
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 113F320700
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qi++iLsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfBVRnw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:43:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60610 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbfBVRnv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:43:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1MHOHMd194431
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=uRkcYs3zEtSa/jkSVeziAhgq80kgG8D0PS6FAXwSr+g=;
 b=qi++iLszOFXOYmuF+nxiHh22ZpMUENTaoRcIHNlc7L0QAI/5CXSnIfrJ83QZrFov3tLt
 7vvnbnfXEnlSorMCBabimxkGPUztPkyICpziNOQ6dTAulPEGWNPbZL2FF67E0vCjUdLb
 2U2V9qoWDPj0rUNRwbNqpYExsLGl/UWEtWroSCAoopsRNIUvngYqpljfnWKeqZRrM26H
 jKE/N7CJvIea9wBrlYF8jyTGYagnDsiN+ttrZ2vawZD0w2Yp47ytHIaa8rr8FFQ2ymk+
 dYZ8wboL5rxzUY7O0UIGg8kyiGb1DF75qsHNiCnLZP0RPnk/i8A9y2WoQtDV7yR+UeCE +w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qp81errmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:49 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1MHhmp3019595
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:48 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1MHhmo1018384
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 17:43:48 GMT
Received: from tpasj.localdomain (/157.45.233.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 Feb 2019 09:43:47 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 2/2] btrfs-progs: replace: gracefully handle the exclusive operation report
Date:   Sat, 23 Feb 2019 01:43:39 +0800
Message-Id: <1550857419-10859-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550857419-10859-1-git-send-email-anand.jain@oracle.com>
References: <1550857419-10859-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9175 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=835 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902220122
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

