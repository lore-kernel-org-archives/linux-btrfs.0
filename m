Return-Path: <SRS0=gdyl=Y4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F033FCA9ED2
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 06:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C65C320578
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 06:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c6zW5Oec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfKDGeg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 01:34:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41558 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbfKDGef (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2019 01:34:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA46YXEK174099
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2019 06:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=P81KxZiFbNgiop+TU4gfv0iOUgSKNHpKLkYqMn574SI=;
 b=c6zW5OecQKk1uqAiTVNNmAsaSxNUKsWDaWTE9Pdz/nGic2qncNqEWx0bGEsuFthtcIF1
 PJAXLNvv8szphsh15xsGV3UlyNTvugzjyFe2i8U3UxaTfCpe6N84Pplu10Z1i4Pn7bkH
 DIdoJQoPj56qJ+dDcayRvfQMHtgO+8k0TVNgxwBqo4bp4YVh9wlLgFenb+OdiWT2zm8+
 4/ii6FCGBCwcUSdyrmEXjEV40bq0EL5IV1dcrya5nyOeoz9VPaJxO2yua/F4Vi5eBC3U
 VIUR4jWFwclQC5cf/EZFJ1AsEIDIyo38LxtvqmQQEY4IM4wx0xcxaVGkl3nF9cYDc2am kA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w12eqw0wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2019 06:34:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA46YWSB187527
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2019 06:34:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w1kxkt98n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2019 06:34:32 +0000
Received: from abhmp0023.oracle.com (abhmp0023.oracle.com [141.146.116.29])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA46XgxA030926
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2019 06:33:42 GMT
Received: from tp.wifi.oracle.com (/192.188.170.104)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 06:33:41 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v1 10/18] btrfs-progs: balance status: use global verbose option
Date:   Mon,  4 Nov 2019 14:33:08 +0800
Message-Id: <1572849196-21775-11-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572849196-21775-1-git-send-email-anand.jain@oracle.com>
References: <1572849196-21775-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040063
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Transpire global --verbose option down to the btrfs balance status
sub-command.

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds/balance.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/cmds/balance.c b/cmds/balance.c
index 0170fcb7f386..54784c76c1de 100644
--- a/cmds/balance.c
+++ b/cmds/balance.c
@@ -828,6 +828,8 @@ static const char * const cmd_balance_status_usage[] = {
 	"Show status of running or paused balance",
 	"",
 	"-v|--verbose     be verbose",
+	HELPINFO_GLOBAL_OPTIONS_HEADER,
+	HELPINFO_INSERT_VERBOSE,
 	NULL
 };
 
@@ -844,9 +846,12 @@ static int cmd_balance_status(const struct cmd_struct *cmd,
 	const char *path;
 	DIR *dirstream = NULL;
 	int fd;
-	int verbose = 0;
 	int ret;
 
+	/* init global verbose if unset */
+	if (bconf.verbose < 0)
+		bconf.verbose = 0;
+
 	optind = 0;
 	while (1) {
 		int opt;
@@ -861,7 +866,7 @@ static int cmd_balance_status(const struct cmd_struct *cmd,
 
 		switch (opt) {
 		case 'v':
-			verbose = 1;
+			bconf.verbose++;
 			break;
 		default:
 			usage_unknown_option(cmd, argv);
@@ -907,7 +912,7 @@ static int cmd_balance_status(const struct cmd_struct *cmd,
 	       (unsigned long long)args.stat.considered,
 	       100 * (1 - (float)args.stat.completed/args.stat.expected));
 
-	if (verbose)
+	if (bconf.verbose)
 		dump_ioctl_balance_args(&args);
 
 	ret = 1;
-- 
1.8.3.1

