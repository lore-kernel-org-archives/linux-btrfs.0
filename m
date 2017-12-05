Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33329 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752682AbdLEIjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:39:55 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A440CABCF
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 08:39:54 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/7] btrfs-progs: Add test for super block recovery
Date: Tue,  5 Dec 2017 10:39:48 +0200
Message-Id: <1512463189-24724-7-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This functionality regressed some time ago and it was never caught. Seems no
one complained of that, but to be sure add a regression test to prevent future 
regressions.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/fsck-tests/029-superblock-recovery/test.sh | 64 ++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100755 tests/fsck-tests/029-superblock-recovery/test.sh

diff --git a/tests/fsck-tests/029-superblock-recovery/test.sh b/tests/fsck-tests/029-superblock-recovery/test.sh
new file mode 100755
index 000000000000..beb78d6ccc22
--- /dev/null
+++ b/tests/fsck-tests/029-superblock-recovery/test.sh
@@ -0,0 +1,64 @@
+#!/bin/bash
+# Test that any superblock is correctly detected
+# and fixed by btrfs rescue
+
+source "$TOP/tests/common"
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+check_prereq btrfs-select-super
+
+setup_root_helper
+
+rm -f dev1
+run_check truncate -s 260G dev1
+loop=$(run_check_stdout $SUDO_HELPER losetup --find --show dev1)
+
+# Create the test file system.
+run_check $SUDO_HELPER "$TOP"/mkfs.btrfs -f "$loop"
+
+function check_corruption {
+	local sb_offset=$1
+	local source_sb=$2
+
+
+	# First we ensure we can mount it successfully
+	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
+	run_check $SUDO_HELPER umount "$TEST_MNT"
+
+	# Now corrupt 1k of the superblock at sb_offset
+	run_check $SUDO_HELPER dd bs=1K count=1 seek=$(($sb_offset + 1)) if=/dev/zero of="$loop"
+
+	#if corrupting one of the sb copies, copy it over the initial superblock
+	if [ ! -z $source_sb ]; then
+		local shift_val=$((16 << $source_sb * 12 ))
+		run_check $SUDO_HELPER dd bs=1K count=4 seek=64 skip=$shift_val if="$loop" of="$loop"
+	fi
+
+	run_mustfail "Mounted fs with corrupted superblock" \
+		$SUDO_HELPER mount $loop "$TEST_MNT"
+
+	# Now run btrfs rescue which should fix the superblock. It uses 2
+	# to signal success of recovery use mayfail to ignore that retval
+	# but still log the output of the command
+	run_mayfail $SUDO_HELPER "$TOP"/btrfs rescue super-recover -yv "$loop"
+	if [ $? != 2 ]; then
+		_fail "couldn't rescue super"
+	fi
+
+	run_check $SUDO_HELPER mount $loop "$TEST_MNT"
+	run_check $SUDO_HELPER umount "$TEST_MNT"
+}
+
+_log "Corrupting first superblock"
+check_corruption 64
+
+_log "Corrupting second superblock"
+check_corruption 65536 1
+
+_log "Corrupting third superblock"
+check_corruption 268435456 2
+
+# Cleanup
+run_check $SUDO_HELPER losetup -d "$loop"
+rm -f dev1
-- 
2.7.4

