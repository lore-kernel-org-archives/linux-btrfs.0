Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33933 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbeAZSl2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:28 -0500
Received: by mail-pg0-f65.google.com with SMTP id r19so794673pgn.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:28 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 04/26] libbtrfsutil: add btrfs_util_is_subvolume() and btrfs_util_subvolume_id()
Date: Fri, 26 Jan 2018 10:40:52 -0800
Message-Id: <ec89f2b55edb450ce4fcbe1485ae8f57ed51187c.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

These are the most trivial helpers in the library and will be used to
implement several of the more involved functions.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile                                    |   2 +-
 libbtrfsutil/btrfsutil.h                    |  33 +++++++
 libbtrfsutil/python/btrfsutilpy.h           |   3 +
 libbtrfsutil/python/module.c                |  12 +++
 libbtrfsutil/python/setup.py                |   1 +
 libbtrfsutil/python/subvolume.c             |  73 +++++++++++++++
 libbtrfsutil/python/tests/__init__.py       |  66 ++++++++++++++
 libbtrfsutil/python/tests/test_subvolume.py |  57 ++++++++++++
 libbtrfsutil/subvolume.c                    | 137 ++++++++++++++++++++++++++++
 9 files changed, 383 insertions(+), 1 deletion(-)
 create mode 100644 libbtrfsutil/python/subvolume.c
 create mode 100644 libbtrfsutil/python/tests/test_subvolume.py
 create mode 100644 libbtrfsutil/subvolume.c

diff --git a/Makefile b/Makefile
index 02b03e81..48a558a9 100644
--- a/Makefile
+++ b/Makefile
@@ -123,7 +123,7 @@ libbtrfs_headers = send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-l
 	       kernel-lib/radix-tree.h kernel-lib/sizes.h kernel-lib/raid56.h \
 	       extent-cache.h extent_io.h ioctl.h ctree.h btrfsck.h version.h
 libbtrfsutil_version := 0.1
-libbtrfsutil_objects = libbtrfsutil/errors.o
+libbtrfsutil_objects = libbtrfsutil/errors.o libbtrfsutil/subvolume.o
 convert_objects = convert/main.o convert/common.o convert/source-fs.o \
 		  convert/source-ext2.o convert/source-reiserfs.o
 mkfs_objects = mkfs/main.o mkfs/common.o
diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index fe1091ca..dff6599d 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -20,6 +20,8 @@
 #ifndef BTRFS_UTIL_H
 #define BTRFS_UTIL_H
 
+#include <stdint.h>
+
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -65,6 +67,37 @@ enum btrfs_util_error {
  */
 const char *btrfs_util_strerror(enum btrfs_util_error err);
 
+/**
+ * btrfs_util_is_subvolume() - Return whether a given path is a Btrfs subvolume.
+ * @path: Path to check.
+ *
+ * Return: %BTRFS_UTIL_OK if @path is a Btrfs subvolume,
+ * %BTRFS_UTIL_ERROR_NOT_BTRFS if @path is not on a Btrfs filesystem,
+ * %BTRFS_UTIL_ERROR_NOT_SUBVOLUME if @path is not a subvolume, non-zero error
+ * code on any other failure.
+ */
+enum btrfs_util_error btrfs_util_is_subvolume(const char *path);
+
+/**
+ * btrfs_util_f_is_subvolume() - See btrfs_util_is_subvolume().
+ */
+enum btrfs_util_error btrfs_util_f_is_subvolume(int fd);
+
+/**
+ * btrfs_util_subvolume_id() - Get the ID of the subvolume containing a path.
+ * @path: Path on a Btrfs filesystem.
+ * @id_ret: Returned subvolume ID.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_subvolume_id(const char *path,
+					      uint64_t *id_ret);
+
+/**
+ * btrfs_util_f_subvolume_id() - See btrfs_util_subvolume_id().
+ */
+enum btrfs_util_error btrfs_util_f_subvolume_id(int fd, uint64_t *id_ret);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index 6d82f7e1..9a04fda7 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -52,6 +52,9 @@ void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
 				    struct path_arg *path1,
 				    struct path_arg *path2);
 
+PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
+
 void add_module_constants(PyObject *m);
 
 #endif /* BTRFSUTILPY_H */
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index d7398808..d492cbc7 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -132,6 +132,18 @@ void path_cleanup(struct path_arg *path)
 }
 
 static PyMethodDef btrfsutil_methods[] = {
+	{"is_subvolume", (PyCFunction)is_subvolume,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "is_subvolume(path) -> bool\n\n"
+	 "Get whether a file is a subvolume.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"subvolume_id", (PyCFunction)subvolume_id,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "subvolume_id(path) -> int\n\n"
+	 "Get the ID of the subvolume containing a file.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
 	{},
 };
 
diff --git a/libbtrfsutil/python/setup.py b/libbtrfsutil/python/setup.py
index 3dc778ab..be973a34 100755
--- a/libbtrfsutil/python/setup.py
+++ b/libbtrfsutil/python/setup.py
@@ -79,6 +79,7 @@ module = Extension(
         'constants.c',
         'error.c',
         'module.c',
+        'subvolume.c',
     ],
     include_dirs=['..'],
     library_dirs=['../..'],
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
new file mode 100644
index 00000000..538bf324
--- /dev/null
+++ b/libbtrfsutil/python/subvolume.c
@@ -0,0 +1,73 @@
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
+PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&:is_subvolume",
+					 keywords, &path_converter, &path))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_is_subvolume(path.path);
+	else
+		err = btrfs_util_f_is_subvolume(path.fd);
+	if (err == BTRFS_UTIL_OK) {
+		path_cleanup(&path);
+		Py_RETURN_TRUE;
+	} else if (err == BTRFS_UTIL_ERROR_NOT_BTRFS ||
+		   err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME) {
+		path_cleanup(&path);
+		Py_RETURN_FALSE;
+	} else {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+}
+
+PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	uint64_t id;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&:subvolume_id",
+					 keywords, &path_converter, &path))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_subvolume_id(path.path, &id);
+	else
+		err = btrfs_util_f_subvolume_id(path.fd, &id);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	return PyLong_FromUnsignedLongLong(id);
+}
diff --git a/libbtrfsutil/python/tests/__init__.py b/libbtrfsutil/python/tests/__init__.py
index e69de29b..d2c6ff28 100644
--- a/libbtrfsutil/python/tests/__init__.py
+++ b/libbtrfsutil/python/tests/__init__.py
@@ -0,0 +1,66 @@
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
+from pathlib import PurePath
+import subprocess
+import tempfile
+import unittest
+
+
+HAVE_PATH_LIKE = hasattr(PurePath, '__fspath__')
+
+
+@unittest.skipIf(os.geteuid() != 0, 'must be run as root')
+class BtrfsTestCase(unittest.TestCase):
+    def setUp(self):
+        self.mountpoint = tempfile.mkdtemp()
+        try:
+            with tempfile.NamedTemporaryFile(delete=False) as f:
+                os.truncate(f.fileno(), 1024 * 1024 * 1024)
+                self.image = f.name
+        except Exception as e:
+            os.rmdir(self.mountpoint)
+            raise e
+
+        try:
+            subprocess.check_call(['mkfs.btrfs', '-q', self.image])
+            subprocess.check_call(['mount', '-o', 'loop', '--', self.image, self.mountpoint])
+        except Exception as e:
+            os.remove(self.image)
+            os.rmdir(self.mountpoint)
+            raise e
+
+    def tearDown(self):
+        try:
+            subprocess.check_call(['umount', self.mountpoint])
+        finally:
+            os.remove(self.image)
+            os.rmdir(self.mountpoint)
+
+    @staticmethod
+    def path_or_fd(path, open_flags=os.O_RDONLY):
+        yield path
+        yield path.encode()
+        if HAVE_PATH_LIKE:
+            yield PurePath(path)
+        fd = os.open(path, open_flags)
+        try:
+            yield fd
+        finally:
+            os.close(fd)
+
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
new file mode 100644
index 00000000..44b1d7f0
--- /dev/null
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -0,0 +1,57 @@
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
+import fcntl
+import errno
+import os
+import os.path
+from pathlib import PurePath
+import traceback
+
+import btrfsutil
+from tests import BtrfsTestCase
+
+
+class TestSubvolume(BtrfsTestCase):
+    def test_is_subvolume(self):
+        dir = os.path.join(self.mountpoint, 'foo')
+        os.mkdir(dir)
+
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                self.assertTrue(btrfsutil.is_subvolume(arg))
+        for arg in self.path_or_fd(dir):
+            with self.subTest(type=type(arg)):
+                self.assertFalse(btrfsutil.is_subvolume(arg))
+
+        with self.assertRaises(btrfsutil.BtrfsUtilError) as e:
+            btrfsutil.is_subvolume(os.path.join(self.mountpoint, 'bar'))
+        # This is a bit of an implementation detail, but really this is testing
+        # that the exception is initialized correctly.
+        self.assertEqual(e.exception.btrfsutilerror, btrfsutil.ERROR_STATFS_FAILED)
+        self.assertEqual(e.exception.errno, errno.ENOENT)
+
+    def test_subvolume_id(self):
+        dir = os.path.join(self.mountpoint, 'foo')
+        os.mkdir(dir)
+
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                self.assertEqual(btrfsutil.subvolume_id(arg), 5)
+        for arg in self.path_or_fd(dir):
+            with self.subTest(type=type(arg)):
+                self.assertEqual(btrfsutil.subvolume_id(arg), 5)
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
new file mode 100644
index 00000000..37d5d388
--- /dev/null
+++ b/libbtrfsutil/subvolume.c
@@ -0,0 +1,137 @@
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
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/vfs.h>
+#include <linux/btrfs.h>
+#include <linux/btrfs_tree.h>
+#include <linux/magic.h>
+
+#include "btrfsutil.h"
+
+#define SAVE_ERRNO_AND_CLOSE(fd) {	\
+	int saved_errno = errno;	\
+					\
+	close(fd);			\
+	errno = saved_errno;		\
+}
+
+/*
+ * This intentionally duplicates btrfs_util_f_is_subvolume() instead of opening
+ * a file descriptor and calling it, because fstat() and fstatfs() don't accept
+ * file descriptors opened with O_PATH on old kernels (before v3.6 and before
+ * v3.12, respectively), but stat() and statfs() can be called on a path that
+ * the user doesn't have read or write permissions to.
+ */
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_is_subvolume(const char *path)
+{
+	struct statfs sfs;
+	struct stat st;
+	int ret;
+
+	ret = statfs(path, &sfs);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_STATFS_FAILED;
+
+	if (sfs.f_type != BTRFS_SUPER_MAGIC) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_NOT_BTRFS;
+	}
+
+	ret = stat(path, &st);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_STAT_FAILED;
+
+	if (st.st_ino != BTRFS_FIRST_FREE_OBJECTID || !S_ISDIR(st.st_mode)) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_NOT_SUBVOLUME;
+	}
+
+	return BTRFS_UTIL_OK;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_f_is_subvolume(int fd)
+{
+	struct statfs sfs;
+	struct stat st;
+	int ret;
+
+	ret = fstatfs(fd, &sfs);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_STATFS_FAILED;
+
+	if (sfs.f_type != BTRFS_SUPER_MAGIC) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_NOT_BTRFS;
+	}
+
+	ret = fstat(fd, &st);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_STAT_FAILED;
+
+	if (st.st_ino != BTRFS_FIRST_FREE_OBJECTID || !S_ISDIR(st.st_mode)) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_NOT_SUBVOLUME;
+	}
+
+	return BTRFS_UTIL_OK;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_subvolume_id(const char *path,
+					      uint64_t *id_ret)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_f_subvolume_id(fd, id_ret);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_f_subvolume_id(int fd, uint64_t *id_ret)
+{
+	struct btrfs_ioctl_ino_lookup_args args = {
+		.treeid = 0,
+		.objectid = BTRFS_FIRST_FREE_OBJECTID,
+	};
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
+	if (ret == -1) {
+		close(fd);
+		return BTRFS_UTIL_ERROR_INO_LOOKUP_FAILED;
+	}
+
+	*id_ret = args.treeid;
+
+	return BTRFS_UTIL_OK;
+}
-- 
2.16.1

