Return-Path: <SRS0=t/Of=ML=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A04C43143
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Sep 2018 00:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 799602073F
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Sep 2018 00:51:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3JT9toDL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 799602073F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbeI2HR4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Sep 2018 03:17:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60520 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbeI2HRz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Sep 2018 03:17:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8T0n12x054439;
        Sat, 29 Sep 2018 00:51:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=pO/fWVNAMnx8/E+piKQg0n3ThPpuggtmUZLSaWy920Q=;
 b=3JT9toDLFbf6PpEws+Q73/foEpx4ksBr0u+56Uuyt1GZNaFHJgIJ3z6Jh70H4MezF+0Y
 edqu6UvhQX63fDuBqJdeBZoCrdHTod302lwHk7HJNqDfV+k5YSM+cwOQO6XUZl470x2q
 uIejtdP3RPD+Bj6nn9X+VyKmt2ljsLv9pagd67FnkyJaSRF4P7uiEzz9rghSkrptVa11
 3cT6utBa9P/H4hpR8KKhTGH0NlAgDVk+mmq7q5p4wYAkUA/fFp5dNwuUulZs8PkoC7Kb
 MajFhkhlERRvyZokgHlkUPgEkWhaak4Ceaz5nvkYKMcdDYt3b5qnvDekKkRnvXmbxtV4 /g== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mnvtv9wax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Sep 2018 00:51:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8T0pZli027470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Sep 2018 00:51:35 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8T0pZPf031997;
        Sat, 29 Sep 2018 00:51:35 GMT
Received: from tpasj.localdomain (/202.156.138.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Sep 2018 17:51:34 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5] test unaligned punch hole at ENOSPC
Date:   Sat, 29 Sep 2018 08:51:27 +0800
Message-Id: <1538182287-9297-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1538146248-1759-1-git-send-email-anand.jain@oracle.com>
References: <1538146248-1759-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9030 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809290007
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Try to punch hole with unaligned size and offset when the FS is
full. Mainly holes are punched at locations which are unaligned
with the file extent boundaries when the FS is full by data.
As the punching holes at unaligned location will involve
truncating blocks instead of just dropping the extents, it shall
involve reserving data and metadata space for delalloc and data
alloc fails as the FS is full.

btrfs_punch_hole()
 btrfs_truncate_block()
   btrfs_check_data_free_space() <-- ENOSPC

We don't fail punch hole if the holes are aligned with the file
extent boundaries as it shall involve just dropping the related
extents.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4->v5:
 Update the change log
 Drop the directio option for xfs_io
v3->v4:
 Add to the group punch
v2->v3:
 Add _require_xfs_io_command "fpunch"
 Add more logs to $seqfull.full
   mount options and
   group profile info
 Add sync after dd upto ENOSPC
 Drop fallocate -p and use xfs_io punch to create holes
 Use a testfile instead of filler file so that easy to trace
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
index 000000000000..1ecf01d862a2
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
+$XFS_IO_PROG -f -c "pwrite -S 0xab 0 $((extent_size * 10))" \
+					$SCRATCH_MNT/testfile >> $seqres.full
+
+echo "Fill fs upto ENOSPC" >> $seqres.full
+dd status=none if=/dev/zero of=$SCRATCH_MNT/filler bs=512 >> $seqres.full 2>&1
+sync
+
+hole_offset=0
+hole_len=$unalign_by
+$XFS_IO_PROG -f -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
+
+hole_offset=$(($extent_size + $unalign_by))
+hole_len=$(($extent_size - $unalign_by))
+$XFS_IO_PROG -f -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
+
+hole_offset=$(($extent_size * 2 + $unalign_by))
+hole_len=$(($extent_size * 5))
+$XFS_IO_PROG -f -c "fpunch $hole_offset $hole_len" $SCRATCH_MNT/testfile
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

