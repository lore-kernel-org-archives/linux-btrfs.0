Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1574C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 783FB208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YHhtPutL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 783FB208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbeKLALU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbeKLALU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEKuC1172925
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=8GohB+CSPkRXI+poRbUgPJ1obTBfq5wvgrBY4U7f88A=;
 b=YHhtPutL7dMGO3lgylRS0eMDZatmpkthFtTEv8hHiz+uZEDqcSAS0wdS8yYUrIwR3Tza
 O9YJEvDJ4iqjoJhVGW/GIZrrvXZVCA5en9Uovvx/xp4iWBIBb430oXe9ekgfFJhvYSjc
 HHN9nR2KKnQ4ptxwKTz4dvrSwN6ddgnFpm8it4b+copurbOA0N0acNpktw1OdEcA1ir4
 H484YYkTzWYZxgBeFsqBxmTVoAPVXkULss2gdZX//ASbiNHcg2WGDclUjMyH3uAuCvPM
 iQqE2OCCKF5N+o4Rn7C8pfkNofM1aj35SfanlhAsnAFYsWl4E147lzMCMSQKUMjZLtEL nQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nnw6ea4a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:37 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMbD2031318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:37 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMbxG004288
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:37 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:37 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs: user requsted replace cancel is not an error
Date:   Sun, 11 Nov 2018 22:22:23 +0800
Message-Id: <1541946144-8174-9-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=863
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As of now only user requested replace cancel can cancel the replace-scrub
so no need to log error for it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9031a362921a..40a0942b4659 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -622,7 +622,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 								src_device,
 								tgt_device);
 	} else {
-		btrfs_err_in_rcu(fs_info,
+		if (scrub_ret != -ECANCELED)
+			btrfs_err_in_rcu(fs_info,
 				 "btrfs_scrub_dev(%s, %llu, %s) failed %d",
 				 btrfs_dev_name(src_device),
 				 src_device->devid,
-- 
1.8.3.1

