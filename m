Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:42836 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167165AbeBOTFo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:44 -0500
Received: by mail-pl0-f66.google.com with SMTP id 31so346361ple.9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:44 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 15/27] libbtrfsutil: add filesystem sync helpers
Date: Thu, 15 Feb 2018 11:05:00 -0800
Message-Id: <6781520f9495a917484119df37b0a7ada42dbcc0.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Namely, sync, start_sync, and wait_sync.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile                                     |   4 +-
 libbtrfsutil/btrfsutil.h                     |  44 ++++++++++++
 libbtrfsutil/filesystem.c                    | 103 +++++++++++++++++++++++++++
 libbtrfsutil/python/btrfsutilpy.h            |   3 +
 libbtrfsutil/python/filesystem.c             |  94 ++++++++++++++++++++++++
 libbtrfsutil/python/module.c                 |  21 ++++++
 libbtrfsutil/python/setup.py                 |   1 +
 libbtrfsutil/python/tests/test_filesystem.py |  73 +++++++++++++++++++
 8 files changed, 341 insertions(+), 2 deletions(-)
 create mode 100644 libbtrfsutil/filesystem.c
 create mode 100644 libbtrfsutil/python/filesystem.c
 create mode 100644 libbtrfsutil/python/tests/test_filesystem.py

diff --git a/Makefile b/Makefile
index fa32c50d..37bd6e5d 100644
--- a/Makefile
+++ b/Makefile
@@ -135,8 +135,8 @@ libbtrfsutil_major := $(shell sed -rn 's/^\#define BTRFS_UTIL_VERSION_MAJOR ([0-
 libbtrfsutil_minor := $(shell sed -rn 's/^\#define BTRFS_UTIL_VERSION_MINOR ([0-9])+$$/\1/p' libbtrfsutil/btrfsutil.h)
 libbtrfsutil_patch := $(shell sed -rn 's/^\#define BTRFS_UTIL_VERSION_PATCH ([0-9])+$$/\1/p' libbtrfsutil/btrfsutil.h)
 libbtrfsutil_version := $(libbtrfsutil_major).$(libbtrfsutil_minor).$(libbtrfsutil_patch)
-libbtrfsutil_objects = libbtrfsutil/errors.o libbtrfsutil/qgroup.o \
-		       libbtrfsutil/subvolume.o
+libbtrfsutil_objects = libbtrfsutil/errors.o libbtrfsutil/filesystem.o \
+		       libbtrfsutil/qgroup.o libbtrfsutil/subvolume.o
 convert_objects = convert/main.o convert/common.o convert/source-fs.o \
 		  convert/source-ext2.o convert/source-reiserfs.o
 mkfs_objects = mkfs/main.o mkfs/common.o mkfs/rootdir.o
diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 677ab3c1..34a2fc4a 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -74,6 +74,50 @@ enum btrfs_util_error {
  */
 const char *btrfs_util_strerror(enum btrfs_util_error err);
 
+/**
+ * btrfs_util_sync() - Force a sync on a specific Btrfs filesystem.
+ * @path: Path on a Btrfs filesystem.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_sync(const char *path);
+
+/**
+ * btrfs_util_sync_fd() - See btrfs_util_sync().
+ */
+enum btrfs_util_error btrfs_util_sync_fd(int fd);
+
+/**
+ * btrfs_util_start_sync() - Start a sync on a specific Btrfs filesystem but
+ * don't wait for it.
+ * @path: Path on a Btrfs filesystem.
+ * @transid: Returned transaction ID which can be waited on with
+ * btrfs_util_wait_sync(). This can be %NULL.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_start_sync(const char *path,
+					    uint64_t *transid);
+
+/**
+ * btrfs_util_start_sync_fd() - See btrfs_util_start_sync().
+ */
+enum btrfs_util_error btrfs_util_start_sync_fd(int fd, uint64_t *transid);
+
+/**
+ * btrfs_util_wait_sync() - Wait for a transaction with a given ID to sync.
+ * @path: Path on a Btrfs filesystem.
+ * @transid: Transaction ID to wait for, or zero for the current transaction.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_wait_sync(const char *path, uint64_t transid);
+
+/**
+ * btrfs_util_wait_sync_fd() - See btrfs_util_wait_sync().
+ */
+enum btrfs_util_error btrfs_util_wait_sync_fd(int fd, uint64_t transid);
+
 /**
  * btrfs_util_is_subvolume() - Return whether a given path is a Btrfs subvolume.
  * @path: Path to check.
diff --git a/libbtrfsutil/filesystem.c b/libbtrfsutil/filesystem.c
new file mode 100644
index 00000000..dfd171bf
--- /dev/null
+++ b/libbtrfsutil/filesystem.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2018 Facebook
+ *
+ * This file is part of libbtrfsutil.
+ *
+ * libbtrfsutil is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * libbtrfsutil is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <linux/btrfs.h>
+
+#include "btrfsutil_internal.h"
+
+PUBLIC enum btrfs_util_error btrfs_util_sync(const char *path)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_sync_fd(fd);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_sync_fd(int fd)
+{
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_SYNC, NULL);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SYNC_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_start_sync(const char *path,
+						   uint64_t *transid)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_start_sync_fd(fd, transid);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_start_sync_fd(int fd, uint64_t *transid)
+{
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_START_SYNC, transid);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_START_SYNC_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_wait_sync(const char *path,
+						  uint64_t transid)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_wait_sync_fd(fd, transid);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_wait_sync_fd(int fd, uint64_t transid)
+{
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_WAIT_SYNC, &transid);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index be5122e2..af3a6edf 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -63,6 +63,9 @@ void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
 				    struct path_arg *path1,
 				    struct path_arg *path2);
 
+PyObject *filesystem_sync(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *start_sync(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *wait_sync(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds);
diff --git a/libbtrfsutil/python/filesystem.c b/libbtrfsutil/python/filesystem.c
new file mode 100644
index 00000000..627ed193
--- /dev/null
+++ b/libbtrfsutil/python/filesystem.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2018 Facebook
+ *
+ * This file is part of libbtrfsutil.
+ *
+ * libbtrfsutil is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * libbtrfsutil is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "btrfsutilpy.h"
+
+PyObject *filesystem_sync(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&:sync", keywords,
+					 &path_converter, &path))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_sync(path.path);
+	else
+		err = btrfs_util_sync_fd(path.fd);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	Py_RETURN_NONE;
+}
+
+PyObject *start_sync(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	uint64_t transid;
+	enum btrfs_util_error err;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&:start_sync", keywords,
+					 &path_converter, &path))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_start_sync(path.path, &transid);
+	else
+		err = btrfs_util_start_sync_fd(path.fd, &transid);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	return PyLong_FromUnsignedLongLong(transid);
+}
+
+PyObject *wait_sync(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "transid", NULL};
+	struct path_arg path = {.allow_fd = true};
+	unsigned long long transid = 0;
+	enum btrfs_util_error err;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|K:wait_sync", keywords,
+					 &path_converter, &path, &transid))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_wait_sync(path.path, transid);
+	else
+		err = btrfs_util_wait_sync_fd(path.fd, transid);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	Py_RETURN_NONE;
+}
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index eaa062ac..2dbdc7be 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -155,6 +155,27 @@ void path_cleanup(struct path_arg *path)
 }
 
 static PyMethodDef btrfsutil_methods[] = {
+	{"sync", (PyCFunction)filesystem_sync,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "sync(path)\n\n"
+	 "Sync a specific Btrfs filesystem.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"start_sync", (PyCFunction)start_sync,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "start_sync(path) -> int\n\n"
+	 "Start a sync on a specific Btrfs filesystem and return the\n"
+	 "transaction ID.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"wait_sync", (PyCFunction)wait_sync,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "wait_sync(path, transid=0)\n\n"
+	 "Wait for a transaction to sync.\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor\n"
+	 "transid -- int transaction ID to wait for, or zero for the current\n"
+	 "transaction"},
 	{"is_subvolume", (PyCFunction)is_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "is_subvolume(path) -> bool\n\n"
diff --git a/libbtrfsutil/python/setup.py b/libbtrfsutil/python/setup.py
index 06857084..131f1755 100755
--- a/libbtrfsutil/python/setup.py
+++ b/libbtrfsutil/python/setup.py
@@ -90,6 +90,7 @@ module = Extension(
     sources=[
         'constants.c',
         'error.c',
+        'filesystem.c',
         'module.c',
         'qgroup.c',
         'subvolume.c',
diff --git a/libbtrfsutil/python/tests/test_filesystem.py b/libbtrfsutil/python/tests/test_filesystem.py
new file mode 100644
index 00000000..006a6b1e
--- /dev/null
+++ b/libbtrfsutil/python/tests/test_filesystem.py
@@ -0,0 +1,73 @@
+# Copyright (C) 2018 Facebook
+#
+# This file is part of libbtrfsutil.
+#
+# libbtrfsutil is free software: you can redistribute it and/or modify
+# it under the terms of the GNU Lesser General Public License as published by
+# the Free Software Foundation, either version 3 of the License, or
+# (at your option) any later version.
+#
+# libbtrfsutil is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU Lesser General Public License for more details.
+#
+# You should have received a copy of the GNU Lesser General Public License
+# along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
+
+import os
+import time
+
+import btrfsutil
+from tests import BtrfsTestCase, HAVE_PATH_LIKE
+
+
+def touch(path):
+    now = time.time()
+    os.utime(path, (now, now))
+
+
+class TestSubvolume(BtrfsTestCase):
+    def super_generation(self):
+        with open(self.image, 'rb') as f:
+            # csum is 32 bytes, fsid is 16 bytes, bytenr is 8 bytes, flags is 8
+            # bytes
+            f.seek(65536 + 32 + 16 + 8 + 8)
+            self.assertEqual(f.read(8), b'_BHRfS_M')
+            return int.from_bytes(f.read(8), 'little')
+
+    def test_sync(self):
+        old_generation = self.super_generation()
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                touch(arg)
+                btrfsutil.sync(arg)
+                new_generation = self.super_generation()
+                self.assertGreater(new_generation, old_generation)
+                old_generation = new_generation
+
+    def test_start_sync(self):
+        old_generation = self.super_generation()
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                touch(arg)
+                transid = btrfsutil.start_sync(arg)
+                self.assertGreater(transid, old_generation)
+
+    def test_wait_sync(self):
+        old_generation = self.super_generation()
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                touch(arg)
+                transid = btrfsutil.start_sync(arg)
+                btrfsutil.wait_sync(arg, transid)
+                new_generation = self.super_generation()
+                self.assertGreater(new_generation, old_generation)
+                old_generation = new_generation
+
+                touch(arg)
+                btrfsutil.start_sync(arg)
+                btrfsutil.wait_sync(arg)
+                new_generation = self.super_generation()
+                self.assertGreater(new_generation, old_generation)
+                old_generation = new_generation
-- 
2.16.1

