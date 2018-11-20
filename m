Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11137C04EBB
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCEDF21479
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XK4G0K/P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCEDF21479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbeKTSlS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 13:41:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46590 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbeKTSlR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 13:41:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAK84321029168
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=pvITtCIh9y0+13R+mXlpuwhjup3n2+Q6sZ05wFtSPaE=;
 b=XK4G0K/PQFVKS5JbXDJ43cNXGPILDjdoq2+u3PjnFqjLo7FBjdwO/EgEvTd01Ed+bG9q
 CRB5sim1xioc+S7MnpQouBiWEiGsdjVzsu58h3EDC9W9G4ZCTsrXYFDp+bECyVJ0R/WW
 h1nWC1IOVixP1asP9qudLSTIGEWmVuDw6uWjKdmQEdH5V/cyby7JxGl/nQlyfZZUzE+3
 l8YpuX2TAmg9rJl5ppRfA7wETf1IZhd4oaUF08eUIVX91Sj22q1jwitqaWBHzdNpTfKI
 o1gH1w/bUpeJpx6CdthChfhuly0zzrlM8sbN1BY2EtendFFL7QvdRBDGBJ3QFfe99y9O yw== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2ntaxq2cnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:26 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAK8DQLN029493
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:26 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAK8DPHG026476
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:26 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 00:13:25 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v6 3/3] btrfs: balance: add kernel log for end or paused
Date:   Tue, 20 Nov 2018 16:12:57 +0800
Message-Id: <1542701577-24586-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1542701577-24586-1-git-send-email-anand.jain@oracle.com>
References: <1542701577-24586-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=856
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add a kernel log when the balance ends, either for cancel or completed
or if it is paused.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5->v6: Quite soul. nothing.
v4->v5: nothing.
v3->v4: nothing.
v2->v3: nothing.
v1->v2: Moved from 2/3 to 3/3
 fs/btrfs/volumes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index eb18739f19ef..0684f14ff70d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4060,6 +4060,13 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	ret = __btrfs_balance(fs_info);
 
 	mutex_lock(&fs_info->balance_mutex);
+	if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
+		btrfs_info(fs_info, "balance: paused");
+	else if (ret == -ECANCELED && atomic_read(&fs_info->balance_cancel_req))
+		btrfs_info(fs_info, "balance: canceled");
+	else
+		btrfs_info(fs_info, "balance: ended with status: %d", ret);
+
 	clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
 
 	if (bargs) {
-- 
1.8.3.1

