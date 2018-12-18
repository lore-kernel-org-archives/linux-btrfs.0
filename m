Return-Path: <SRS0=wLRn=O3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843A0C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 16:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5403821873
	for <linux-btrfs@archiver.kernel.org>; Tue, 18 Dec 2018 16:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YqusyGq1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbeLRQBr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 18 Dec 2018 11:01:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48112 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbeLRQBq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Dec 2018 11:01:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBIFvbos064565
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 16:01:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=VSPl8LuIYh6b+R9OthXCXgt4ACN3C3B9iYyKoe2FDH0=;
 b=YqusyGq1M+5n+NXZaZprziPUrIgM6RXaqd4OvmeqssRBL6XkuwIZSO7ZM0ObZQQt6x1G
 WbpR7Jq4XwDpyWY7jgNLJw7g10JjDT2q0Bnk7iH2GpHRltNAylJSxg6RkL1HCv1rTCCl
 7Ko3TXBLyNCWvsl3NWPmObEppIkQ4rYAHBr0E+iz+lcgci8WIE9zRLLN1FL8LrRJZlDG
 cfLqa63uC9u9KQTev6ix9uSsFDZcuDwyITKgav6fWJ3PPgEPhCQ0x7n4bUnz0vMNy60H
 YumlhZVEpRVEo+vqRRcx9OU3zw8rQepfMYXoGcoRVqRENBjzCVGk9O6NxWSvzg18CesN HA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pcq4dvgh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 16:01:45 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wBIG1jba025364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 16:01:45 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBIG1jSi010100
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2018 16:01:45 GMT
Received: from tpasj.localdomain (/157.49.157.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Dec 2018 08:01:44 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: handle balance and replace concurrency
Date:   Wed, 19 Dec 2018 00:01:44 +0800
Message-Id: <1545148904-32714-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9111 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812180134
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Test case:
Run replace
 btrfs repl start -B -f /dev/sdd /dev/sdb /btrfs;
while replace is still running, from another terminal try to start
balance
 btrfs bal start  --full-balance /btrfs; echo ...:$?
 Done, had to relocate 0 out of 0 chunks
 ...:0

which fails to report that balance failed to relocate because another
exclusive operation is running.
In fact kernel ioctl BTRFS_IOC_BALANCE(_V2) does return error code 8,
but progs recast it to 0. Fix it by checking for the error code > 0.

After:
 btrfs bal start --full-balance /btrfs; echo ...:$?
 ERROR: balance: add/delete/balance/replace/resize operation in progress
 ...:8

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-balance.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 6cc26c358f95..77402ef62d85 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -481,11 +481,12 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 			"There may be more info in syslog - try dmesg | tail\n");
 			ret = 1;
 		}
+	} else if (ret > 0) {
+		error("balance: %s", btrfs_err_str(ret));
 	} else {
 		printf("Done, had to relocate %llu out of %llu chunks\n",
 		       (unsigned long long)args->stat.completed,
 		       (unsigned long long)args->stat.considered);
-		ret = 0;
 	}
 
 out:
-- 
1.8.3.1

