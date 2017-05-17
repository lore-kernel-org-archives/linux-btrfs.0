Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753944AbdEQPba (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 11:31:30 -0400
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D13E223986
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 15:31:23 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: test for restoring multiple devices fs into a single device
Date: Wed, 17 May 2017 02:41:31 +0100
Message-Id: <20170517014131.8549-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Test that we are able to create an image from a multiple devices fs, that
we are able to restore that image into a single device and finally that we
are able to mount it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/misc-tests/020-image-multi-devices/test.sh | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100755 tests/misc-tests/020-image-multi-devices/test.sh

diff --git a/tests/misc-tests/020-image-multi-devices/test.sh b/tests/misc-tests/020-image-multi-devices/test.sh
new file mode 100755
index 00000000..d4a5f006
--- /dev/null
+++ b/tests/misc-tests/020-image-multi-devices/test.sh
@@ -0,0 +1,49 @@
+#!/bin/bash
+# Test btrfs-image with multiple devices filesystem and verify that restoring
+# the created image works against a single device.
+
+source $TOP/tests/common
+
+check_prereq btrfs-image
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+
+rm -f dev1 dev2
+run_check truncate -s 2G dev1
+run_check truncate -s 2G dev2
+
+loop1=$(run_check_stdout $SUDO_HELPER losetup --find --show dev1)
+loop2=$(run_check_stdout $SUDO_HELPER losetup --find --show dev2)
+
+# Create the test file system.
+
+run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $loop1 $loop2
+run_check $SUDO_HELPER mount $loop1 $TEST_MNT
+run_check $SUDO_HELPER dd bs=1M count=1 if=/dev/zero of=$TEST_MNT/foobar
+orig_md5=$(run_check_stdout md5sum $TEST_MNT/foobar | cut -d ' ' -f 1)
+run_check $SUDO_HELPER umount $TEST_MNT
+
+# Create the image to restore later.
+run_check $SUDO_HELPER $TOP/btrfs-image $loop1 $IMAGE
+
+# Wipe out the filesystem from the devices, restore the image on a single
+# device, check everything works and file foobar is there and with 1Mb of
+# zeroes.
+run_check $SUDO_HELPER wipefs -a $loop1
+run_check $SUDO_HELPER wipefs -a $loop2
+
+run_check $SUDO_HELPER $TOP/btrfs-image -r $IMAGE $loop1
+
+run_check $SUDO_HELPER mount $loop1 $TEST_MNT
+new_md5=$(run_check_stdout md5sum $TEST_MNT/foobar | cut -d ' ' -f 1)
+run_check $SUDO_HELPER umount $TEST_MNT
+
+# Cleanup loop devices.
+run_check $SUDO_HELPER losetup -d $loop1
+run_check $SUDO_HELPER losetup -d $loop2
+rm -f dev1 dev2
+
+# Compare the file digests.
+[ $orig_md5 == $new_md5 ] || _fail "File digests do not match"
-- 
2.11.0

