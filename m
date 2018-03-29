Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34121 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbeC2HyG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 03:54:06 -0400
Received: by mail-pg0-f68.google.com with SMTP id y16so2025943pgv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 00:54:06 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 3/5] libbtrfsutil: use local mkfs.btrfs for tests if it exists
Date: Thu, 29 Mar 2018 00:53:55 -0700
Message-Id: <17179692e153c54e92591a728b7a28b9c2127bce.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The system might not have mkfs installed at all.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile                              | 2 +-
 libbtrfsutil/python/tests/__init__.py | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 8afc8f6e..699f864d 100644
--- a/Makefile
+++ b/Makefile
@@ -357,7 +357,7 @@ testsuite: btrfs-corrupt-block fssum
 	$(Q)cd tests && ./export-testsuite.sh
 
 ifeq ($(PYTHON_BINDINGS),1)
-test-libbtrfsutil: libbtrfsutil_python
+test-libbtrfsutil: libbtrfsutil_python mkfs.btrfs
 	$(Q)cd libbtrfsutil/python; \
 		LD_LIBRARY_PATH=../.. $(PYTHON) -m unittest discover -v tests
 
diff --git a/libbtrfsutil/python/tests/__init__.py b/libbtrfsutil/python/tests/__init__.py
index d2c6ff28..35550e0a 100644
--- a/libbtrfsutil/python/tests/__init__.py
+++ b/libbtrfsutil/python/tests/__init__.py
@@ -37,8 +37,12 @@ class BtrfsTestCase(unittest.TestCase):
             os.rmdir(self.mountpoint)
             raise e
 
+        if os.path.exists('../../mkfs.btrfs'):
+            mkfs = '../../mkfs.btrfs'
+        else:
+            mkfs = 'mkfs.btrfs'
         try:
-            subprocess.check_call(['mkfs.btrfs', '-q', self.image])
+            subprocess.check_call([mkfs, '-q', self.image])
             subprocess.check_call(['mount', '-o', 'loop', '--', self.image, self.mountpoint])
         except Exception as e:
             os.remove(self.image)
-- 
2.16.3

