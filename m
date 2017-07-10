Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35967 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754630AbdGJV3Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 17:29:25 -0400
Received: by mail-pg0-f53.google.com with SMTP id u62so55539657pgb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Jul 2017 14:29:25 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: abuchbinder@google.com
Subject: [PATCH] btrfs-progs: Fix missing internal deps in tests.
Date: Mon, 10 Jul 2017 14:29:08 -0700
Message-Id: <20170710212909.31559-1-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Doing a straight 'make test' would fail because some misc and fsck
tests require particular tools to already be built. Add dependencies
at the Makefile and shell-script level.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 Makefile            | 5 +++--
 tests/fsck-tests.sh | 1 +
 tests/misc-tests.sh | 3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 81598df..4669525 100644
--- a/Makefile
+++ b/Makefile
@@ -272,11 +272,12 @@ test-convert: btrfs btrfs-convert
 	$(Q)bash tests/convert-tests.sh
 
 test-check: test-fsck
-test-fsck: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs
+test-fsck: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune
 	@echo "    [TEST]   fsck-tests.sh"
 	$(Q)bash tests/fsck-tests.sh
 
-test-misc: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune fssum
+test-misc: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune fssum \
+		btrfs-zero-log btrfs-find-root btrfs-select-super
 	@echo "    [TEST]   misc-tests.sh"
 	$(Q)bash tests/misc-tests.sh
 
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 44cca1b..15d26c7 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -23,6 +23,7 @@ rm -f "$RESULTS"
 check_prereq btrfs-corrupt-block
 check_prereq btrfs-image
 check_prereq btrfs
+check_prereq btrfstune
 check_kernel_support
 
 run_one_test() {
diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index 1c645c9..0898801 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -24,6 +24,9 @@ check_prereq btrfs-corrupt-block
 check_prereq btrfs-image
 check_prereq btrfstune
 check_prereq btrfs
+check_prereq btrfs-zero-log
+check_prereq btrfs-find-root
+check_prereq btrfs-select-super
 check_kernel_support
 
 # The tests are driven by their custom script called 'test.sh'
-- 
2.13.2.725.g09c95d1e9-goog

