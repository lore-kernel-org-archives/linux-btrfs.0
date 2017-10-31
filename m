Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39364 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752514AbdJaIoG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 04:44:06 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [RFC PATCH 1/3] btrfs-progs: Add EXEC parameter in Makefile
Date: Tue, 31 Oct 2017 16:43:34 +0800
Message-ID: <1509439416-51824-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
References: <1509439416-51824-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When EXEC parameter is set, do not build this tool.
run the test tool with a given path.(/usr/bin, /usr/local/bin)

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Makefile        | 32 +++++++++++++++++++++++++++++++-
 tests/README.md | 10 ++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 30a0ee22..8ca5e63f 100644
--- a/Makefile
+++ b/Makefile
@@ -26,6 +26,7 @@
 #   EXTRA_LDFLAGS  additional linker flags
 #
 # Testing-specific options (see also tests/README.md):
+#   EXEC=path      run test(s) use exec file in given path
 #   TEST=GLOB      run test(s) from directories matching GLOB
 #   TEST_LOG=tty   print name of a command run via the execution helpers
 #   TEST_LOG=dump  dump testing log file when a test fails
@@ -295,11 +296,38 @@ $(BUILDDIRS):
 	@echo "Making all in $(patsubst build-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst build-%,%,$@)
 
+ifneq ("$(EXEC)","")
+test-convert:
+	@echo "    [TEST]   convert-tests.sh"
+	$(Q)bash tests/convert-tests.sh
+
+# btrfs-corrupt-block is a internal tool of btrfs-progs.
+test-fsck: btrfs-corrupt-block
+	@echo "    [TEST]   fsck-tests.sh"
+	$(Q)bash tests/fsck-tests.sh
+
+# btrfs-corrupt-block is a internal tool of btrfs-progs.
+# fssum is a internal tool for tests.
+test-misc: btrfs-corrupt-block fssum
+	@echo "    [TEST]   misc-tests.sh"
+	$(Q)bash tests/misc-tests.sh
+
+test-mkfs:
+	@echo "    [TEST]   mkfs-tests.sh"
+	$(Q)bash tests/mkfs-tests.sh
+
+test-fuzz:
+	@echo "    [TEST]   fuzz-tests.sh"
+	$(Q)bash tests/fuzz-tests.sh
+
+test-cli:
+	@echo "    [TEST]   cli-tests.sh"
+	$(Q)bash tests/cli-tests.sh
+else
 test-convert: btrfs btrfs-convert
 	@echo "    [TEST]   convert-tests.sh"
 	$(Q)bash tests/convert-tests.sh
 
-test-check: test-fsck
 test-fsck: btrfs btrfs-image btrfs-corrupt-block mkfs.btrfs btrfstune
 	@echo "    [TEST]   fsck-tests.sh"
 	$(Q)bash tests/fsck-tests.sh
@@ -320,7 +348,9 @@ test-fuzz: btrfs
 test-cli: btrfs
 	@echo "    [TEST]   cli-tests.sh"
 	$(Q)bash tests/cli-tests.sh
+endif
 
+test-check: test-fsck
 test-clean:
 	@echo "Cleaning tests"
 	$(Q)bash tests/clean-tests.sh
diff --git a/tests/README.md b/tests/README.md
index 04d2ce2a..35383346 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -28,6 +28,16 @@ $ ./misc-tests.sh
 The verbose output of the tests is logged into a file named after the test
 category, eg. `fsck-tests-results.txt`.
 
+## Specify binary
+
+Use binary in the given path to run test.
+
+```shell
+$ make EXEC=/usr/bin/ test
+```
+
+will run tests use binary in /usr/bin.
+
 ## Selective testing
 
 The tests are prefixed by a number for ordering and uniqueness. To run a
-- 
2.13.6



