Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:43692 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161132AbeBOTFd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:33 -0500
Received: by mail-pg0-f66.google.com with SMTP id f6so491388pgs.10
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:33 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 06/27] libbtrfsutil: add btrfs_util_create_subvolume()
Date: Thu, 15 Feb 2018 11:04:51 -0800
Message-Id: <afd80fc716f0242909ca573abdf0ba3ae432b6e4.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Doing the ioctl() directly isn't too bad, but passing in a full path is
more convenient than opening the parent and passing the path component.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  34 +++++++++
 libbtrfsutil/python/btrfsutilpy.h           |   1 +
 libbtrfsutil/python/module.c                |   8 ++
 libbtrfsutil/python/subvolume.c             |  29 +++++++
 libbtrfsutil/python/tests/test_qgroup.py    |  11 +++
 libbtrfsutil/python/tests/test_subvolume.py |  49 +++++++++++-
 libbtrfsutil/subvolume.c                    | 114 ++++++++++++++++++++++++++++
 7 files changed, 245 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 76bf0b60..5d67f111 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -105,6 +105,40 @@ enum btrfs_util_error btrfs_util_subvolume_id_fd(int fd, uint64_t *id_ret);
 
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
+ * btrfs_util_create_subvolume_fd() - Create a new subvolume given its parent
+ * and name.
+ * @parent_fd: File descriptor of the parent directory where the subvolume
+ * should be created.
+ * @name: Name of the subvolume to create.
+ * @flags: See btrfs_util_create_subvolume().
+ * @async_transid: See btrfs_util_create_subvolume().
+ * @qgroup_inherit: See btrfs_util_create_subvolume().
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_create_subvolume_fd(int parent_fd,
+						     const char *name,
+						     int flags,
+						     uint64_t *async_transid,
+						     struct btrfs_util_qgroup_inherit *qgroup_inherit);
+
 /**
  * btrfs_util_create_qgroup_inherit() - Create a qgroup inheritance specifier
  * for btrfs_util_create_subvolume() or btrfs_util_create_snapshot().
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index a36f2671..87d47ae0 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -60,6 +60,7 @@ void SetFromBtrfsUtilErrorWithPaths(enum btrfs_util_error err,
 
 PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
 
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index de7d17a1..69bba704 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -144,6 +144,14 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "Get the ID of the subvolume containing a file.\n\n"
 	 "Arguments:\n"
 	 "path -- string, bytes, path-like object, or open file descriptor"},
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
index 4aab06a5..6f2080ee 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -71,3 +71,32 @@ PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds)
 	path_cleanup(&path);
 	return PyLong_FromUnsignedLongLong(id);
 }
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
index 44b1d7f0..f6c5958d 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -23,7 +23,7 @@ from pathlib import PurePath
 import traceback
 
 import btrfsutil
-from tests import BtrfsTestCase
+from tests import BtrfsTestCase, HAVE_PATH_LIKE
 
 
 class TestSubvolume(BtrfsTestCase):
@@ -55,3 +55,50 @@ class TestSubvolume(BtrfsTestCase):
         for arg in self.path_or_fd(dir):
             with self.subTest(type=type(arg)):
                 self.assertEqual(btrfsutil.subvolume_id(arg), 5)
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
index 04988c14..8efbdd43 100644
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
@@ -125,3 +127,115 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_id_fd(int fd,
 
 	return BTRFS_UTIL_OK;
 }
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
+PUBLIC enum btrfs_util_error btrfs_util_create_subvolume(const char *path,
+							 int flags,
+							 uint64_t *async_transid,
+							 struct btrfs_util_qgroup_inherit *qgroup_inherit)
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
+	err = btrfs_util_create_subvolume_fd(parent_fd, name, flags,
+					    async_transid, qgroup_inherit);
+	SAVE_ERRNO_AND_CLOSE(parent_fd);
+	return err;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_fd(int parent_fd,
+							    const char *name,
+							    int flags,
+							    uint64_t *async_transid,
+							    struct btrfs_util_qgroup_inherit *qgroup_inherit)
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

