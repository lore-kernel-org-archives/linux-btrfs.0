Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37229 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbbH3OpC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 10:45:02 -0400
Received: from /spool/local
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sun, 30 Aug 2015 20:15:00 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
Subject: [PATCH] Abort tests on mkfs failure
Date: Sun, 30 Aug 2015 20:14:48 +0530
Message-Id: <1440945888-32220-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When creating small Btrfs filesystem instances (i.e. filesystem size <= 1GiB),
mkfs.btrfs can fail if "data block size" does not match "metadata block
size". In such cases this commit aborts the test instead of letting it to
continue and report misleading results.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/027 | 3 ++-
 tests/generic/081 | 3 ++-
 tests/generic/085 | 3 ++-
 tests/generic/096 | 3 ++-
 tests/generic/102 | 3 ++-
 tests/generic/204 | 4 ++++
 tests/generic/226 | 3 ++-
 tests/generic/269 | 3 ++-
 tests/generic/270 | 3 ++-
 tests/generic/300 | 3 ++-
 10 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/tests/generic/027 b/tests/generic/027
index d2e59d6..3aef914 100755
--- a/tests/generic/027
+++ b/tests/generic/027
@@ -65,7 +65,8 @@ _require_scratch
 rm -f $seqres.full
 echo "Silence is golden"
 
-_scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 _scratch_mount
 
 echo "Reserve 2M space" >>$seqres.full
diff --git a/tests/generic/081 b/tests/generic/081
index 34da1ac..4044d12 100755
--- a/tests/generic/081
+++ b/tests/generic/081
@@ -63,7 +63,8 @@ mkdir -p $mnt
 
 # make sure there's enough disk space for 256M lv, test for 300M here in case
 # lvm uses some space for metadata
-_scratch_mkfs_sized $((300 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((300 * 1024 * 1024)) >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 $LVM_PROG vgcreate -f $vgname $SCRATCH_DEV >>$seqres.full 2>&1
 $LVM_PROG lvcreate --yes -L 256M -n $lvname $vgname >>$seqres.full 2>&1
 # wait for lvcreation to fully complete
diff --git a/tests/generic/085 b/tests/generic/085
index 8398752..ec543be 100755
--- a/tests/generic/085
+++ b/tests/generic/085
@@ -76,7 +76,8 @@ echo "Silence is golden"
 
 size=$((256 * 1024 * 1024))
 size_in_sector=$((size / 512))
-_scratch_mkfs_sized $size >>$seqres.full 2>&1
+_scratch_mkfs_sized $size >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 
 node=$seq-test
 lvdev=/dev/mapper/$node
diff --git a/tests/generic/096 b/tests/generic/096
index daf9981..f9bdc81 100755
--- a/tests/generic/096
+++ b/tests/generic/096
@@ -53,7 +53,8 @@ rm -f $seqres.full
 echo "Silence is golden"
 
 # Use smaller scratch fs to shorten the test time
-_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 _scratch_mount
 
 testfile=$SCRATCH_MNT/$seq.$$
diff --git a/tests/generic/102 b/tests/generic/102
index abc3994..d7f598b 100755
--- a/tests/generic/102
+++ b/tests/generic/102
@@ -49,7 +49,8 @@ _require_scratch
 rm -f $seqres.full
 
 dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
-_scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
+_scratch_mkfs_sized $dev_size >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 _scratch_mount
 
 for ((i = 0; i < 10; i++)); do
diff --git a/tests/generic/204 b/tests/generic/204
index 42985ab..79de712 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -60,6 +60,10 @@ _scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > /dev/null
 SIZE=`expr 106 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
 		| _filter_mkfs 2> $tmp.mkfs > /dev/null
+if [[ ${PIPESTATUS[0]} != 0 ]]; then
+	_fail "mkfs failed"
+fi
+
 _scratch_mount
 
 # Source $tmp.mkfs to get geometry
diff --git a/tests/generic/226 b/tests/generic/226
index 4ad56a5..a83ee0f 100755
--- a/tests/generic/226
+++ b/tests/generic/226
@@ -44,7 +44,8 @@ rm -f $seqres.full
 
 umount $SCRATCH_DEV 2>/dev/null
 echo "--> mkfs 256m filesystem"
-_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seqres.full 2>&1
+_scratch_mkfs_sized `expr 256 \* 1024 \* 1024` >> $seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 _scratch_mount
 
 loops=16
diff --git a/tests/generic/269 b/tests/generic/269
index fe648b5..5ceedba 100755
--- a/tests/generic/269
+++ b/tests/generic/269
@@ -67,7 +67,8 @@ _need_to_be_root
 _require_scratch
 
 rm -f $seqres.full
-_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 _scratch_mount
 
 if ! _workout; then
diff --git a/tests/generic/270 b/tests/generic/270
index 255ebf2..6d1c5f1 100755
--- a/tests/generic/270
+++ b/tests/generic/270
@@ -82,7 +82,8 @@ _need_to_be_root
 _require_scratch
 
 rm -f $seqres.full
-_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 _scratch_mount "-o usrquota,grpquota"
 chmod 777 $SCRATCH_MNT
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
diff --git a/tests/generic/300 b/tests/generic/300
index d7523aa..72f1ab3 100755
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -143,7 +143,8 @@ _workout()
 
 _require_fio $fio_config
 
-_scratch_mkfs_sized $FS_SIZE >> $seqres.full 2>&1
+_scratch_mkfs_sized $FS_SIZE >> $seqres.full 2>&1 \
+	|| _fail "mkfs failed"
 _scratch_mount
 
 if ! _workout; then
-- 
2.1.0

