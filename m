Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B15C46464
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 07:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9924B20841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 07:55:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CdB+G1UN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9924B20841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbeJKPVp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 11:21:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbeJKPVp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 11:21:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B7s69l054066;
        Thu, 11 Oct 2018 07:55:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=aW5RfutVKCc4seEwnM/NHGxHrVeVX0ajkhUGlBTbKZs=;
 b=CdB+G1UNjmWLCfSZi2JR08Ysd62CUmptkTDqA8sc0TK/XfPVK17Bj4yjzY8kQ3sOM+zC
 rRFVgHMtc+d57YJPKGgLr+bcVJqp8+AOMvXMV+gNTTRIkToBN4mAOsNOcoTbl0VYjQCf
 1R6ecClhvU9rs3gQ17QeZGaK46JFvEomR9ZhgaUAQnt6naqhAibiIZwvFXfrY8xgDzgp
 pu7EHRZ+PndPborKG4/aRiEvMQvIZmd5yEAOfgTkR3slE6lVF0ITPGfJ8iSziKQV3VSv
 kN2Kij1QpVRUXa5O2uMSnW+fFM9M1q0BVh7NqNrZfAVgSDpX5FxKEpvxhs7DzMtR00Fn sg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mxn0qaepp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 07:55:38 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B7tbJI029881
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 07:55:37 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9B7tbOf001223;
        Thu, 11 Oct 2018 07:55:37 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 07:55:37 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4] geneirc/077 fix min size for btrfs
Date:   Thu, 11 Oct 2018 15:55:28 +0800
Message-Id: <1539244528-9647-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1539228360-8575-1-git-send-email-anand.jain@oracle.com>
References: <1539228360-8575-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=653
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110078
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If btrfs need to be tested at its default blockgroup which is non-mixed,
then it needs at least 256mb.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3->v4: fix the check for the /usr or /lib/modules size. Thanks Darrick.
v2->v3:
	separated from the patch set of 9.
	notrun for the cases where filler is not big enough to fill the
		fssize.
v2->v1: ref the cover-letter of the set.

 tests/generic/077 | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/tests/generic/077 b/tests/generic/077
index ef6af18c83e3..284e25253c9e 100755
--- a/tests/generic/077
+++ b/tests/generic/077
@@ -13,11 +13,18 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1
-# Something w/ enough data to fill 50M of fs...
-filler=/lib/modules/
 
-# fall back in case /lib/modules doesn't exist
-[ -d $filler ] || filler=/usr
+# Something w/ enough data to fill 256M of fs...
+filler=""
+[ -d /lib/modules ] && \
+	[ $(( $(du -h -m /lib/modules | tail -1| cut -f1) * 2 )) -ge 256 ] && \
+	filler=/lib/modules
+
+# fall back in case /lib/modules doesn't exist or smaller
+[[ -z $filler ]] && \
+	[ -d /usr ] && \
+	[ $(( $(du -h -m /usr | tail -1| cut -f1) * 2 )) -ge 256 ] && \
+	filler=/usr
 
 _cleanup()
 {
@@ -36,7 +43,7 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
-[ ! -d $filler ] && _notrun "No directory to source files from"
+[ ! -d $filler ] && _notrun "No directory at least 256MB to source files from"
 
 _require_scratch
 _require_attrs
@@ -49,9 +56,8 @@ rm -f $seqres.full
 _scratch_unmount >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seqres.full
 echo ""                                     >>$seqres.full
-SIZE=`expr 50 \* 1024 \* 1024`
-_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
-	|| _fail "mkfs failed"
+fs_size=$((256 * 1024 * 1024))
+_scratch_mkfs_sized $fs_size >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount
 mkdir $SCRATCH_MNT/subdir
 
-- 
1.8.3.1

