Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33653 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757783AbcIMNiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 09:38:46 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH] fstests: btrfs: support encryption
Date: Tue, 13 Sep 2016 21:39:50 +0800
Message-Id: <1473773990-3071-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This will help to test kernel encryption patch, and
when compiled with the below defines. So to use the
existing fstests test-cases on top of encryption.

diff --git a/fs/btrfs/encrypt.h b/fs/btrfs/encrypt.h
index 8e794da9d8f5..1ae6840d0742 100644
--- a/fs/btrfs/encrypt.h
+++ b/fs/btrfs/encrypt.h
@@ -25,9 +25,9 @@
 #ifndef BTRFS_CRYPT_SUB_FEATURES
 //testing
        //enable method
-       #define BTRFS_CRYPTO_TEST_ENABLE_BYMNTOPT       0
+       #define BTRFS_CRYPTO_TEST_ENABLE_BYMNTOPT       1
        //key choice
-       #define BTRFS_CRYPTO_TEST_BYDUMMYKEY            0 //off rest
+       #define BTRFS_CRYPTO_TEST_BYDUMMYKEY            1 //off rest
        #define BTRFS_CRYPTO_TEST_BYDUMMYENC            0 //off rest

Now use the following mount option during fstests to
exercise the extents with encryption.
  MOUNT_OPTIONS="-o compress=ctr(aes)"

As of now this mount option isn't for the end users but
for the testing only, but inspired by ecryptfs, we could
provide such an interface if useful. 

(Not sending this patch to fstests community as of now, but
it would be in the long run).

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/filter.btrfs |   2 +-
 common/rc           |   2 +-
 tests/btrfs/041     |   2 +
 tests/btrfs/041.out |  13 ++++
 tests/btrfs/052     |  12 +++
 tests/btrfs/052.out | 214 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/079     |   2 +
 tests/btrfs/125     |   2 +-
 tests/generic/297   |   6 +-
 tests/generic/298   |   2 +-
 10 files changed, 251 insertions(+), 6 deletions(-)

diff --git a/common/filter.btrfs b/common/filter.btrfs
index 9970f4d42fce..cf93f6156247 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -69,7 +69,7 @@ _filter_btrfs_subvol_delete()
 
 _filter_btrfs_compress_property()
 {
-	sed -e "s/compression=\(lzo\|zlib\)/COMPRESSION=XXX/g"
+	sed -e "s/compression=\(lzo\|zlib\|ctr(aes)\)/COMPRESSION=XXX/g"
 }
 
 # filter name of the property from the output, optionally verify against $1
diff --git a/common/rc b/common/rc
index 67762a7fc834..a0e486bf55d2 100644
--- a/common/rc
+++ b/common/rc
@@ -3481,7 +3481,7 @@ _btrfs_stress_remount_compress()
 {
 	local btrfs_mnt=$1
 	while true; do
-		for algo in no zlib lzo; do
+		for algo in no zlib lzo 'ctr(aes)'; do
 			$MOUNT_PROG -o remount,compress=$algo $btrfs_mnt
 		done
 	done
diff --git a/tests/btrfs/041 b/tests/btrfs/041
index 8bb74cd2a241..be4a10fb3746 100755
--- a/tests/btrfs/041
+++ b/tests/btrfs/041
@@ -106,6 +106,8 @@ echo "Testing restore of file compressed with lzo"
 test_btrfs_restore "lzo"
 echo "Testing restore of file compressed with zlib"
 test_btrfs_restore "zlib"
+echo "Testing restore of file encrypted with ctr(aes)"
+test_btrfs_restore "ctr(aes)"
 echo "Testing restore of file without any compression"
 test_btrfs_restore
 
diff --git a/tests/btrfs/041.out b/tests/btrfs/041.out
index 9f4e53dec979..b8d5234649ef 100644
--- a/tests/btrfs/041.out
+++ b/tests/btrfs/041.out
@@ -25,6 +25,19 @@ wrote 100/100 bytes at offset 99000
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 67edd038aaa42adb5a1aa78f2eb1d2b6  SCRATCH_MNT/foo
 67edd038aaa42adb5a1aa78f2eb1d2b6
+Testing restore of file encrypted with ctr(aes)
+wrote 100000/100000 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100000/100000 bytes at offset 100000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 2/2 bytes at offset 10000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 11/11 bytes at offset 33000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+wrote 100/100 bytes at offset 99000
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+67edd038aaa42adb5a1aa78f2eb1d2b6  SCRATCH_MNT/foo
+67edd038aaa42adb5a1aa78f2eb1d2b6
 Testing restore of file without any compression
 wrote 100000/100000 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/btrfs/052 b/tests/btrfs/052
index 599d2616f92f..94b555c4f422 100755
--- a/tests/btrfs/052
+++ b/tests/btrfs/052
@@ -186,5 +186,17 @@ _scratch_unmount
 echo "Testing with a nocow file and zlib compression"
 test_btrfs_clone_same_file "nodatacow,compress-force=zlib"
 
+_scratch_unmount
+
+echo "Testing with a cow file and ctr(aes) encryption"
+test_btrfs_clone_same_file "compress-force=ctr(aes)"
+
+_scratch_unmount
+
+echo "Testing with a nocow file and ctr(aes) encryption"
+test_btrfs_clone_same_file "nodatacow,compress-force=ctr(aes)"
+
+_scratch_unmount
+
 status=0
 exit
diff --git a/tests/btrfs/052.out b/tests/btrfs/052.out
index ac5924ecfa04..034d54fa7248 100644
--- a/tests/btrfs/052.out
+++ b/tests/btrfs/052.out
@@ -641,3 +641,217 @@ Blocks modified: [0 - 1]
 23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
 30
+Testing with a cow file and ctr(aes) encryption
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+clone failed: Invalid argument
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+clone failed: Invalid argument
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+Testing with a nocow file and ctr(aes) encryption
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+clone failed: Invalid argument
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+clone failed: Invalid argument
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
diff --git a/tests/btrfs/079 b/tests/btrfs/079
index 6aee3a373f91..489cbb174c9a 100755
--- a/tests/btrfs/079
+++ b/tests/btrfs/079
@@ -48,6 +48,8 @@ _cleanup()
 	wait
 	rm -fr $testfile
 	rm -fr $tmp.* $tmp
+	# to avoid umount getting failed with error busy
+	sleep 30
 }
 
 # get standard environment, filters and checks
diff --git a/tests/btrfs/125 b/tests/btrfs/125
index 1062b87b3eb9..eccb77b6a99e 100755
--- a/tests/btrfs/125
+++ b/tests/btrfs/125
@@ -138,7 +138,7 @@ _run_btrfs_util_prog device scan
 _scratch_mount >> $seqres.full 2>&1
 
 echo >> $seqres.full
-_run_btrfs_util_prog balance start ${SCRATCH_MNT}
+_run_btrfs_util_prog balance start --full-balance ${SCRATCH_MNT}
 
 _run_btrfs_util_prog filesystem show
 _run_btrfs_util_prog filesystem df ${SCRATCH_MNT}
diff --git a/tests/generic/297 b/tests/generic/297
index 4ae2b9c634c7..43d314710206 100755
--- a/tests/generic/297
+++ b/tests/generic/297
@@ -33,6 +33,8 @@ _cleanup()
 {
     cd /
     rm -rf $tmp.* $TEST_DIR/before $TEST_DIR/after
+    sync
+    sleep 40
 }
 
 # get standard environment, filters and checks
@@ -63,7 +65,7 @@ blksz="$(stat -f $testdir -c '%S')"
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 
 fnr=26		# 2^26 reflink extents should be enough to find a slow op?
-timeout=8	# guarantee a good long run...
+timeout=40	# guarantee a good long run...
 echo "Find a reflink size that takes a long time"
 truncate -s $(( (2 ** i) * blksz)) $testdir/file1
 for i in $(seq 0 $fnr); do
@@ -92,7 +94,7 @@ echo "reflink of $n bytes took $delta seconds" >> $seqres.full
 test $delta -gt $timeout && _fail "reflink didn't stop in time, n=$n t=$delta"
 
 echo "Check scratch fs"
-sleep 2		# give it a few seconds to actually die...
+sleep 40		# give it a few seconds to actually die...
 
 # success, all done
 status=0
diff --git a/tests/generic/298 b/tests/generic/298
index e85db1266fa9..4092efa6b961 100755
--- a/tests/generic/298
+++ b/tests/generic/298
@@ -92,7 +92,7 @@ echo "reflink of $n bytes took $delta seconds" >> $seqres.full
 test $delta -gt $timeout && _fail "reflink didn't stop in time, n=$n t=$delta"
 
 echo "Check scratch fs"
-sleep 2		# give it a few seconds to actually die...
+sleep 40		# give it a few seconds to actually die...
 
 # success, all done
 status=0
-- 
2.7.0

