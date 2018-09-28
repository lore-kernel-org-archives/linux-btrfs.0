Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B539C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 15:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E69192064D
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 15:00:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q3OQ2ffn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E69192064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbeI1VYn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 17:24:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeI1VYn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 17:24:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8SExKS9168248;
        Fri, 28 Sep 2018 15:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=4+0J2mEj86qe0vTRre8dwPwHBfxQ85QKEGbTCptiOt8=;
 b=Q3OQ2ffnCgpwnbuT34zvz15YVg+RAqbdv57Q89TjKU2AY1WhbfyGeeluC0cZAeY5i3Nb
 IymEEatuHdVUBTFBCvIt6+aKovmktNti14Kp49ShWKk3EFsAdIydzXyO/52DFFt0Y96c
 hT0LxL3R7bo4tNpIVIY/+MCdfXtniUYkaiJMLdTpZdUGDYzOm3Ft74qrh+TPnujKza4i
 K/hfKJV0x80ipKT7wJh9tKPrlazKoqwGzeksZwlZparsnRsVNy/ufSPRq6WquxjFchJs
 8kSqq5kQDvjCEx2HfWMsOQOLNPdkvja0dDDomo3z36g/ybh2olqRd6NNlqMRUqF0o01e cw== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mnvtv7htf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 15:00:32 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8SF0U2K028744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 15:00:31 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8SF0UBQ014950;
        Fri, 28 Sep 2018 15:00:30 GMT
Received: from tpasj.localdomain (/202.156.138.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Sep 2018 08:00:30 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4] test unaligned punch hole at ENOSPC
Date:   Fri, 28 Sep 2018 22:59:59 +0800
Message-Id: <1538146799-2085-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1538146248-1759-1-git-send-email-anand.jain@oracle.com>
References: <1538146248-1759-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9029 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809280151
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Try to punch hole with unaligned size and offset when the FS
returns ENOSPC

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3->v4:
 add to the group punch
v2->v3:
 add _require_xfs_io_command "fpunch"
 add more logs to $seqfull.full
   mount options and
   group profile info
 add sync after dd upto ENOSPC
 drop fallocate -p and use xfs_io punch to create holes
v1->v2: Use at least 256MB to test.
This test case fails on btrfs as of now.
 tests/btrfs/172     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/172.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 77 insertions(+)
 create mode 100755 tests/btrfs/172
 create mode 100644 tests/btrfs/172.out

diff --git a/tests/btrfs/172 b/tests/btrfs/172
new file mode 100755
index 000000000000..59413a5de12f
--- /dev/null
+++ b/tests/btrfs/172
@@ -0,0 +1,74 @@
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
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "fpunch"
+
+_scratch_mkfs_sized $((256 * 1024 *1024)) >> $seqres.full
+
+# max_inline helps to create regular extent
+_scratch_mount "-o max_inline=0,nodatacow"
+
+cat /proc/self/mounts | grep $SCRATCH_DEV >> $seqres.full
+$BTRFS_UTIL_PROG filesystem df $SCRATCH_MNT >> $seqres.full
+
+extent_size=$(_scratch_btrfs_sectorsize)
+unalign_by=512
+echo extent_size=$extent_size unalign_by=$unalign_by >> $seqres.full
+
+$XFS_IO_PROG -f -d -c "pwrite -S 0xab 0 $((extent_size * 10))" \
+					$SCRATCH_MNT/testfile >> $seqres.full
+
+echo "Fill fs upto ENOSPC" >> $seqres.full
+dd status=none if=/dev/zero of=$SCRATCH_MNT/filler bs=512 >> $seqres.full 2>&1
+sync
+
+hole_offset=0
+hole_len=$unalign_by
+$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
+
+hole_offset=$(($extent_size + $unalign_by))
+hole_len=$(($extent_size - $unalign_by))
+$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
+
+hole_offset=$(($extent_size * 2 + $unalign_by))
+hole_len=$(($extent_size * 5))
+$XFS_IO_PROG -f -d -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
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
index feffc45b6564..45782565c3b7 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -174,3 +174,4 @@
 169 auto quick send
 170 auto quick snapshot
 171 auto quick qgroup
+172 auto quick punch
-- 
1.8.3.1

