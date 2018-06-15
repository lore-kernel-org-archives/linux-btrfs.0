Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965688AbeFOLGN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:06:13 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: osandov@osandov.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/6] btrfs-progs: tests: Test for FST corruption detection/repair
Date: Fri, 15 Jun 2018 14:06:02 +0300
Message-Id: <1529060762-4372-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1529060762-4372-1-git-send-email-nborisov@suse.com>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Simple test case which preps a filesystem, then corrupts the FST and
finally repairs it. Tests both extent based and bitmap based FSTs.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/fsck-tests/035-freespacetree-repair/test.sh | 79 +++++++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100755 tests/fsck-tests/035-freespacetree-repair/test.sh

diff --git a/tests/fsck-tests/035-freespacetree-repair/test.sh b/tests/fsck-tests/035-freespacetree-repair/test.sh
new file mode 100755
index 000000000000..e19d997b3d6a
--- /dev/null
+++ b/tests/fsck-tests/035-freespacetree-repair/test.sh
@@ -0,0 +1,79 @@
+#!/bin/bash
+# Corrupt a filesystem that is using freespace tree and then ensure that 
+# btrfs check is able to repair it. This tests correct detection/repair of 
+# both a FREE_SPACE_EXTENT based FST and a FREE_SPACE_BITMAP based FST. 
+
+source "$TEST_TOP/common"
+
+repair_and_verify()
+{
+	# since repairing entails allocating a block, which in turn implies 
+	# FST modification another btrfs check is required to ensure that 
+	# FST modification logic is correct. 
+	run_check $SUDO_HELPER "$TOP/btrfs" check --repair "$TEST_DEV"
+	run_check $SUDO_HELPER "$TOP/btrfs" check "$TEST_DEV"
+}
+
+# wrapper for btrfs-corrupt-item
+# $1: Type of item we want to corrupt - extent or bitmap
+corrupt_fst_item()
+{
+	local type
+	local objectid
+	local offset
+	type="$1"
+
+	if [[ $type == "bitmap" ]]; then 
+		type=200
+		objectid=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_BITMAP [[:digit:]]*" | \
+			cut -d' ' -f1 | tail -2 | head -1)
+		offset=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_BITMAP [[:digit:]]*" | \
+			cut -d' ' -f3 |tail -2 | head -1)
+		echo "Corrupting $objectid,FREE_SPACE_BITMAP,$offset"
+	elif [[ $type == "extent" ]]; then
+		type=199
+		objectid=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_EXTENT [[:digit:]]*" | \
+			cut -d' ' -f1 | tail -2 | head -1)
+		offset=$("$TOP/btrfs" inspect-internal dump-tree -t 10 "$TEST_DEV" | \
+			grep -o "[[:digit:]]* FREE_SPACE_EXTENT [[:digit:]]*" | \
+			cut -d' ' -f3 | tail -2 | head -1)
+		echo "Corrupting $objectid,FREE_SPACE_EXTENT,$offset"
+	else
+		_fail "Unknown item type for corruption"
+	fi
+	
+
+	run_check "$TOP/btrfs-corrupt-block" -r 10 -K "$objectid,$type,$offset" \
+		-f offset "$TEST_DEV"
+}
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+check_global_prereq grep
+check_global_prereq tail 
+check_global_prereq head
+check_global_prereq cut
+
+setup_root_helper
+prepare_test_dev 256M
+
+run_check "$TOP/mkfs.btrfs" -n 4k -f "$TEST_DEV"
+run_check_mount_test_dev -oclear_cache,space_cache=v2
+
+#create files which will populate the FST
+for i in {1..3000}; do
+	fallocate -l 4k "$TEST_MNT/file.$i" 
+done
+
+run_check_umount_test_dev
+
+#now corrupt one of the bitmap items 
+corrupt_fst_item "bitmap"
+check_image "$TEST_DEV"
+
+#now corrupt an extent 
+corrupt_fst_item "extent"
+check_image "$TEST_DEV"
-- 
2.7.4

