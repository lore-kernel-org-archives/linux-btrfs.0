Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63713C6786F
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 04:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2062220868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 04:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0oSDB/UE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2062220868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbeJLLhL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 07:37:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35386 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbeJLLhL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 07:37:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9C43TT8040373
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=a35QQRyhcBJeTYt2wJIZ2jii2BXiCXNOq9VJ8o3vo24=;
 b=0oSDB/UE5s/3vMiTmfc5xXhdnNP094cheVfEPr7WWWxM08VzKt43jp4YPcwuaN/2P39C
 A879plqG0+hr6urdgIGt+1anrFoTPkLAE7TPgsAwaoJN/0pOgaa55fne91hNM6foDlv0
 6PCgAN4kjOyIIqmRrU/8NRKE2GjShRLMWlPwnzWMDOIpN5+/EEVX2jLjTET43Z/pB+5C
 9smIPHP0TBV0DP/Wek+2zhasreuLaFcKSmHcxCoofk2YBkecXvY/+j6gSFHQLZfz8pBw
 IshjNQ8zYt8eonGYRKnEf9vQjO037dgkzAZ5wp7DP5kNPvsMc+vH285HSrb7eyeQ7LwB mQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mxnprfy26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:45 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9C46i05013796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:44 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9C46iMu024614
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 04:06:44 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Oct 2018 04:06:44 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs use forget if not reload
Date:   Fri, 12 Oct 2018 12:06:31 +0800
Message-Id: <1539317191-9265-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
References: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9043 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810120040
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs reload was introduced to cleanup the device list inside the btrfs
kernel module.

The problem with the reload approach is that you can't run btrfs test
cases 124,125, 154 and 164 on the system with btrfs as root fs.

Now as we are introducing the btrfs forget feature as an btrfs device
scan option [1], so here are its pertaining changes in the fstests.

So these changes ensures we use the forget feature where available and
if its not then falls back to the reload approach.

[1]
btrfs-progs: add cli to forget one or all scanned devices
btrfs: introduce feature to forget a btrfs device

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/btrfs    | 20 ++++++++++++++++++++
 tests/btrfs/124 |  6 +++---
 tests/btrfs/125 |  6 +++---
 tests/btrfs/154 |  6 +++---
 tests/btrfs/164 |  4 ++--
 5 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 26dc0bb9600f..c7fbec11c8c1 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -374,3 +374,23 @@ _scratch_btrfs_sectorsize()
 	$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV |\
 		grep sectorsize | awk '{print $2}'
 }
+
+_btrfs_supports_forget()
+{
+	$BTRFS_UTIL_PROG device scan --help | grep -wq forget && \
+		$BTRFS_UTIL_PROG device scan --forget > /dev/null 2>&1
+}
+
+_require_btrfs_forget_if_not_fs_loadable()
+{
+	_btrfs_supports_forget && return
+
+	_require_loadable_fs_module "btrfs"
+}
+
+_btrfs_forget_if_not_fs_reload()
+{
+	_btrfs_supports_forget && return
+
+	_reload_fs_module "btrfs"
+}
diff --git a/tests/btrfs/124 b/tests/btrfs/124
index ce3ad6aa3a58..edbeff1443f5 100755
--- a/tests/btrfs/124
+++ b/tests/btrfs/124
@@ -51,7 +51,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 2
 _test_unmount
-_require_loadable_fs_module "btrfs"
+_require_btrfs_forget_if_not_fs_loadable
 
 _scratch_dev_pool_get 2
 
@@ -86,7 +86,7 @@ echo "clean btrfs ko" >> $seqres.full
 _scratch_unmount
 
 # un-scan the btrfs devices
-_reload_fs_module "btrfs"
+_btrfs_forget_if_not_fs_reload
 
 echo >> $seqres.full
 echo "-----Write degraded mount fill upto $max_fs_sz bytes-----" >> $seqres.full
@@ -125,7 +125,7 @@ echo
 echo "Mount degraded with the other dev"
 _scratch_unmount
 # un-scan the btrfs devices
-_reload_fs_module "btrfs"
+_btrfs_forget_if_not_fs_reload
 _mount -o degraded $dev2 $SCRATCH_MNT >>$seqres.full 2>&1
 _run_btrfs_util_prog filesystem show
 checkpoint3=`md5sum $SCRATCH_MNT/tf2`
diff --git a/tests/btrfs/125 b/tests/btrfs/125
index e38de264b28e..9161a2ddeaad 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -50,7 +50,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 3
 _test_unmount
-_require_loadable_fs_module "btrfs"
+_require_btrfs_forget_if_not_fs_loadable
 
 _scratch_dev_pool_get 3
 
@@ -102,7 +102,7 @@ echo "unmount" >> $seqres.full
 _scratch_unmount
 echo "clean btrfs ko" >> $seqres.full
 # un-scan the btrfs devices
-_reload_fs_module "btrfs"
+_btrfs_forget_if_not_fs_reload
 _mount -o degraded,device=$dev2 $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
 dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
 					>>$seqres.full 2>&1
@@ -138,7 +138,7 @@ echo "Mount degraded but with other dev"
 
 _scratch_unmount
 # un-scan the btrfs devices
-_reload_fs_module "btrfs"
+_btrfs_forget_if_not_fs_reload
 
 _mount -o degraded,device=${dev2} $dev3 $SCRATCH_MNT >>$seqres.full 2>&1
 
diff --git a/tests/btrfs/154 b/tests/btrfs/154
index 99ea232aba4c..01745d20e9fc 100755
--- a/tests/btrfs/154
+++ b/tests/btrfs/154
@@ -36,7 +36,7 @@ rm -f $seqres.full
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 2
-_require_loadable_fs_module "btrfs"
+_require_btrfs_forget_if_not_fs_loadable
 
 _scratch_dev_pool_get 2
 
@@ -90,7 +90,7 @@ degrade_mount_write()
 
 	echo "clean btrfs ko" >> $seqres.full
 	# un-scan the btrfs devices
-	_reload_fs_module "btrfs"
+	_btrfs_forget_if_not_fs_reload
 	_mount -o degraded $DEV1 $SCRATCH_MNT >>$seqres.full 2>&1
 	cnt=$(( $COUNT/10 ))
 	dd if=/dev/urandom of="$SCRATCH_MNT"/tf1 bs=$bs count=$cnt \
@@ -142,7 +142,7 @@ verify()
 	echo "unmount" >> $seqres.full
 
 	_scratch_unmount
-	_reload_fs_module "btrfs"
+	_btrfs_forget_if_not_fs_reload
 	_mount -o degraded $DEV2 $SCRATCH_MNT >>$seqres.full 2>&1
 	verify_checkpoint1=`md5sum $SCRATCH_MNT/tf1`
 	verify_checkpoint2=`md5sum $SCRATCH_MNT/tf2`
diff --git a/tests/btrfs/164 b/tests/btrfs/164
index 097191a0e493..55042c4035e0 100755
--- a/tests/btrfs/164
+++ b/tests/btrfs/164
@@ -36,7 +36,7 @@ rm -f $seqres.full
 # Modify as appropriate.
 _supported_fs btrfs
 _supported_os Linux
-_require_loadable_fs_module "btrfs"
+_require_btrfs_forget_if_not_fs_loadable
 _require_scratch_dev_pool 2
 
 _scratch_dev_pool_get 2
@@ -69,7 +69,7 @@ delete_seed()
 {
 	_run_btrfs_util_prog device delete $dev_seed $SCRATCH_MNT
 	_scratch_unmount
-	_reload_fs_module "btrfs"
+	_btrfs_forget_if_not_fs_reload
 	run_check _mount $dev_sprout $SCRATCH_MNT
 	_run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
 	echo -- sprout --
-- 
1.8.3.1

