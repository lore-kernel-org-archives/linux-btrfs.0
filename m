Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9F5C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AAD2206DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S8R3Jka8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfDCQv5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 12:51:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44550 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbfDCQv4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 12:51:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33GhmnH136746;
        Wed, 3 Apr 2019 16:51:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Qy47NDRBfWGaEaUnKj3SFm+DAVWA09EXpMGauqLgBW0=;
 b=S8R3Jka8luakpRvk9ZCOVZkd1WkD5n8cyrigZxgT7Z4I4bpEAGJdBaDeElhNtIhiJl+B
 a9FoQDdgZEDYaKZX+o/UQr/m/1n1W5GE9jZaKkt0Cjfat4tVzhDVMxNCb9f7WqliQ7Le
 dPJhgePZVOmv6gpMsGUlHoYxq+tkaAsudTMtwwhdSCyY8LYmAaL+tusDbvjWT/Xg2UJj
 OOnLKvMG9DqpqLmRJm80fXiom4FM3HG7FtGf/OGb83lkf9C19xCTDc/8smNECeycS7wY
 O1v830Xc/M9cI4NrkO6CrERDwUybZAGPu5ZDpD8O0wrub2l47ibrtLxU7sih/s4ZCD/R uQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2rhwydaeyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33GpM5a040427;
        Wed, 3 Apr 2019 16:51:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2rm9mj5tcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:51:52 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x33GppD5005176;
        Wed, 3 Apr 2019 16:51:51 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 09:51:50 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [PATCH 4/4] btrfs: fix vanished compression property after failed set
Date:   Thu,  4 Apr 2019 00:51:34 +0800
Message-Id: <20190403165134.12378-5-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403165134.12378-1-anand.jain@oracle.com>
References: <20190403165134.12378-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030114
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030114
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The compression property resets to NULL, instead of the old value if we
fail to set the new compression parameter.

btrfs prop get /btrfs compression
  compression=lzo
btrfs prop set /btrfs compression zli
  ERROR: failed to set compression for /btrfs: Invalid argument
btrfs prop get /btrfs compression

This is because the compression property ->validate() is successful for
'zli' as the strncmp() used the len passed from the userland.

Fix it by using the expected string length in strncmp().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
Please note:
This patch also fixes the bug that generation number gets updated when
property validation fails. As the reason its reason is weak validate(),
which lets the bad set pass untill ->apply().

 fs/btrfs/props.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index b324a5fd7864..64b5f4695d4c 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -255,11 +255,11 @@ static int prop_compression_validate(const char *value, size_t len)
 	if (!value)
 		return 0;
 
-	if (!strncmp("lzo", value, len))
+	if (!strncmp("lzo", value, 3))
 		return 0;
-	else if (!strncmp("zlib", value, len))
+	else if (!strncmp("zlib", value, 4))
 		return 0;
-	else if (!strncmp("zstd", value, len))
+	else if (!strncmp("zstd", value, 4))
 		return 0;
 
 	return -EINVAL;
-- 
2.17.1

