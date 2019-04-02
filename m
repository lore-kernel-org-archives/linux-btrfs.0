Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CE3C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D631420856
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 10:08:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rVf5zwP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfDBKIC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 06:08:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45932 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728710AbfDBKIC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 06:08:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x329hiAQ123920
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Kt3+EKFqoKaNPGw9mIxlrsIq9ugGcGHgPPFwohjiN5M=;
 b=rVf5zwP0ES/9/hCUhDrl7yFzoF8vdT2bIZCleYNFVoFZLUWsAcUNjAyKfLNSuOsEV7mG
 eFDM3CrkHMnTFksekQEfgKqwLdH2FoL0FdbIdCden+fK4KXpkd+xzosiPcFvCSXsB74v
 yCszQ/IcFuNo4tP99OPrG8nSgOqhxCVfFGmXpZov5ZXswKI0VsOY3GmIKOSderDaf8Nv
 F0b4xHPjje3dgeDbhIjZckuICJOZjRuWHeg72pCojoaX2Qz070XdOBHhLAimK5W7K8uv
 2L10rSlxnBAf1g8k4C+4+QNQgLhN0Fdr6QZpNKVYBLNiXS1gV5KGqgLKJA6ebcv3NWpX JQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2rj13q43r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 10:08:01 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x32A80lN007839
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:00 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x32A80ak006869
        for <linux-btrfs@vger.kernel.org>; Tue, 2 Apr 2019 10:08:00 GMT
Received: from tp.wifi.oracle.com (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Apr 2019 03:07:59 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs/048: amend property validation cases
Date:   Tue,  2 Apr 2019 18:07:39 +0800
Message-Id: <20190402100742.8355-3-anand.jain@oracle.com>
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

Add more property validation cases which are fixed by the patches [1]
 [1]
  btrfs: fix property validate fail should not increment generation
  btrfs: open code btrfs_set_prop in inherit_prop
  btrfs: fix vanished compression property after failed set
  btrfs: fix zstd compression parameter

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
(As this fstest patch depends on the kernel patches,
 this patch isn't sent to fstests mailing list yet).

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

