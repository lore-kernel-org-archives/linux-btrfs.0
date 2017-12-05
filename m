Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48920 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbdLEI0F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 03:26:05 -0500
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs/124: add balance --full-balance option
Date: Tue,  5 Dec 2017 16:26:28 +0800
Message-Id: <20171205082628.1676-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs balance needs --full-balance option since 4.6, so check the
version and then use it.

As this may be useful for other btrfs tests as well, so this patch
adds _btrfs_full_balance_option() to the common/btrfs file.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/btrfs    | 13 +++++++++++++
 tests/btrfs/124 |  3 ++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/common/btrfs b/common/btrfs
index c09206c6f292..8ca6486b26dc 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -356,3 +356,16 @@ _btrfs_compression_algos()
 		echo "${feature#/sys/fs/btrfs/features/compress_}"
 	done
 }
+
+#btrfs-progs adds required --full-balance option since v4.6 so check for
+#that and then return the required option.
+_btrfs_full_balance_option()
+{
+	ver=$($BTRFS_UTIL_PROG --version|awk '{print $2}'|cut -d"-" -f1 | cut -d"v" -f2)
+	tup1=$(echo $ver| cut -d"." -f1)
+	tup2=$(echo $ver| cut -d"." -f2)
+
+	RET=""
+	(("$tup1" > "4")) && RET="--full-balance"
+	(("$tup1" == "4")) && (("tup2" >= "6")) && RET="--full-balance"
+}
diff --git a/tests/btrfs/124 b/tests/btrfs/124
index a6486270a972..ec1d24b5ef42 100755
--- a/tests/btrfs/124
+++ b/tests/btrfs/124
@@ -129,7 +129,8 @@ _run_btrfs_util_prog device scan
 _scratch_mount >> $seqres.full 2>&1
 _run_btrfs_util_prog filesystem show
 echo >> $seqres.full
-_run_btrfs_util_prog balance start ${SCRATCH_MNT}
+_btrfs_full_balance_option
+_run_btrfs_util_prog balance start $RET ${SCRATCH_MNT}
 
 checkpoint2=`md5sum $SCRATCH_MNT/tf2`
 echo $checkpoint2 >> $seqres.full 2>&1
-- 
2.15.0

