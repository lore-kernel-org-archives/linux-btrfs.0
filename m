Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:41631 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeAZSlb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:31 -0500
Received: by mail-pg0-f66.google.com with SMTP id 136so781698pgd.8
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:31 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 08/26] libbtrfsutil: add btrfs_util_[gs]et_read_only()
Date: Fri, 26 Jan 2018 10:40:56 -0800
Message-Id: <5a7095592d94a9fdb4c5c99c411a492ecf35c3c0.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

In the future, btrfs_util_[gs]et_subvolume_flags() might be useful, but
since these are the only subvolume flags we've defined in all this time,
this will do for now.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    | 33 ++++++++++++++
 libbtrfsutil/python/btrfsutilpy.h           |  2 +
 libbtrfsutil/python/module.c                | 13 ++++++
 libbtrfsutil/python/subvolume.c             | 53 ++++++++++++++++++++++
 libbtrfsutil/python/tests/test_subvolume.py | 17 +++++++
 libbtrfsutil/subvolume.c                    | 69 +++++++++++++++++++++++++++++
 6 files changed, 187 insertions(+)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 41d5c1e7..d187d3a7 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -227,6 +227,39 @@ enum btrfs_util_error btrfs_util_subvolume_info(const char *path, uint64_t id,
 enum btrfs_util_error btrfs_util_f_subvolume_info(int fd, uint64_t id,
 						  struct btrfs_util_subvolume_info *subvol);
 
+/**
+ * btrfs_util_get_subvolume_read_only() - Get whether a subvolume is read-only.
+ * @path: Subvolume path.
+ * @ret: Returned read-only flag.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_get_subvolume_read_only(const char *path,
+							 bool *ret);
+
+/**
+ * btrfs_util_f_get_subvolume_read_only() - See
+ * btrfs_util_get_subvolume_read_only().
+ */
+enum btrfs_util_error btrfs_util_f_get_subvolume_read_only(int fd, bool *ret);
+
+/**
+ * btrfs_util_set_subvolume_read_only() - Set whether a subvolume is read-only.
+ * @path: Subvolume path.
+ * @read_only: New value of read-only flag.
+ *
+ * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
+ */
+enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
+							 bool read_only);
+
+/**
+ * btrfs_util_f_set_subvolume_read_only() - See
+ * btrfs_util_set_subvolume_read_only().
+ */
+enum btrfs_util_error btrfs_util_f_set_subvolume_read_only(int fd,
+							   bool read_only);
+
 struct btrfs_util_qgroup_inherit;
 
 /**
diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
index e601cb8b..21253e51 100644
--- a/libbtrfsutil/python/btrfsutilpy.h
+++ b/libbtrfsutil/python/btrfsutilpy.h
@@ -64,6 +64,8 @@ PyObject *is_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_id(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_path(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *subvolume_info(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *get_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds);
+PyObject *set_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds);
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
 
 void add_module_constants(PyObject *m);
diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index b1469fc9..3395fb14 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -160,6 +160,19 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "path -- string, bytes, path-like object, or open file descriptor\n"
 	 "id -- if not zero, instead of returning information about the\n"
 	 "given path, return information about the subvolume with this ID"},
+	{"get_subvolume_read_only", (PyCFunction)get_subvolume_read_only,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "get_subvolume_read_only(path) -> bool\n\n"
+	 "Get whether a subvolume is read-only.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor"},
+	{"set_subvolume_read_only", (PyCFunction)set_subvolume_read_only,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "set_subvolume_read_only(path, read_only=True)\n\n"
+	 "Set whether a subvolume is read-only.\n\n"
+	 "Arguments:\n"
+	 "path -- string, bytes, path-like object, or open file descriptor\n"
+	 "read_only -- bool flag value"},
 	{"create_subvolume", (PyCFunction)create_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "create_subvolume(path, async=False)\n\n"
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 9c323995..9ae7729f 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -215,6 +215,59 @@ PyStructSequence_Desc SubvolumeInfo_desc = {
 
 PyTypeObject SubvolumeInfo_type;
 
+PyObject *get_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	bool read_only;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds,
+					 "O&:get_subvolume_read_only",
+					 keywords, &path_converter, &path))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_get_subvolume_read_only(path.path, &read_only);
+	else
+		err = btrfs_util_f_get_subvolume_read_only(path.fd, &read_only);
+	if (err) {
+		SetFromBtrfsUtilErrorWithPath(err, &path);
+		path_cleanup(&path);
+		return NULL;
+	}
+
+	path_cleanup(&path);
+	return PyBool_FromLong(read_only);
+}
+
+PyObject *set_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds)
+{
+	static char *keywords[] = {"path", "read_only", NULL};
+	struct path_arg path = {.allow_fd = true};
+	enum btrfs_util_error err;
+	int read_only = 1;
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwds,
+					 "O&|p:set_subvolume_read_only",
+					 keywords, &path_converter, &path,
+					 &read_only))
+		return NULL;
+
+	if (path.path)
+		err = btrfs_util_set_subvolume_read_only(path.path, read_only);
+	else
+		err = btrfs_util_f_set_subvolume_read_only(path.fd, read_only);
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
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 {
 	static char *keywords[] = {"path", "async", "qgroup_inherit", NULL};
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index ecb0d7ae..23871de9 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -137,6 +137,23 @@ class TestSubvolume(BtrfsTestCase):
                     # BTRFS_EXTENT_TREE_OBJECTID
                     btrfsutil.subvolume_info(arg, 2)
 
+    def test_read_only(self):
+        for arg in self.path_or_fd(self.mountpoint):
+            with self.subTest(type=type(arg)):
+                btrfsutil.set_subvolume_read_only(arg)
+                self.assertTrue(btrfsutil.get_subvolume_read_only(arg))
+                self.assertTrue(btrfsutil.subvolume_info(arg).flags & 1)
+
+                btrfsutil.set_subvolume_read_only(arg, False)
+                self.assertFalse(btrfsutil.get_subvolume_read_only(arg))
+                self.assertFalse(btrfsutil.subvolume_info(arg).flags & 1)
+
+                btrfsutil.set_subvolume_read_only(arg, True)
+                self.assertTrue(btrfsutil.get_subvolume_read_only(arg))
+                self.assertTrue(btrfsutil.subvolume_info(arg).flags & 1)
+
+                btrfsutil.set_subvolume_read_only(arg, False)
+
     def test_create_subvolume(self):
         subvol = os.path.join(self.mountpoint, 'subvol')
 
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 3e94c050..394c7cbd 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -414,6 +414,75 @@ enum btrfs_util_error btrfs_util_f_subvolume_info(int fd, uint64_t id,
 	return BTRFS_UTIL_OK;
 }
 
+enum btrfs_util_error btrfs_util_f_get_subvolume_read_only(int fd,
+							   bool *read_only_ret)
+{
+	uint64_t flags;
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SUBVOL_GETFLAGS_FAILED;
+
+	*read_only_ret = flags & BTRFS_SUBVOL_RDONLY;
+	return BTRFS_UTIL_OK;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_get_subvolume_read_only(const char *path,
+							 bool *ret)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_f_get_subvolume_read_only(fd, ret);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_set_subvolume_read_only(const char *path,
+							 bool read_only)
+{
+	enum btrfs_util_error err;
+	int fd;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+	err = btrfs_util_f_set_subvolume_read_only(fd, read_only);
+	SAVE_ERRNO_AND_CLOSE(fd);
+	return err;
+}
+
+__attribute__((visibility("default")))
+enum btrfs_util_error btrfs_util_f_set_subvolume_read_only(int fd,
+							   bool read_only)
+{
+	uint64_t flags;
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_GETFLAGS, &flags);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SUBVOL_GETFLAGS_FAILED;
+
+	if (read_only)
+		flags |= BTRFS_SUBVOL_RDONLY;
+	else
+		flags &= ~BTRFS_SUBVOL_RDONLY;
+
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &flags);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_SUBVOL_SETFLAGS_FAILED;
+
+	return BTRFS_UTIL_OK;
+}
+
 static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
 						    char *name, size_t name_len,
 						    int *fd)
-- 
2.16.1

