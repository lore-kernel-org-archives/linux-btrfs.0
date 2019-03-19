Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6A4C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 09:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E61920828
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 09:49:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nY3czjqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfCSJtc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 05:49:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfCSJtb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 05:49:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9mjZK185067;
        Tue, 19 Mar 2019 09:49:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=3aGI/iFiJOj4gYodekULJ39zH/+dp7wJJJF7cAq0Vy8=;
 b=nY3czjqrd9PpL7ihpFmddeByW+UOqu244WhnIYEGLf+7ycvgYg9cTtM9qi9fbTII9b+j
 xtRQ25VZNAYB3hYnawLRJRr/KLN7BiObW4PnqV+3bEG8GpuTeEgv6QKHM/qb38nK3mr2
 oQqKvZoUCYXFApcY9CmRiKoBaEH2Np5GL2zeu3SKysqvGsQZuRGGz3D1LjHf/vOk60i8
 EtLLefmlD2asJPcw/ryU6LW/37quQt1JHCYD6ijPRYEoJoAqE+65nEha4LJ3kDvjgY/H
 Cb0bfY4e0swkkOvIgC1xzKdf347GZci1DOvujkDYWrx3cTgj+0LmVKOOTdxNHq38jO1c Jw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2r8ssrbem0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 09:49:30 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2J9nPI8001319
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 09:49:25 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2J9nO9Z013392;
        Tue, 19 Mar 2019 09:49:24 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 02:49:24 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs try use forget to unregister device
Date:   Tue, 19 Mar 2019 17:49:40 +0800
Message-Id: <1552988980-25710-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs module reload was introduced to unregister devices in the btrfs
kernel module.

The problem with the module reload approach is that you can't run btrfs
test cases 124, 125, 154 and 164 on the system with btrfs as root fs.

Patches [1] introduced btrfs forget feature which lets to cleanup the
kernel device list without kernel module reload.

 [1]
 btrfs-progs: add cli to forget one or all scanned devices
 btrfs: introduce new ioctl to unregister a btrfs device

So this patch uses forget feature instead of kernel module reload, if
the forget feature is available.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/btrfs    | 20 ++++++++++++++++++++
 tests/btrfs/124 |  6 +++---
 tests/btrfs/125 |  6 +++---
 tests/btrfs/154 |  6 +++---
 tests/btrfs/164 |  4 ++--
 5 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index f6513c06f95f..e94e011db04e 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -382,3 +382,23 @@ _scratch_btrfs_sectorsize()
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
index a52c65f608ff..9341dcea8896 100755
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
index 847fa62ad25f..3d847033f1a2 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -50,7 +50,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch_dev_pool 3
 _test_unmount
-_require_loadable_fs_module "btrfs"
+_require_btrfs_forget_if_not_fs_loadable
 _require_btrfs_fs_feature raid56
 
 _scratch_dev_pool_get 3
@@ -103,7 +103,7 @@ echo "unmount" >> $seqres.full
 _scratch_unmount
 echo "clean btrfs ko" >> $seqres.full
 # un-scan the btrfs devices
-_reload_fs_module "btrfs"
+_btrfs_forget_if_not_fs_reload
 _mount -o degraded,device=$dev2 $dev1 $SCRATCH_MNT >>$seqres.full 2>&1
 dd if=/dev/zero of="$SCRATCH_MNT"/tf2 bs=$bs count=$count \
 					>>$seqres.full 2>&1
@@ -139,7 +139,7 @@ echo "Mount degraded but with other dev"
 
 _scratch_unmount
 # un-scan the btrfs devices
-_reload_fs_module "btrfs"
+_btrfs_forget_if_not_fs_reload
 
 _mount -o degraded,device=${dev2} $dev3 $SCRATCH_MNT >>$seqres.full 2>&1
 
diff --git a/tests/btrfs/154 b/tests/btrfs/154
index cd6c688fb9fe..e39f54ac6ab8 100755
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

