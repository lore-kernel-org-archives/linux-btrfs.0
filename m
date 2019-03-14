Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13046C10F06
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9760217F5
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 05:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G+j/z6VJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfCNFE6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 01:04:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51386 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfCNFE6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 01:04:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2E5460Q067893
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=p1QpKWpC5/eH1WEcq8+sNoolFCALr1GRilhns7bKSzk=;
 b=G+j/z6VJIfNLY8GQAqSVcmpJc02MUwTSGxblJBt6+P7qzb9m1c/+4fNcuwssnxy1JIB6
 Q8eVr1CvRXX2bs0Nkrc3Sk58/MSBLoaTq7Xp9Apj0M60Evc1Xv2rHospsFletwqFU976
 0Ck1dzNObj7AiWs58KNVH0btXuHSQiw0kMoQIhvDSDHU655/9GP2v+ANPgB1oAav1ZVX
 Y5XVZ008PRZOQHPAp31nSr+ZIOOAUlQERQeiJGxNlRl6Y6Cqf0ngHN6+OX1J2SHW0lOY
 KmITZmvllqewA9tLknMh2ql21PhCkw2oECYMTvMI6obpiVueKhlbvICGcXBJpbs1venp YA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r44wuesng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:56 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2E54uJj005053
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:56 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2E54uI6028993
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 05:04:56 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 Mar 2019 05:04:55 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: fix zstd compression parameter
Date:   Thu, 14 Mar 2019 13:05:03 +0800
Message-Id: <1552539906-29703-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
References: <1552539906-29703-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9194 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903140033
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

