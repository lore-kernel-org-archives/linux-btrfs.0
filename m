Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0756BC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 11:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9A1E2085A
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 11:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y9oirIBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfCSLfS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:35:18 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40920 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfCSLfS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 07:35:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2JBYYEO106207
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=IB0zk4sbsFH2Fn+fdgtHQvLEPw4QQiKkiV+IRh4SvUQ=;
 b=Y9oirIBLJVdj4cRT0etTW6jhysALTV6v3X3jzkr6+k5pfCF56T7GpWT/ZZ8Wn6WXPrCB
 kZFqipUv1MiG8TLVybSU3ITku4xZ4LacQ7bMvA+jGmZ4nS08BXvLlE4V5CAJT6Z8kdmj
 FQqZSPRw59Q5ZAdQVGp4Jz8CYeAsVDlHAvWAsWyy++BeMqxfgJtqChXyojdfPX79/gz1
 Z0WMKsUTDE6+gza7Yr/0Tu9unoxubfj6XHIKApaoupqRmuFiVOhNOT8sxCNnQY/JLVI3
 7CdtkQ9cgm6yWv+oiPn7tZ4P3tp9iX7XxGHp6JXbKfNEfeLx+edlPJFFqNBkrand4WYM Cg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2r8pnem8re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2JBZGnd024880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:16 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2JBZFXo020217
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 11:35:16 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 04:35:15 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs test read from disks of different generation
Date:   Tue, 19 Mar 2019 19:35:30 +0800
Message-Id: <1552995330-28927-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190087
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Verify file read from disks assembled with different generations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/184     | 132 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/184.out |   9 ++++
 tests/btrfs/group   |   1 +
 3 files changed, 142 insertions(+)
 create mode 100755 tests/btrfs/184
 create mode 100644 tests/btrfs/184.out

diff --git a/tests/btrfs/184 b/tests/btrfs/184
new file mode 100755
index 000000000000..1791fdb079b7
--- /dev/null
+++ b/tests/btrfs/184
@@ -0,0 +1,132 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 184
+#
+# Test read on raid1 assembled with disks of different generations.
+#  Steps:
+#   . Use btrfs snapshot on the test_dir to create disk images of
+#     different generations (lets say generation a and generation b).
+#   . Mount one disk from generation a and another disk from generation
+#     b, and verify the file md5sum.
+#  Note: readmirror feature (in the btrfs ml) helps to reproduce the
+#     problem consistently.
+#  Fix-by: kernel patch
+#   [PATCH] btrfs: fix read corrpution on disks of different generation
+
+
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
+	_scratch_unmount > /dev/null 2>&1
+	_destroy_loop_device $dev1
+	_destroy_loop_device $dev2
+	btrfs subvolume delete $img_subvol > /dev/null 2>&1
+	btrfs subvolume delete $img_subvol_at_gen_a > /dev/null 2>&1
+	[[ -z $scratch_dev_pool_saved ]] || \
+			SCRATCH_DEV_POOL="$scratch_dev_pool_saved"
+	_scratch_dev_pool_put
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
+_require_test
+_require_scratch_dev_pool 2
+
+_test_unmount
+_require_btrfs_forget_if_not_fs_loadable
+_test_mount
+
+_scratch_dev_pool_get 2
+scratch_dev_pool_saved=""
+
+img_subvol=$TEST_DIR/img_subvol
+img_subvol_at_gen_a=$TEST_DIR/img_subvol_at_gen_a
+dev1_img=$img_subvol/d1
+dev2_img=$img_subvol/d2
+dev1_img_at_gen_a=$img_subvol_at_gen_a/d1
+dev2_img_at_gen_a=$img_subvol_at_gen_a/d2
+
+$BTRFS_UTIL_PROG subvolume create $img_subvol >> /dev/null 2>&1 || \
+					_fail "subvol create failed"
+
+$XFS_IO_PROG -f -c "pwrite -S 0xdd 0 256m" $dev1_img >> /dev/null 2>&1
+$XFS_IO_PROG -f -c "pwrite -S 0xdd 0 256m" $dev2_img >> /dev/null 2>&1
+
+dev1=$(_create_loop_device $dev1_img)
+dev2=$(_create_loop_device $dev2_img)
+
+scratch_dev_pool_saved="$SCRATCH_DEV_POOL"
+SCRATCH_DEV_POOL="$dev1 $dev2"
+_scratch_pool_mkfs -d raid1 -m raid1 >> $seqres.full 2>&1 || \
+			_fail  "mkfs failed on $SCRATCH_DEV_POOL"
+
+
+_mount "-o max_inline=0,nodatacow,device=$dev1" $dev2 $SCRATCH_MNT || \
+					_fail "mount for gen a failed"
+
+$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 4K" $SCRATCH_MNT/foobar >> /dev/null 2>&1
+
+echo md5sum at generation aa
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+echo
+_scratch_unmount
+
+$BTRFS_UTIL_PROG subvolume snapshot $img_subvol $img_subvol_at_gen_a \
+		>> /dev/null 2>&1 || _fail "subvol create failed"
+
+_mount "-o max_inline=0,nodatacow,device=$dev1" $dev2 $SCRATCH_MNT || \
+					_fail "mount for gen b failed"
+
+$XFS_IO_PROG -f -c "pwrite -S 0xbb 0 4K" $SCRATCH_MNT/foobar >> /dev/null 2>&1
+
+echo md5sum at generation bb
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+echo
+
+_scratch_unmount
+
+_destroy_loop_device $dev1
+_destroy_loop_device $dev2
+
+_test_unmount
+_btrfs_forget_if_not_fs_reload
+_test_mount
+
+dev1=$(_create_loop_device $dev1_img_at_gen_a)
+dev2=$(_create_loop_device $dev2_img)
+
+# mount with readmirror option, if it fails try without but the
+# problem may or may not be reproduced without the readmirror option.
+_mount "-o ro,device=$dev1,readmirror=devid$dev1_devid" $dev2 $SCRATCH_MNT > \
+								/dev/null 2>&1
+[[ $? != 0 ]] && (echo "readmirror option notfound" >> $seqres.full;
+		  _mount "-o ro,device=$dev1" $dev2 $SCRATCH_MNT || \
+					_fail "mount at gen ab failed";)
+echo md5sum at generation ab
+md5sum $SCRATCH_MNT/foobar | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/184.out b/tests/btrfs/184.out
new file mode 100644
index 000000000000..cc71898920ec
--- /dev/null
+++ b/tests/btrfs/184.out
@@ -0,0 +1,9 @@
+QA output created by 184
+md5sum at generation aa
+3e4309c7cc81f23d45e260a8f13ca860  SCRATCH_MNT/foobar
+
+md5sum at generation bb
+055a2a7342c0528969e1b6e32aadeee3  SCRATCH_MNT/foobar
+
+md5sum at generation ab
+055a2a7342c0528969e1b6e32aadeee3  SCRATCH_MNT/foobar
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f3227c1708d9..a4f8fe1eb5ce 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -186,3 +186,4 @@
 181 auto quick balance
 182 auto quick balance
 183 auto quick clone compress punch
+184 other
-- 
1.8.3.1

