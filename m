Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3288FC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E746F2081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m8nAZVH3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E746F2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbeKGVNs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46070 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbeKGVNs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:48 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7BdEuq167014
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=9gbhumIq9IGO501Re/piwAZE3K05mhcn187VrOAA+is=;
 b=m8nAZVH3xmA8tTKn2GqRdIjtPn16uUOkfKp9WoM77/FUP+uMrH+tHeYaPLvW0mlkR+qw
 Q9rm+1MH7knIuGhSAQV/QrZVRCfUSqisTg0QFfznfJTpLGq3UnGqkfvbKaI/L9oBwWI1
 O+rfEkPrJ35jhqeR3vFEfDxAcpwhMXZ/ka0a0qvnz9CgvBf/9lGy+GrvxxATE++sxd0C
 Ft0Z08Dj52sRth4/s5oDhNZGdbuwcDZfx+M9m/Eo65EbQak1i+dHyvzMkXusXCBbeZsQ
 tnlJ35T2cQgwzWdSK1UljpK5oKtVhQ8MiDFby0QkJqffJj/4Q78pbXfo6zQbZoUvWUtD dQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nh3mpty86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhkkJ000533
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:46 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wA7BhkJo005545
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:46 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:46 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 8/9] btrfs: user requsted replace cancel is not an error
Date:   Wed,  7 Nov 2018 19:43:29 +0800
Message-Id: <1541591010-29789-9-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=864
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
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
index c14c41b70287..cf3554554616 100644
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

