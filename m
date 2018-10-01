Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2AAC43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 08:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E1AD2083C
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 08:30:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DcRXe/yK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E1AD2083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbeJAPG5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:06:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39126 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbeJAPG4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 11:06:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w918T976101190;
        Mon, 1 Oct 2018 08:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=3EPdNsodAtSnq6j1kEExAyzsAbS+cjNLBG6Z2xU3mW0=;
 b=DcRXe/yK2ZLYlOOKm+0xJzOf8EJv6fA6jbf8dXIjWQdHz/UUvEyYi59DGEeVrEpRJ9Kv
 dMximF1eiejt+4P/hYYuwxc3ZL1OqWFgjHaCnKTatXgkxBLMFrV7M0RW23QuBnvnmvTZ
 tLa2i0uiLqOcLC3KQ5EiVbZ+dV7S9QotF+3vDdNtlFF/klmx42kBVghk1UcTSse0e0Lo
 hjsu83aaYrMJnypZ6qFSnyrjLRXMU+rTirYM78e7R6ckOouu0cOtOmdlFoWMGk5LLX6I
 wNhtktL82H8BpQVu7faL4EegyRJ7hoOjDOf0TJi36eZZ+Ytt35PUUxLv7GiNvecVMC3R 4A== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mt1bpnfc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Oct 2018 08:30:20 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w918UJ7g005424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Oct 2018 08:30:19 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w918UJ9P006225;
        Mon, 1 Oct 2018 08:30:19 GMT
Received: from tpasj.sg.oracle.com (/10.186.53.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Oct 2018 01:30:19 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH] verify hardening agaist duplicate fsid
Date:   Mon,  1 Oct 2018 16:29:52 +0800
Message-Id: <1538382592-1632-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9032 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810010087
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Its not that impossible to imagine that a device OR a btrfs image is
been copied just by using the dd or the cp command. Which in case both
the copies of the btrfs will have the same fsid. If on the system with
automount enabled, the copied FS gets scanned.

We have a known bug in btrfs, that we let the device path be changed
after the device has been mounted. So using this loop hole the new
copied device would appears as if its mounted immediately after its
been copied.

For example:

Initially.. /dev/mmcblk0p4 is mounted as /

lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
mmcblk0     179:0    0 29.2G  0 disk
|-mmcblk0p4 179:4    0    4G  0 part /
|-mmcblk0p2 179:2    0  500M  0 part /boot
|-mmcblk0p3 179:3    0  256M  0 part [SWAP]
`-mmcblk0p1 179:1    0  256M  0 part /boot/efi

btrfs fi show
Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
    Total devices 1 FS bytes used 1.40GiB
    devid    1 size 4.00GiB used 3.00GiB path /dev/mmcblk0p4

Copy mmcblk0 to sda
dd if=/dev/mmcblk0 of=/dev/sda

And immediately after the copy completes the change in the device
superblock is notified which the automount scans using
btrfs device scan and the new device sda becomes the mounted root
device.

lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    1 14.9G  0 disk
|-sda4        8:4    1    4G  0 part /
|-sda2        8:2    1  500M  0 part
|-sda3        8:3    1  256M  0 part
`-sda1        8:1    1  256M  0 part
mmcblk0     179:0    0 29.2G  0 disk
|-mmcblk0p4 179:4    0    4G  0 part
|-mmcblk0p2 179:2    0  500M  0 part /boot
|-mmcblk0p3 179:3    0  256M  0 part [SWAP]
`-mmcblk0p1 179:1    0  256M  0 part /boot/efi
btrfs fi show /
Label: none  uuid: 07892354-ddaa-4443-90ea-f76a06accaba
    Total devices 1 FS bytes used 1.40GiB
    devid    1 size 4.00GiB used 3.00GiB path /dev/sda4

The bug is quite nasty that you can't either unmount /dev/sda4 or
/dev/mmcblk0p4. And the problem does not get solved until you take
the sda out of the system on to another system to change its fsid using
the 'btrfstune -u' command.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/btrfs/173     | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/173.out |  5 ++++
 tests/btrfs/group   |  1 +
 3 files changed, 76 insertions(+)
 create mode 100755 tests/btrfs/173
 create mode 100644 tests/btrfs/173.out

diff --git a/tests/btrfs/173 b/tests/btrfs/173
new file mode 100755
index 000000000000..c644b07d6f5b
--- /dev/null
+++ b/tests/btrfs/173
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Oracle. All Rights Reserved.
+#
+# FS QA Test 173
+#
+# Fuzzy test for FS image duplication.
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
+_require_scratch_dev_pool 2
+_scratch_dev_pool_get 2
+
+dev_foo=$(echo $SCRATCH_DEV_POOL | awk '{print $1}' | rev | cut -d"/" -f1 | rev)
+dev_bar=$(echo $SCRATCH_DEV_POOL | awk '{print $2}' | rev | cut -d"/" -f1 | rev)
+
+_mkfs_dev /dev/$dev_foo
+_mount /dev/$dev_foo $SCRATCH_MNT
+
+echo mount before btrfs image clone | tee -a $seqres.full
+findmnt /dev/$dev_foo | grep -v TARGET | awk '{print $1" "$2}' | \
+	sed -e "s/$dev_foo/dev_foo/g" | _filter_scratch | tee -a $seqres.full
+findmnt /dev/$dev_bar | grep -v TARGET | awk '{print $1" "$2}' | \
+	sed -e "s/$dev_bar/dev_bar/g" | _filter_scratch | tee -a $seqres.full
+
+for sb_bytenr in 65536 67108864
+do
+	echo -n "dd status=none if=/dev/$dev_foo of=/dev/$dev_bar bs=1 "\
+		"seek=$sb_bytenr skip=$sb_bytenr count=4096" >> $seqres.full
+	dd status=none if=/dev/$dev_foo of=/dev/$dev_bar bs=1 seek=$sb_bytenr \
+				skip=$sb_bytenr count=4096 >> $seqres.full 2>&1
+	echo ..:$? >> $seqres.full
+done
+
+echo mount after btrfs image clone | tee -a $seqres.full
+findmnt /dev/$dev_foo | grep -v TARGET | awk '{print $1" "$2}' | \
+	sed -e "s/$dev_foo/dev_foo/g" | _filter_scratch | tee -a $seqres.full
+findmnt /dev/$dev_bar | grep -v TARGET | awk '{print $1" "$2}' | \
+	sed -e "s/$dev_bar/dev_bar/g" | _filter_scratch | tee -a $seqres.full
+
+_scratch_dev_pool_put
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/173.out b/tests/btrfs/173.out
new file mode 100644
index 000000000000..a2ef7a26f4b9
--- /dev/null
+++ b/tests/btrfs/173.out
@@ -0,0 +1,5 @@
+QA output created by 173
+mount before btrfs image clone
+SCRATCH_MNT /dev/dev_foo
+mount after btrfs image clone
+SCRATCH_MNT /dev/dev_foo
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 45782565c3b7..b2f1393f3e97 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -175,3 +175,4 @@
 170 auto quick snapshot
 171 auto quick qgroup
 172 auto quick punch
+173 volume
-- 
1.8.3.1

