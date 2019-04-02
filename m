Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255BCC10F0B
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E67DF20856
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PLxTkbAo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbfDBKIA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 06:08:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfDBKIA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 06:08:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x329hSHx123761
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:07:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=p1QpKWpC5/eH1WEcq8+sNoolFCALr1GRilhns7bKSzk=;
 b=PLxTkbAorNN3nN7Qlm4G4l3dgO0iidtZz5sZoNI6rrRRGWr81LDMKudMhlDJnxhLfn66
 YomPKJiFRs7l9k6okfNe9Id50kVR9mMapnCkmH2NfGe3pD2uRElLAOf9JspITBSCteWU
 wtL6w5OKWbFcdhJSoSSpl87uNumN4JuvdzS0fFOhAE+e2IfUBSzrE374kdmtfeeI+wq1
 xXCGIrsfhdDx4J799KhzYQphFqeOi6A1fiEtl1JiKRSFLBfzcix+vD6IXrR/YQHTmTTR
 gu/gkrypMHHb1iyzy8+ZljTh1VNhzq5od2SwV0nm1FclAsZx/vSodEY3RL/A0tIggG6h ow== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2rj13q43qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 10:07:59 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x32A7wlu007815
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:07:59 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x32A7wUR000548
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:07:58 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 03:07:58 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4 RESEND] btrfs: fix zstd compression parameter
Date:   Tue,  2 Apr 2019 18:07:38 +0800
Message-Id: <20190402100742.8355-2-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190402100742.8355-1-anand.jain@oracle.com>
References: <20190402100742.8355-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9214 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904020070
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We let to pass zstd compression parameter even if its not fully written.
For example:
  btrfs prop set /btrfs compression zst
  btrfs prop get /btrfs compression
     compression=zst

zlib and lzo are fine.

Fix it by using the expected number of char in strncmp().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/props.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f1a8be67f639..3cc007e3c7f8 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -304,7 +304,7 @@ static int prop_compression_apply(struct inode *inode, const char *value,
 		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
 	} else if (!strncmp("zlib", value, 4)) {
 		type = BTRFS_COMPRESS_ZLIB;
-	} else if (!strncmp("zstd", value, len)) {
+	} else if (!strncmp("zstd", value, 4)) {
 		type = BTRFS_COMPRESS_ZSTD;
 		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
 	} else {
-- 
1.8.3.1

