Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829A9C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 15:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46DA72145D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 15:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fm7OdXoL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbeLQPIg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 10:08:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbeLQPIf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 10:08:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBHF5jln092652
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=CdUsd8Y//X0hSfXCygX7EqTtv42ADSwt+nLT9khvfHE=;
 b=fm7OdXoLXwsFQWSrN9jVggIj4Jx5vGPqSrARa9uuVTr99PO1AmiKm5DJKle8qkOYne8X
 3CTn/psTfuQsmtVR2LVp2XD7ziEJwSEhPAq1UkrLLV5NKNOnSFNowwg7dfFd7ZZ75W4i
 iT0BcMgkjn54UZ7tWc52EGgUBSpVo+aZekdoSFu3oJ5yP3liU5L/GuPcq2+RDsW9qfRl
 7HX1VUGLc1er1pc5CtCG2SngOUGY4Lhp28RV/YvCiOhd9OVbS0N7LvbHBN6V98e8nXKg
 mkzQgJwouwfHrrozyY3v4YWTWKdmAfC9H7znrvA7QLCcHvHpgFfLfbfW3Zf/PZiHuo73 fQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pct8qp1wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:34 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBHF8S3K007245
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:28 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wBHF8SYY029282
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 15:08:28 GMT
Received: from tpasj.localdomain (/157.49.131.42)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Dec 2018 07:08:28 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND] fstests: btrfs use forget if not reload
Date:   Mon, 17 Dec 2018 23:08:22 +0800
Message-Id: <1545059302-3935-4-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1545059302-3935-1-git-send-email-anand.jain@oracle.com>
References: <1545059302-3935-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9110 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170134
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[I will send this the xfstest ML after kernel and progs patch
 has been integrated].

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

