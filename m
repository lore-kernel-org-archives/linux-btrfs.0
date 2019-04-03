Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5289C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 17:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8870A2075E
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 17:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PLFHiJlQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfDCREv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:04:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfDCREv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2019 13:04:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33H3itj148991;
        Wed, 3 Apr 2019 17:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=FUJSxDXNyScKBzOng/TmfrQAvaF1OJjGX/YArc/Oyxo=;
 b=PLFHiJlQv+xgRbir4nUs/cnuPvkm0D3hxgmkqgDuo0fIUPBI5GU9YjqyIXNZMK0a8E5J
 e/9gFurF4qBMLCN5nYS0jM/vdgKX4wtsIfgEtu9QPN27zSCjnx9440TcsFiJczxdDi/i
 kBzq2Cld3vpMEN/iSQXyRA13AYG3eDtRN7wGwXofkxY528n/tAhEGuW+I8LznHAhwRJc
 BX8t9aI92G5qCDcyX2DPRqLCTFIDOQbGDK5L2b8tQdjIe5XhWDiJpq6ujxrh+i7iONN9
 fvacJtk1VgM3QPioPsKC3SDdNBzKUdsdoAhd6KnnwTSSWsi4kTTE5R8juAk85fy/GIJZ Lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2rhyvtacma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 17:04:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x33H3Mml071079;
        Wed, 3 Apr 2019 17:04:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2rm9mj6122-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Apr 2019 17:04:48 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x33H4lbK012783;
        Wed, 3 Apr 2019 17:04:47 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Apr 2019 10:04:46 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] fstests: btrfs/048: amend property validation cases
Date:   Thu,  4 Apr 2019 01:04:37 +0800
Message-Id: <20190403170437.14448-1-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190403165419.12666-1-anand.jain@oracle.com>
References: <20190403165419.12666-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904030116
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9216 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904030116
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
v2: correct kernel patch titles in the test header and change log

 tests/btrfs/048     | 23 +++++++++++++++++++++++
 tests/btrfs/048.out | 16 ++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tests/btrfs/048 b/tests/btrfs/048
index 588219579cc6..f6de0b8ca8b1 100755
--- a/tests/btrfs/048
+++ b/tests/btrfs/048
@@ -6,6 +6,9 @@
 #
 # Btrfs properties test. The btrfs properties feature was introduced in the
 # linux kernel 3.14.
+# Fails without the kernel patches:
+#  btrfs: fix vanished compression property after failed set
+#  btrfs: fix zstd compression parameter
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
@@ -34,6 +37,7 @@ _supported_os Linux
 _require_test
 _require_scratch
 _require_btrfs_command "property"
+_require_btrfs_command inspect-internal dump-super
 
 send_files_dir=$TEST_DIR/btrfs-test-$seq
 
@@ -203,5 +207,24 @@ $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
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

