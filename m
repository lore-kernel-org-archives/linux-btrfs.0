Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 088B4C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 06:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B538920843
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 06:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AM1g/LL4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B538920843
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbeIZMvY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 08:51:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbeIZMvX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 08:51:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8Q6d8SD094580
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 06:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=CoW9vma+iE/TGqi52JHaQxUyfmyVCKu03gnVrfVIZuQ=;
 b=AM1g/LL4bDqGU6vYTRDZ1stajIpjHDN4OR44eOZIWA/xCW2aoed0UItETQHJI5ocINcO
 3kUsUbLnb/uK4mgGsft8kCwxNuAua09pX3Lq+EsAISXzzYiZcLVBnAMc9rMdRomaDFsO
 UUUWFBsIvRF1YEzapwHSsNKs3UW7HBA0BaSjFODVDJ7Pu8Jwvdnf/4a6F8NohaCxk9Sc
 OfVwemFqEkCSWmd2Lr+o/K0nIVtvQqDdqRINExRYItpSWtLXTyXhvo1dQpLv8jkeP13V
 n0j7aTZrhuKP8N+UWw8pNF1jiGcszk/swhT4WcTtCxxc+bJya4IqWujA6p6QoLSmIytW dg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2mndppgd5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 06:40:00 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8Q6dxWu004651
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 06:40:00 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8Q6dxEO006079
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 06:39:59 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Sep 2018 23:39:59 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] test unaligned punch hole at ENOSPC
Date:   Wed, 26 Sep 2018 14:39:49 +0800
Message-Id: <1537943989-27404-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1537789659-29460-1-git-send-email-anand.jain@oracle.com>
References: <1537789659-29460-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9027 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809260069
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Try to punch hole with unaligned size and offset when the FS
returns ENOSPC.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Use at least 256MB to test.
This test case fails on btrfs as of now.

 tests/btrfs/172     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/172.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/btrfs/172
 create mode 100644 tests/btrfs/172.out

diff --git a/tests/btrfs/172 b/tests/btrfs/172
new file mode 100755
index 000000000000..e84e742a3f1a
--- /dev/null
+++ b/tests/btrfs/172
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle. All Rights Reserved.
+#
+# FS QA Test 172
+#
+# Test if the unaligned (by size and offset) punch hole is successful when FS
+# is at ENOSPC.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs_sized $((256 * 1024 *1024)) >> $seqres.full
+
+# max_inline helps to create regular extent
+_scratch_mount "-o max_inline=0,nodatacow"
+
+echo "Fill fs upto ENOSPC" >> $seqres.full
+dd status=none if=/dev/zero of=$SCRATCH_MNT/filler bs=512 >> $seqres.full 2>&1
+
+extent_size=$(_scratch_btrfs_sectorsize)
+unalign_by=512
+echo extent_size=$extent_size unalign_by=$unalign_by >> $seqres.full
+
+hole_offset=0
+hole_len=$unalign_by
+run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
+
+hole_offset=$(($extent_size + $unalign_by))
+hole_len=$(($extent_size - $unalign_by))
+run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
+
+hole_offset=$(($extent_size * 2 + $unalign_by))
+hole_len=$(($extent_size * 5))
+run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/172.out b/tests/btrfs/172.out
new file mode 100644
index 000000000000..ce2de3f0d107
--- /dev/null
+++ b/tests/btrfs/172.out
@@ -0,0 +1,2 @@
+QA output created by 172
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index feffc45b6564..7e1a638ab7e1 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -174,3 +174,4 @@
 169 auto quick send
 170 auto quick snapshot
 171 auto quick qgroup
+172 auto quick
-- 
1.8.3.1

