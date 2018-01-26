Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36715 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbeAZSla (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:30 -0500
Received: by mail-pf0-f193.google.com with SMTP id 23so821542pfp.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:29 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 06/26] libbtrfsutil: add btrfs_util_create_subvolume()
Date: Fri, 26 Jan 2018 10:40:54 -0800
Message-Id: <22b2dc3b189fb73beacd3b705cff7648b410caea.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Doing the ioctl() directly isn't too bad, but passing in a full path is
more convenient than opening the parent and passing the path component.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  52 ++++++
 libbtrfsutil/internal.h                     |  29 ++++
 libbtrfsutil/python/btrfsutilpy.h           |   2 +
 libbtrfsutil/python/module.c                |  16 ++
 libbtrfsutil/python/subvolume.c             |  59 +++++++
 libbtrfsutil/python/tests/test_qgroup.py    |  11 ++
 libbtrfsutil/python/tests/test_subvolume.py |  80 ++++++++-
 libbtrfsutil/subvolume.c                    | 241 ++++++++++++++++++++++++++++
 8 files changed, 489 insertions(+), 1 deletion(-)
 create mode 100644 libbtrfsutil/internal.h

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index d401f4d7..20029f18 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -99,8 +99,60 @@ enum btrfs_util_error btrfs_util_subvolume_id(const char *path,
  */
 enum btrfs_util_error btrfs_util_f_subvolume_id(int fd, uint64_t *id_ret);
 
+/**
+ * btrfs_util_subvolume_path() - Get the path of the subvolume with a given ID
+ * relative to the filesystem root.
+ * @path: Path on a Btrfs filesystem.
+ * @id: ID of subvolume to set as the default. If zero is given, the subvolume
+ * ID of @path is used.
+ * @path_ret: Returned path.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_subvolume_path(const char *path, uint64_t id,
+						char **path_ret);
+
+/**
+ * btrfs_util_f_subvolume_path() - See btrfs_util_subvolume_path().
+ */
+enum btrfs_util_error btrfs_util_f_subvolume_path(int fd, uint64_t id,
+						  char **path_ret);
+
 struct btrfs_util_qgroup_inherit;
 
+/**
+ * btrfs_util_create_subvolume() - Create a new subvolume.
+ * @path: Where to create the subvolume.
+ * @flags: Must be zero.
+ * @async_transid: If not NULL, create the subvolume asynchronously (i.e.,
+ * without waiting for it to commit it to disk) and return the transaction ID
+ * that it was created in. This transaction ID can be waited on with
+ * btrfs_util_wait_sync().
+ * @qgroup_inherit: Qgroups to inherit from, or NULL.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_create_subvolume(const char *path, int flags,
+						  uint64_t *async_transid,
+						  struct btrfs_util_qgroup_inherit *qgroup_inherit);
+
+/**
+ * btrfs_util_f_create_subvolume() - Create a new subvolume given its parent and
+ * name.
+ * @parent_fd: File descriptor of the parent directory where the subvolume
+ * should be created.
+ * @name: Name of the subvolume to create.
+ * @flags: See btrfs_util_create_subvolume().
+ * @async_transid: See btrfs_util_create_subvolume().
+ * @qgroup_inherit: See btrfs_util_create_subvolume().
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_f_create_subvolume(int parent_fd,
+						    const char *name, int flags,
+						    uint64_t *async_transid,
+						    struct btrfs_util_qgroup_inherit *qgroup_inherit);
+
 /**
  * btrfs_util_create_qgroup_inherit() - Create a qgroup inheritance specifier
  * for btrfs_util_create_subvolume() or btrfs_util_create_snapshot().
diff --git a/libbtrfsutil/internal.h b/libbtrfsutil/internal.h
new file mode 100644
index 00000000..bc91ad88
--- /dev/null
+++ b/libbtrfsutil/internal.h
@@ -0,0 +1,29 @@
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
+#ifndef BTRFS_UTIL_INTERNAL_H
+#define BTRFS_UTIL_INTERNAL_H
+
+#include <asm/byteorder.h>
+
+#define le16_to_cpu __le16_to_cpu
+#define le32_to_cpu __le32_to_cpu
+#define le64_to_cpu __le64_to_cpu
+
+#endif /* BTRFS_UTIL_INTERNAL_H */
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index a36f2671..32e83fe5 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -60,6 +60,8 @@ void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
 
 PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
 
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index de7d17a1..444516b1 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -144,6 +144,22 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "Get the ID of the subvolume containing a file.\n\n"
 	 "Arguments:\n"
 	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"subvolume_path", (PyCFunction)subvolume_path,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "subvolume_path(path, id=0) -> int\n\n"
+	 "Get the path of a subvolume relative to the filesystem root.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor\n"
+	 "id -- if not zero, instead of returning the subvolume path of the\n"
+	 "given path, return the path of the subvolume with this ID"},
+	{"create_subvolume", (PyCFunction)create_subvolume,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "create_subvolume(path, async=False)\n\n"
+	 "Create a new subvolume.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, or path-like object\n"
+	 "async -- create the subvolume without waiting for it to commit to\n"
+	 "disk and return the transaction ID"},
 	{},
 };
 
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 538bf324..bef9fab5 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -71,3 +71,62 @@ PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds)
 	path_cleanup(&path);
 	return PyLong_FromUnsignedLongLong(id);
 }
+
+PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "id", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	uint64_t id = 0;
+	char *subvol_path;
+	PyObject *ret;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|K:subvolume_path",
+					 keywords, &path_converter, &path, &id))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_subvolume_path(path.path, id, &subvol_path);
+	else
+		err = btrfs_util_f_subvolume_path(path.fd, id, &subvol_path);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+
+	ret = PyUnicode_DecodeFSDefault(subvol_path);
+	free(subvol_path);
+	return ret;
+}
+
+PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "async", "qgroup_inherit", NULL};
+	struct path_arg path = {.allow_fd = false};
+	enum btrfs_util_error err;
+	int async = 0;
+	QgroupInherit *inherit = NULL;
+	uint64_t transid;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&|pO!:create_subvolume",
+					 keywords, &path_converter, &path,
+					 &async, &QgroupInherit_type, &inherit))
+		return NULL;
+
+	err = btrfs_util_create_subvolume(path.path, 0, async ? &transid : NULL,
+					  inherit ? inherit->inherit : NULL);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	if (async)
+		return PyLong_FromUnsignedLongLong(transid);
+	else
+		Py_RETURN_NONE;
+}
diff --git a/libbtrfsutil/python/tests/test_qgroup.py b/libbtrfsutil/python/tests/test_qgroup.py
index a590464b..19e6b05a 100644
--- a/libbtrfsutil/python/tests/test_qgroup.py
+++ b/libbtrfsutil/python/tests/test_qgroup.py
@@ -19,6 +19,17 @@ import os
 import unittest
 
 import btrfsutil
+from tests import BtrfsTestCase
+
+
+class TestQgroup(BtrfsTestCase):
+    def test_subvolume_inherit(self):
+        subvol = os.path.join(self.mountpoint, 'subvol')
+
+        inherit = btrfsutil.QgroupInherit()
+        inherit.add_group(5)
+
+        btrfsutil.create_subvolume(subvol, qgroup_inherit=inherit)
 
 
 class TestQgroupInherit(unittest.TestCase):
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 44b1d7f0..57ba27bf 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -23,7 +23,7 @@ from pathlib import PurePath
 import traceback
 
 import btrfsutil
-from tests import BtrfsTestCase
+from tests import BtrfsTestCase, HAVE_PATH_LIKE
 
 
 class TestSubvolume(BtrfsTestCase):
@@ -55,3 +55,81 @@ class TestSubvolume(BtrfsTestCase):
         for arg in self.path_or_fd(dir):
             with self.subTest(type=type(arg)):
                 self.assertEqual(btrfsutil.subvolume_id(arg), 5)
+
+    def test_subvolume_path(self):
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'subvol1'))
+        os.mkdir(os.path.join(self.mountpoint, 'dir1'))
+        os.mkdir(os.path.join(self.mountpoint, 'dir1/dir2'))
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'dir1/dir2/subvol2'))
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'dir1/dir2/subvol2/subvol3'))
+        os.mkdir(os.path.join(self.mountpoint, 'subvol1/dir3'))
+        btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'subvol1/dir3/subvol4'))
+
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                self.assertEqual(btrfsutil.subvolume_path(arg), '')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 5), '')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 256), 'subvol1')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 257), 'dir1/dir2/subvol2')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 258), 'dir1/dir2/subvol2/subvol3')
+                self.assertEqual(btrfsutil.subvolume_path(arg, 259), 'subvol1/dir3/subvol4')
+
+        pwd = os.getcwd()
+        try:
+            os.chdir(self.mountpoint)
+            path = ''
+            for i in range(26):
+                name = chr(ord('a') + i) * 255
+                path = os.path.join(path, name)
+                btrfsutil.create_subvolume(name)
+                os.chdir(name)
+            self.assertEqual(btrfsutil.subvolume_path('.'), path)
+        finally:
+            os.chdir(pwd)
+
+    def test_create_subvolume(self):
+        subvol = os.path.join(self.mountpoint, 'subvol')
+
+        btrfsutil.create_subvolume(subvol + '1')
+        self.assertTrue(btrfsutil.is_subvolume(subvol + '1'))
+        btrfsutil.create_subvolume((subvol + '2').encode())
+        self.assertTrue(btrfsutil.is_subvolume(subvol + '2'))
+        if HAVE_PATH_LIKE:
+            btrfsutil.create_subvolume(PurePath(subvol + '3'))
+            self.assertTrue(btrfsutil.is_subvolume(subvol + '3'))
+
+        pwd = os.getcwd()
+        try:
+            os.chdir(self.mountpoint)
+            btrfsutil.create_subvolume('subvol4')
+            self.assertTrue(btrfsutil.is_subvolume('subvol4'))
+        finally:
+            os.chdir(pwd)
+
+        btrfsutil.create_subvolume(subvol + '5/')
+        self.assertTrue(btrfsutil.is_subvolume(subvol + '5'))
+
+        btrfsutil.create_subvolume(subvol + '6//')
+        self.assertTrue(btrfsutil.is_subvolume(subvol + '6'))
+
+        transid = btrfsutil.create_subvolume(subvol + '7', async=True)
+        self.assertTrue(btrfsutil.is_subvolume(subvol + '7'))
+        self.assertGreater(transid, 0)
+
+        # Test creating subvolumes under '/' in a chroot.
+        pid = os.fork()
+        if pid == 0:
+            try:
+                os.chroot(self.mountpoint)
+                os.chdir('/')
+                btrfsutil.create_subvolume('/subvol8')
+                self.assertTrue(btrfsutil.is_subvolume('/subvol8'))
+                with self.assertRaises(btrfsutil.BtrfsUtilError):
+                    btrfsutil.create_subvolume('/')
+                os._exit(0)
+            except Exception:
+                traceback.print_exc()
+                os._exit(1)
+        wstatus = os.waitpid(pid, 0)[1]
+        self.assertTrue(os.WIFEXITED(wstatus))
+        self.assertEqual(os.WEXITSTATUS(wstatus), 0)
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 37d5d388..864b8663 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -19,6 +19,8 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <stdlib.h>
+#include <string.h>
 #include <unistd.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
@@ -29,6 +31,7 @@
 #include <linux/magic.h>
 
 #include "btrfsutil.h"
+#include "internal.h"
 
 #define SAVE_ERRNO_AND_CLOSE(fd) {	\
 	int saved_errno = errno;	\
@@ -135,3 +138,241 @@ enum btrfs_util_error btrfs_util_f_subvolume_id(int fd, uint64_t *id_ret)
 
 	return BTRFS_UTIL_OK;
 }
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_subvolume_path(const char *path, uint64_t id,
+						char **path_ret)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_f_subvolume_path(fd, id, path_ret);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_f_subvolume_path(int fd, uint64_t id,
+						  char **path_ret)
+{
+	char *path, *p;
+	size_t capacity = 4096;
+
+	path = malloc(capacity);
+	if (!path)
+		return BTRFS_UTIL_ERROR_NO_MEMORY;
+	p = path + capacity - 1;
+	p[0] = '\0';
+
+	if (id == 0) {
+		enum btrfs_util_error err;
+
+		err = btrfs_util_f_is_subvolume(fd);
+		if (err)
+			return err;
+
+		err = btrfs_util_f_subvolume_id(fd, &id);
+		if (err)
+			return err;
+	}
+
+	while (id != BTRFS_FS_TREE_OBJECTID) {
+		struct btrfs_ioctl_search_args search = {
+			.key = {
+				.tree_id = BTRFS_ROOT_TREE_OBJECTID,
+				.min_objectid = id,
+				.max_objectid = id,
+				.min_type = BTRFS_ROOT_BACKREF_KEY,
+				.max_type = BTRFS_ROOT_BACKREF_KEY,
+				.min_offset = 0,
+				.max_offset = UINT64_MAX,
+				.min_transid = 0,
+				.max_transid = UINT64_MAX,
+				.nr_items = 1,
+			},
+		};
+		struct btrfs_ioctl_ino_lookup_args lookup;
+		const struct btrfs_ioctl_search_header *header;
+		const struct btrfs_root_ref *ref;
+		const char *name;
+		uint16_t name_len;
+		size_t lookup_len;
+		size_t total_len;
+		int ret;
+
+		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &search);
+		if (ret == -1) {
+			free(path);
+			return BTRFS_UTIL_ERROR_SEARCH_FAILED;
+		}
+
+		if (search.key.nr_items == 0) {
+			free(path);
+			errno = ENOENT;
+			return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+		}
+
+		header = (struct btrfs_ioctl_search_header *)search.buf;
+		ref = (struct btrfs_root_ref *)(header + 1);
+		name = (char *)(ref + 1);
+		name_len = le16_to_cpu(ref->name_len);
+
+		id = header->offset;
+
+		lookup.treeid = id;
+		lookup.objectid = le64_to_cpu(ref->dirid);
+		ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &lookup);
+		if (ret == -1) {
+			free(path);
+			return BTRFS_UTIL_ERROR_SEARCH_FAILED;
+		}
+		lookup_len = strlen(lookup.name);
+
+		total_len = name_len + lookup_len + (id != BTRFS_FS_TREE_OBJECTID);
+		if (p - total_len < path) {
+			char *new_path, *new_p;
+			size_t new_capacity = capacity * 2;
+
+			new_path = malloc(new_capacity);
+			if (!new_path) {
+				free(path);
+				return BTRFS_UTIL_ERROR_NO_MEMORY;
+			}
+			new_p = new_path + new_capacity - (path + capacity - p);
+			memcpy(new_p, p, path + capacity - p);
+			free(path);
+			path = new_path;
+			p = new_p;
+			capacity = new_capacity;
+		}
+		p -= name_len;
+		memcpy(p, name, name_len);
+		p -= lookup_len;
+		memcpy(p, lookup.name, lookup_len);
+		if (id != BTRFS_FS_TREE_OBJECTID)
+			*--p = '/';
+	}
+
+	if (p != path)
+		memmove(path, p, path + capacity - p);
+
+	*path_ret = path;
+
+	return BTRFS_UTIL_OK;
+}
+
+static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
+						    char *name, size_t name_len,
+						    int *fd)
+{
+	char *tmp_path, *slash, *dirname, *basename;
+	size_t len;
+
+	/* Ignore trailing slashes. */
+	len = strlen(path);
+	while (len > 1 && path[len - 1] == '/')
+		len--;
+
+	tmp_path = malloc(len + 1);
+	if (!tmp_path)
+		return BTRFS_UTIL_ERROR_NO_MEMORY;
+	memcpy(tmp_path, path, len);
+	tmp_path[len] = '\0';
+
+	slash = memrchr(tmp_path, '/', len);
+	if (slash == tmp_path) {
+		dirname = "/";
+		basename = tmp_path + 1;
+	} else if (slash) {
+		*slash = '\0';
+		dirname = tmp_path;
+		basename = slash + 1;
+	} else {
+		dirname = ".";
+		basename = tmp_path;
+	}
+
+	len = strlen(basename);
+	if (len >= name_len) {
+		errno = ENAMETOOLONG;
+		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
+	}
+	memcpy(name, basename, len);
+	name[len] = '\0';
+
+	*fd = openat(dirfd, dirname, O_RDONLY | O_DIRECTORY);
+	if (*fd == -1) {
+		free(tmp_path);
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+	}
+
+	free(tmp_path);
+	return BTRFS_UTIL_OK;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_create_subvolume(const char *path, int flags,
+						  uint64_t *async_transid,
+						  struct btrfs_util_qgroup_inherit *qgroup_inherit)
+{
+	char name[BTRFS_SUBVOL_NAME_MAX + 1];
+	enum btrfs_util_error err;
+	int parent_fd;
+
+	err = openat_parent_and_name(AT_FDCWD, path, name, sizeof(name),
+				     &parent_fd);
+	if (err)
+		return err;
+
+	err = btrfs_util_f_create_subvolume(parent_fd, name, flags,
+					    async_transid, qgroup_inherit);
+	SAVE_ERRNO_AND_CLOSE(parent_fd);
+	return err;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_f_create_subvolume(int parent_fd,
+						    const char *name, int flags,
+						    uint64_t *async_transid,
+						    struct btrfs_util_qgroup_inherit *qgroup_inherit)
+{
+	struct btrfs_ioctl_vol_args_v2 args = {};
+	size_t len;
+	int ret;
+
+	if (flags) {
+		errno = EINVAL;
+		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
+	}
+
+	if (async_transid)
+		args.flags |= BTRFS_SUBVOL_CREATE_ASYNC;
+	if (qgroup_inherit) {
+		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
+		args.qgroup_inherit = (struct btrfs_qgroup_inherit *)qgroup_inherit;
+		args.size = (sizeof(*args.qgroup_inherit) +
+			     args.qgroup_inherit->num_qgroups *
+			     sizeof(args.qgroup_inherit->qgroups[0]));
+	}
+
+	len = strlen(name);
+	if (len >= sizeof(args.name)) {
+		errno = ENAMETOOLONG;
+		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
+	}
+	memcpy(args.name, name, len);
+	args.name[len] = '\0';
+
+	ret = ioctl(parent_fd, BTRFS_IOC_SUBVOL_CREATE_V2, &args);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SUBVOL_CREATE_FAILED;
+
+	if (async_transid)
+		*async_transid = args.transid;
+
+	return BTRFS_UTIL_OK;
+}
-- 
2.16.1

