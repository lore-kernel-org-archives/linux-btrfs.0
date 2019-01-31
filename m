Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767F5C282C7
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 10:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CC3520B1F
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 10:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rlivwt4y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbfAaKGE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 05:06:04 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbfAaKGD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 05:06:03 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VA4TIx172412
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=uRkcYs3zEtSa/jkSVeziAhgq80kgG8D0PS6FAXwSr+g=;
 b=rlivwt4yUlcTnDOvxJ8nmIKYsVJrMfWXyTzXU9D4PqgNfp/Xa1Hn/dnINJoCdeAGniOZ
 TbqyBJByIJeOf04vCQ7q9Jt2dJPmlJb9KtLiCIrydVULTzwqQsg9CBoQuKmFn+FgN3ik
 CBt3l50mApLzHyaESmvpZ7wZ4R4RhPmfezcE6trNMKciEJ+CxnfHp5fxeambv7y6kCW4
 XuYEGPyhCj1O7JpWhCg4AWl8F2Mdz27BaYNZhj7i9ZdpcSa+Of1vrIJ8an0JB2DHkIZr
 En5MlFv/TyKmFh0KIgOpTUH/DX+F3HpcG3dbXFHteGXgmCDwQRGSBX/Mvw2zaTswTpyh qg== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2q8g6rfjea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:02 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0VA61Gt002973
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:02 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x0VA6127011838
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 10:06:01 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 31 Jan 2019 02:06:01 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 2/2] btrfs-progs: replace: gracefully handle the exclusive operation report
Date:   Thu, 31 Jan 2019 18:05:41 +0800
Message-Id: <1548929141-10695-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
References: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9152 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=827 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1901310080
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

