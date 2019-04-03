Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6E2C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1142A206DF
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 16:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2Kh0sgMJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfDCQyb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 12:54:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47498 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfDCQyb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 12:54:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33GraV6145089;
        Wed, 3 Apr 2019 16:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=qfe1k6L94jN78YuH8LAkY23Tr27Pcp96y29Mv5Pq9+0=;
 b=2Kh0sgMJFtjXRzp8v8NqJHpaWhJnuiGLQMF1Xa3EfRoaNnhR9CI8zMJ9XfKy55jzTciI
 WBKvE+9yjN5SEq4jRt75ZsYU3p+G/rK+vyVqV+db0scvYHI1BumDvTK3k6P00kR/uB6t
 1vOD18I/SXQGWUrcg/zoC2AoRzHziKosiKwZN0Z+mdnuMc64WaHH8lDtk0Kx4JOLBam8
 A2vv93fdG/HQSbIeCXEyI62t6sjr92J0JartzTzaYO45YmE1ONXnGixQNHrTCVLFJ3kl
 c0ZFqKwCPBZCOnfLBULNsUDWhGddN+1wd5lWnADqfAytxbMBAC0a6O0d4BOwwKIQ5ixC dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2rhwydafek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:54:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33GrJcL002437;
        Wed, 3 Apr 2019 16:54:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2rm8f5fa3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 16:54:29 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x33GsRJ3005836;
        Wed, 3 Apr 2019 16:54:28 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 09:54:27 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs/048: amend property validation cases
Date:   Thu,  4 Apr 2019 00:54:19 +0800
Message-Id: <20190403165419.12666-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030114
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904030115
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add more property validation cases which are fixed by the patches [1]
 [1]
  btrfs: fix vanished compression property after failed set
  btrfs: fix zstd compression parameter

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/048     | 25 +++++++++++++++++++++++++
 tests/btrfs/048.out | 16 ++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/tests/btrfs/048 b/tests/btrfs/048
index 588219579cc6..657634f7cc3e 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -6,6 +6,11 @@
 #
 # Btrfs properties test. The btrfs properties feature was introduced in the
 # linux kernel 3.14.
+# Fails without the kernel patches:
+#  btrfs: fix property validate fail should not increment generation
+#  btrfs: open code btrfs_set_prop in inherit_prop
+#  btrfs: fix vanished compression property after failed set
+#  btrfs: fix zstd compression parameter
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -34,6 +39,7 @@ _supported_os Linux
 _require_test
 _require_scratch
 _require_btrfs_command "property"
+_require_btrfs_command inspect-internal dump-super
 
 send_files_dir=$TEST_DIR/btrfs-test-$seq
 
@@ -203,5 +209,24 @@ $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
 touch $SCRATCH_MNT/sv1/file2
 $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
 
+echo -e "\nTesting argument validation, should fail"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
+echo "***"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' | _filter_scratch
+
+echo -e "\nTesting if property is persistent across failed validation"
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
+
+echo -e "\nTesting generation is unchanged after failed validation"
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
+$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
+$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
+
 status=0
 exit
diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
index 3e4e3d28950a..00f39bc01227 100644
--- a/tests/btrfs/048.out
+++ b/tests/btrfs/048.out
@@ -76,3 +76,19 @@ compression=zlib
 Testing subvolume property inheritance
 compression=lzo
 compression=lzo
+
+Testing argument validation, should fail
+ERROR: failed to set compression for /mnt/scratch: Invalid argument
+***
+ERROR: failed to set compression for /mnt/scratch: Invalid argument
+***
+ERROR: failed to set compression for /mnt/scratch: Invalid argument
+
+Testing if property is persistent across failed validation
+ERROR: failed to set compression for /mnt/scratch: Invalid argument
+compression=lzo
+
+Testing generation is unchanged after failed validation
+generation		7
+ERROR: failed to set compression for /mnt/scratch: Invalid argument
+generation		7
-- 
2.17.1

