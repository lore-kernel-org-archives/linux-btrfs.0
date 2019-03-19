Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E08C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C6120857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0VOouFaP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfCSKAW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:00:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35558 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfCSKAV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:00:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wxfg193501
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=HCJO7nKtNJ4ddsnSJBmOAUG77U21wACLnYsiUUSvrAQ=;
 b=0VOouFaP8Eii2uHRye9h02IoWWuAf8/ySICQ1hc+hTQwGdc/hcm4hOHvWOuvbAAAwDpF
 MkZwQ9Swukn0HW+V/UquRZeiI9sx8UrREi9yjKOfCURm6ggXGUwcLXlkwLMJuVcjscRK
 8VfA1DRZBbFVLmkKQC6TAC5B5qgY3tx/pXZA95wvn8KKkolnouhfa7WhilR1BQ2Y+GEe
 27K9CLEAhXxN1ONe9WVvmL735F/yqL0yBnwIh5JiIIMQR5/RSB25bNPv07d2jZMRbfl5
 zKmF1Bqy89hXmSMVDt7ydAZj6NxOGMclo6fn070sgvWmdRPqeT7T5DKun0veWQf4oQZ3 wA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2r8ssrbg86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA0F7f011578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:16 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2JA0FKP018888
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:15 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:00:15 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 4/5] btrfs: add readmirror pid mount option
Date:   Tue, 19 Mar 2019 18:00:23 +0800
Message-Id: <1552989624-29577-5-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch adds mount option -o readmirror, which provides a transient
readmirror feature, which can be used in a readonly mount as well.

For example..
  mount -o readmirror=pid

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index e01fc68af6c1..9d25a01bcecb 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -343,6 +343,7 @@ enum {
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	Opt_ref_verify,
 #endif
+	Opt_readmirror_policy,
 	Opt_err,
 };
 
@@ -413,6 +414,7 @@ enum {
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	{Opt_ref_verify, "ref_verify"},
 #endif
+	{Opt_readmirror_policy, "readmirror=%s"},
 	{Opt_err, NULL},
 };
 
@@ -850,6 +852,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_set_opt(info->mount_opt, REF_VERIFY);
 			break;
 #endif
+		case Opt_readmirror_policy:
+			if (strcmp(args[0].from, "pid") == 0) {
+				info->fs_devices->readmirror_policy =
+							BTRFS_READMIRROR_PID;
+				break;
+			}
+			ret = -EINVAL;
+			goto out;
 		case Opt_err:
 			btrfs_info(info, "unrecognized mount option '%s'", p);
 			ret = -EINVAL;
-- 
1.8.3.1

