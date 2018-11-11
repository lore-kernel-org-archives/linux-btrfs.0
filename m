Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFB5C0044C
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83B1208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vUp3CZGF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B83B1208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbeKLALR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728331AbeKLALR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEK3T9172011
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=O9GJYQted7T4PG23/kwUKcS3sC+FzB/Y4ZJYMBC0xn8=;
 b=vUp3CZGFsa7xGxZFmpxQMnMnoQf2w3VND2IIB8jJT46ZhU1cMwVswgudLAsWyTkp92fM
 TsF+QSgOi99J+CuS4OLL4CO6wknfmTDZlmBUFajmYJGDiEiEqRgX9ZX9JElHbVdNfdtR
 VclzlSs8jl52tO//q4/KVlW2m+qmuaUMJvY7MEsTYG2UZd2WaWVy9Eu7vfak7HJe9hNB
 mCWSIbAqBovka9IRrM28Gi0GV/h5Wl/SRFn1OtGyEwKh41zP6e+VoZiOlN1P7alDA77G
 gYL9KgvTo18waMij81KLzaxAsUdA1LQqBKtzX8OCpDf4sYjuXGWvT7+XXfUCDBPn9OEK Bw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nnw6ea4a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:34 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMXIB031189
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:33 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wABEMXHu005104
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:33 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:33 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs: replace's scrub must not be running in replace suspended state
Date:   Sun, 11 Nov 2018 22:22:21 +0800
Message-Id: <1541946144-8174-7-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=595
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When the replace state is placed in the suspended state,
btrfs_scrub_cancel() should fail with -ENOTCONN as there is no
scrub running, as a safety catch check if btrfs_scrub_cancel()
returns -ENOTCONN and assert if it doesn't.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9fc3cb8d3918..1dc8e86546db 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -831,7 +831,9 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 
 		btrfs_dev_replace_write_unlock(dev_replace);
 
-		btrfs_scrub_cancel(fs_info);
+		/* scrub for replace must not be running in suspended state */
+		ret = btrfs_scrub_cancel(fs_info);
+		ASSERT(ret != -ENOTCONN);
 
 		trans = btrfs_start_transaction(root, 0);
 		if (IS_ERR(trans)) {
-- 
1.8.3.1

