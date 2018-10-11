Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B951C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 03:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA6B2082B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 03:26:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJuJrDtO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAA6B2082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbeJKKve (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 06:51:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58592 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbeJKKve (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 06:51:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B3Nh4K092645;
        Thu, 11 Oct 2018 03:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=CRcyMNFt+36UKChhBFiN3aVrQZdIOMWUBBOHb7kDaLE=;
 b=YJuJrDtOD3++5QVuUlE2yKdK9QHk9sjrR2QVIi6Z4ArZ2kECpSgPv9oSwvD50puu7b1A
 kkfIL1MrpU4oTkVAuRczTtssnjcBHJtSKvzm7GaN3zTpMBeZPA6UY8k15+AT7avo9VWk
 3tZKa+LQdkYF+nZIPvVptqmibLCKTDx4KTRLy3uFc+NyEsbZR79GKJibMNAiluhDZ1AX
 EHqfUjL4qjUHNfJVQ6kE6h7Wihk7gpX99xViAAiDmq8wm1p1oMDdK47f4grhDxsuXELF
 mVI3lV4F8UkJTFN+cxyI7I5wfqOvSOU8QQaKRaOWjzIs99Qf2OMbP/jt0lMrqWsiB5ac 2w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mxnpr8f1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 03:26:20 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9B3QK7S005356
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 03:26:20 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9B3QKTA015386;
        Thu, 11 Oct 2018 03:26:20 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 03:26:19 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3] geneirc/077 fix min size for btrfs
Date:   Thu, 11 Oct 2018 11:26:00 +0800
Message-Id: <1539228360-8575-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=633
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110031
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If btrfs need to be tested at its default blockgroup which is non-mixed,
then it needs at least 256mb.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3:
	separated from the patch set of 9.
	notrun for the cases where filler is not big enough to fill the
		fssize.
v2->v1: ref the cover-letter of the set.

 tests/generic/077 | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tests/generic/077 b/tests/generic/077
index ef6af18c83e3..784afe448940 100755
--- a/tests/generic/077
+++ b/tests/generic/077
@@ -13,7 +13,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1
-# Something w/ enough data to fill 50M of fs...
+# Something w/ enough data to fill 256M of fs...
 filler=/lib/modules/
 
 # fall back in case /lib/modules doesn't exist
@@ -38,6 +38,11 @@ _supported_os Linux
 
 [ ! -d $filler ] && _notrun "No directory to source files from"
 
+# check if two iterations of the assigned filler is big enough to fill fssize
+fs_size=$((256 * 1024 * 1024))
+[ $(( $(du -h -m /usr | tail -1| cut -f1) * 2 )) -lt 256 ] && \
+	_notrun "filler $filler isn't big enough to fill fssize $fssize"
+
 _require_scratch
 _require_attrs
 _require_acls
@@ -49,9 +54,7 @@ rm -f $seqres.full
 _scratch_unmount >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seqres.full
 echo ""                                     >>$seqres.full
-SIZE=`expr 50 \* 1024 \* 1024`
-_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
-	|| _fail "mkfs failed"
+_scratch_mkfs_sized $fs_size >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
 mkdir $SCRATCH_MNT/subdir
 
-- 
1.8.3.1

