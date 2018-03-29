Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33674 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752040AbeC2HyI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 03:54:08 -0400
Received: by mail-pf0-f195.google.com with SMTP id f15so2715046pfn.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 00:54:08 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 5/5] libbtrfsutil: fix test assumptions about top-level subvolume
Date: Thu, 29 Mar 2018 00:53:57 -0700
Message-Id: <459ffd8130e337e16fc2205584ee27883e959442.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Since "btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of, FS_TREE",
the top-level subvolume has a non-zero UUID, ctime, and otime. Fix the
subvolume_info() test to not check for zero.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/python/tests/test_subvolume.py | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index a46d4a34..93396cba 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -95,7 +95,8 @@ class TestSubvolume(BtrfsTestCase):
                 self.assertEqual(info.parent_id, 0)
                 self.assertEqual(info.dir_id, 0)
                 self.assertEqual(info.flags, 0)
-                self.assertEqual(info.uuid, bytes(16))
+                self.assertIsInstance(info.uuid, bytes)
+                self.assertEqual(len(info.uuid), 16)
                 self.assertEqual(info.parent_uuid, bytes(16))
                 self.assertEqual(info.received_uuid, bytes(16))
                 self.assertNotEqual(info.generation, 0)
@@ -103,8 +104,8 @@ class TestSubvolume(BtrfsTestCase):
                 self.assertEqual(info.otransid, 0)
                 self.assertEqual(info.stransid, 0)
                 self.assertEqual(info.rtransid, 0)
-                self.assertEqual(info.ctime, 0)
-                self.assertEqual(info.otime, 0)
+                self.assertIsInstance(info.ctime, float)
+                self.assertIsInstance(info.otime, float)
                 self.assertEqual(info.stime, 0)
                 self.assertEqual(info.rtime, 0)
 
@@ -117,6 +118,7 @@ class TestSubvolume(BtrfsTestCase):
         self.assertEqual(info.dir_id, 256)
         self.assertEqual(info.flags, 0)
         self.assertIsInstance(info.uuid, bytes)
+        self.assertEqual(len(info.uuid), 16)
         self.assertEqual(info.parent_uuid, bytes(16))
         self.assertEqual(info.received_uuid, bytes(16))
         self.assertNotEqual(info.generation, 0)
-- 
2.16.3

