Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1612C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AB282081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 11:43:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="5GCzHQAL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AB282081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbeKGVN4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 16:13:56 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbeKGVN4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Nov 2018 16:13:56 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA7BdPMB113382
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=DSQ4M0Fh/W+vxnnyGu8F0Hg5Bnd6JMn4HvNFarmn7LQ=;
 b=5GCzHQALXls1pmeGIcvtb1YcRam+VWITAwGTU2jzTG3ZhN0RV4OqPNjF1guS938GJIvW
 Rhew+1jlQUqNKWQqaS5685bEoTjPD6obvNnIJEMvAwz/fasCrb615sHov0Udg4KSLQU6
 pJow8wmINml3cl9x42Sk2ULTGKJsWp6D72HJbOjX/mT6qrWCTIQnsrV79VaDkwNP3shl
 JKinu09aylsa85XCfMLhyDfB6Yr83kaR+JXzL3WSzw2Ai3eG8ZhwCGGMrAEXmpiGQgZg
 qLcrm0sS+k5GoovXElFq8rNNawNnqVbjIcU3D/jWYm2A99i+BoGGofB6ehbtsJ6VIYq4 0Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2nh4aqtuyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Nov 2018 11:43:55 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhnFX000592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:49 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA7BhmJT027597
        for <linux-btrfs@vger.kernel.org>; Wed, 7 Nov 2018 11:43:49 GMT
Received: from tpasj.localdomain (/202.156.136.99)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Nov 2018 03:43:48 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs: add explicit check for replace result no error
Date:   Wed,  7 Nov 2018 19:43:30 +0800
Message-Id: <1541591010-29789-10-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
References: <1541591010-29789-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9069 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=804
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811070108
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We recast the replace return status
BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS to 0, to indicate no
error.
And since BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR should also return 0,
which is also declared as 0, so we just return. Instead add it to the if
statement so that there is enough clarity while reading the code.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cf3554554616..ca44998189c7 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -533,8 +533,9 @@ int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 					args->start.cont_reading_from_srcdev_mode);
 	args->result = ret;
 	/* don't warn if EINPROGRESS, someone else might be running scrub */
-	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS)
-		ret = 0;
+	if (ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS ||
+	    ret == BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR)
+		return 0;
 
 	return ret;
 }
-- 
1.8.3.1

