Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51467 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbcFCCej (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 22:34:39 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs-progs: convert-tests: Add support for custom test scripts
Date: Fri,  3 Jun 2016 10:34:25 +0800
Message-Id: <20160603023426.25216-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support for custom convert test scripts, just like fsck tests.

Instead of generic convert tests, we need more specifically created images
for new convert tests.

This patch provide the needed infrastructure for later convert test
cases.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Split test case with infrastructure
---
 tests/common           |  8 ++++++++
 tests/convert-tests.sh | 31 +++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tests/common b/tests/common
index 91682ef..fed9ede 100644
--- a/tests/common
+++ b/tests/common
@@ -94,6 +94,14 @@ check_prereq()
 	fi
 }
 
+check_global_prereq()
+{
+	which $1 &> /dev/null
+	if [ $? -ne 0 ]; then
+		_fail "Failed system wide prerequisities: $1";
+	fi
+}
+
 check_image()
 {
 	local image
diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 06d8419..a02311d 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -15,6 +15,11 @@ DATASET_SIZE=50
 
 source $TOP/tests/common
 
+# Allow child test to use $TOP and $RESULTS
+export TOP
+export RESULTS
+export LANG
+
 rm -f $RESULTS
 
 setup_root_helper
@@ -22,6 +27,25 @@ prepare_test_dev 512M
 
 CHECKSUMTMP=$(mktemp --tmpdir btrfs-progs-convert.XXXXXXXXXX)
 
+run_one_test() {
+	local testname
+
+	testname="$1"
+	echo "    [TEST/conv]   $testname"
+	cd $testname
+	echo "=== Entering $testname" >> $RESULTS
+	if [ -x test.sh ]; then
+		# Difference convert test case needs different tools to restore
+		# and check image, so only support custom test scripts
+		./test.sh
+		if [ $? -ne 0 ]; then
+			_fail "test failed for case $(basename $testname)"
+		fi
+	else
+		_fail "custom test script not found"
+	fi
+}
+
 generate_dataset() {
 
 	dataset_type="$1"
@@ -163,4 +187,11 @@ for feature in '' 'extref' 'skinny-metadata' 'no-holes'; do
 	convert_test "$feature" "ext4 64k nodesize" 65536 mke2fs -t ext4 -b 4096
 done
 
+# Test special images
+for i in $(find $TOP/tests/convert-tests -maxdepth 1 -mindepth 1 -type d \
+	   ${TEST:+-name "$TEST"} | sort)
+do
+	run_one_test "$i"
+done
+
 rm $CHECKSUMTMP
-- 
2.8.3



