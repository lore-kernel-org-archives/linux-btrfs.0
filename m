Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E536AC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 03:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4860206C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 03:13:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KMCoJjda"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbfAPDNi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 22:13:38 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37884 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729097AbfAPDNh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 22:13:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0G352OV060620
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=uRkcYs3zEtSa/jkSVeziAhgq80kgG8D0PS6FAXwSr+g=;
 b=KMCoJjdaLwIAEON1eEu68x0k1PC3VEMO+88kuU16KOdrIMEtBA06LLehm+9Lxqlx+SvK
 DeCpemWwmxhZtehIGw+y9SPUbvoDDdlOsXyHSf8VkXra7FY2znezC+IijaGhaCtUFxsB
 yDUOhNJL0d0twiTDsALFxpxYdlxdBxZ5ig4wVfLIWwaKDwXoWJab6tSCYRSpldUtFiD8
 ef9HK8j68xxxkCnlqieaUzfEdP8JRYI+imfc6KUYhXjwbJiOv6+PB4QeT2jNHhtnrRZo
 dCI4sGZyOSufvWdnv1uWE38ewWYsC0Ip3KNDhthD0XH9CKLo1y+3nYebkpTp/1O3pUDp Yw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pybjnqdbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:35 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0G3DZTE003732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:35 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0G3DZf7022260
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 03:13:35 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Jan 2019 19:13:34 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 2/2] btrfs-progs: replace: gracefully handle the exclusive operation report
Date:   Wed, 16 Jan 2019 11:13:26 +0800
Message-Id: <1547608406-6430-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1547608406-6430-1-git-send-email-anand.jain@oracle.com>
References: <1547608406-6430-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9137 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=803
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901160022
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

