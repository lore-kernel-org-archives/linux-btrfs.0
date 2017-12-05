Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45259 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752283AbdLELgJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 06:36:09 -0500
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs/124: add balance --full-balance option
Date: Tue,  5 Dec 2017 19:36:32 +0800
Message-Id: <20171205113632.12589-1-anand.jain@oracle.com>
In-Reply-To: <20171205082628.1676-1-anand.jain@oracle.com>
References: <20171205082628.1676-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs balance needs --full-balance option since 4.6, so check the
version and then use it.

As this may be useful for other btrfs tests as well, so this patch
also adds _run_btrfs_balance_start() to the common/btrfs file.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Use help to find if --full-balance is supported
    Make a local variable
    run the balance instead of getting the options

 common/btrfs    | 11 +++++++++++
 tests/btrfs/124 |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/common/btrfs b/common/btrfs
index c09206c6f292..c3a62b29c70e 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -356,3 +356,14 @@ _btrfs_compression_algos()
 		echo "${feature#/sys/fs/btrfs/features/compress_}"
 	done
 }
+
+#runs btrfs balance start with required --full-balance if available.
+_run_btrfs_balance_start()
+{
+	local bal_opt=""
+
+	$BTRFS_UTIL_PROG balance start --help | grep -q "full-balance"
+	(( $? == 0 )) && bal_opt="--full-balance"
+
+	run_check $BTRFS_UTIL_PROG balance start $bal_opt $*
+}
diff --git a/tests/btrfs/124 b/tests/btrfs/124
index a6486270a972..94c35fe1ede8 100755
--- a/tests/btrfs/124
+++ b/tests/btrfs/124
@@ -129,7 +129,7 @@ _run_btrfs_util_prog device scan
 _scratch_mount >> $seqres.full 2>&1
 _run_btrfs_util_prog filesystem show
 echo >> $seqres.full
-_run_btrfs_util_prog balance start ${SCRATCH_MNT}
+_run_btrfs_balance_start ${SCRATCH_MNT}
 
 checkpoint2=`md5sum $SCRATCH_MNT/tf2`
 echo $checkpoint2 >> $seqres.full 2>&1
-- 
2.15.0

