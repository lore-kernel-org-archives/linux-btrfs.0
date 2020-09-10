Return-Path: <SRS0=1Lxm=CT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7C5C433E2
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 22:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9B1D207EA
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Sep 2020 22:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l6zwLxCC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgIJWJs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 18:09:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgIJWJo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Sep 2020 18:09:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AM8u6j125799;
        Thu, 10 Sep 2020 22:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=KGYTj25HvjvGWgx345nVyl4wZYp2E4aE1nF18gwa8oo=;
 b=l6zwLxCCAiAd2hxVnBje8Mb+vRrc18tw1ejn2irMQ9NnPgJSiMln5bFudC3+Ah/FlKKw
 5IYRubrOokpFZ8dFc21azB7sVFRc3AB8VzqK9Zudap5lO0W4eTmz+ZMaaaQ4tU1j+TUv
 Up+XrsbIssql+X12hwskfBMF+SLfeTinJ1MKqd/XU5iE9/Wp9weYneK0i+fxtOUiv2s/
 mJMtZFWEwFzy+wdHX8oVEKw1m8SvHpXLy4jrht5vLWCYSg1sxEGxVWvourrRy02wxw1v
 GkLmhW1cKThcmhXs6WMBmXbloySQimNQXOsM7X7o/HV/gTHB67GFNA8NcTI2p6Jgug9W Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33c2mmaw6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 22:09:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AM1YNN108847;
        Thu, 10 Sep 2020 22:09:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33cmevu7s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 22:09:39 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AM9aCv027506;
        Thu, 10 Sep 2020 22:09:38 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 15:09:35 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] fixup: btrfs: simplify parameters of btrfs_sysfs_add_devices_dir
Date:   Fri, 11 Sep 2020 06:09:27 +0800
Message-Id: <de807752385624b9ce46bd3a759a3fa4588051ec.1599775651.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <202009110113.Eg6BMMot%lkp@intel.com>
References: <202009110113.Eg6BMMot%lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100192
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add static to btrfs_sysfs_add_fs_devices()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Can you please roll this into the commit fd8e11fb8ffc
  btrfs: simplify parameters of btrfs_sysfs_add_devices_dir
on misc-next

 fs/btrfs/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 1f14b08cc04f..bc341560dc69 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1352,7 +1352,7 @@ int btrfs_sysfs_add_device(struct btrfs_device *device)
 	return ret;
 }
 
-int btrfs_sysfs_add_fs_devices(struct btrfs_fs_devices *fs_devices)
+static int btrfs_sysfs_add_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	int ret;
 	struct btrfs_device *device;
-- 
2.25.1

