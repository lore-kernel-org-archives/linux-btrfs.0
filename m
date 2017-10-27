Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:48662 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdJ0Axc (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 26 Oct 2017 20:53:32 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 2/2] btrfs-progs: test/mkfs: Test if the minimal device size is valid
Date: Fri, 27 Oct 2017 08:53:24 +0800
Message-Id: <20171027005324.17950-2-wqu@suse.com>
In-Reply-To: <20171027005324.17950-1-wqu@suse.com>
References: <20171027005324.17950-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New test case to test if the minimal device size given by "mkfs.btrfs"
failure case is valid.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/mkfs-tests/010-small-image/test.sh | 49 ++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100755 tests/mkfs-tests/010-small-image/test.sh

diff --git a/tests/mkfs-tests/010-small-image/test.sh b/tests/mkfs-tests/010-small-image/test.sh
new file mode 100755
index 000000000000..f55760df061f
--- /dev/null
+++ b/tests/mkfs-tests/010-small-image/test.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+# test if the reported minimal size of mkfs.btrfs is valid
+
+source "$TOP"/tests/common
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+
+do_test()
+{
+	# Well, 1M small enough to fail, we just use the output
+	# to get the minimal device size
+	prepare_test_dev 1M
+	output=$(run_mustfail_stdout "mkfs.btrfs for small image" \
+		 "$TOP"/mkfs.btrfs -f $@ "$TEST_DEV")
+	good_size=$(echo "$output" | grep -oP "(?<=is )\d+")
+
+	prepare_test_dev "$good_size"
+	run_check "$TOP"/mkfs.btrfs -f $@ "$TEST_DEV"
+	run_check $SUDO_HELPER mount "$TEST_DEV" "$TEST_MNT"
+	run_check $SUDO_HELPER umount "$TEST_MNT"
+}
+
+do_test -n 4k	-m single	-d single
+do_test -n 4k	-m single	-d dup
+do_test -n 4k	-m dup		-d single
+do_test -n 4k	-m dup		-d dup
+
+do_test -n 8k	-m single	-d single
+do_test -n 8k	-m single	-d dup
+do_test -n 8k	-m dup		-d single
+do_test -n 8k	-m dup		-d dup
+
+do_test -n 16k	-m single	-d single
+do_test -n 16k	-m single	-d dup
+do_test -n 16k	-m dup		-d single
+do_test -n 16k	-m dup		-d dup
+
+do_test -n 32k	-m single	-d single
+do_test -n 32k	-m single	-d dup
+do_test -n 32k	-m dup		-d single
+do_test -n 32k	-m dup		-d dup
+
+do_test -n 64k	-m single	-d single
+do_test -n 64k	-m single	-d dup
+do_test -n 64k	-m dup		-d single
+do_test -n 64k	-m dup		-d dup
-- 
2.14.3

